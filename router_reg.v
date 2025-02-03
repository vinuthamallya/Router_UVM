module router_reg(	input	clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
						input [7:0]	data_in,
						output reg [7:0] dout,
						output reg parity_done, low_pkt_valid, err);
						
	reg [7:0]header_byte,fifo_full_state_byte,internal_parity,packet_parity;
		
	// Latching Header Byte from Input to Local Header Byte register	
	always @ (posedge clock)
		begin
			if(!resetn)
				header_byte	<=	'b0;
			else if (detect_add && pkt_valid)
				header_byte	<= data_in;
		end
		
	// Latching Data in Internal register, if FIFO full 
	always @ (posedge clock)
		begin
			if(!resetn)
				fifo_full_state_byte	<=	'b0;
			else if (ld_state && fifo_full)
				fifo_full_state_byte	<= data_in;
		end
	
	// Calculating Internal Parity with header and payload
	always @ (posedge clock)
		begin
			if(!resetn)
				internal_parity	<=	'b0;
			else if (lfd_state)
				internal_parity	<=	internal_parity ^ header_byte;
			else if (ld_state && pkt_valid && !full_state)
				internal_parity	<=	internal_parity ^ data_in;
			else if(detect_add)
				internal_parity	<=	'b0;
			else if(!pkt_valid && rst_int_reg)
				internal_parity	<=	'b0;
		end
	
	//Packet Parity - Storing Parity byte in Internal Packet Parity  register
	always @ (posedge clock)
		begin
			if(!resetn)
				packet_parity	<=	'b0;
			else if ((!pkt_valid && ld_state && !fifo_full) || (laf_state && low_pkt_valid && !parity_done))
				packet_parity	<=	data_in;
			else if(detect_add)
				packet_parity	<=	'b0;
			else if(!pkt_valid && rst_int_reg)
				packet_parity	<=	'b0;
		end
		
	// Dout Output Signal Logic
	always @ (posedge clock)
		begin
			if(!resetn)
				dout	<=	'b0;
			else if (lfd_state)
				dout	<=	header_byte;
			else if	(ld_state && !fifo_full)
				dout	<=	data_in;
			else if	(laf_state)
				dout	<=	fifo_full_state_byte;
		end
		
	// Parity Done Output Signal 
	always @ (posedge clock)
		begin
			if(!resetn)
				parity_done	<=	1'b0;
			else if (ld_state && !fifo_full && !pkt_valid)
				parity_done	<= 	1'b1;
			else if (laf_state && low_pkt_valid && !parity_done)
				parity_done	<= 	1'b1;
			else if(detect_add)
				parity_done	<=	1'b0;
		end
	
	// Low Packet Valid_ Output Signal 
	always @ (posedge clock)
		begin
			if(!resetn)
				low_pkt_valid	<=	1'b0;
			else if (ld_state && !pkt_valid)
				low_pkt_valid	<= 	1'b1;
			else if (rst_int_reg)
				low_pkt_valid	<= 	1'b0;
		end
		
	// Error  Value Output Signal 
	always @ (posedge clock)
		begin
			if(!resetn)
				err	<=	1'b0;
			else if (parity_done)
				begin
					if (internal_parity != packet_parity)
						err	<= 	1'b1;
					else
						err	<= 	1'b0;
				end
		end
		
endmodule


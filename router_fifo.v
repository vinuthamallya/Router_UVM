module router_fifo #(parameter WIDTH = 9, DEPTH = 16, BIT = 3)(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,full,empty,data_out);
	input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
	input [(WIDTH-2):0]data_in;  			
	output empty,full;
	output reg [(WIDTH-2):0]data_out; 		
	integer i;
	reg [(BIT):0]write_ptr;  		
	reg [(BIT):0]read_ptr;			
	reg [(BIT+1):0]status_count;		
	reg [5:0]fifo_count;		
	reg lfd_state_temp;
	reg [(WIDTH-1):0]fifo_memory[(DEPTH-1):0];	 	
	
	/// Lfd_state Logic
	
	always @ (posedge clock)
		begin
			if(!resetn)
				lfd_state_temp = 1'b0;
			else
				lfd_state_temp = lfd_state;
		end
		
	///	Write Logic
	
	always @ (posedge clock)
		begin
			if(!resetn || soft_reset)
				begin
					for(i=0;i<16;i=i+1)
						fifo_memory[i] <= 'b0;
					write_ptr 	<= 'b0;
				end
				
			else if (write_enb && !full)
				begin
					fifo_memory[write_ptr] <= {lfd_state_temp,data_in};
					write_ptr 	<= write_ptr + 1;
				end
		end
		
	///	Read Logic
	
	always @ (posedge clock)
		begin
			if(!resetn)
				begin
					data_out 	<= 'b0;
					read_ptr	<= 'b0;
				end
			else if(soft_reset)
				begin
					data_out 	<= 'bz;
					read_ptr	<= 'b0;
				end
			else if (read_enb && !empty)
				begin
				data_out 	<= fifo_memory[read_ptr];
				read_ptr 	<= read_ptr + 1;
				end
			else if(fifo_count==0)
				data_out 	<= 'bz;
		end
	
	/// fifo_count logic
	always@(posedge clock)
	begin
		 if(read_enb && !empty)
			begin
				if(fifo_memory[read_ptr][8])  //Header byte is read      
					fifo_count	<= (fifo_memory[read_ptr][7:2])+1'b1;	
				//length of the (packet + parity) byte
				else if(fifo_count != 6'd0)
					fifo_count	<= fifo_count-1'b1;  
				
			end
	end
		
	/// status_count Logic
	
		always @ (posedge clock)
		begin
			if(!resetn)
				status_count <= 0;
			else if ((write_enb && !full) && (read_enb && !empty))
				status_count <= status_count;
			else if (write_enb && !full)
				status_count <= status_count + 1;
			else if (read_enb && !empty)
				status_count <= status_count - 1;
			else
				status_count <= status_count;
		end
		
	/// Full and Empty Logic	

		assign full	 = (status_count == DEPTH) ? 1'b1 : 1'b0;
		assign empty = (status_count == 0) ? 1'b1 : 1'b0;
		
endmodule


module router_fsm (	input 	clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
							fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,
					input 	[1:0]data_in,
					output 	busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
					
	parameter 	DECODE_ADDRESS		=	3'b000,
				LOAD_FIRST_DATA		=	3'b001,
				LOAD_DATA			=	3'b010,
				LOAD_PARITY			=	3'b011,
				CHECK_PARITY_ERROR	=	3'b100,
				FIFO_FULL_STATE		=	3'b101,
				LOAD_AFTER_FULL		=	3'b110,
				WAIT_TILL_EMPTY		=	3'b111;
				
	reg [2:0]pre_state,nxt_state;
	reg [1:0]temp_din;
	
	always @ (posedge clock)
		begin
			if (!resetn)
				temp_din	<= 2'b0;
			else if (detect_add)
				temp_din 	<= data_in;
			else
				temp_din 	<= 2'b0;
		end
	
	always @ (posedge clock)
		begin
			if (!resetn)
				pre_state	<=	DECODE_ADDRESS;
			else if ((soft_reset_0 && temp_din == 2'b00)||(soft_reset_1 && temp_din == 2'b01)||(soft_reset_2 && temp_din == 2'b10))
				pre_state	<=	DECODE_ADDRESS;
			else
				pre_state	<=	nxt_state;
		end
	
	always @ (*)
		begin
			case(pre_state)
			DECODE_ADDRESS:	
							begin
								if ((pkt_valid && data_in == 0 && fifo_empty_0)||(pkt_valid && data_in == 1 && fifo_empty_1)||(pkt_valid && data_in == 2 && fifo_empty_2))
									nxt_state	<=	LOAD_FIRST_DATA;
								else if ((pkt_valid && data_in == 0 && !fifo_empty_0)||(pkt_valid && data_in == 1 && !fifo_empty_1)||(pkt_valid && data_in == 2 && !fifo_empty_2))
									nxt_state	<=	WAIT_TILL_EMPTY;
								else
									nxt_state	<=	DECODE_ADDRESS;
							end
							
			LOAD_FIRST_DATA:
									nxt_state	<=	LOAD_DATA;
			
			LOAD_DATA:
							begin
								if(fifo_full)
									nxt_state	<=	FIFO_FULL_STATE;
								else if(!fifo_full && !pkt_valid)
									nxt_state	<=	LOAD_PARITY;
								else
									nxt_state	<=	LOAD_DATA;
							end
			LOAD_PARITY:
									nxt_state	<=	CHECK_PARITY_ERROR;
							
			CHECK_PARITY_ERROR:
							begin
								if(fifo_full)
									nxt_state	<=	FIFO_FULL_STATE;
								else
									nxt_state	<=	DECODE_ADDRESS;
							end
							
			FIFO_FULL_STATE:
							begin
								if(fifo_full)
									nxt_state	<=	FIFO_FULL_STATE;
								else
									nxt_state	<=	LOAD_AFTER_FULL;
							end
							
			LOAD_AFTER_FULL:
							begin
								if(parity_done)
									nxt_state	<=	DECODE_ADDRESS;
								else if(!parity_done && low_pkt_valid)
									nxt_state	<=	LOAD_PARITY;
								else if(!parity_done && !low_pkt_valid)
									nxt_state	<=	LOAD_DATA;
								else
									nxt_state	<=	LOAD_AFTER_FULL;
							end
							
			WAIT_TILL_EMPTY:
							begin
								if((fifo_empty_0 && temp_din == 0) || (fifo_empty_1 && temp_din == 1) || (fifo_empty_2 && temp_din == 2))
									nxt_state	<=	LOAD_FIRST_DATA;
								else
									nxt_state	<=	WAIT_TILL_EMPTY;
							end
							
			default:				nxt_state	<=	DECODE_ADDRESS;
			endcase
		end	
			assign busy				= 	((pre_state == LOAD_FIRST_DATA)||(pre_state == LOAD_PARITY)||(pre_state == FIFO_FULL_STATE)||(pre_state == LOAD_AFTER_FULL)||(pre_state == WAIT_TILL_EMPTY)||(pre_state == CHECK_PARITY_ERROR))? 1'b1 : 1'b0;
			assign write_enb_reg	=	((pre_state == LOAD_DATA)||(pre_state == LOAD_PARITY)||(pre_state == LOAD_AFTER_FULL)) ? 1'b1 : 1'b0;
			assign detect_add		=	(pre_state == DECODE_ADDRESS) ? 1'b1 : 1'b0;
			assign ld_state			=	(pre_state == LOAD_DATA) ? 1'b1 : 1'b0;
			assign laf_state		=	(pre_state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
			assign lfd_state		=	(pre_state == LOAD_FIRST_DATA) ? 1'b1 : 1'b0;
			assign full_state		=	(pre_state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
			assign rst_int_reg		=	(pre_state == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
				
endmodule

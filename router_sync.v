module router_sync (input clock,resetn,detect_add,write_enb_reg,full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2,
					input [1:0]data_in,
					output vld_out_0,vld_out_1,vld_out_2,
					output reg [2:0]write_enb,
					output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2);
	
	reg [1:0]temp_data_in;
	reg [4:0]counter_0,counter_1,counter_2;

/// temp data in for continuous changing value
	always @ (posedge clock)
		begin
			if (!resetn)
				temp_data_in	<= 2'b0;
			else if (detect_add)
				temp_data_in 	<= data_in;
		end
		
/// Write Enable Logic
	always @ (*)
		begin
			if (write_enb_reg)
				begin
					case(temp_data_in)
						2'b00:	write_enb <= 3'b001;
						2'b01:	write_enb <= 3'b010;
						2'b10:	write_enb <= 3'b100;
						default:	write_enb <= 3'b0;
					endcase
				end
			else
				write_enb <= 3'b0;
		end
		
/// for FIFO Full logic
	always @ (*)
		begin
			case(temp_data_in)
				2'b00:	fifo_full <= full_0;
				2'b01:	fifo_full <= full_1;
				2'b10:	fifo_full <= full_2;
				default:	fifo_full <= 1'b0;
			endcase
		end
		
/// Valid Out Logic
	assign vld_out_0 = ~ empty_0;
	assign vld_out_1 = ~ empty_1;
	assign vld_out_2 = ~ empty_2;
	
/// Counter Logic for Soft reset 0 - Wait for 30 clock
	always @ (posedge clock)
		begin
			if (!resetn)
				begin
					counter_0	<= 5'b0;
					soft_reset_0 <= 1'b0;
				end
			else if (vld_out_0)
				begin
					if(read_enb_0)
						begin
							counter_0	<= 5'b0;
							soft_reset_0 <= 1'b0;
						end	
					else	
						begin
							if (counter_0 == 30)
								begin
									soft_reset_0 <= 1'b1;
									counter_0	<= 5'b0;
								end
							else
								begin
									soft_reset_0 <= 1'b0;
									counter_0	<= counter_0 + 1'b1;
								end
						end
				end
			else	
				counter_0	<= 5'b0;
		end

/// Counter Logic for Soft reset 1 - Wait for 30 clock
	always @ (posedge clock)
		begin
			if (!resetn)
				begin
					counter_1	<= 5'b0;
					soft_reset_1 <= 1'b0;
				end
			else if (vld_out_1)
				begin
					if(read_enb_1)
						begin
							counter_1	<= 5'b0;
							soft_reset_1 <= 1'b0;
						end
					else	
						begin
							if (counter_1 == 30)
								begin
									soft_reset_1 <= 1'b1;
									counter_1	<= 5'b0;
								end
							else
								begin
									soft_reset_1 <= 1'b0;
									counter_1	<= counter_1 + 1'b1;
								end
						end
				end
			else	
				counter_1	<= 5'b0;
		end
		
/// Counter Logic for Soft reset 2 - Wait for 30 clock
	always @ (posedge clock)
		begin
			if (!resetn)
				begin
					counter_2	<= 5'b0;
					soft_reset_2 <= 1'b0;
				end
			else if (vld_out_2)
				begin
					if(read_enb_2)
						begin
							counter_2	<= 5'b0;
							soft_reset_2 <= 1'b0;
						end
					else	
						begin
							if (counter_2 == 30)
								begin
									soft_reset_2 <= 1'b1;
									counter_2	<= 5'b0;
								end
							else
								begin
									soft_reset_2 <= 1'b0;
									counter_2	<= counter_2 + 1'b1;
								end
						end
				end
			else	
				counter_2	<= 5'b0;
		end
endmodule


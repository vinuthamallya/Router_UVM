module top;
	
		import router_pkg::*;

		import uvm_pkg::*;

		//Clock generation
		bit clock;
		
		always 
		#10 clock = ~clock;

		//Interface instantiation
		router_if min0(clock);
		router_if sin0(clock);
		router_if sin1(clock);
		router_if sin2(clock);

		//Rtl instantiation
		router_top DUV(clock,min0.resetn,sin0.read_enb,sin1.read_enb,sin2.read_enb,min0.pkt_valid,min0.data_in,
		sin0.data_out,sin1.data_out,sin2.data_out,sin0.valid_out,sin1.valid_out,sin2.valid_out,min0.error,min0.busy);	

		//Setting Interface in config db and calling run_test
		initial
		begin
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif

			uvm_config_db #(virtual router_if)::set(null,"*","vif_min0",min0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_sin0",sin0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_sin1",sin1);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_sin2",sin2);
			run_test();
		end

	endmodule:top


class router_rd_monitor extends uvm_monitor;

   // Factory Registration
	 `uvm_component_utils(router_rd_monitor)
    
   // Declare virtual interface handle with WMON_MP as modport
   virtual router_if.R_MON_MP vif;

   // Declare the router_rd_agent_config handle as "m_cfg"
   router_rd_agt_config m_cfg;
bit [7:0] parity;
   // Analysis TLM port to connect the monitor to the scoreboard for lab09
   uvm_analysis_port #(read_xtn) monitor_port;
   


   // Standard UVM Methods:
   extern function new(string name = "router_rd_monitor", uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern task collect_data();
   extern function void report_phase(uvm_phase phase);
	 
endclass 

//-----------------  constructor new method  -------------------//
function router_rd_monitor::new(string name = "router_rd_monitor", uvm_component parent);
	 super.new(name,parent);
	 monitor_port = new("monitor_port", this);
endfunction

//-----------------  build() phase method  -------------------//
function void router_rd_monitor::build_phase(uvm_phase phase);
	 super.build_phase(phase);
	 if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
		  `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
endfunction

//-----------------  connect() phase method  -------------------//
function void router_rd_monitor::connect_phase(uvm_phase phase);
   vif = m_cfg.vif;
endfunction
//-----------------  run() phase method  -------------------//
task router_rd_monitor::run_phase(uvm_phase phase);
   forever
	    begin
         collect_data(); 
			end    
endtask


// Collect Reference Data from DUV IF 
task router_rd_monitor::collect_data();
   read_xtn mon_data;
   mon_data = read_xtn::type_id::create("mon_data");

	parity = 8'b0;

   @(vif.rmon_cb);
   while(!vif.rmon_cb.read_enb)
   @(vif.rmon_cb);

   @(vif.rmon_cb);
 
   mon_data.header = vif.rmon_cb.data_out;

   mon_data.payload_data = new[mon_data.header[7:2]];
   @(vif.rmon_cb);
   foreach(mon_data.payload_data[i])
			begin
				 mon_data.payload_data[i] = vif.rmon_cb.data_out;
				 @(vif.rmon_cb);
      end
	 mon_data.parity = vif.rmon_cb.data_out;

	parity = 8'b0 ^ mon_data.header;
	foreach(mon_data.payload_data[i])
		parity = parity ^ mon_data.payload_data[i];
	if(parity == mon_data.parity)
		mon_data.error = 1'b0;
	else
		mon_data.error = 1'b1;

	 @(vif.rmon_cb);

	 `uvm_info("ROUTER_rd_MONITOR",$sformatf("printing from monitor \n %s", mon_data.sprint()),UVM_LOW) 
	 m_cfg.mon_data_count++;
	 monitor_port.write(mon_data);
endtask

	 	         	  	  
 // UVM report_phase
function void router_rd_monitor::report_phase(uvm_phase phase);
   `uvm_info(get_type_name(), $sformatf("Report: router read Monitor Collected  %0d Transactions",m_cfg.mon_data_count),UVM_LOW)
endfunction 



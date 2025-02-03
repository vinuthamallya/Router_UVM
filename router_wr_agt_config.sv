class router_wr_agt_config extends uvm_object;

   // UVM Factory Registration Macro
   `uvm_object_utils(router_wr_agt_config)

   // Declare the virtual interface handle vif
   virtual router_if vif;
   static int drv_data_count = 0;
   static int mon_data_count = 0;

   //----------------SET UVM ACTIVE------------------//
   uvm_active_passive_enum is_active = UVM_ACTIVE;

   // Standard UVM Methods
   extern function new(string name = "router_wr_agt_config");
endclass

//-----------------  constructor new method  -------------------//
function router_wr_agt_config::new(string name = "router_wr_agt_config");
   super.new(name);
endfunction

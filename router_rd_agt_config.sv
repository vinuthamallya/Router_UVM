class router_rd_agt_config extends uvm_object;

   // UVM Factory Registration Macro
   `uvm_object_utils(router_rd_agt_config)

   // Declare the virtual interface handle "vif"
   virtual router_if vif;

   //----------------SET UVM ACTIVE------------------//
   uvm_active_passive_enum is_active = UVM_ACTIVE;
   static int drv_data_count = 0;
   static int mon_data_count = 0;

   // Standard UVM Methods
   extern function new(string name = "router_rd_agt_config");
endclass

//-----------------  constructor new method  -------------------//
function router_rd_agt_config::new(string name = "router_rd_agt_config");
   super.new(name);
endfunction

 


class router_wr_seq extends uvm_sequence #(write_xtn);
	
   // Factory registration using `uvm_object_utils

	 `uvm_object_utils(router_wr_seq)  

   // Standard UVM Methods
   extern function new(string name ="router_wr_seq");
endclass

//-----------------  constructor new method  -------------------//
function router_wr_seq::new(string name ="router_wr_seq");
	 super.new(name);
endfunction


///////////////////////SMALL PACKET///////////////////

class router_wxtns_small_pkt extends router_wr_seq;	

   `uvm_object_utils(router_wxtns_small_pkt)
   bit[1:0]addr;
   // Standard UVM Methods:
	 extern function new(string name ="router_wxtns_small_pkt");
	 extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_wxtns_small_pkt::new(string name = "router_wxtns_small_pkt");
	 super.new(name);
endfunction
	  
//-----------------  task body method  -------------------//
task router_wxtns_small_pkt::body();
    	   
	 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration failed, check if it set properly")
 	 req = write_xtn::type_id::create("req");
   start_item(req);
   assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0]==addr;});
	 `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	 finish_item(req); 
endtask

///////////////////////MEDIUM PACKET///////////////////

class router_wxtns_medium_pkt extends router_wr_seq;	

   `uvm_object_utils(router_wxtns_medium_pkt)
    bit[1:0]addr;
   // Standard UVM Methods:
   extern function new(string name ="router_wxtns_medium_pkt");
   extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_wxtns_medium_pkt::new(string name = "router_wxtns_medium_pkt");
	 super.new(name);
endfunction
	  
//-----------------  task body method  -------------------//
      	
task router_wxtns_medium_pkt::body();
   
	 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile, check if it set properly")
          req = write_xtn::type_id::create("req");
          start_item(req);
          assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0]==addr;});
	 `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	 finish_item(req); 
/*	 get_response(rsp);
	 
	 if(rsp.error)
	 begin
	 start_item(req);
   //assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0]==addr;});
	 //`uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	 finish_item(req);
	 end  */
endtask

///////////////////////BIG PACKET///////////////////

class router_wxtns_big_pkt extends router_wr_seq;	

   `uvm_object_utils(router_wxtns_big_pkt)
    
		bit[1:0]addr;
   // Standard UVM Methods:
   extern function new(string name ="router_wxtns_big_pkt");
   extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_wxtns_big_pkt::new(string name = "router_wxtns_big_pkt");
	 super.new(name);
endfunction
	  
//-----------------  task body method  -------------------//
      	
task router_wxtns_big_pkt::body();
   if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile, check if it set properly")

   req = write_xtn::type_id::create("req");
   start_item(req);
   assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0]==addr;});
	 `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	 finish_item(req); 
	 
endtask

///////////////////////RANDOM PACKET///////////////////

class router_wxtns_rndm_pkt extends router_wr_seq;	

   `uvm_object_utils(router_wxtns_rndm_pkt)
   bit[1:0]addr;
   // Standard UVM Methods:
   extern function new(string name ="router_wxtns_rndm_pkt");
   extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_wxtns_rndm_pkt::new(string name = "router_wxtns_rndm_pkt");
	 super.new(name);
endfunction
	  
//-----------------  task body method  -------------------//
      	
task router_wxtns_rndm_pkt::body();
    if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile, check if it set properly")

   req = write_xtn::type_id::create("req");
   start_item(req);
   assert(req.randomize() with {header[1:0]==addr;});
	 `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	 finish_item(req); 
endtask


///////////////////////BAD PACKET///////////////////

class router_wxtns_bad_pkt extends router_wr_seq;	

   `uvm_object_utils(router_wxtns_bad_pkt)

   // Standard UVM Methods:
   extern function new(string name ="router_wxtns_bad_pkt");
   extern task body();
endclass

//-----------------  constructor new method  -------------------//
function router_wxtns_bad_pkt::new(string name = "router_wxtns_bad_pkt");
	 super.new(name);
endfunction
	  
//-----------------  task body method  -------------------//
      	
task router_wxtns_bad_pkt::body();
   begin
   	  req = write_xtn::type_id::create("req");
      start_item(req);
   	  assert(req.randomize());
	    `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW) 
	    finish_item(req); 
	 end
endtask







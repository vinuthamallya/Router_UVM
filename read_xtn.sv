class read_xtn extends uvm_sequence_item;

   //....................FACTORY REGISTRATION.....................//
   `uvm_object_utils(read_xtn)

   //..................VARIABLES DECLARATION......................//
  
   bit [7:0]header;
   bit [7:0]payload_data[];
   bit [7:0]parity;
   rand bit [5:0]no_of_cycles;
bit error; 
 


   //.........................METHODS.............................//
   extern function new(string name ="read_xtn");
   extern function void do_print(uvm_printer printer);
endclass

//.......................CONSTRUCTOR........................//
function read_xtn::new(string name = "read_xtn");
 	 super.new(name);
endfunction

//-----------------  do_print method  -------------------//
function void  read_xtn::do_print (uvm_printer printer);
   super.do_print(printer); 
   //                   string name   			    bitstream value        	size       radix for printing
   printer.print_field( "header", 				this.header, 	   	  8,		 UVM_HEX	);
   foreach(payload_data[i])
         printer.print_field( $sformatf(" payload_data[%0d]",i),	this.payload_data[i], 	  8,		 UVM_HEX	);
         printer.print_field( "parity", 				this.parity, 	  	  8,		 UVM_HEX	);
	 printer.print_field( "no_of_cycles", 				this.no_of_cycles, 	   	  6,		 UVM_DEC	);
         printer.print_field( "error", 					this.error,		  1, 			UVM_DEC);

endfunction




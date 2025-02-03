interface router_if(input bit clock);
logic resetn;
bit pkt_valid;
logic [7:0] data_in;
logic error;
logic busy;
logic read_enb;
logic [7:0] data_out;
logic valid_out;

clocking wdr_cb@(posedge clock);
default input #1 output #1;
			input busy;
			input error;
			output resetn;
			output pkt_valid;
			output data_in;
endclocking

clocking wmon_cb@(posedge clock);
			default input #1 output #1;
			input busy;
			input error;
			input resetn;
			input pkt_valid;
			input data_in;
endclocking

clocking rmon_cb@(posedge clock);
			default input #1 output #1;
			input read_enb;
			input valid_out;	
			input data_out;	
endclocking

clocking rdr_cb@(posedge clock);
			default input #1 output #1;
			input valid_out;
			output read_enb;
endclocking


modport W_DR_MP(clocking wdr_cb);
modport W_MON_MP(clocking wmon_cb);
modport R_MON_MP(clocking rmon_cb);
modport R_DR_MP(clocking rdr_cb);

//endinterface




property pkt_vld;
      @(posedge clock)
      $rose(min0.pkt_valid) |=> min0.busy;
   endproperty

   A1: assert property (pkt_vld);

   property stable;
      @(posedge clock)
      min0.busy |=> $stable(min0.data_in);
   endproperty

   A2: assert property (stable);

   property read1;
      @(posedge clock)
      $rose(sin1.valid_out) |=> ## [0:29] sin1.read_enb;
   endproperty

   R1:assert property(read1);

   property read2;
      @(posedge clock)
      $rose(sin2.valid_out) |=> ## [0:29] sin2.read_enb;
   endproperty

   R2:assert property(read2);

   property read3;
      @(posedge clock)
      $rose(sin0.valid_out) |=> ## [0:29] sin0.read_enb;
   endproperty

   R3:assert property(read3);


   property valid1;
      bit[1:0]addr;
      @(posedge clock)
      ( $rose(min0.pkt_valid),addr = min0.data_in[1:0]) ##3 (addr==0) |->sin0.valid_out;
   endproperty
 
   property valid2;
      bit[1:0]addr;
      @(posedge clock)
      ( $rose(min0.pkt_valid),addr = min0.data_in[1:0]) ##3 (addr==1) |->sin1.valid_out;
   endproperty

   property valid3;
      bit[1:0]addr;
      @(posedge clock)
      ( $rose(min0.pkt_valid),addr = min0.data_in[1:0]) ##3 (addr==2) |->sin2.valid_out;
   endproperty

   property valid;
      @(posedge clock)
      $rose(min0.pkt_valid)|-> ##3 sin0.valid_out | sin2.valid_out |sin1.valid_out;
   endproperty

   V: assert property(valid);
   V1: assert property(valid1);
   V2: assert property(valid2);
   V3: assert property(valid3);

   property read_1;
      bit[1:0]addr;
      @(posedge clock)
      sin1.valid_out ##1 !sin1.valid_out |=> $fell(sin1.read_enb);
  endproperty
 
  property read_2;
     bit[1:0]addr;
     @(posedge clock)
     sin2.valid_out ##1 !sin2.valid_out |=> $fell(sin2.read_enb);
  endproperty

  property read_3;
     bit[1:0]addr;
     @(posedge clock)
     (sin0.valid_out)  ##1 !sin0.valid_out |=> $fell(sin0.read_enb);
  endproperty

  RR1:assert property(read_1);
  RR2:assert property(read_2);
  RR3:assert property(read_3);


endinterface

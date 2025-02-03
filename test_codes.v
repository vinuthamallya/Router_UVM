task test:: run_phase(uvm phase phase);
	seq_a = sequence_A::type_id::create("seq_a");// the sequence for agent A
	seq_b = sequence_B::type_id::create("seq_b");// the sequence for agent B
	
	phase.raise_objection(this);
    seq_a.start(env.agt_a.seqr_a);
	seq_b.start(env.agt_b.seqr_b);
    phase.drop_objection(this);
	
endtask
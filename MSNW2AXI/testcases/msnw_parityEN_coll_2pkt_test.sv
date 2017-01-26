class msnw_parityEN_coll_2pkt_test extends base_test;

  `uvm_component_utils(msnw_parityEN_coll_2pkt_test)
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("TEST","msnw_parityEN_coll_2pkt_test: run phase begins", UVM_HIGH)
  endfunction


  task run_phase(uvm_phase phase);
    msnw_parityEN_coll_2pkt_seq seq;
    super.run_phase(phase);
        phase.raise_objection(this);
        seq = msnw_parityEN_coll_2pkt_seq::type_id::create("seq");
        seq.start(m_env.vs);
     #1 phase.drop_objection(this);
  endtask : run_phase
  
endclass: msnw_parityEN_coll_2pkt_test

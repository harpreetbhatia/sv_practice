//  DESCRIPTION : This file declares the msnw basic test with 1 packet. 
class single_msnw_pkt_test extends base_test;

  `uvm_component_utils(single_msnw_pkt_test)
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("WARNING","single_msnw_pkt_test: run phase begins", UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    single_msnw_pkt_seq seq;
    super.run_phase(phase);
        phase.raise_objection(this);
        seq = single_msnw_pkt_seq::type_id::create("seq");
        seq.start(m_env.my_m2a_env.msnw_in_env.agent.dut_in_sequencer);
     #1 phase.drop_objection(this);
  endtask : run_phase
  
endclass: single_msnw_pkt_test

//  DESCRIPTION : This file declares the msnw basic test number 1. 
class virt_basic_test1 extends base_test;

  `uvm_component_utils(virt_basic_test1)
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("WARNING","virt_basic_test1: run phase begins", UVM_HIGH)

    //set the starting sequence to system
//    uvm_config_db#(uvm_object_wrapper)::set(this, "m_env.vs.run_phase", "default_sequence",simple_seq::type_id::get());
//    uvm_top.set_config_int("*", "recording_detail" , UVM_LOW);

  endfunction


  task run_phase(uvm_phase phase);
    simple_seq seq;
    super.run_phase(phase);
        phase.raise_objection(this);
        seq = simple_seq::type_id::create("seq");
        seq.start(m_env.vs);
     #1 phase.drop_objection(this);
  endtask : run_phase
  
endclass: virt_basic_test1

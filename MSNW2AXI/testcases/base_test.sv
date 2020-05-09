//  DESCRIPTION : This file declares the base test used by all testcases. 
class base_test extends uvm_test;

  `uvm_component_utils(base_test)
  
  m2a_sv_env m_env; 
  uvm_table_printer m_printer; 
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     m_env = m2a_sv_env::type_id::create("m_env",this);
	 m_printer = new();
	 m_printer.knobs.depth = 5;

    //enable/disable slave response randomization in this test, default to enabled
    uvm_config_db#(int)::set(this, "m_env.my_m2a_env.activeSlave.driver", "randomizeSlaveResp", 1);

  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
     `uvm_info("get_type_name()",$sformatf("Printing the Test Topology: \n%s", 
	            this.sprint(m_printer)), UVM_LOW)
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.phase_done.set_drain_time(this, 1000); // ensures that a test does not end prematurely when all the objections are dropped
  endtask : run_phase
 
endclass: base_test

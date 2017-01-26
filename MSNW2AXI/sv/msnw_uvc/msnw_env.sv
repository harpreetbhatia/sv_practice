class msnw_env extends uvm_env;

  // Components of the environment
  msnw_agent agent;
  
  `uvm_component_utils(msnw_env)

  // Constructor - Required UVM syntax
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

 // UVM build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = msnw_agent::type_id::create("agent",this);
  endfunction : build_phase

endclass : msnw_env

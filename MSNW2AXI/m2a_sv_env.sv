
`ifndef _CDN_AXI_SVE_SV_
`define _CDN_AXI_SVE_SV_

 import uvm_pkg::*;
 import msnw_pkg::*;
 import axi_pkg::*;

  // Import the DDVAPI CDN_AXI SV interface and the generic mem Interface
  import DenaliSvCdn_axi::*;
  import DenaliSvMem::*;

  // Include the VIP UVM Base classes
  import cdnAxiUvm::*;

class m2a_sv_env extends uvm_env;

  m2a_env my_m2a_env;
  m2a_virt_sequencer vs;
     
  `uvm_component_utils(m2a_sv_env)
        
  function new(string name = "m2a_sv_env", uvm_component parent);
    super.new(name,parent);
    factory.set_type_override_by_type(cdnAxiUvmSequencer::get_type(),cdnAxiUvmUserSequencer::get_type());
    factory.set_type_override_by_type(cdnAxiUvmInstance::get_type(),cdnAxiUvmUserInstance::get_type());
    factory.set_type_override_by_type(cdnAxiUvmMonitor::get_type(),cdnAxiUvmUserMonitor::get_type());
    factory.set_type_override_by_type(cdnAxiUvmMemInstance::get_type(),cdnAxiUvmUserMemInstance::get_type());
  endfunction // new
   
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    //set Passive Master monitor to collect coverage
    set_config_int("my_m2a_env.passiveMaster.monitor", "coverageEnable",1);
    
    //set the full hdl path of the agent wrapper - this setting is mandatory.
    set_config_string("my_m2a_env.activeMaster","hdlPath", "lw56_40_13_tb.activeMaster");
    set_config_string("my_m2a_env.passiveMaster","hdlPath", "lw56_40_13_tb.passiveMaster");
    set_config_string("my_m2a_env.activeSlave","hdlPath", "lw56_40_13_tb.activeSlave");
    set_config_string("my_m2a_env.passiveSlave","hdlPath", "lw56_40_13_tb.passiveSlave");
    
    my_m2a_env = m2a_env::type_id::create("my_m2a_env", this);
    vs = m2a_virt_sequencer::type_id::create("vs", this); 
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    $cast(vs.Axi_slaveSeqr , my_m2a_env.activeSlave.sequencer);
    $cast(vs.Axi_masterSeqr, my_m2a_env.activeMaster.sequencer);
    $cast(vs.msnw_in_seqr  , my_m2a_env.msnw_in_env.agent.dut_in_sequencer);
    $cast(vs.msnw_out_seqr , my_m2a_env.msnw_out_env.agent.dut_out_sequencer);
    $cast(vs.pEnv          , my_m2a_env);
  endfunction 
      
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Printing environment settings: \n %0s", this.sprint()), UVM_LOW)
  endfunction 
      
endclass

`endif

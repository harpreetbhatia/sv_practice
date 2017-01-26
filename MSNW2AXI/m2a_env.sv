////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : This file declares the m2a(DUT) environment. 
//
//
//  NOTES : Naming conventions of interfaces:
//          prefix of lower-case "i_" or "o_": interface connecting to DUT
//          prefix of lower-case "in_" or "out_": interface passed to the environment
//          prefix of lower-case "vi_": virtual interface used by verification components
//
////////////////////////////////////////////////////////////////////////////////
 
class m2a_env extends uvm_env;

  // Components of the environment
  msnw_env msnw_in_env;
  msnw_env msnw_out_env;

  //Slave Agent (passiveMaster instanced separately, this is where protocol checking occurs according
  //to Cadence)
  cdnAxiUvmUserSlaveAgent activeSlave;
  cdnAxiUvmUserMasterAgent  passiveMaster; 

  //Master Agent (passiveSlave instanced separately, this is where protocol checking occurs according
  //to Cadence)
  cdnAxiUvmUserMasterAgent  activeMaster; 
  cdnAxiUvmUserSlaveAgent passiveSlave;

   m2a_scbd sb;
  
  `uvm_component_utils(m2a_env)

  // Constructor - Required UVM syntax
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task wait_for_EndedCbEvent();

endclass : m2a_env


//------------------------------------------------------------------------------
// m2a_env functions and/or tasks
//------------------------------------------------------------------------------

// UVM build_phase
function void m2a_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

    set_inst_override_by_type("activeSlave.driver",cdnAxiUvmDriver::get_type(),cdnAxiUvmUserSlaveDriver::get_type());

  uvm_config_db#(int)::set(this, "msnw_in_env.agent", "is_active", UVM_ACTIVE);
  uvm_config_db#(int)::set(this, "msnw_out_env.agent", "is_active", UVM_PASSIVE);

  uvm_config_db#(string)::set(this, "msnw_in_env.agent.monitor", "monitor_if", "in_msnw");
  uvm_config_db#(string)::set(this, "msnw_out_env.agent.monitor", "monitor_if", "out_msnw");
  
  msnw_in_env = msnw_env::type_id::create("msnw_in_env",this);
  msnw_out_env = msnw_env::type_id::create("msnw_out_env",this);
//cjw for axi

    set_config_int("activeMaster","is_active",UVM_ACTIVE);
    set_config_int("passiveSlave","is_active",UVM_PASSIVE);
    set_config_int("activeSlave","is_active",UVM_ACTIVE);
    set_config_int("passiveMaster","is_active",UVM_PASSIVE);

    // Active Master
    activeMaster = cdnAxiUvmUserMasterAgent::type_id::create("activeMaster", this);

    // Passive Slave
    passiveSlave = cdnAxiUvmUserSlaveAgent::type_id::create("passiveSlave", this);

    // Active Slave
    activeSlave = cdnAxiUvmUserSlaveAgent::type_id::create("activeSlave", this);

    // Passive Master
    passiveMaster = cdnAxiUvmUserMasterAgent::type_id::create("passiveMaster", this);

    // Scoreboard Master
    sb = m2a_scbd::type_id::create("sb", this);

    // set the full hdl path of the agent wrapper - this setting is mandatory.
    set_config_string("activeMaster","hdlPath", "lw56_40_13_tb.activeMaster");
    set_config_string("passiveSlave","hdlPath", "lw56_40_13_tb.passiveSlave");
    set_config_string("activeSlave","hdlPath", "lw56_40_13_tb.activeSlave");
    set_config_string("passiveMaster","hdlPath", "lw56_40_13_tb.passiveMaster");
    activeMaster.print();
    passiveSlave.print();
    activeSlave.print();
    passiveMaster.print();

endfunction : build_phase

// UVM connect_phase
function void m2a_env::connect_phase(uvm_phase phase);
  `uvm_info(get_type_name(), "connect_phase for m2a_env starting", UVM_LOW);
  super.connect_phase(phase);

  //connect up analysis ports to scoreboard fifos
  activeMaster.monitor.EndedCbPort.connect(sb.axi_in_pkts_collected.analysis_export);
  activeSlave.monitor.EndedCbPort.connect(sb.axi_out_pkts_collected.analysis_export);
  msnw_in_env.agent.monitor.msnw_ap.connect(sb.msnw_in_pkts_collected.analysis_export);
  msnw_out_env.agent.monitor.msnw_ap.connect(sb.msnw_out_pkts_collected.analysis_export);

  `uvm_info(get_type_name(), "connect_phase for m2a_env done", UVM_LOW);
endfunction : connect_phase

  // ***************************************************************
  // Method : end_of_elaboration_phase
  // Desc.  : Apply configuration settings in this phase
  // ***************************************************************
  function void m2a_env::end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase);

    `uvm_info(get_type_name(), "Setting callbacks", UVM_LOW);

    // Enable PureSpec callbacks. Uncomment as necessary
    // Refer to the User Guide for callbacks description

    // Active Master
    void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_Error));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_ResetStarted));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_ResetEnded));
    void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSend));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendAddress));
    void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendResponse));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendTransfer));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_Started));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedAddress));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedResponse));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedTransfer));
    void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_Ended));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedAddress));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedResponse));
    //void'(activeMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedTransfer));

    // Passive Master  (this is for protocol checks on DUT for interface where it is master)
    void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_Error));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_ResetStarted));
    void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_ResetEnded));
    void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_Started));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedAddress));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedResponse));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_StartedTransfer));
    void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_Ended));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedAddress));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedResponse));
    //void'(passiveMaster.inst.setCallback( DENALI_CDN_AXI_CB_EndedTransfer));

    // Active Slave
    void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_Error));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_ResetStarted));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_ResetEnded));
    void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSend));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendAddress));
    void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendResponse));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_BeforeSendTransfer));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_Started));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedAddress));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedResponse));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedTransfer));
    void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_Ended));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedAddress));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedResponse));
    //void'(activeSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedTransfer));

    // Passive Slave  (this is for protocol checks on DUT for interface where it is slave)
    void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_Error));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_ResetStarted));
    void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_ResetEnded));
    void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_Started));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedAddress));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedResponse));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_StartedTransfer));
    void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_Ended));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedAddress));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedResponse));
    //void'(passiveSlave.inst.setCallback( DENALI_CDN_AXI_CB_EndedTransfer));

    `uvm_info(get_type_name(), "Setting callbacks ... DONE", UVM_LOW);

  endfunction : end_of_elaboration_phase



  //This task waits for EndedCbEvent Callback to be triggered
  task m2a_env::wait_for_EndedCbEvent();
    // denaliCdn_apbTransaction tr;
    `uvm_info(get_type_name(), "wait_for_EndedCbEvent Started", UVM_LOW);
    // passiveMaster.monitor.EndedCbPort.wait_trigger_data(obj);
    `uvm_info(get_type_name(), "wait_for_EndedCbEvent Ended", UVM_LOW);
  endtask
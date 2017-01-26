class msnw_agent extends uvm_agent;

  // This field determines whether an agent is active or passive.
   protected uvm_active_passive_enum is_active = UVM_ACTIVE;

  msnw_monitor   monitor;
  msnw_sequencer dut_in_sequencer;
  msnw_in_driver dut_in_driver;
  msnw_sequencer dut_out_sequencer;
  msnw_out_driver dut_out_driver;
  
  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(msnw_agent)
 	`uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : msnw_agent


//------------------------------------------------------------------------------
// msnw_agent functions and/or tasks
//------------------------------------------------------------------------------

// UVM build_phase
function void msnw_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);  
  if(is_active == UVM_ACTIVE) begin
    dut_in_sequencer = msnw_sequencer::type_id::create("dut_in_sequencer",this);
    dut_in_driver = msnw_in_driver::type_id::create("dut_in_driver",this);
  end
  else if (is_active == UVM_PASSIVE) begin
    dut_out_sequencer = msnw_sequencer::type_id::create("dut_out_sequencer",this);
    dut_out_driver = msnw_out_driver::type_id::create("dut_out_driver",this);
  end
    monitor = msnw_monitor::type_id::create("monitor",this);
     `uvm_info("MSNW_AGENT", "build stage complete", UVM_LOW)
endfunction : build_phase

// UVM connect_phase
function void msnw_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
   // Connect the driver to the sequencer using TLM interface
  if (is_active == UVM_ACTIVE) begin
    dut_in_driver.seq_item_port.connect(dut_in_sequencer.seq_item_export);
  end
  else if (is_active == UVM_PASSIVE) begin
    dut_out_driver.seq_item_port.connect(dut_out_sequencer.seq_item_export);
  end
  	`uvm_info("MSNW_IN_AGENT", "connect stage complete", UVM_LOW)
endfunction : connect_phase


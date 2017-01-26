class msnw_collector extends uvm_component;

  // The virtual interface used to view HDL signals.
  virtual m2a_if.msnw_in vif;

  // Property indicating the number of packets occuring on the msnw.
  protected int unsigned num_packets = 0;

  // TLM Ports - packet collected for monitor 
  uvm_analysis_port #(msnw_packet) item_collected_port;

  // temp to hold the packet currently captured. 
  msnw_packet pkt_collected;

  `uvm_component_utils_begin(msnw_collector)
    `uvm_field_int(num_packets, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_packets();
  extern virtual function void report_phase(uvm_phase phase);

endclass : msnw_collector



//------------------------------------------------------------------------------
// msnw_collector functions and/or tasks
//------------------------------------------------------------------------------



// UVM build_phase
function void msnw_collector::build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_collected = msnw_packet::type_id::create("pkt_collected");
    item_collected_port = new("item_collected_port", this); //create TLM port
    if (!uvm_config_db#(virtual m2a_if.msnw_in)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
endfunction : build_phase

// UVM run_phase()
task msnw_collector::run_phase(uvm_phase phase);
    @(posedge vif.rstb);
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_LOW)
    collect_packets();
endtask : run_phase

// collect_packets
task msnw_collector::collect_packets();
  forever begin
    @(posedge vif.clk iff (vif.rstb !=0))  // rstb is inactive
    void'(this.begin_tr(pkt_collected,"msnw_collector","UVM Debug",
                    "MSNW collector: packet is inside collect_packets()"));
    pkt_collected.xoff = vif.xoff_out;
    this.end_tr(pkt_collected);
    item_collected_port.write(pkt_collected);
    `uvm_info(get_type_name(), $psprintf("transfer collected :\n%s",
              pkt_collected.sprint()), UVM_MEDIUM)
      `ifdef HEAP
      runq.push_back(pkt_collected);
      `endif
     num_packets++;
    end
endtask : collect_packets

function void msnw_collector::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report: MSNW collector collected %0d transfers", num_packets), UVM_LOW);
endfunction : report_phase



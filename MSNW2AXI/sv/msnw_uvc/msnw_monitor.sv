////////////////////////////////////////////////////////////////////////////////
//  DESCRIPTION : This msnw monitor is for msnw2axi as well as axi2msnw.
//
//
//  NOTES : Naming conventions of interfaces: given in interface file.
//
////////////////////////////////////////////////////////////////////////////////

class msnw_monitor extends uvm_component;

// Property indicating the number of packets occurring on the msnw.
  protected int unsigned num_trans = 0;

  `uvm_component_utils_begin(msnw_monitor)
    `uvm_field_int(num_trans, UVM_DEFAULT)
  `uvm_component_utils_end
  
  // TLM Ports - trans collected for monitor 
  uvm_analysis_port #(msnw_trans) msnw_ap;
 // uvm_analysis_port #(msnw_trans) msnw_output_ap;
  
// temp to hold the signals. 
  protected msnw_trans                  trans_collected;
  msnw_trans                            trans_clone; // Create & clone a transaction

  virtual msnw_if vi_msnw; // MSNW virtual interface
  string monitor_if;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern virtual protected task collect_trans();
  extern virtual function void report_phase(uvm_phase phase);

endclass : msnw_monitor



//------------------------------------------------------------------------------
// msnw_monitor functions and/or tasks
//------------------------------------------------------------------------------

// UVM build_phase
function void msnw_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "monitor_if", monitor_if))
      `uvm_fatal("NOSTRING", {"Need interface name for: ", get_full_name(), ".monitor_if"})
	  
     `uvm_info(get_type_name(), $sformatf("interface used is %0s", monitor_if), UVM_LOW)
	 
    if (!uvm_config_db#(virtual msnw_if)::get(this, "", monitor_if, vi_msnw))
      `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vi_msnw"})
    
	trans_collected = msnw_trans::type_id::create("trans_collected");
    trans_clone     = msnw_trans::type_id::create("trans_clone");// copy of the trans   
	msnw_ap = new("msnw_ap", this); //create TLM port for msnw input intf
 //   msnw_output_ap = new("msnw_output_ap", this); //create TLM port for msnw output intf


endfunction : build_phase

// UVM run_phase()
task msnw_monitor::run_phase(uvm_phase phase);
    @(posedge vi_msnw.rstb);  
    `uvm_info(get_type_name(), "Reset dropped", UVM_LOW)
    collect_trans();
endtask : run_phase

// collect_trans
task msnw_monitor::collect_trans();
  forever begin
    @(vi_msnw.mon iff ((vi_msnw.rstb !=0)&& (vi_msnw.mon.valid)))  // rstb is inactive
    void'(this.begin_tr(trans_collected,"msnw_monitor","UVM Debug",
                    "MSNW monitor: trans is inside collect_trans()"));
    trans_collected.pkt          = vi_msnw.mon.msnw_pkt;  
	trans_collected.valid        = vi_msnw.mon.valid;
    trans_collected.xoff         = vi_msnw.mon.xoff;
    trans_collected.parity_en    = vi_msnw.mon.parity_en;
    trans_collected.parity_error = vi_msnw.mon.parity_error; // used in axi2msnw 
    trans_collected.error_pkt    = vi_msnw.mon.error_pkt;    // used in axi2msnw 
    this.end_tr(trans_collected);
    
	$cast(trans_clone, trans_collected.clone());
    
	msnw_ap.write(trans_clone);
`uvm_info(get_type_name(), $psprintf("\nclone collected: %H\npkt collected: %H\nvalid collected: %b...\nxoff collected: %b...\nparity_en collected: %b...\nparity_error collected: %b...\nerror_pkt collected: %H",
                           trans_clone.pkt, trans_collected.pkt, trans_collected.valid,trans_collected.xoff, trans_collected.parity_en, trans_collected.parity_error,trans_collected.error_pkt), UVM_MEDIUM)
      `ifdef HEAP
      runq.push_back(trans_collected);
      `endif
     
	 num_trans++;
    end
endtask : collect_trans

function void msnw_monitor::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $psprintf("Report: MSNW monitor collected %0d transfers", 
            num_trans), UVM_LOW);
endfunction : report_phase

////////////////////////////////////////////////////////////////////////////////
//  DESCRIPTION : This file declares the msnw driver at the output interface of the DUT. 
//
//
//  NOTES : Naming conventions of interfaces:
//          prefix of lower-case "i_" or "o_": interface connecting to DUT
//          prefix of lower-case "in_" or "out_": interface passed to the environment
//          prefix of lower-case "vi_": virtual interface used by verification components
//
////////////////////////////////////////////////////////////////////////////////

class msnw_out_driver extends uvm_driver #(msnw_trans);

  // The virtual interface used to drive and view HDL signal
  virtual msnw_if vi_msnw;
  virtual atu_if  vi_atu;
  `uvm_component_utils(msnw_out_driver)
 
// temp to hold the msnw_pkt, valid, parity_error, error_pkt.
// TBD
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset();

endclass : msnw_out_driver


//------------------------------------------------------------------------------
// msnw_out_driver functions and/or tasks
//------------------------------------------------------------------------------


// UVM build_phase - gets the vi_msnw, vi_atu 
function void msnw_out_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual msnw_if)::get(this, "", "out_msnw", vi_msnw))
    `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vi_msnw"});
endfunction : build_phase

// UVM run_phase
task msnw_out_driver::run_phase(uvm_phase phase);
    get_and_drive();
endtask : run_phase

// Task: Drive all signals to reset state 
task msnw_out_driver::reset();
 forever begin
  @(negedge vi_msnw.rstb)
        `uvm_info("msnw_out_driver", "Resetting signals", UVM_MEDIUM)
  vi_msnw.slv.xoff            <= 'h1;
  end
 endtask : reset

// Task: manage the interaction between the sequencer and driver
task msnw_out_driver::get_and_drive();
fork
  forever @(vi_msnw.slv iff (vi_msnw.rstb !=0)) begin // rstb is inactive
          vi_msnw.slv.xoff  <= 'h0;
    end
  while (1)  reset();
join
endtask : get_and_drive

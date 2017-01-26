class msnw_in_driver extends uvm_driver #(msnw_trans);

  // The virtual interface used to drive and view HDL signal
  virtual msnw_if vi_msnw;
  virtual atu_if  vi_atu;
  `uvm_component_utils(msnw_in_driver)
 
// temp to hold the xoff_out.
  protected logic  m_xoff;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual protected task get_and_drive();
  extern virtual protected task reset();
  extern virtual protected task drive_trans (msnw_trans trans); //, atu_trans ctrl);

endclass : msnw_in_driver


//------------------------------------------------------------------------------
// msnw_in_driver functions and/or tasks
//------------------------------------------------------------------------------


// UVM build_phase - gets the vi_msnw, vi_atu 
function void msnw_in_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual msnw_if)::get(this, "", "in_msnw", vi_msnw))
    `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vi_msnw"});
  if (!uvm_config_db#(virtual atu_if)::get(this, "", "in_atu", vi_atu))
    `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vi_atu"});
endfunction : build_phase

// UVM run_phase
task msnw_in_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);  
    get_and_drive();
endtask : run_phase

// Task: Drive all signals to reset state 
task msnw_in_driver::reset();
 forever begin
  @(negedge vi_msnw.rstb)
        `uvm_info("msnw_in_driver", "Resetting signals", UVM_MEDIUM)
  vi_msnw.mstr.msnw_pkt        <= 'h0;
  vi_msnw.mstr.valid           <= 'b0;
  vi_msnw.mstr.parity_en       <= 'b0;
  vi_atu.mstr.mask             <= 'h0;
  vi_atu.mstr.bar              <= 'h0;
  vi_atu.mstr.collate          <= 'h1;
  m_xoff                        = 'b1;
  end
 endtask : reset

// Task: manage the interaction between the sequencer and driver
task msnw_in_driver::get_and_drive();
fork
  forever @(vi_msnw.mstr iff (vi_msnw.rstb !=0)) 
         m_xoff = vi_msnw.mstr.xoff; // collect xoff_out	    
 
  begin
   @(posedge vi_msnw.rstb); 
    forever begin
      if (vi_msnw.rstb !=0) begin // rstb is inactive
          seq_item_port.get_next_item(req);
              if (req == null) `uvm_fatal("DRIVER", "msnw_pkt returned null"); 
          drive_trans(req);
          seq_item_port.item_done(req); 
        `uvm_info("msnw_in_driver", "\nTruly Finished driving a pkt", UVM_MEDIUM)
      end
      else  repeat (1) @ (vi_msnw.mstr);
	 end
  end
 
  while (1)  reset();
join
endtask : get_and_drive


  // Task: Drive a msnw transfer and an atu transfer when an item is ready to be sent.
task msnw_in_driver::drive_trans (msnw_trans trans); //, atu_trans ctrl);
`uvm_info(get_type_name(), $psprintf("\nFetched a packet: %H",trans.pkt), UVM_MEDIUM)

  //only wait clocks if transaction specifies delay
  if (trans.pkt_delay > 0)
    repeat(trans.pkt_delay) @(vi_msnw.mstr);

  //time to drive the trans
  vi_msnw.mstr.msnw_pkt           <= trans.pkt;
  vi_msnw.mstr.valid              <= trans.valid;
  vi_msnw.mstr.parity_en          <= trans.parity_en;
  vi_atu.mstr.mask                <= 'h0; //ctrl.mask;
  vi_atu.mstr.bar                 <= 'h0; //ctrl.bar;
  vi_atu.mstr.collate             <= 1; //ctrl.collate;

  repeat(1) @(vi_msnw.mstr); // wait a cycle; 
          `uvm_info("msnw_in_driver", "\nrepeat(1) @(vi_msnw.mstr)", UVM_MEDIUM)
  //if xoff=0, data will be transferred on next clock edge
  //keep driving interface until you see DUT has accepted the transfer
  while (m_xoff == 1)  begin
     repeat(1) @(vi_msnw.mstr);
          `uvm_info("msnw_in_driver", "\nwhile (m_xoff == 1)", UVM_MEDIUM)
   end
  //data transfer occurs when valid=1 and xoff=0, so we're good now

  //Default these back to inactive but don't let time elapse
  //If next transaction is waiting and delay = 0, want to immediately transition to it
  //without asserting any additional delay
  vi_msnw.mstr.valid    <= 'h0;
  vi_msnw.mstr.msnw_pkt <= 'h0;

  endtask : drive_trans


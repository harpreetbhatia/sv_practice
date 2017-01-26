// ***************************************************************
// Class: m2a_virt_sequence
//
// This class defines a base virtual sequence
// ***************************************************************
`ifndef CDN_AXI_UVM_VIRTUAL_SEQUENCE_SV
`define CDN_AXI_UVM_VIRTUAL_SEQUENCE_SV

class m2a_virt_sequence extends uvm_sequence;
  
   // By default, if the response_queue overflows, an error is reported. The
   // response_queue will overflow if more responses are sent to this sequence
   // from the driver than get_response calls are made. Setting value to 1
   // disables these errors, while setting it to 0 enables them.
   bit response_queue_error_report_disbaled = 1;
   
   // User extention for active master agent's monitor
   cdnAxiUvmUserMonitor myMonitor;
   
   `uvm_object_utils_begin(m2a_virt_sequence)
      `uvm_field_int(response_queue_error_report_disbaled, UVM_ALL_ON)
    `uvm_object_utils_end
	
  `uvm_declare_p_sequencer(m2a_virt_sequencer)

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "m2a_virt_sequence");
    super.new(name);
    set_response_queue_error_report_disabled(response_queue_error_report_disbaled);
  endfunction : new

  // ***************************************************************
  // Method : pre_body
  // Desc.  : Raise an objection to prevent premature simulation end
  // ***************************************************************
  virtual task pre_body();
    if (starting_phase != null) begin
      starting_phase.raise_objection(this);
    end
    
    if (!$cast(myMonitor, p_sequencer.pEnv.activeMaster.monitor))  
        `uvm_fatal(get_type_name(), "$cast(myMonitor, p_sequencer.pEnv.activeMaster.monitor) call failed!");
    
  endtask

  // ***************************************************************
  // Method : post_body
  // Desc.  : Drop the objection raised earlier
  // ***************************************************************
  virtual task post_body();
    if (starting_phase != null) begin
      starting_phase.drop_objection(this);
    end
  endtask
  
endclass : m2a_virt_sequence 

`endif // CDN_AXI_UVM_VIRTUAL_SEQUENCE_SV 


// ****************************************************************************
// Class : simple_seq
// Desc. : Simple virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class simple_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   single_msnw_pkt_seq  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(simple_seq)

   function new(string name="simple_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence simple_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = single_msnw_pkt_seq::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of simple_seq", UVM_LOW);
      
  endtask

endclass : simple_seq

// ****************************************************************************
// Class : multi_seq
// Desc. : Simple virtual sequence, multiple times - This sequence sends a 0 - 16 transactions 
//        in both directions, from msnw2axi and from axi2msnw
// ****************************************************************************
class multi_seq extends m2a_virt_sequence;

  rand reg [4:0]  a2m_cnt, m2a_cnt ;
  //rand reg [4:0]  a2m_cnt, m2a_cnt, a2m_index, m2a_index ;

   //AXI mastered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   single_msnw_pkt_seq  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(multi_seq)

   function new(string name="multi_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence multi_seq started", UVM_LOW);
    
    #500;
    a2m_cnt = $urandom_range(16); 
    m2a_cnt = $urandom_range(16); 

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        for (int m2a_index=1; m2a_index<=m2a_cnt; m2a_index++) begin
          `uvm_info(get_type_name(), $sformatf("Virtual sequence for MSNW transaction %d",m2a_index), UVM_LOW);
          msnw_write = single_msnw_pkt_seq::type_id::create("msnw_write");
          msnw_write.start(p_sequencer.msnw_in_seqr);
        end
      end

    //AXI_2_MSNW
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        for (int a2m_index=1; a2m_index<=a2m_cnt; a2m_index++) begin
          `uvm_info(get_type_name(), $sformatf("Virtual sequence issuing an AXI Master write %d",a2m_index), UVM_LOW);
        `  uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
             masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
             masterBurst.IdTag ==  a2m_index;
             //masterBurst.StartAddress == a2m_index; //randomize failure with this??
             masterBurst.StartAddress < 'h5_ffff; //This must be constrained to be within the
                                                  //mapped address range (default in cdnAxiUvmUserSlaveCfg.sv
                                                  //and cdnAxiUvmUserMasterCfg.sv currently)
	      masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	      //masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
	      masterBurst.Length inside{[1:16]} ; //playing with how big the transaction is
           })
          `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        end
      end
      begin
        //If we don't include this, the sim stops before the transactions have all completed, since
        //they're all launched in zero time above. Seems like we should have objections taking care
        //of this somewhere central, and not need this claus.
        for (int a2m_index2=1; a2m_index2<=a2m_cnt; a2m_index2++) begin
          // wait for write burst to end
          `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_HIGH);
          myMonitor.writeBurstEnded.wait_trigger();
          `uvm_info(get_type_name(), $sformatf("Virtual sequence %d saw trigger ",a2m_index2), UVM_HIGH);
        end
      end
    join

    #50;
    `uvm_info(get_type_name(), "Finished body of multi_seq", UVM_LOW);
      
  endtask

endclass : multi_seq


// ****************************************************************************
// Class : msnw_default_1pkt_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_default_1pkt_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_default_1pkt  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_default_1pkt_seq)

   function new(string name="msnw_default_1pkt_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_default_1pkt_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_default_1pkt::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_default_1pkt_seq", UVM_LOW);
      
  endtask

endclass : msnw_default_1pkt_seq


// ****************************************************************************
// Class : msnw_default_mult_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_default_mult_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_default_mult  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_default_mult_seq)

   function new(string name="msnw_default_mult_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_default_mult_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_default_mult::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_default_mult_seq", UVM_LOW);
      
  endtask

endclass : msnw_default_mult_seq

// ****************************************************************************
// Class : msnw_parityEN_1pkt_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_parityEN_1pkt_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_parityEN_1pkt  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_parityEN_1pkt_seq)

   function new(string name="msnw_parityEN_1pkt_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_parityEN_1pkt_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_parityEN_1pkt::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_parityEN_1pkt_seq", UVM_LOW);
      
  endtask

endclass : msnw_parityEN_1pkt_seq

// ****************************************************************************
// Class : msnw_parityEN_mult_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_parityEN_mult_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_parityEN_mult  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_parityEN_mult_seq)

   function new(string name="msnw_parityEN_mult_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_parityEN_mult_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_parityEN_mult::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_parityEN_mult_seq", UVM_LOW);
      
  endtask

endclass : msnw_parityEN_mult_seq

// ****************************************************************************
// Class : msnw_parityEN_coll_2pkt_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_parityEN_coll_2pkt_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_parityEN_coll_2pkt  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_parityEN_coll_2pkt_seq)

   function new(string name="msnw_parityEN_coll_2pkt_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_parityEN_coll_2pkt_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_parityEN_coll_2pkt::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_parityEN_coll_2pkt_seq", UVM_LOW);
      
  endtask

endclass : msnw_parityEN_coll_2pkt_seq


// ****************************************************************************
// Class : msnw_errParity_1pkt_seq
// Desc. : Virtual sequence - This sequence sends a single transaction 
//        from msnw2axi in parallel with a single transaction from axi2msnw
// ****************************************************************************
class msnw_errParity_1pkt_seq extends m2a_virt_sequence;

  rand reg [31:0]  a_delay, b_delay, w_delay;

   //AXI masterered write transaction
   cdnAxiUvmWriteSeq axi_masterWrite;
   //AXI Slave Responder transaction
   mySlaveResp axi_slaveResp;
   //MSNW Write transaction
   msnw_errParity_1pkt  msnw_write;
   //MSNW Write Responder transaction 

   myAxiTransaction masterBurst;

   `uvm_object_utils(msnw_errParity_1pkt_seq)

   function new(string name="msnw_errParity_1pkt_seq");
      super.new(name);
   endfunction

   virtual task body();

    `uvm_info(get_type_name(), "Virtual sequence msnw_errParity_1pkt_seq started", UVM_LOW);
    
    #500;

    //MSNW_2_AXI
    fork
      begin
      //MSNW write transaction
        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
        msnw_write = msnw_errParity_1pkt::type_id::create("msnw_write");
        msnw_write.start(p_sequencer.msnw_in_seqr);
      end
      begin
      //AXI out transaction is randomized by default, in the base test, by setting randomizeSlaveResp == 1
      //so no constraints or control needed here. Look at commented code at bottom of file for an example
      //of constraining the AXI out parameters directly
      end
    join

    //AXI_2_MSNW
    fork
      begin
        // Issue an AXI write using denaliCdn_axiTransaction. Only a few fields are defined here.
        // The rest are assigned by UVC
        `uvm_info(get_type_name(), "Virtual sequence issuing an AXI Master write ", UVM_LOW);

     `uvm_do_on_with(masterBurst, p_sequencer.Axi_masterSeqr,  {
        masterBurst.Direction ==  DENALI_CDN_AXI_DIRECTION_WRITE;
            masterBurst.IdTag ==  2;
            masterBurst.StartAddress == 'h0000;
	    masterBurst.Size == DENALI_CDN_AXI_TRANSFERSIZE_TWO_WORDS ; //width of the data bus
	    masterBurst.Length == 1 ; //current DUT doesn't support more than 1 beat of data
         })
        `uvm_info(get_type_name(), "Virtual sequence AXI Master write launched ", UVM_LOW);
        // wait for write burst to end
        `uvm_info(get_type_name(), "Virtual sequence waiting for trigger ", UVM_LOW);
        myMonitor.writeBurstEnded.wait_trigger();
        `uvm_info(get_type_name(), "Virtual sequence saw trigger ", UVM_LOW);
      end
      begin
      //Where we describe the msnw_out_env transaction....
        `uvm_info(get_type_name(), "Virtual sequence placeholder for MSNW Out responder transaction ", UVM_LOW);
      end
    join

    #5000;
    
    `uvm_info(get_type_name(), "Finished body of msnw_errParity_1pkt_seq", UVM_LOW);
      
  endtask

endclass : msnw_errParity_1pkt_seq


// Example of specifically driving a single transaction on activeSlave.  Dimitry recommends having constrained
// randomization of this driver set up instead and controlled by the test.

//      a_delay = $urandom_range(9); 
//      w_delay = $urandom_range(9); 
//      b_delay = $urandom_range(9); 
//      `uvm_info(get_type_name(), $sformatf("a_delay is %d: w_delay is %d: b_delay is %d",a_delay, w_delay, b_delay), UVM_LOW);

      //Where we describe the AXI Slave response transaction....
//        `uvm_info(get_type_name(), "Virtual sequence for AXI ActiveSlave responder transaction ", UVM_LOW);
//        `uvm_do_on_with(axi_slaveResp, p_sequencer.Axi_slaveSeqr,  { 
//          axi_slaveResp.Length == 1;
//          axi_slaveResp.AreadyControl == DENALI_CDN_AXI_READYCONTROL_DELAYED_ASSERTION;
//          axi_slaveResp.AddressDelay == a_delay;
//          axi_slaveResp.WreadyControl == DENALI_CDN_AXI_READYCONTROL_OSCILLATING;
//          axi_slaveResp.TransfersChannelDelay[0] == w_delay;
//          //randomization failure if we apply a number to the ChannelDelay to delay rsp_valid signal
//          //axi_slaveResp.ChannelDelay == b_delay;
//	  })

// ****************************************************************************
// Class : myAxiTransaction
// Desc. : This class extends denaliCdn_axiTransaction class and adds a few
//	   constraints common to all transactions in this environment
// ****************************************************************************
class myAxiTransaction extends denaliCdn_axiTransaction;

  `uvm_object_utils(myAxiTransaction)
  
  function new(string name = "myAxiTransaction");
    super.new(name);
    this.SpecVer = DENALI_CDN_AXI_SPECVERSION_AMBA3;
    this.SpecSubtype = DENALI_CDN_AXI_SPECSUBTYPE_BASE;
    this.SpecInterface = DENALI_CDN_AXI_SPECINTERFACE_FULL;
  endfunction : new 
    	   
  constraint user_dut_information { 
  	BurstMaxSize == DENALI_CDN_AXI_TRANSFERSIZE_EIGHT_WORDS; 
    IdTag < (1 << 15);
  }
     
endclass

// ****************************************************************************
// Class : mySlaveResp
// Desc. : This class extends myAxiTransaction class
// ****************************************************************************
class mySlaveResp extends myAxiTransaction;
  `uvm_object_utils(mySlaveResp)

  function new(string name = "mySlaveResp");
    super.new(name);
  endfunction : new 
  
  constraint wr_resp_dist {
  	Resp dist { DENALI_CDN_AXI_RESPONSE_OKAY   := 50,
                DENALI_CDN_AXI_RESPONSE_SLVERR := 50 
    };        
  }
  
  constraint memory_consistency {
  	 // If data exists in main memory, return it from there and ignore the trnasaction's Data field.
  	 IgnoreConstraints == 1;
  }

endclass : mySlaveResp

// ----------------------------------------------------------------------------
// Class : cdnAxiUvmWriteSeq
// This class extends the uvm_sequence and implements a Write Transaction.
// ----------------------------------------------------------------------------
class cdnAxiUvmWriteSeq extends cdnAxiUvmSequence;

  // ---------------------------------------------------------------
  // The sequence item (transaction) that will be randomized and
  // passed to the driver.
  // ---------------------------------------------------------------
  rand myAxiTransaction trans;
  
  // ---------------------------------------------------------------
  // Possible input address to the sequence
  // ---------------------------------------------------------------
  //cjw
  //rand reg [63:0] address;
  rand reg [31:0] address;
  
  // ---------------------------------------------------------------
  // Possible input length to the sequence
  // ---------------------------------------------------------------
  rand reg[3:0] length;
  
  // ---------------------------------------------------------------
  // Possible input size to the sequence
  // ---------------------------------------------------------------
  rand denaliCdn_axiTransferSizeT size;
  
  // ---------------------------------------------------------------
  // Possible input kind to the sequence
  // ---------------------------------------------------------------
  rand denaliCdn_axiBurstKindT kind;
  
  // ---------------------------------------------------------------
  // Possible input secure to the sequence (AWPROT[1])
  // ---------------------------------------------------------------
  rand denaliCdn_axiSecureModeT secure;


  // ---------------------------------------------------------------
  // Use the UVM Sequence macro for this class.
  // ---------------------------------------------------------------
  `uvm_object_utils_begin(cdnAxiUvmWriteSeq)
    `uvm_field_object(trans, UVM_ALL_ON)
  `uvm_object_utils_end
  
  `uvm_declare_p_sequencer(cdnAxiUvmSequencer)

  // ---------------------------------------------------------------
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ---------------------------------------------------------------
  function new(string name = "cdnAxiUvmWriteSeq");
    super.new(name);
  endfunction : new

  // ---------------------------------------------------------------
  // Method : body
  // Desc.  : AXI Write Transaction.
  // ---------------------------------------------------------------
  virtual task body();
    `uvm_do_with(trans,
    	{trans.Direction == DENALI_CDN_AXI_DIRECTION_WRITE;
    	trans.StartAddress == address;
    	trans.Length == length;
    	trans.Size == size;
    	trans.Kind == kind;
    	trans.Secure == secure;
    });
  endtask : body

endclass 

//--DocEx start->modifyTransactionExample
class cdnAxiUvmUserModifyTransactionSeq extends cdnAxiUvmModifyTransactionSequence;

  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_object_utils(cdnAxiUvmUserModifyTransactionSeq)
     
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnAxiUvmUserModifyTransactionSeq");
    super.new(name);        
  endfunction : new
  
  myAxiTransaction trans; 
  
  virtual task pre_body();
    if (starting_phase != null) begin
      starting_phase.raise_objection(this);
    end    
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


  virtual task body();
    denaliCdn_axiTransaction response;

    `uvm_do_with(trans,
    {trans.Direction == DENALI_CDN_AXI_DIRECTION_WRITE;
      trans.IdTag < (1 << 4);
      trans.Size == DENALI_CDN_AXI_TRANSFERSIZE_WORD;
      trans.Length == 8;
      trans.Kind == DENALI_CDN_AXI_BURSTKIND_INCR;
    })    

    //Wait till transaction is transmitted to DUT
    //   we want the sequence to end only after the transaction transmission is completed.
    //   when sequence ends no modification will take effect
    get_response(response,trans.get_transaction_id());    
        
    `uvm_info(get_type_name(), "Finished Transaction modification", UVM_LOW)
  endtask : body

  // Modify the transaction in BeofreSend callback using TransSet()
  // This is where we decide what are the transaction's attributes (fields) we want to modify 
  // and which items should it effect. 
  virtual function void modifyTransaction(denaliCdn_axiTransaction tr);
    bit status;
    //in this case we can choose to modify only a specific burst this sequence has generated.
    //if there was no condition then the modification would have occurred to any burst being sent.
    //by default only bursts created in this sequence will be affected.
    if (trans != null && tr.UserData ==  trans.UserData)    
    begin
      `uvm_info(get_type_name(), "Starting Transaction modification", UVM_LOW)      
      tr.WriteAddressOffset = 8; // send all transfers before address
      tr.TransmitDelay = 10;
      for (int i=0; i<tr.TransfersChannelDelay.size(); i++) begin 
      	tr.TransfersChannelDelay[i] = 1;
      end
      //Update the model transaction with the new values
      //   transSet() is being used to update that fields were changed.
      status = tr.transSet();
          
      `uvm_info(get_type_name(), "Finished Transaction modification", UVM_LOW)
    end
  endfunction

endclass
//--DocEx end->modifyTransactionExample

class cdnAxiUvmUserModifyResponseSeq extends cdnAxiUvmModifyTransactionSequence;

  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_object_utils(cdnAxiUvmUserModifyResponseSeq)
     
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnAxiUvmUserModifyResponseSeq");
    super.new(name);        
  endfunction : new
  
  mySlaveResp resp; 
  
  virtual task pre_body();
    if (starting_phase != null) begin
      starting_phase.raise_objection(this);
    end    
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


  virtual task body();
  	denaliCdn_axiTransaction response;

  	// generate a template slave response
    `uvm_do(resp)  
    
    //Wait till transaction is ended
    //   we want the sequence to end only after the transaction transmission is completed.
    //   after the sequence ends no modification will take effect
    get_response(response,resp.get_transaction_id());   
          
  endtask : body

  // Modify the transaction in BeofreSendResponse callback using TransSet()
  // This is where we decide what are the transaction's attributes (fields) we want to modify 
  // and which items should it effect. 
  virtual function void modifyTransaction(denaliCdn_axiTransaction tr);
    bit status;
    //in this case we can choose to modify only a specific burst this sequence has generated.
    //if there was no condition then the modification would have occurred to any burst being sent.
    //by default only bursts created in this sequence will be affected.
    if (resp != null )//&& tr.UserData ==  resp.UserData)    
    begin
      `uvm_info(get_type_name(), "Starting Response modification", UVM_LOW)      
      tr.Resp = DENALI_CDN_AXI_RESPONSE_OKAY;
      for (int i=0; i<tr.TransfersChannelDelay.size(); i++) begin 
      	tr.TransfersChannelDelay[i] = 0;
      end
      //Update the model transaction with the new values
      //   transSet() is being used to update that fields were changed.
      status = tr.transSet();
          
      `uvm_info(get_type_name(), "Finished Response modification", UVM_LOW)
    end
  endfunction

endclass

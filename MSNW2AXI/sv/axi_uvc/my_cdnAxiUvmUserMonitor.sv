      // ----------------------------------------------------------------------------
      // 
      // Class : cdnAxiUvmUserMonitor
      //
      // ----------------------------------------------------------------------------
class cdnAxiUvmUserMonitor extends cdnAxiUvmMonitor;

  	denaliCdn_axiTransaction endedBurst;

	// Extended protocol events 
	uvm_event readBurstStarted;
	uvm_event writeBurstStarted;
	uvm_event readBurstEnded;
	uvm_event writeBurstEnded;
	uvm_event readTransferStarted;
	uvm_event writeTransferStarted;
	uvm_event readTransferEnded;
	uvm_event writeTransferEnded;
	
  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_component_utils_begin(cdnAxiUvmUserMonitor)
  	`uvm_field_event(readBurstStarted, UVM_ALL_ON)
  	`uvm_field_event(writeBurstStarted, UVM_ALL_ON)
  	`uvm_field_event(readBurstEnded, UVM_ALL_ON)
  	`uvm_field_event(writeBurstEnded, UVM_ALL_ON)
  	`uvm_field_event(readTransferStarted, UVM_ALL_ON)
  	`uvm_field_event(writeTransferStarted, UVM_ALL_ON)
  	`uvm_field_event(readTransferEnded, UVM_ALL_ON)
  	`uvm_field_event(writeTransferEnded, UVM_ALL_ON)
  `uvm_component_utils_end
   
  // ***************************************************************
  // Imp port
  // ***************************************************************  
  uvm_analysis_imp_cdn_axi_burst_ended #(denaliCdn_axiTransaction, cdnAxiUvmUserMonitor) endedImp;
  uvm_analysis_imp_cdn_axi_burst_ended_transfer #(denaliCdn_axiTransaction, cdnAxiUvmUserMonitor) endedTransferImp;
  uvm_analysis_imp_cdn_axi_burst_started #(denaliCdn_axiTransaction, cdnAxiUvmUserMonitor) startedImp;
  uvm_analysis_imp_cdn_axi_burst_started_transfer #(denaliCdn_axiTransaction, cdnAxiUvmUserMonitor) startedTransferImp;
  
  virtual function void write_cdn_axi_burst_ended (denaliCdn_axiTransaction trans);
    if (trans != null) begin 
      $cast(endedBurst, trans);
      printEndedBurst(trans);
    end
    if (trans.Type == DENALI_CDN_AXI_TR_Read) begin
    	this.readBurstEnded.trigger(trans);
    end  
    if (trans.Type == DENALI_CDN_AXI_TR_Write) begin
    	this.writeBurstEnded.trigger(trans);
    end 
  endfunction : write_cdn_axi_burst_ended
  
  virtual function void write_cdn_axi_burst_ended_transfer (denaliCdn_axiTransaction trans);
  	if (trans.Type == DENALI_CDN_AXI_TR_ReadTransfer) begin
    	this.readTransferEnded.trigger(trans);
    end  
    if (trans.Type == DENALI_CDN_AXI_TR_WriteTransfer) begin
    	this.writeTransferEnded.trigger(trans);
    end
  endfunction : write_cdn_axi_burst_ended_transfer
  
  virtual function void write_cdn_axi_burst_started (denaliCdn_axiTransaction trans);
  	if (trans.Type == DENALI_CDN_AXI_TR_Read) begin
    	this.readBurstStarted.trigger(trans);
    end  
    if (trans.Type == DENALI_CDN_AXI_TR_Write) begin
    	this.writeBurstStarted.trigger(trans);
    end
  endfunction : write_cdn_axi_burst_started
  
  virtual function void write_cdn_axi_burst_started_transfer (denaliCdn_axiTransaction trans);
  	if (trans.Type == DENALI_CDN_AXI_TR_ReadTransfer) begin
    	this.readTransferStarted.trigger(trans);
    end  
    if (trans.Type == DENALI_CDN_AXI_TR_WriteTransfer) begin
    	this.writeTransferStarted.trigger(trans);
    end
  endfunction : write_cdn_axi_burst_started_transfer
  

  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnAxiUvmUserMonitor", uvm_component parent = null);
    super.new(name, parent);
    endedImp = new("endedImp", this);
    endedTransferImp = new("endedTransferImp", this); 
    startedImp = new("startedImp", this); 
    startedTransferImp = new("startedTransferImp", this); 
    
    readBurstStarted = new("readBurstStarted");
    writeBurstStarted = new("writeBurstStarted");
    readBurstEnded = new("readBurstEnded");
    writeBurstEnded = new("writeBurstEnded");
    readTransferStarted = new("readTransferStarted");
    writeTransferStarted = new("writeTransferStarted");
    readTransferEnded = new("readTransferEnded");
    writeTransferEnded = new("writeTransferEnded");
    readBurstStarted = new("readBurstStarted");
      
  endfunction : new
      
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction : build_phase

  // ***************************************************************
  // Method : connect_phase
  // Desc.  : Connect analysis ports to imp ports in Events model
  // ***************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      	
    this.EndedCbPort.connect(this.endedImp);
    this.EndedTransferCbPort.connect(this.endedTransferImp);
    this.StartedCbPort.connect(this.startedImp);
    this.StartedTransferCbPort.connect(this.startedTransferImp);
   
  endfunction // void


  virtual function void printEndedBurst (denaliCdn_axiTransaction trans); 
    if (trans.Type == DENALI_CDN_AXI_TR_Write || trans.Type == DENALI_CDN_AXI_TR_Read) begin
      `uvm_info(get_type_name(), $sformatf("The following transaction was ended: \n %0s", trans.sprint()), UVM_FULL) 
      `uvm_info(get_type_name(), $sformatf("Ended %s Burst: Address = %d  Length = %d",
          trans.Direction == DENALI_CDN_AXI_DIRECTION_READ ? "READ" : "WRITE", trans.StartAddress,trans.Length), UVM_LOW);
    end 
  endfunction : printEndedBurst

//Cause discarded transaction to create an error so that the user is aware of them
  virtual function void ErrorCbF(denaliCdn_axiTransaction trans) ;
    if (trans.IsDiscarded == 1)
    begin
      `uvm_error(get_type_name(), $sformatf("The following transaction got discarded: \n %0s", trans.sprint()))
    end
  endfunction

endclass : cdnAxiUvmUserMonitor

// ****************************************************************************
// Class : cdnAxiUvmUserSlaveDriver
// Desc. : This class extends the cdnAxiUvmDriver and implements request/response
//         mechanism for communication with Sequencer
// ****************************************************************************
class cdnAxiUvmUserSlaveDriver extends cdnAxiUvmDriver;

  // Transaction unique ID
  int unique_id=-1;

  int randomizeSlaveResp = 0;
   
  // ***************************************************************
  // Use the UVM registration macro for this class.
  // ***************************************************************
  `uvm_component_utils_begin(cdnAxiUvmUserSlaveDriver)
  	`uvm_field_int(randomizeSlaveResp, UVM_ALL_ON)
  `uvm_component_utils_end

 
  // ***************************************************************
  // Method : new
  // Desc.  : Call the constructor of the parent class.
  // ***************************************************************
  function new(string name = "cdnAxiUvmUserSlaveDriver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
   // ***************************************************************
   // Method : build_phase
   // Desc.  : Create a pointer to the encompassing agent
   // ***************************************************************
  function void build_phase(uvm_phase phase); 
    super.build_phase(phase);
  endfunction
 
  virtual function void connect_phase(uvm_phase phase);
  	super.connect_phase(phase);
  endfunction : connect_phase
  
  // ***************************************************************
  // Method : get_next_unique_id
  // Desc.  : Calculates unique ID for each transaction
  // ***************************************************************
  function int get_next_unique_id();
    unique_id++;
    return unique_id;
  endfunction : get_next_unique_id
    
  //  ***************************************************************
  // Method : write_cdn_axi_uvm_driver_BeforeSend
  // Desc.  : will be called when uvm_analysis_imp: DriverTransactionBeforeSend is been written
  //  ***************************************************************
  virtual function void write_cdn_axi_uvm_driver_BeforeSend(denaliCdn_axiTransaction trans);    
    super.write_cdn_axi_uvm_driver_BeforeSend(trans);    
  endfunction : write_cdn_axi_uvm_driver_BeforeSend
  
  //  ***************************************************************
  // Method : write_cdn_axi_uvm_driver_BeforeSendResponse
  // Desc.  : will be called when uvm_analysis_imp: BeforeSendResponeImp is been written
  //  ***************************************************************
  virtual function void write_cdn_axi_uvm_driver_BeforeSendResponse(denaliCdn_axiTransaction trans);   

     int rd_resp_dist;
     int wr_resp_dist;

    super.write_cdn_axi_uvm_driver_BeforeSendResponse(trans);     
   
  if (randomizeSlaveResp==0) begin
     `uvm_info(get_type_name(), $sformatf("Slave response in BeforeSendResponse callback will NOT be randomized: \n %0s", trans.sprint()), UVM_LOW)
  end //if (randomizeSlaveResp==0)

  if (randomizeSlaveResp==1) begin
 
     `uvm_info(get_type_name(), $sformatf("Slave response in BeforeSendResponse callback BEFORE randomization: \n %0s", trans.sprint()), UVM_LOW)

    
     // Randomization of ARREADY and AWREADY (address channels) behavior and delay
     rd_resp_dist = $urandom_range(1,100);
     `uvm_info(get_type_name(), $sformatf(" rd_resp_dist : %0d", rd_resp_dist), UVM_LOW)
     if  (rd_resp_dist < 20)              
       trans.AreadyControl =  DENALI_CDN_AXI_READYCONTROL_DELAYED_ASSERTION;          // ARREADY & AWREADY CONTROL
     else if (rd_resp_dist >= 20 && rd_resp_dist < 40)               
       trans.AreadyControl = DENALI_CDN_AXI_READYCONTROL_OSCILLATING;                 // ARREADY & AWREADY CONTROL
     else if (rd_resp_dist >= 40 && rd_resp_dist < 60)               
       trans.AreadyControl = DENALI_CDN_AXI_READYCONTROL_STALL_UNTIL_VALID;           // ARREADY & AWREADY CONTROL
     else if (rd_resp_dist >= 60 && rd_resp_dist < 100)               
       trans.AreadyControl = DENALI_CDN_AXI_READYCONTROL_STALL_UNTIL_VALID_AND_DELAY; // ARREADY & AWREADY CONTROL
     
     trans.AddressDelay = $urandom_range(0,5);                                        // ARREADY & AWREADY DELAY
     

     // Randomization of data channels delay
     foreach (trans.TransfersChannelDelay[index]) begin
                trans.TransfersChannelDelay[index] = $urandom_range(0,5);             // RVALID DELAY and WREADY DELAY
     end     

     // Randomization of read responses
     if (trans.Type == DENALI_CDN_AXI_TR_ReadData) begin
                  foreach (trans.TransfersResp[index]) begin
             		rd_resp_dist = $urandom_range(1,100);
             			if (rd_resp_dist > 50)
               				trans.TransfersResp[index] = DENALI_CDN_AXI_RESPONSE_SLVERR;
             			else
               				trans.TransfersResp[index] = DENALI_CDN_AXI_RESPONSE_OKAY;
          			end
       end // if (trans.Type == DENALI_CDN_AXI_TR_ReadData)
      

      // Randomization of WREADY (write data channel) behavior
      wr_resp_dist = $urandom_range(1,100);
      `uvm_info(get_type_name(), $sformatf(" wr_resp_dist : %0d", wr_resp_dist), UVM_HIGH)
      if  (wr_resp_dist < 10)              
           trans.WreadyControl =  DENALI_CDN_AXI_READYCONTROL_DELAYED_ASSERTION;          // WREADY CONTROL
      else if (wr_resp_dist >= 10 && wr_resp_dist < 20)               
           trans.WreadyControl = DENALI_CDN_AXI_READYCONTROL_OSCILLATING;                 // WREADY CONTROL                               
      else if (wr_resp_dist >= 20 && wr_resp_dist < 30)               
           trans.WreadyControl = DENALI_CDN_AXI_READYCONTROL_STALL_UNTIL_VALID;           // WREADY CONTROL
      else if (wr_resp_dist >= 30 && wr_resp_dist <=100)               
           trans.WreadyControl = DENALI_CDN_AXI_READYCONTROL_STALL_UNTIL_VALID_AND_DELAY; // WREADY CONTROL
                                


       if (trans.Type == DENALI_CDN_AXI_TR_WriteResponse) begin
                  trans.ChannelDelay = $urandom_range(0,2);                               // BVALID

            // Randomization of write response
            wr_resp_dist = $urandom_range(1,100);
            if (wr_resp_dist > 50)
            	trans.Resp = DENALI_CDN_AXI_RESPONSE_SLVERR;
            else
            	trans.Resp = DENALI_CDN_AXI_RESPONSE_OKAY;

        end // if (trans.Type == DENALI_CDN_AXI_TR_WriteResponse)

       
       // Push modified transaction back in the stack for transmission
       void'(trans.transSet());

       `uvm_info(get_type_name(), $sformatf("Slave response in BeforeSendResponse callback AFTER randomization: \n %0s", trans.sprint()), UVM_LOW)

  end //if (randomizeSlaveResp==1)

  endfunction : write_cdn_axi_uvm_driver_BeforeSendResponse
  
endclass : cdnAxiUvmUserSlaveDriver

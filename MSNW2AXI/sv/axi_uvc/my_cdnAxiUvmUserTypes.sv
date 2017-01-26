
`ifndef CDN_AXI_UVM_USER_TYPES
`define CDN_AXI_UVM_USER_TYPES

//typedef class cdnAxiUvmUserMemInstance;
//typedef class cdnAxiUvmUserInstance;
//typedef class cdnAxiUvmUserMasterCfg;
//typedef class cdnAxiUvmUserSlaveCfg;
//typedef class cdnAxiUvmUserMasterDriver;
//typedef class cdnAxiUvmUserSlaveDriver;
//typedef class cdnAxiUvmUserMonitor;
//typedef class cdnAxiUvmUserSequencer;
//typedef class cdnAxiUvmUserAgent;
//typedef class cdnAxiUvmUserMasterAgent;		
//typedef class cdnAxiUvmUserSlaveAgent;	
//typedef class cdnAxiUvmUserEnv;
//typedef class cdnAxiUvmUserSve;
//typedef class cdnAxiUvmUserVirtualSequencer;
	
	
// ***************************************************************
// Analysis imports which connect to analysis ports
// ***************************************************************
`uvm_analysis_imp_decl(_cdn_axi_burst_started)
`uvm_analysis_imp_decl(_cdn_axi_burst_started_transfer)  
`uvm_analysis_imp_decl(_cdn_axi_burst_ended)
`uvm_analysis_imp_decl(_cdn_axi_burst_ended_transfer)  
`uvm_analysis_imp_decl(_cdn_axi_error)


`endif // CDN_AXI_UVM_USER_TYPES
  

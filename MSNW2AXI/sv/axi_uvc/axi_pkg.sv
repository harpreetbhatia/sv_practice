////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: axi_pkg.sv $
// 
//  $Date: Wed Oct  13 15:50:04 2013 $
// 
//  $Revision: 1.00 $
// 
//  $Author: bhatiaha $
// 
//      
//      CAD Log : 
//  
//   
//      
//      
//      $KeysEnd$
// 
//  DESCRIPTION : This file declares the msnw UVC. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////



package axi_pkg;

// Import the UVM class library  and UVM automation macros
 import uvm_pkg::*;
`include "uvm_macros.svh"
//`include "axi_if.sv"

import DenaliSvCdn_axi::*;
import DenaliSvMem::*;
//`include "denaliAxiUserInstance.sv"

// Include the VIP UVM Base classes
import cdnAxiUvm::*;

//tjl copied info from /tools/cds/ies/lnx86/vipcat/v11.30.021/tools.lnx86/
//                      denali/ddvapi/sv/uvm/cdn_axi/examples/axi3 files

`include "cdnAxiUvmUserAgent.sv"
`include "cdnAxiUvmUserSlaveCfg.sv"
`include "cdnAxiUvmUserSlaveAgent.sv"
`include "my_cdnAxiUvmUserSlaveDriver.sv"

`include "cdnAxiUvmUserMasterCfg.sv"
`include "cdnAxiUvmUserMasterAgent.sv"
`include "cdnAxiUvmUserMasterDriver.sv"

`include "my_cdnAxiUvmUserTypes.sv"
`include "cdnAxiUvmUserInstance.sv"
`include "cdnAxiUvmUserMemInstance.sv"
`include "my_cdnAxiUvmUserMonitor.sv"
`include "cdnAxiUvmUserSequencer.sv"

`include "axi_seq_lib.sv"

endpackage : axi_pkg


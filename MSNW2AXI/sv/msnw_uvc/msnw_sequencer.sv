////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_sequencer.sv $
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
//  DESCRIPTION : This file declares the msnw_sequencer. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_sequencer extends uvm_sequencer #(msnw_trans);

  //register sequencer into factory
  `uvm_sequencer_utils(msnw_sequencer)

  // Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
	`uvm_info("MSNW_SQR", "sequencer created", UVM_INFO)
  endfunction : new

endclass : msnw_sequencer

////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_default_mult_test.sv $
// 
//  $Date: Wed Oct  13 15:50:04 2013 $
// 
//  $Revision: 1.00 $
// 
//  $Author: $
// 
//      
//      CAD Log : 
//  
//   
//      
//      
//      $KeysEnd$
// 
//  DESCRIPTION : This file declares the msnw_default_mult_test test. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_default_mult_test extends base_test;

  `uvm_component_utils(msnw_default_mult_test)
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("TEST","msnw_default_mult_test: run phase begins", UVM_HIGH)
  endfunction


  task run_phase(uvm_phase phase);
    msnw_default_mult_seq seq;
    super.run_phase(phase);
        phase.raise_objection(this);
        seq = msnw_default_mult_seq::type_id::create("seq");
        seq.start(m_env.vs);
     #1 phase.drop_objection(this);
  endtask : run_phase
  
endclass: msnw_default_mult_test

  ////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: virt_basic_test2.sv $
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
//  DESCRIPTION : This file declares the msnw basic test number 2. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class virt_basic_test2 extends base_test;

  `uvm_component_utils(virt_basic_test2)
  
  function new(input string name, uvm_component parent);
    super.new(name,parent);
  endfunction  
  
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("WARNING","virt_basic_test2: run phase begins", UVM_HIGH)

    //set the starting sequence to system
//    uvm_config_db#(uvm_object_wrapper)::set(this, "m_env.vs.run_phase", "default_sequence",multi_seq::type_id::get());
//    uvm_top.set_config_int("*", "recording_detail" , UVM_LOW);

  endfunction


  task run_phase(uvm_phase phase);
    multi_seq seq;
    super.run_phase(phase);
        phase.raise_objection(this);
        seq = multi_seq::type_id::create("seq");
        seq.start(m_env.vs);
     #1 phase.drop_objection(this);
  endtask : run_phase
  
endclass: virt_basic_test2

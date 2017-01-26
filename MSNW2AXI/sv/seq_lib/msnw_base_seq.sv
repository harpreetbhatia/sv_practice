////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_base_seq.sv $
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
//  DESCRIPTION : This file declares the msnw base sequence. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_base_seq extends uvm_sequence #(msnw_trans);

  `uvm_object_utils(msnw_base_seq)
  
  function new(string name="msnw_base_seq");
    super.new(name);
  endfunction
 

  `uvm_declare_p_sequencer(msnw_sequencer) //*This declares a variable 'p_sequencer'. 
                                           //*This variable will be used to interact 
										   //*with the msnw_sequencer.

// Use a base sequence to raise/drop objections if this is a default sequence
  virtual task pre_body();
     if (starting_phase != null)
        starting_phase.raise_objection(this, {"Running sequence '",
                                              get_full_name(), "'"});
  endtask
  

  virtual task post_body();
     if (starting_phase != null)
        starting_phase.drop_objection(this, {"Completed sequence '",
                                             get_full_name(), "'"});
  endtask
  
endclass : msnw_base_seq


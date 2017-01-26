////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_parityEN_coll_mult_incr.sv $
// 
//  $Date: Wed Nov  15 15:50:04 2013 $
// 
//  $Revision: 1.10 $
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
//    
// DESCRIPTION : SEQ i: Multiple message network packets with incremental address 
//               sent in ascending order(lower address first then higher) alongwith 
//               computed parity; Generates AXI transaction that coalasces every two 
//               packets inside the 8-byte aligned window (32-bit data each) into 
//              single 64-bit AXI  transaction. 
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_parityEN_coll_mult_incr extends msnw_base_seq;

  `uvm_object_utils(msnw_parityEN_coll_mult_incr)
	
   rand int loop = 1;
  
  function new(string name="msnw_parityEN_coll_mult_incr");
    super.new(name);
  endfunction
 
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
//	     `uvm_do_with(req, {req.valid ==1; req.parity_en ==1;})
       `uvm_info("SEQ i", $psprintf("Seq gives a pkt with \naddr = 'h%0h, \ndata = 'h%0h, \nparity = %0b, \ndelay = %0d",
                                  req.pkt.addr, req.pkt.data, req.pkt.parity, req.pkt_delay), UVM_INFO)
     end
   endtask: body
endclass : msnw_parityEN_coll_mult_incr
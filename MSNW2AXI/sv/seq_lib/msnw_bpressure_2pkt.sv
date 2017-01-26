////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_bpressure_2pkt.sv $
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
// DESCRIPTION : SEQ l: Two message network packets with adjacent address sent in any 
//               order(higher address first then lower OR vice-versa) alongwith computed 
//               parity, AXI backpressured applied immediatly after first MSNW packet is 
//               accepted. Second packet will be accpeted by DUT, stored, coalasced and 
//               ready to go until backpressured is released.
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_bpressure_2pkt extends msnw_base_seq;

  `uvm_object_utils(msnw_bpressure_2pkt)
	
   rand int loop = 1;
  
  function new(string name="msnw_bpressure_2pkt");
    super.new(name);
  endfunction
 
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
//	     `uvm_do_with(req, {req.valid ==1; req.parity_en ==1;})
       `uvm_info("SEQ l", $psprintf("Seq gives a pkt with \naddr = 'h%0h, \ndata = 'h%0h, \nparity = %0b, \ndelay = %0d",
                                  req.pkt.addr, req.pkt.data, req.pkt.parity, req.pkt_delay), UVM_INFO)
     end
   endtask: body
endclass : msnw_bpressure_2pkt
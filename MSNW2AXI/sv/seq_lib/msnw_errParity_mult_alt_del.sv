////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_errParity_mult_alt_del.sv $
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
// DESCRIPTION : SEQ k: Multiple message network packets with adjacent address sent 
//               in any order(higher address first then lower OR vice-versa) separated 
//               by # clock cycles. Generates AXI transaction that may or may not be 
//               coalasce the two packets within the same 8-byte aligned window (32-bit 
//               data each) into single 64-bit AXI  transaction. Coalascing in this case 
//               depends on the whether backpressure mechanism forces the separated 
//               packets to transform them into back-to-back packets which then are 
//               qualified for coalascing. 
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_errParity_mult_alt_del extends msnw_base_seq;

  `uvm_object_utils(msnw_errParity_mult_alt_del)
	
   rand int loop = 1;
  
  function new(string name="msnw_errParity_mult_alt_del");
    super.new(name);
  endfunction
 
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
//	     `uvm_do_with(req, {req.valid ==1; req.parity_en ==1;})
       `uvm_info("SEQ k", $psprintf("Seq gives a pkt with \naddr = 'h%0h, \ndata = 'h%0h, \nparity = %0b, \ndelay = %0d",
                                  req.pkt.addr, req.pkt.data, req.pkt.parity, req.pkt_delay), UVM_INFO)
     end
   endtask: body
endclass : msnw_errParity_mult_alt_del
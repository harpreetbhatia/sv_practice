////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_errParity_1pkt.sv $
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
// DESCRIPTION : SEQ c: Single message network packet input on MSNW interface 
//               with parity enabled and parity error injected;Asserts     
//               'parity_error' flag, drops the MSNW packet  and outputs the      
//               same packet on port 'error_packet'.
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_errParity_1pkt extends err_base_seq;

  `uvm_object_utils(msnw_errParity_1pkt)
	
   rand int loop = 1;
  
  function new(string name="msnw_errParity_1pkt");
    super.new(name);
  endfunction
 
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
	     `uvm_do_with(req, {req.valid ==1; req.parity_en ==1;})
       `uvm_info("SEQ c", $psprintf("Seq gives a ERRROR pkt with \naddr = 'h%0h, \ndata = 'h%0h, \nparity = %0b, \ndelay = %0d",
                                  req.pkt.addr, req.pkt.data, req.pkt.parity, req.pkt_delay), UVM_INFO)
     end
   endtask: body
endclass : msnw_errParity_1pkt


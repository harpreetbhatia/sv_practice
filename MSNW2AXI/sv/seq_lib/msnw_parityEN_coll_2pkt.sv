////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_parityEN_coll_2pkt.sv $
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
// DESCRIPTION : SEQ h: Two message network packets with adjacent address sent in 
//               any order(higher address first then lower OR vice-versa) alongwith 
//               computed parity; Generates AXI transaction that coalasces two 
//               packets (32-bit data each) into single 64-bit AXI  transaction.
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_parityEN_coll_2pkt extends msnw_base_seq;

  `uvm_object_utils(msnw_parityEN_coll_2pkt)
	
   rand int loop = 4;
  
  function new(string name="msnw_parityEN_coll_2pkt");
    super.new(name);
  endfunction
 
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
       if (i%2== 0) begin `uvm_do_with(req, {req.valid ==1; req.parity_en ==1; req.pkt.addr =='h4da540;}); end
       else begin `uvm_do_with(req, {req.valid ==1; req.parity_en ==1; req.pkt.addr =='h4da541;}); end
       
       if (i%2== 0) begin `uvm_info("SEQ h", $psprintf("loop is even, expected addr = 'h4da540, actual addr = 'h%0h", req.pkt.addr), UVM_INFO)   end
       else begin `uvm_info("SEQ h", $psprintf("loop is odd, expected addr = 'h4da541, actual addr = 'h%0h", req.pkt.addr), UVM_INFO)  end
     end 
   endtask: body
endclass : msnw_parityEN_coll_2pkt

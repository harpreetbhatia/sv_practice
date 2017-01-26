////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: single_msnw_pkt_seq.sv $
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
//  DESCRIPTION : This sequence sends in a 1 msnw packet. Valid is asserted for 1 clk cycle.  
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class single_msnw_pkt_seq extends msnw_base_seq;

  `uvm_object_utils(single_msnw_pkt_seq)

   rand int loop = 2;
  
  function new(string name="single_msnw_pkt_seq");
    super.new(name);
  endfunction
 
 
 //Constraints
 //constraint limit {loop inside{[5:10]};}
 //constraint c_transmit_delay { req.pkt_delay <= 10 ; }
 //constraint c_parity { req.pkt.parity == ~^{req.pkt.addr, req.pkt.data} ; }
 //constraint c_valid { req.valid ==1;}
 //constraint c_parity_en { req.parity_en ==1;}
 
  virtual task body();
     for (int i= 0; i < loop; i++) begin
     `uvm_do_with(req, {req.valid ==1; req.parity_en ==1;})
 //       req = msnw_trans::type_id::create("req");
 //       start_item(req);
 //        assert (req.randomize() with ) ;
 //        assert (req.get_parity());
       `uvm_info("1MSNW", $psprintf("Seq gives a pkt with addr = 'h%0h, data = 'h%0h, parity = %0b",
                                            req.pkt.addr, req.pkt.data, req.pkt.parity), UVM_INFO)
 //       finish_item(req);
         
     end
   endtask: body
endclass : single_msnw_pkt_seq
//      virtual task body();

//     `uvm_create(item)
//     sequencer.wait_for_grant(prior); 
//     this.pre_do(1); 
//     item.randomize();
// 	 `uvm_info("1MSNW", $psprintf("Seq gives a pkt with addr = 'h%0h, data = 'h%0h, parity = %0b",
//        item.pkt.addr, item.pkt.data, item.pkt.parity), UVM_INFO)
//     item.get_parity();
// 	 `uvm_info("1MSNW", $psprintf("Seq gives a pkt with addr = 'h%0h, data = 'h%0h, parity = %0b",
//        item.pkt.addr, item.pkt.data, item.pkt.parity), UVM_INFO)
//     this.mid_do(item)        ;      
//     sequencer.send_request(item) ;   
//     sequencer.wait_for_item_done() ;
//     this.post_do(item)   ;  

//      endtask





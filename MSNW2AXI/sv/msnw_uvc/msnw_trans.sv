////////////////////////////////////////////////////////////////////////////////
//                              PMC-Sierra, Inc.                              //
//                                                                            //
//                               Copyright 2013                               //
//                            All Rights Reserved                             //
//                         CONFIDENTIAL & PROPRIETARY                         //
////////////////////////////////////////////////////////////////////////////////
// 
//  $RCSfile: msnw_trans.sv $
// 
//  $Date: Wed Nov  13 15:50:04 2013 $
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
//  DESCRIPTION : This file declares the msnw transaction, consisting of msnw pkt, valid, parity_en. 
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////
  
  typedef struct packed { bit [6:0] zeroes; bit  parity; bit [23:0] addr; bit [31:0] data; } msnw_pkt;
  
class msnw_trans extends uvm_sequence_item;                                  

  rand msnw_pkt   pkt;
  rand bit        valid;
  rand bit        parity_en;
  rand bit        xoff;
  bit             parity_error;
  msnw_pkt        error_pkt;
  
// Not part of the transaction.
  rand int          pkt_delay;  //to introduce delay between pkts.

  `uvm_object_utils_begin(msnw_trans)
    `uvm_field_int  (pkt,          UVM_HEX)
    `uvm_field_int  (valid,        UVM_DEFAULT)
    `uvm_field_int  (parity_en,    UVM_DEFAULT)
    `uvm_field_int  (xoff,         UVM_DEFAULT)
    `uvm_field_int  (parity_error, UVM_DEFAULT)
    `uvm_field_int  (error_pkt,    UVM_NOPRINT)
    `uvm_field_int  (pkt_delay,    UVM_DEFAULT)
  `uvm_object_utils_end
  
  
  function new (string name = "msnw_trans");
      super.new(name);
   endfunction

  constraint c_zeroes { pkt.zeroes == 7'b0; }
  constraint c_parity { pkt.parity == ~^{pkt.addr, pkt.data}; }
  constraint c_transmit_delay { pkt_delay == 0;}

endclass : msnw_trans

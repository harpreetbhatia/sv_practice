class msnw_err_trans extends msnw_trans;                                  

  `uvm_object_utils_begin(msnw_err_trans)
    `uvm_field_int  (pkt,          UVM_HEX)
    `uvm_field_int  (valid,        UVM_DEFAULT)
    `uvm_field_int  (parity_en,    UVM_DEFAULT)
    `uvm_field_int  (xoff,         UVM_DEFAULT)
    `uvm_field_int  (parity_error, UVM_DEFAULT)
    `uvm_field_int  (error_pkt,    UVM_NOPRINT)
    `uvm_field_int  (pkt_delay,    UVM_DEFAULT)
  `uvm_object_utils_end
  
  constraint c_parity { pkt.parity == ^{pkt.addr, pkt.data}; } // parity error

endclass : msnw_err_trans

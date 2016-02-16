
`include "uvm_macros.svh"

module dut(dut_if _if);

  import uvm_pkg::*;

  always @(posedge _if.clock)
  begin
    `uvm_info("mg", $psprintf("DUT received cmd=%b, addr=%d, data=%d",
                               _if.cmd, _if.addr, _if.data), UVM_NONE);
  end
  
endmodule: dut

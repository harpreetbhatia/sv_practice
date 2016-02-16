
`include "uvm_macros.svh"

interface dut_if();

  logic clock, reset;
  logic cmd;
  logic [7:0] addr;
  logic [7:0] data;

endinterface: dut_if

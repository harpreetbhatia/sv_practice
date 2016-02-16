
`include "uvm_macros.svh"

module top;

  import uvm_pkg::*;
  import my_pkg::*;
  
  dut_if dut_if1 ();
  
  dut    dut1 ( ._if(dut_if1) );

  // Clock and reset generator
  initial
  begin
    dut_if1.clock = 0;
    forever #5 dut_if1.clock = ~dut_if1.clock;
  end

  initial
  begin
    dut_if1.reset = 1;
    repeat(3) @(negedge dut_if1.clock);
    dut_if1.reset = 0;
  end

  initial
  begin: blk
     uvm_config_db #(virtual dut_if)::set(null, "uvm_test_top",
	                                  "dut_vi", dut_if1);

     uvm_top.finish_on_completion  = 1;
    
     run_test();
  end

endmodule: top

////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : This file declares the Top level file for the testbench. 
// 
//
//  NOTES : Naming conventions of interfaces:
//          prefix of lower-case "i_" or "o_": interface connecting to DUT
//          prefix of lower-case "in_" or "out_": interface passed to the environment
//          prefix of lower-case "vi_": virtual interface used by verification components
//
////////////////////////////////////////////////////////////////////////////////


  module lw56_40_13_tb;

     import uvm_pkg::*;
     import msnw_pkg::*;
     import axi_pkg::*;

     // Import the DDVAPI CDN_AXI SV interface and the generic mem Interface
     import DenaliSvCdn_axi::*;
     import DenaliSvMem::*;

     // Include the VIP UVM Base classes
     import cdnAxiUvm::*;
 

 
   // ====================================
   // SHARED signals
   // ====================================
   
   // clock
   bit tb_clk;
   
   // reset
   bit tb_rstb;
   logic [7:0] ecc_out;
   logic [63:0] data_out;
   
  // interface instantiation
  msnw_if i_msnw  (.clk(tb_clk), .rstb(tb_rstb));
  msnw_if o_msnw  (.clk(tb_clk), .rstb(tb_rstb));
  atu_if  i_atu   (.clk(tb_clk), .rstb(tb_rstb));
  axi_if  axi_vif (.clk(tb_clk), .rstb(tb_rstb));
 
  //AXI
  activemaster activeMaster (
    .aclk           (tb_clk),
    .aresetn        (tb_rstb),
    .awvalid        (axi_vif.s_awvalid),
    .awaddr         (axi_vif.s_awaddr),
    .awlen          (axi_vif.s_awlen),
    .awsize         (axi_vif.s_awsize),
    .awburst        (axi_vif.s_awburst),
    .awlock         (),                          // signal doesn't exist in DUT
    .awcache        (),                          // signal doesn't exist in DUT
    .awprot         (),                          // signal doesn't exist in DUT
    .awid           (axi_vif.s_awid),
    .awready        (axi_vif.s_awready),
    .awuser         (),                          // signal doesn't exist in DUT
    .wvalid         (axi_vif.s_wvalid),
    .wlast          (axi_vif.s_wlast),
    .wdata          (axi_vif.s_wdata),
    .wstrb          (axi_vif.s_wstrb),
    .wid            (axi_vif.s_wid),
    .wready         (axi_vif.s_wready),
    .wuser          (),                           // signal doesn't exist in DUT
    .bvalid         (axi_vif.s_bvalid),
    .bresp          (axi_vif.s_bresp),
    .bid            (axi_vif.s_bid),
    .bready         (axi_vif.s_bready),
    .buser          (32'b0),                      // signal doesn't exist in DUT
    .arvalid        (),
    .araddr         (),
    .arlen          (),
    .arsize         (),
    .arburst        (),
    .arlock         (),
    .arcache        (),
    .arprot         (),
    .arid           (),
    .arready        (1'b0),
    .aruser         (),
    .rvalid         (1'b0),
    .rlast          (1'b0),
    .rdata          (65'b0),
    .rresp          (2'b0),
    .rid            (9'b0),
    .rready         (),
    .ruser          (32'b0)
);
  defparam activeMaster.interface_soma = {"../sv/axi_uvc/activemaster.soma"};

  passiveslave passiveSlave (
    .aclk           (tb_clk),
    .aresetn        (tb_rstb),
    .awvalid        (axi_vif.s_awvalid),
    .awaddr         (axi_vif.s_awaddr),
    .awlen          (axi_vif.s_awlen),
    .awsize         (axi_vif.s_awsize),
    .awburst        (axi_vif.s_awburst),
    .awlock         (2'b0),                    // signal doesn't exist in DUT
    .awcache        (4'b0),                    // signal doesn't exist in DUT
    .awprot         (3'b0),                    // signal doesn't exist in DUT
    .awid           (axi_vif.s_awid),
    .awready        (axi_vif.s_awready),
    .awuser         (32'b0),                   // signal doesn't exist in DUT
    .wvalid         (axi_vif.s_wvalid),
    .wlast          (axi_vif.s_wlast),
    .wdata          (axi_vif.s_wdata),
    .wstrb          (axi_vif.s_wstrb),
    .wid            (axi_vif.s_wid),
    .wready         (axi_vif.s_wready),
    .wuser          (32'b0),                   // signal doesn't exist in DUT
    .bvalid         (axi_vif.s_bvalid),
    .bresp          (axi_vif.s_bresp),
    .bid            (axi_vif.s_bid),
    .bready         (axi_vif.s_bready),
    .buser          (32'b0),                   // signal doesn't exist in DUT
    .arvalid        (1'b0),
    .araddr         (32'b0),
    .arlen          (4'b0),
    .arsize         (3'b0),
    .arburst        (2'b0),
    .arlock         (2'b0),
    .arcache        (4'b0),
    .arprot         (3'b0),
    .arid           (9'b0),
    .arready        (1'b0),
    .aruser         (32'b0),
    .rvalid         (1'b0),
    .rlast          (1'b0),
    .rdata          (64'b0),
    .rresp          (2'b0),
    .rid            (9'b0),
    .rready         (1'b0),
    .ruser          (32'b0)
);
  defparam passiveSlave.interface_soma = {"../sv/axi_uvc/passiveslave.soma"};
 
  activeslave activeSlave (
    .aclk           (tb_clk),
    .aresetn        (tb_rstb),
    .awvalid        (axi_vif.m_awvalid),
    .awaddr         (axi_vif.m_awaddr),
    .awlen          (axi_vif.m_awlen),
    .awsize         (axi_vif.m_awsize),
    .awburst        (axi_vif.m_awburst),
    .awlock         (2'b0),                 // signal doesn't exist in DUT
    .awcache        (4'b0),                 // signal doesn't exist in DUT
    .awprot         (3'b0),                 // signal doesn't exist in DUT
    .awid           (axi_vif.m_awid),
    .awready        (axi_vif.m_awready),
    .awuser         (32'b0),                // signal doesn't exist in DUT
    .wvalid         (axi_vif.m_wvalid),
    .wlast          (axi_vif.m_wlast),
    .wdata          (axi_vif.m_wdata),
    .wstrb          (axi_vif.m_wstrb),
    .wid            (axi_vif.m_wid),
    .wready         (axi_vif.m_wready),
    .wuser          (32'b0),                 // signal doesn't exist in DUT
    .bvalid         (axi_vif.m_bvalid),
    .bresp          (axi_vif.m_bresp),
    .bid            (axi_vif.m_bid),
    .bready         (axi_vif.m_bready),
    .buser          (),                      // signal doesn't exist in DUT
    .arvalid        (1'b0),
    .araddr         (32'b0),
    .arlen          (4'b0),
    .arsize         (3'b0),
    .arburst        (2'b0),
    .arlock         (2'b0),
    .arcache        (4'b0),
    .arprot         (3'b0),
    .arid           (9'b0),
    .arready        (),
    .aruser         (32'b0),
    .rvalid         (),
    .rlast          (),
    .rdata          (),
    .rresp          (),
    .rid            (),
    .rready         (1'b0),
    .ruser          ()
);
  defparam activeSlave.interface_soma = {"../sv/axi_uvc/activeslave.soma"};

  passivemaster passiveMaster (
    .aclk           (tb_clk),
    .aresetn        (tb_rstb),
    .awvalid        (axi_vif.m_awvalid),
    .awaddr         (axi_vif.m_awaddr),
    .awlen          (axi_vif.m_awlen),
    .awsize         (axi_vif.m_awsize),
    .awburst        (axi_vif.m_awburst),
    .awlock         (2'b0),                // signal doesn't exist in DUT
    .awcache        (4'b0),                // signal doesn't exist in DUT
    .awprot         (3'b0),                // signal doesn't exist in DUT
    .awid           (axi_vif.m_awid),
    .awready        (axi_vif.m_awready),
    .awuser         (32'b0),               // signal doesn't exist in DUT
    .wvalid         (axi_vif.m_wvalid),
    .wlast          (axi_vif.m_wlast),
    .wdata          (axi_vif.m_wdata),
    .wstrb          (axi_vif.m_wstrb),
    .wid            (axi_vif.m_wid),
    .wready         (axi_vif.m_wready),
    .wuser          (32'b0),                // signal doesn't exist in DUT
    .bvalid         (axi_vif.m_bvalid),
    .bresp          (axi_vif.m_bresp),
    .bid            (axi_vif.m_bid),
    .bready         (axi_vif.m_bready),
    .buser          (32'b0),                // signal doesn't exist in DUT
    .arvalid        (1'b0),
    .araddr         (32'b0),
    .arlen          (4'b0),
    .arsize         (3'b0),
    .arburst        (2'b0),
    .arlock         (2'b0),
    .arcache        (4'b0),
    .arprot         (3'b0),
    .arid           (9'b0),
    .arready        (1'b0),
    .aruser         (32'b0),
    .rvalid         (1'b0),
    .rlast          (1'b0),
    .rdata          (64'b0),
    .rresp          (2'b0),
    .rid            (9'b0),
    .rready         (1'b0),
    .ruser          (32'b0)
);
  defparam passiveMaster.interface_soma = {"../sv/axi_uvc/passivemaster.soma"};
 
//parameters passed to this block: 64 bits data width, 8 bits ecc width, and enable ecc generation
sfm_ecc #(64, 8, 1) tb_ecc_gen(
     .enable        (1'b1),                 // Always enabled when generating.
     .inj_err       ('0),                   // No Error Injection at this stage
     .data_in       (axi_vif.s_wdata),      // Data to generate ECC for
     .ecc_in        ('0),                   // Not used for generation
     .data_out      (data_out),             // No error injection, so no data out.
     .ecc_out       (ecc_out),              // Generated ECC bits.
     .ecc_err       ()                      // Not connected in generate mode.
);
  // DUT 
   lw23_60_11 dut (    
    .clk            (tb_clk),
    .rstb           (tb_rstb),
    
    //MSNW interface
    .msnw_packet_in (i_msnw.msnw_pkt),
    .valid_in       (i_msnw.valid),
    .xoff_out       (i_msnw.xoff),
    .parity_en      (i_msnw.parity_en),
    
    .msnw_packet_out(o_msnw.msnw_pkt),
    .valid_out      (o_msnw.valid),
    .xoff_in        (o_msnw.xoff),
    .parity_error   (o_msnw.parity_error),
    .error_packet   (o_msnw.error_pkt),

    
    //ATU Interface
    .mask           (i_atu.mask),
    .bar            (i_atu.bar),
    .collate        (i_atu.collate),
   

    //AXI MASTER SIGNALS(msnw2axi)
    //Address Channel
    .m_awaddr       (axi_vif.m_awaddr),
    .m_awaddr_parity(axi_vif.m_awaddr_parity),
    .m_awburst      (axi_vif.m_awburst),
    .m_awid         (axi_vif.m_awid),
    .m_awlen        (axi_vif.m_awlen),
    .m_awsize       (axi_vif.m_awsize),
    .m_awvalid      (axi_vif.m_awvalid),

    .m_awready      (axi_vif.m_awready),

    //Data Channel
    .m_wdata        (axi_vif.m_wdata),
    .m_wdata_ecc    (axi_vif.m_wdata_ecc),
    .m_wid          (axi_vif.m_wid),
    .m_wlast        (axi_vif.m_wlast),
    .m_wstrb        (axi_vif.m_wstrb),
    .m_wvalid       (axi_vif.m_wvalid),

    .m_wready       (axi_vif.m_wready),

    //Response Channel
    .m_bid          (axi_vif.m_bid),
    .m_bresp        (axi_vif.m_bresp),
    .m_bvalid       (axi_vif.m_bvalid),

    .m_bready       (axi_vif.m_bready),



    //AXI SLAVE SIGNALS(axi2msnw)

    //Address Channel
    .s_awaddr       (axi_vif.s_awaddr),
    .s_awaddr_parity(^axi_vif.s_awaddr), //odd parity of s_awaddr goes here
    .s_awburst      (axi_vif.s_awburst),
    .s_awid         (axi_vif.s_awid),
    .s_awlen        (axi_vif.s_awlen),
    .s_awsize       (axi_vif.s_awsize),
    .s_awvalid      (axi_vif.s_awvalid),

    .s_awready      (axi_vif.s_awready),
   
    //Data Channel
    .s_wdata        (data_out),
    .s_wdata_ecc    (ecc_out),
    .s_wid          (axi_vif.s_wid),
    .s_wlast        (axi_vif.s_wlast),
    .s_wstrb        (axi_vif.s_wstrb),
    .s_wvalid       (axi_vif.s_wvalid),

    .s_wready       (axi_vif.s_wready),

    //Response Channel
    .s_bid          (axi_vif.s_bid),
    .s_bresp        (axi_vif.s_bresp), 
    .s_bvalid       (axi_vif.s_bvalid),
    .s_bready       (axi_vif.s_bready)
);



initial
begin
  tb_clk = 0;
  tb_rstb = 1;

  #5 tb_rstb = 0;
  #25 tb_rstb = 1;
//  #120  $finish; 
end

always #5 tb_clk = ~tb_clk;

initial begin
  uvm_config_db#(virtual msnw_if)::set(uvm_root::get(), "*", "in_msnw" , i_msnw );
  uvm_config_db#(virtual msnw_if)::set(uvm_root::get(), "*", "out_msnw", o_msnw );
  uvm_config_db#(virtual atu_if) ::set(uvm_root::get(), "*", "in_atu"  , i_atu  );
  uvm_config_db#(virtual axi_if) ::set(uvm_root::get(), "*", "axi_vif" , axi_vif);
  run_test();
end

endmodule

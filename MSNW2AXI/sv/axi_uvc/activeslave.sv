// pragma cdn_vip_model -class cdn_axi
// Module:                      activeslave
// SOMA file:                   
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
`timescale 1ps/1ps

module activeslave(
    aclk,
    aresetn,
    awvalid,
    awaddr,
    awlen,
    awsize,
    awburst,
    awlock,
    awcache,
    awprot,
    awid,
    awready,
    awuser,
    wvalid,
    wlast,
    wdata,
    wstrb,
    wid,
    wready,
    wuser,
    bvalid,
    bresp,
    bid,
    bready,
    buser,
    arvalid,
    araddr,
    arlen,
    arsize,
    arburst,
    arlock,
    arcache,
    arprot,
    arid,
    arready,
    aruser,
    rvalid,
    rlast,
    rdata,
    rresp,
    rid,
    rready,
    ruser
);
    parameter interface_soma = "../sv/axi_uvc/activeslave.soma";
    parameter init_file   = "";
    parameter sim_control = "";
    input aclk;
    input aresetn;
    input awvalid;
    input [31:0] awaddr;
    input [3:0] awlen;
    input [2:0] awsize;
    input [1:0] awburst;
    input [1:0] awlock;
    input [3:0] awcache;
    input [2:0] awprot;
    input [8:0] awid;
    output awready;
      reg den_awready;
      assign awready = den_awready;
    input [31:0] awuser;
    input wvalid;
    input wlast;
    input [63:0] wdata;
    input [7:0] wstrb;
    input [8:0] wid;
    output wready;
      reg den_wready;
      assign wready = den_wready;
    input [31:0] wuser;
    output bvalid;
      reg den_bvalid;
      assign bvalid = den_bvalid;
    output [1:0] bresp;
      reg [1:0] den_bresp;
      assign bresp = den_bresp;
    output [8:0] bid;
      reg [8:0] den_bid;
      assign bid = den_bid;
    input bready;
    output [31:0] buser;
      reg [31:0] den_buser;
      assign buser = den_buser;
    input arvalid;
    input [31:0] araddr;
    input [3:0] arlen;
    input [2:0] arsize;
    input [1:0] arburst;
    input [1:0] arlock;
    input [3:0] arcache;
    input [2:0] arprot;
    input [8:0] arid;
    output arready;
      reg den_arready;
      assign arready = den_arready;
    input [31:0] aruser;
    output rvalid;
      reg den_rvalid;
      assign rvalid = den_rvalid;
    output rlast;
      reg den_rlast;
      assign rlast = den_rlast;
    output [63:0] rdata;
      reg [63:0] den_rdata;
      assign rdata = den_rdata;
    output [1:0] rresp;
      reg [1:0] den_rresp;
      assign rresp = den_rresp;
    output [8:0] rid;
      reg [8:0] den_rid;
      assign rid = den_rid;
    input rready;
    output [31:0] ruser;
      reg [31:0] den_ruser;
      assign ruser = den_ruser;
initial
    $cdn_axi_access(aclk,aresetn,awvalid,awaddr,awlen,awsize,awburst,awlock,awcache,awprot,awid,den_awready,awuser,wvalid,wlast,wdata,wstrb,wid,den_wready,wuser,den_bvalid,den_bresp,den_bid,bready,den_buser,arvalid,araddr,arlen,arsize,arburst,arlock,arcache,arprot,arid,den_arready,aruser,den_rvalid,den_rlast,den_rdata,den_rresp,den_rid,rready,den_ruser);
endmodule


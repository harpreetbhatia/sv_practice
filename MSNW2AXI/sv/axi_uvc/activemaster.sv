// pragma cdn_vip_model -class cdn_axi
// Module:                      activemaster
// SOMA file:                   
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
`timescale 1ps/1ps

module activemaster(
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
    parameter interface_soma = "../sv/axi_uvc/activemaster.soma";
    parameter init_file   = "";
    parameter sim_control = "";
    input aclk;
    input aresetn;
    output awvalid;
      reg den_awvalid;
      assign awvalid = den_awvalid;
    output [31:0] awaddr;
      reg [31:0] den_awaddr;
      assign awaddr = den_awaddr;
    output [3:0] awlen;
      reg [3:0] den_awlen;
      assign awlen = den_awlen;
    output [2:0] awsize;
      reg [2:0] den_awsize;
      assign awsize = den_awsize;
    output [1:0] awburst;
      reg [1:0] den_awburst;
      assign awburst = den_awburst;
    output [1:0] awlock;
      reg [1:0] den_awlock;
      assign awlock = den_awlock;
    output [3:0] awcache;
      reg [3:0] den_awcache;
      assign awcache = den_awcache;
    output [2:0] awprot;
      reg [2:0] den_awprot;
      assign awprot = den_awprot;
    output [8:0] awid;
      reg [8:0] den_awid;
      assign awid = den_awid;
    input awready;
    output [31:0] awuser;
      reg [31:0] den_awuser;
      assign awuser = den_awuser;
    output wvalid;
      reg den_wvalid;
      assign wvalid = den_wvalid;
    output wlast;
      reg den_wlast;
      assign wlast = den_wlast;
    output [63:0] wdata;
      reg [63:0] den_wdata;
      assign wdata = den_wdata;
    output [7:0] wstrb;
      reg [7:0] den_wstrb;
      assign wstrb = den_wstrb;
    output [8:0] wid;
      reg [8:0] den_wid;
      assign wid = den_wid;
    input wready;
    output [31:0] wuser;
      reg [31:0] den_wuser;
      assign wuser = den_wuser;
    input bvalid;
    input [1:0] bresp;
    input [8:0] bid;
    output bready;
      reg den_bready;
      assign bready = den_bready;
    input [31:0] buser;
    output arvalid;
      reg den_arvalid;
      assign arvalid = den_arvalid;
    output [31:0] araddr;
      reg [31:0] den_araddr;
      assign araddr = den_araddr;
    output [3:0] arlen;
      reg [3:0] den_arlen;
      assign arlen = den_arlen;
    output [2:0] arsize;
      reg [2:0] den_arsize;
      assign arsize = den_arsize;
    output [1:0] arburst;
      reg [1:0] den_arburst;
      assign arburst = den_arburst;
    output [1:0] arlock;
      reg [1:0] den_arlock;
      assign arlock = den_arlock;
    output [3:0] arcache;
      reg [3:0] den_arcache;
      assign arcache = den_arcache;
    output [2:0] arprot;
      reg [2:0] den_arprot;
      assign arprot = den_arprot;
    output [8:0] arid;
      reg [8:0] den_arid;
      assign arid = den_arid;
    input arready;
    output [31:0] aruser;
      reg [31:0] den_aruser;
      assign aruser = den_aruser;
    input rvalid;
    input rlast;
    input [63:0] rdata;
    input [1:0] rresp;
    input [8:0] rid;
    output rready;
      reg den_rready;
      assign rready = den_rready;
    input [31:0] ruser;
initial
    $cdn_axi_access(aclk,aresetn,den_awvalid,den_awaddr,den_awlen,den_awsize,den_awburst,den_awlock,den_awcache,den_awprot,den_awid,awready,den_awuser,den_wvalid,den_wlast,den_wdata,den_wstrb,den_wid,wready,den_wuser,bvalid,bresp,bid,den_bready,buser,den_arvalid,den_araddr,den_arlen,den_arsize,den_arburst,den_arlock,den_arcache,den_arprot,den_arid,arready,den_aruser,rvalid,rlast,rdata,rresp,rid,den_rready,ruser);
endmodule


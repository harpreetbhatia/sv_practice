// pragma cdn_vip_model -class cdn_axi
// Module:                      passiveslave
// SOMA file:                   
// Initial contents file:       
// Simulation control flags:    

// PLEASE do not remove, modify or comment out the timescale declaration below.
// Doing so will cause the scheduling of the pins in Denali models to be
// inaccurate and cause simulation problems and possible undetected errors or
// erroneous errors.  It must remain `timescale 1ps/1ps for accurate simulation.   
`timescale 1ps/1ps

module passivemaster(
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
    parameter interface_soma = "../sv/axi_uvc/passivemaster.soma";
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
    input awready;
    input [31:0] awuser;
    input wvalid;
    input wlast;
    input [63:0] wdata;
    input [7:0] wstrb;
    input [8:0] wid;
    input wready;
    input [31:0] wuser;
    input bvalid;
    input [1:0] bresp;
    input [8:0] bid;
    input bready;
    input [31:0] buser;
    input arvalid;
    input [31:0] araddr;
    input [3:0] arlen;
    input [2:0] arsize;
    input [1:0] arburst;
    input [1:0] arlock;
    input [3:0] arcache;
    input [2:0] arprot;
    input [8:0] arid;
    input arready;
    input [31:0] aruser;
    input rvalid;
    input rlast;
    input [63:0] rdata;
    input [1:0] rresp;
    input [8:0] rid;
    input rready;
    input [31:0] ruser;
initial
    $cdn_axi_access(aclk,aresetn,awvalid,awaddr,awlen,awsize,awburst,awlock,awcache,awprot,awid,awready,awuser,wvalid,wlast,wdata,wstrb,wid,wready,wuser,bvalid,bresp,bid,bready,buser,arvalid,araddr,arlen,arsize,arburst,arlock,arcache,arprot,arid,arready,aruser,rvalid,rlast,rdata,rresp,rid,rready,ruser);
endmodule


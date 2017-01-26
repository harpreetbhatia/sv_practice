////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : This file declares the AXI side of the msnw2axi interface. 
//
////////////////////////////////////////////////////////////////////////////////


interface axi_if (input clk, input rstb);
    parameter SLV_AXI_ID_BUS_WIDTH = 4 ;

//LOGIC

    //dut as a MASTER (msnw2axi)
	
    //Address Channel
    logic  [31:0]                       m_awaddr;
    logic  [3:0]                        m_awaddr_parity;
    logic  [1:0]                        m_awburst;
    logic  [8:0]                        m_awid;
    logic  [3:0]                        m_awlen;
    logic  [2:0]                        m_awsize;
    logic                               m_awvalid;
    
    logic                               m_awready;

    //Data Channel
    logic [63:0]                        m_wdata;
    logic [7:0]                         m_wdata_ecc;
    logic [8:0]                         m_wid;
    logic                               m_wlast;
    logic [7:0]                         m_wstrb;
    logic                               m_wvalid;
    
    logic                               m_wready;
    
    //Response Channel
    logic [8:0]                         m_bid;
    logic [1:0]                         m_bresp;
    logic                               m_bvalid;
    
    logic                               m_bready;


    //dut as a SLAVE (axi2msnw)
    
    //Address Channel
    logic  [31:0]                       s_awaddr;
    logic  [3:0]                        s_awaddr_parity;
    logic  [1:0]                        s_awburst;
    logic  [SLV_AXI_ID_BUS_WIDTH-1:0]   s_awid;
    logic  [3:0]                        s_awlen;
    logic  [2:0]                        s_awsize;
    logic                               s_awvalid;
    
    logic                               s_awready;
   
    //Data Channel
    logic  [63:0]                       s_wdata;
    logic  [7:0]                        s_wdata_ecc;
    logic  [SLV_AXI_ID_BUS_WIDTH-1:0]   s_wid;
    logic                               s_wlast;
    logic  [7:0]                        s_wstrb;
    logic                               s_wvalid;
    
    logic                               s_wready;

    //Response Channel
    logic  [SLV_AXI_ID_BUS_WIDTH-1:0]   s_bid;
    logic  [1:0]                        s_bresp;
    logic                               s_bvalid;
    logic                               s_bready;

					   
endinterface : axi_if

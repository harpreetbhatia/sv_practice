////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : This file declares the message network interface. 
//
////////////////////////////////////////////////////////////////////////////////


interface msnw_if (input clk, input rstb);

    parameter MSNW_PKT_WIDTH   = 64;

//logic
   logic [MSNW_PKT_WIDTH-1:0]  msnw_pkt;  // Message Network pkt
   logic   valid;
   logic   xoff;
   logic   parity_en;
   logic   parity_error;
   logic [MSNW_PKT_WIDTH-1:0]  error_pkt;


//Clocking blocks
  // clocking block mstr  -- connect any msnw master AGENT to this
  // clocking block slv   -- connect any msnw slave AGENT to this 
  // clocking block mon   -- connect any monitor to this
  

  clocking mstr @ (posedge clk);
    output msnw_pkt, valid, parity_en;
    input xoff;
  endclocking //  cb mstr 
//   modport  master (input clk, clocking mstr);
  
  clocking slv @ (posedge clk);
    input msnw_pkt, valid, parity_error, error_pkt;  
    output xoff;
  endclocking //  cb slv 
//  modport  slave (input clk, clocking slv);

  clocking mon @ (posedge clk);
    input msnw_pkt, valid, xoff, parity_en, parity_error, error_pkt;
  endclocking //  cb mon 
//  modport  monitor (input clk, clocking mon);
	
endinterface : msnw_if
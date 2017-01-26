////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : This file declares the address translation unit interface. 
//
////////////////////////////////////////////////////////////////////////////////


interface atu_if (input clk, input rstb);
    
    parameter         NUM_OF_WINDOWS = 1 ; 

//logic
    logic  [24 * NUM_OF_WINDOWS - 1 :0] mask;
    logic  [32 * NUM_OF_WINDOWS - 1 :0] bar;
    logic       [NUM_OF_WINDOWS - 1 :0] collate;


//Clocking blocks
  // clocking block mstr -- connect any ATU master AGENT to this 
  // clocking block mon  -- connect any monitor to this
   
   clocking mstr @ (posedge clk);
    output mask, bar, collate;
   endclocking //   clocking mstr  

    clocking mon @ (posedge clk);
    input mask, bar, collate;
    endclocking //   clocking mon 

endinterface : atu_if
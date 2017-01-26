////////////////////////////////////////////////////////////////////////////////
// 
//  DESCRIPTION : Scoreboard for data integrity check between MSNWin and MSNWout
//
//
//  NOTES : Anyone must be able to load this file without errors
//
////////////////////////////////////////////////////////////////////////////////

class msnw_scoreboard extends uvm_scoreboard;

  uvm_tlm_analysis_fifo #(msnw_pkt) input_pkts_collected;
  uvm_tlm_analysis_fifo #(axi_pkt) output_pkts_collected;

  msnw_pkt input_pkt;
  axi_pkt output_pkt;
  
  `uvm_component_utils(msnw_scoreboard)
   
  function new (string name , uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  
// UVM build_phase
function void msnw_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);  
  input_pkts_collected = new("input_pkts_collected", this);
  output_pkts_collected = new("output_pkts_collected", this);
  input_pkt = msnw_scoreboard::type_id::create("input_pkt",this);
  output_pkt = msnw_scoreboard::type_id::create("output_pkt",this);
  
 endfunction : build_phase

  
  // UVM run_phase
task msnw_scoreboard::run_phase(uvm_phase phase);
  watcher();
endtask : run_phase


// Task: 
task msnw_scoreboard::watcher();
    forever begin
		  //@(posedge vif.clk iff (vif.rstb !=0)) begin  // rstb is inactive
          input_pkts_collected.get(input_pkt);
		  output_pkt_collected.get(output_pkt);
          compare_data();
          end
     end
endtask : watcher


  // implement 
  virtual task compare_data();

 /*   if ((transfer.address ==   (slave_cfg.start_address + `SPI_RX0_REG)) && (transfer.direction.name() == "READ"))
      begin
        temp1 = data_to_ahb.pop_front();
       
        if (temp1 == transfer.data[7:0]) 
          `uvm_info("SCRBD", $psprintf("####### PASS : AHB RECEIVED CORRECT DATA from %s  expected = %h, received = %h", slave_cfg.name, temp1, transfer.data), UVM_MEDIUM)
        else begin
          `uvm_error(get_type_name(), $psprintf("####### FAIL : AHB RECEIVED WRONG DATA from %s", slave_cfg.name))
          `uvm_info("SCRBD", $psprintf("expected = %h, received = %h", temp1, transfer.data), UVM_MEDIUM)
        end
      end
  endfunction : write_ahb
   
  function void assign_csr(spi_pkg::spi_csr_s csr_setting);
    csr = csr_setting;
  endfunction : assign_csr */

endclass : msnw_scoreboard



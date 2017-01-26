////////////////////////////////////////////////////////////////////////////////
//  DESCRIPTION : This file declares the m2a(DUT) scoreboard.
//
//
//  NOTES : Naming conventions of interfaces:
//          prefix of lower-case "i_" or "o_": interface connecting to DUT
//          prefix of lower-case "in_" or "out_": interface passed to the environment
//          prefix of lower-case "vi_": virtual interface used by verification components
//
////////////////////////////////////////////////////////////////////////////////

     import uvm_pkg::*;
     import msnw_pkg::*;
     import axi_pkg::*;

     // Import the DDVAPI CDN_AXI SV interface and the generic mem Interface
     import DenaliSvCdn_axi::*;
     import DenaliSvMem::*;

     // Include the VIP UVM Base classes
     import cdnAxiUvm::*;

class m2a_scbd extends uvm_scoreboard;
  uvm_tlm_analysis_fifo #(denaliCdn_axiTransaction) axi_in_pkts_collected;
  uvm_tlm_analysis_fifo #(denaliCdn_axiTransaction) axi_out_pkts_collected;
  uvm_tlm_analysis_fifo #(msnw_trans) msnw_out_pkts_collected;
  uvm_tlm_analysis_fifo #(msnw_trans) msnw_in_pkts_collected;

  denaliCdn_axiTransaction axi_in_pkt;
  denaliCdn_axiTransaction axi_out_pkt;
  msnw_trans msnw_in_pkt;
  msnw_trans msnw_out_pkt;

  `uvm_component_utils(m2a_scbd)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    axi_in_pkts_collected = new("axi_in_pkts_collected", this); 
    axi_out_pkts_collected = new("axi_out_pkts_collected", this); 
    msnw_out_pkts_collected = new("msnw_out_pkts_collected", this); 
    msnw_in_pkts_collected = new("msnw_in_pkts_collected", this); 

    axi_in_pkt = denaliCdn_axiTransaction::type_id::create("axi_in_pkt");
    axi_out_pkt = denaliCdn_axiTransaction::type_id::create("axi_out_pkt");
    msnw_out_pkt = msnw_trans::type_id::create("msnw_out_pkt");
    msnw_in_pkt = msnw_trans::type_id::create("msnw_in_pkt");


    `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    fork
      begin
        m2a_watcher( );
      end
      begin
        a2m_watcher( );
      end
    join
  endtask: run_phase

  virtual task m2a_watcher( );
    fork
      begin
        forever 
          begin
            msnw_in_pkts_collected.get(msnw_in_pkt);
            `uvm_info(get_type_name(), "Printing msnw_in_pkt ", UVM_LOW)
            msnw_in_pkt.print();
          end
      end
      begin
        forever 
          begin
            axi_out_pkts_collected.get(axi_out_pkt);
            `uvm_info(get_type_name(), "Printing axi_out_pkt ", UVM_LOW)
            axi_out_pkt.print();
          end
      end
    join
  endtask: m2a_watcher

  virtual task a2m_watcher( );
    fork
      begin
        forever 
          begin
            axi_in_pkts_collected.get(axi_in_pkt);
            `uvm_info(get_type_name(), "Printing axi_in_pkt ", UVM_LOW)
            axi_in_pkt.print();
          end
      end
      begin
        forever 
          begin
            msnw_out_pkts_collected.get(msnw_out_pkt);
            `uvm_info(get_type_name(), "Printing msnw_out_pkt ", UVM_LOW)
            msnw_out_pkt.print();
          end
      end
    join
  endtask: a2m_watcher

endclass: m2a_scbd

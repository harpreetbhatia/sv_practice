// ----------------------------------------------------------------------------
// 
// Class : m2a_virt_sequencer
//
// ----------------------------------------------------------------------------
//cjw not using this yet....
class m2a_virt_sequencer extends uvm_sequencer;
  
  cdnAxiUvmUserSequencer Axi_masterSeqr;
  cdnAxiUvmUserSequencer Axi_slaveSeqr;
  msnw_sequencer msnw_in_seqr;
  msnw_sequencer msnw_out_seqr;
 
  m2a_env pEnv;
  
  `uvm_component_utils_begin(m2a_virt_sequencer)
    `uvm_field_object(Axi_masterSeqr, UVM_ALL_ON)
    `uvm_field_object(Axi_slaveSeqr, UVM_ALL_ON)
    `uvm_field_object(msnw_in_seqr, UVM_ALL_ON)
    `uvm_field_object(msnw_out_seqr, UVM_ALL_ON)
    `uvm_field_object(pEnv, UVM_ALL_ON)
  `uvm_component_utils_end
   
  function new(string name = "m2a_virt_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass 

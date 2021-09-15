`ifndef AXI_SEQUENCER
`define AXI_SEQUENCER

class axi_sequencer extends uvm_sequencer#(axi_transaction);
  `uvm_component_utils(axi_sequencer)
  ///////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
   
endclass

`endif





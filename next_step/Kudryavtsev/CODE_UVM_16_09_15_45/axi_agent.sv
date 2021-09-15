`ifndef AXI_AGENT 
`define AXI_AGENT
 
class axi_agent extends uvm_agent;
  axi_driver    driver;
  axi_sequencer sequencer;
  ///////////////////////////////////////////////////////////////////////////////
  `uvm_component_utils(axi_agent)
  ///////////////////////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : build-phase 
  // Description : construct the components such as.. driver,monitor,sequencer..etc
  ///////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = axi_driver::type_id::create("driver", this);
    sequencer = axi_sequencer::type_id::create("sequencer", this);
  endfunction : build_phase
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : connect_phase 
  // Description : connect tlm ports ande exports (ex: analysis port/exports) 
  ///////////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);
      `uvm_info(get_full_name(),"Connect stage complete.",UVM_LOW)
  endfunction : connect_phase
 
endclass : axi_agent

`endif

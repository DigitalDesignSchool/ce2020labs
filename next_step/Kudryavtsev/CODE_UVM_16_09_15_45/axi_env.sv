`ifndef AXI_ENV
`define AXI_ENV
 
class axi_environment extends uvm_env;
  axi_agent axi_agnt;
  axi_coverage#(axi_transaction) coverage;
  axi_scoreboard  sb;
  //////////////////////////////////////////////////////////////////////////////
  `uvm_component_utils(axi_environment)
  //////////////////////////////////////////////////////////////////////////////
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //////////////////////////////////////////////////////////////////////////////
  // Method name : build_phase 
  // Description : constructor
  //////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    axi_agnt = axi_agent::type_id::create("axi_agent", this);
    coverage = axi_coverage#(axi_transaction)::type_id::create("coverage", this);
    sb = axi_scoreboard::type_id::create("sb", this);
  endfunction : build_phase
  //////////////////////////////////////////////////////////////////////////////
  // Method name : build_phase 
  // Description : constructor
  //////////////////////////////////////////////////////////////////////////////
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    axi_agnt.driver.drv2sb_port.connect(sb.transaction_fifo.analysis_export);
    axi_agnt.driver.drv2sb_port.connect(coverage.analysis_export);
    `uvm_info(get_full_name(),"Build stage complete.",UVM_LOW)
  endfunction : connect_phase
endclass : axi_environment

`endif





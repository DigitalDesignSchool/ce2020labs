`ifndef AXI_BASIC_TEST 
`define AXI_BASIC_TEST
`include "uvm_macros.svh"
 import uvm_pkg::*;
 
class axi_basic_test extends uvm_test;
  `uvm_component_utils(axi_basic_test)
 
  axi_environment     env;
  axi_basic_seq       seq;
  ////////////////////////////////////////////////////////////////////
  // Method name : new
  // Decription: Constructor 
  ////////////////////////////////////////////////////////////////////
  function new(string name = "axi_basic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
  ////////////////////////////////////////////////////////////////////
  // Method name : build_phase 
  // Decription: Construct the components and objects 
  ////////////////////////////////////////////////////////////////////
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi_environment::type_id::create("env", this);
    seq = axi_basic_seq::type_id::create("seq");
  endfunction : build_phase
  ////////////////////////////////////////////////////////////////////
  // Method name : run_phase 
  // Decription: Trigger the sequences to run 
  ////////////////////////////////////////////////////////////////////
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
     seq.start(env.axi_agnt.sequencer);
    phase.drop_objection(this);
  endtask : run_phase
 
endclass : axi_basic_test

`endif













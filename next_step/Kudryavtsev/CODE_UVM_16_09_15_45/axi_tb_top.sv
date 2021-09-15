`ifndef AXI_TB_TOP
`define AXI_TB_TOP
`include "axi_defines.svh"
`include "uvm_macros.svh"
`include "axi_interface.sv"
import uvm_pkg::*;
`include "axi_transaction.sv"
`include "axi_basic_seq.sv"
`include "axi_driver.sv"
`include "axi_sequencer.sv"
`include "axi_agent.sv"
`include "axi_coverage.sv"
`include "axi_scoreboard.sv"
`include "axi_env.sv"
`include "axi_basic_test.sv"

module axi_tb_top;
  parameter cycle = 10 ;
  bit axi_aclk;
  bit Write_address_ready = 0, Read_address_ready = 0; 
  //////////////////////////////////////////////////////////////////////////////
  initial begin
     axi_aclk=0;
     forever #(cycle/2) axi_aclk=~axi_aclk;
  end
  //////////////////////////////////////////////////////////////////////////////
  AXI intf(axi_aclk);
   //////////////////////////////////////////////////////////////////////////////
  /*********************axi DUT Instantation **********************************/
  //////////////////////////////////////////////////////////////////////////////
localparam C_S00_AXI_DATA_WIDTH	 = 32;
localparam C_S00_AXI_ADDR_WIDTH	 = 32;
		
AXILITE  # (
		.C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S00_BASEADDR(`C_S00_BASEADDR),
		.C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)) 
 AXILITE_V
	(
		.s00_axi_aclk(axi_aclk),
		.s00_axi_aresetn(intf.s00_axi_aresetn),
		.s00_axi_awaddr(intf.s00_axi_awaddr),
		.s00_axi_awvalid(intf.s00_axi_awvalid),
		.s00_axi_awready(intf.s00_axi_awready),
		.s00_axi_wdata(intf.s00_axi_wdata),
		.s00_axi_wvalid(intf.s00_axi_wvalid),
		.s00_axi_wready(intf.s00_axi_wready),
		.s00_axi_bresp(intf.s00_axi_bresp),
		.s00_axi_bvalid(intf.s00_axi_bvalid),
		.s00_axi_bready(intf.s00_axi_bready),
		.s00_axi_araddr(intf.s00_axi_araddr),
		.s00_axi_arvalid(intf.s00_axi_arvalid),
		.s00_axi_arready(intf.s00_axi_arready),
		.s00_axi_rdata(intf.s00_axi_rdata),
		.s00_axi_rresp(intf.s00_axi_rresp),
		.s00_axi_rvalid(intf.s00_axi_rvalid),
		.s00_axi_rready(intf.s00_axi_rready)
	);
	
  //////////////////////////////////////////////////////////////////////////////
  /*********************starting the execution uvm phases**********************/
  //////////////////////////////////////////////////////////////////////////////
  initial begin
    run_test("axi_basic_test");
  end
  //////////////////////////////////////////////////////////////////////////////
  /**********Set the Interface instance Using Configuration Database***********/
  //////////////////////////////////////////////////////////////////////////////
  initial begin
   uvm_config_db#(virtual AXI)::set(uvm_root::get(),"*","intf",intf);
  end
  
  initial begin
   $dumpfile("dump.vcd");
   $dumpvars;

    for (int i = 0; i < 7000; i++)
     @intf.cb;

    $fatal (1,"Global timeout");
  end
 
endmodule

`endif




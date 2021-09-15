`ifndef AXI_INTERFACE
`define AXI_INTERFACE
`include "axi_defines.svh"

interface AXI(input logic axi_aclk);
logic s00_axi_aresetn;  
logic [31 : 0] s00_axi_awaddr;
logic  s00_axi_awvalid;
logic  s00_axi_awready;
logic [31 : 0] s00_axi_wdata;
logic  s00_axi_wvalid;
logic  s00_axi_wready;
logic [1 : 0] s00_axi_bresp;
logic  s00_axi_bvalid;
logic  s00_axi_bready;
logic [31 : 0] s00_axi_araddr;
logic  s00_axi_arvalid;
logic  s00_axi_arready;
logic [31 : 0] s00_axi_rdata;
logic [1 : 0] s00_axi_rresp;
logic  s00_axi_rvalid;
logic  s00_axi_rready;

clocking cb @(posedge axi_aclk);
    default input #1 output #1;
    output s00_axi_awvalid;
    output s00_axi_wvalid;
    output s00_axi_arvalid;
    input  s00_axi_rvalid;
    input  s00_axi_arready; 
    output s00_axi_bready;
    output s00_axi_rready;
    output s00_axi_awaddr;
    output s00_axi_araddr;
    output s00_axi_wdata;
    input  s00_axi_rdata;
    input  s00_axi_bresp;
    input  s00_axi_rresp;
    input  s00_axi_awready; 
    input  s00_axi_wready; 
    input  s00_axi_bvalid; 
  endclocking
  
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_awvalid) & ~intf.s00_axi_rvalid |-> ##[1:4] intf.s00_axi_awready) else $fatal(1,"awready is not set during 4 cycles");
  assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rvalid) |-> ##[0:4] intf.s00_axi_rready) else $fatal(1,"rready is not set during 4 cycles");  
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_wvalid) |->  ##[1:4]intf.s00_axi_wready)  else $fatal(1,"wready is not set during 4 cycles");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_wvalid) |->  ##[1:4]intf.s00_axi_bvalid)  else $fatal(1,"bvalid is not set during 4 cycles");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_arvalid) & ~intf.s00_axi_rvalid |-> ##[1:4]intf.s00_axi_arready) else $fatal(1,"arready is not set during 4 cycles");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_arvalid) & intf.s00_axi_arready |->  ##[1:4]intf.s00_axi_rvalid)  else $fatal(1,"rvalid is not set during 4 cycles");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_bvalid) |->  (intf.s00_axi_bresp == 2'b00)||(intf.s00_axi_bresp == 2'b10)) else $fatal(1,"BRESP is not correct"); 
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rvalid) |->  (intf.s00_axi_rresp == 2'b00)||(intf.s00_axi_rresp == 2'b10)) else $fatal(1,"RRESP is not correct");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rvalid) |->  $past(intf.s00_axi_arvalid,1)) else $fatal(1,"rvalid is set without request");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid & ~intf.s00_axi_rready) |-> ##1(intf.s00_axi_rvalid )) else $fatal (1,"rvalid is removed before getting rready");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_awaddr )) |-> (intf.s00_axi_awvalid )) else $fatal (1,"awaddr is unstable during awvalid = 0");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_arvalid & ~intf.s00_axi_arready & ~intf.s00_axi_rvalid) |-> ##1(intf.s00_axi_arvalid )) else $fatal (1,"arvalid is removed before getting arready");
assert property ( @(posedge axi_aclk) (intf.s00_axi_wvalid & ~intf.s00_axi_wready) |-> ##1(intf.s00_axi_wvalid )) else $fatal (1,"wvalid is removed before getting wready");
assert property ( @(posedge axi_aclk) (intf.s00_axi_awvalid & ~intf.s00_axi_awready) |-> ##1(intf.s00_axi_awvalid )) else $fatal (1,"awvalid is removed before getting awready");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid & ~intf.s00_axi_rready) |-> ##1 $stable(intf.s00_axi_rdata )) else $fatal (1,"rdata is unstable during rvalid = 1 and rready = 0");
assert property ( @(posedge axi_aclk) ((intf.s00_axi_wvalid & intf.s00_axi_wready) && intf.s00_axi_awaddr == `C_S00_BASEADDR) |-> ##1($past(intf.s00_axi_wdata) == AXILITE_V.AXILITE_S00_inst.slv_reg0)) else $fatal (1,"Addend_0 error");
assert property ( @(posedge axi_aclk) ((intf.s00_axi_wvalid & intf.s00_axi_wready) && intf.s00_axi_awaddr == (`C_S00_BASEADDR + 4)) |-> ##1($past(intf.s00_axi_wdata) == AXILITE_V.AXILITE_S00_inst.slv_reg1)) else $fatal (1,"Addend_1 error");
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid && (intf.s00_axi_araddr == (`C_S00_BASEADDR + 8)) && intf.s00_axi_rready) |-> ##1(intf.s00_axi_rdata == $past(AXILITE_V.AXILITE_S00_inst.slv_reg2))) else $fatal (1,"Sum reading error");
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid && (intf.s00_axi_araddr == (`C_S00_BASEADDR + 12)) && intf.s00_axi_rready) |-> ##1(intf.s00_axi_rdata == $past(AXILITE_V.AXILITE_S00_inst.slv_reg3))) else $fatal (1,"Extension reading error");
assert property ( @(posedge axi_aclk) ($root.axi_tb_top.Write_address_ready) |-> ##1(AXILITE_V.AXILITE_S00_inst.slv_reg2 == 
                                                                   (AXILITE_V.AXILITE_S00_inst.slv_reg0 +
                                                                    AXILITE_V.AXILITE_S00_inst.slv_reg1))) else $fatal (1,"Sum calculation error");
assert property ( @(posedge axi_aclk) ($root.axi_tb_top.Write_address_ready) |-> ##1(AXILITE_V.AXILITE_S00_inst.slv_reg3[31]==
                                                                    (AXILITE_V.AXILITE_S00_inst.slv_reg0[31] & 
                                                                    AXILITE_V.AXILITE_S00_inst.slv_reg1[31] & 
                                                                    ~AXILITE_V.AXILITE_S00_inst.slv_reg2[31] | 
                                                                    (~AXILITE_V.AXILITE_S00_inst.slv_reg0[31] & 
                                                                    ~AXILITE_V.AXILITE_S00_inst.slv_reg1[31] & 
                                                                    AXILITE_V.AXILITE_S00_inst.slv_reg2[31])))) else $fatal (1,"Extension calculation error"); 	  
  
  
  
endinterface



`endif

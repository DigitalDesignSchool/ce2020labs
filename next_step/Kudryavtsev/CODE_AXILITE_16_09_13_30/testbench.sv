`timescale 1ns/10ps
// function from the book of Spears
`define SV_RAND_CHECK(r)\
do begin\
if(!r) begin\
$display("%s:%0d Randomization error \"%s\"",\
`__FILE__, `__LINE__, `"r`");\
$finish; \
end\
end while (0)

typedef enum {WRITE = 1, READ = 0} write_read_e;
parameter bit[31:0] C_S00_BASEADDR = 17;
const int NUM_EXP = 10000;

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
    //default input #1 output #1;
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
endinterface

module AXI_TB;

localparam C_S00_AXI_DATA_WIDTH	 = 32;
localparam C_S00_AXI_ADDR_WIDTH	 = 32;
		
bit axi_aclk;	

AXILITE_V_v1_0  # (
		.C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S00_BASEADDR(C_S00_BASEADDR),
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


AXI intf(axi_aclk);

always #5 axi_aclk = ~axi_aclk;

initial begin
intf.s00_axi_awaddr <= 'X;
intf.s00_axi_aresetn <= 1'b0;
intf.s00_axi_awvalid <= 1'b0;
intf.s00_axi_arvalid <= 1'b0;
intf.s00_axi_wvalid <= 1'b0;
intf.s00_axi_rready <= 1'b0;
intf.s00_axi_bready <= 1'b1;
#23 intf.s00_axi_aresetn <= 1'b1;
end
test t0(intf,axi_aclk);
endmodule

program automatic test(AXI intf,input logic axi_aclk);
class automatic TRANSACTION;
bit Check;
bit Immediate_Read;
rand write_read_e Op;
rand bit [31:0] Address;  
rand bit [31:0] Data;         
rand int Add_Delay;             //Delay between address and data transfers
rand int Data_Delay;            //delay after data transmissions
constraint AD_c { Add_Delay  dist { 0:/30, [1 : 5]:/70 }; }
constraint DD_c { Data_Delay dist { 0:/30, [1 : 5]:/70 }; }
constraint DATA     { Data dist     {[32'h00000000 : 32'h00000080]:/400, 
                                     [32'h70000000 : 32'h7FFFFFFF]:/200, 
                                     [32'h80000000 : 32'h8FFFFFFF]:/400,
                                     [32'hFFFFFF80 : 32'hFFFFFFFF]:/200 }; }
constraint ADDRESSR { Address dist  {[C_S00_BASEADDR : C_S00_BASEADDR + 13]:/100, 
                                     [C_S00_BASEADDR + 14 : 32'h7FFFFFFF]:/1,
                                     [32'h80000000 : 32'hFFFFFFFF]:/1 }; }
endclass
TRANSACTION Tr;
TRANSACTION Send[$];
TRANSACTION Result[$];
TRANSACTION Current;
int Error_Counter = 0;
bit [31:0] Address_to_check = 0, Sum = 0, Extension = 0;
bit [31:0] Addend_0 = 0, Addend_1 = 0;
bit [1:0] BRESP, RRESP;
bit Write_address_ready = 0, Read_address_ready = 0;
`include "binding_coverage.sv"
task automatic ScoreBoard_Task();

wait(intf.s00_axi_aresetn==1'b1);
forever begin
    wait(Result.size()>0);
    Current = Result.pop_front();
    begin
        BRESP = intf.s00_axi_bresp;
        RRESP = intf.s00_axi_rresp;
        RGCov.sample();
        ACov.sample();
        case(Current.Address)
          C_S00_BASEADDR : begin Addend_0 = Current.Data; Sum = Addend_1 + Current.Data; DCov.sample(); DLCov.sample(); end
          C_S00_BASEADDR + 4 : begin Addend_1 = Current.Data; Sum = Addend_0 + Current.Data; DCov.sample(); DLCov.sample(); end
          C_S00_BASEADDR + 8 : if(Current.Check == 0) 
            begin 
            assert (Sum == Current.Data) else begin $display("Sum %X != Current.Data %X",Sum,Current.Data); Error_Counter++; end
            RCov.sample();
            end
          C_S00_BASEADDR + 12 : if(Current.Check == 0) 
            begin
            assert(Current.Data == {32{(~Addend_0[31] & ~Addend_1[31] & Sum[31]) | (Addend_0[31] & Addend_1[31] & ~Sum[31])}}) else Error_Counter++;
            Extension = Current.Data;
            RCov.sample();
          	end
        endcase
        if(Current.Op == WRITE) begin
            if(Current.Check)
                if ((Current.Address == C_S00_BASEADDR)||(Current.Address == C_S00_BASEADDR + 4)) assert (intf.s00_axi_bresp == 2'b00) else begin if(intf.s00_axi_bresp == 2'b10) $fatal(1,"Correct write address %d is not accepted",Current.Address); end 
                else assert (intf.s00_axi_bresp == 2'b10) else begin if(intf.s00_axi_bresp == 2'b00) $fatal(1,"Incorrect write address %d is erroneously accepted",Current.Address); end
            else assert (intf.s00_axi_bresp == 2'b00) else if(intf.s00_axi_bresp == 2'b10) $fatal(1,"Data is not accepted");
        end
        else begin
            if(Current.Check) 
                if((Current.Address == C_S00_BASEADDR + 8)||(Current.Address == C_S00_BASEADDR + 12))  
                assert(intf.s00_axi_rresp == 2'b00) else begin if(intf.s00_axi_rresp == 2'b10) $fatal(1,"Correct read address %d is not accepted",Current.Address); end
                else 
                assert (intf.s00_axi_rresp == 2'b10) else begin if(intf.s00_axi_rresp == 2'b00) $fatal(1,"Incorrect read address %d is erroneously accepted",Current.Address); end
            else assert (intf.s00_axi_rresp == 2'b00) else if(intf.s00_axi_rresp == 2'b10) $fatal(1,"Data is not read"); 
	    end 
    end
 end     
endtask

task automatic Driver_Task();
TRANSACTION CurrentW, CurrentR;
bit [1:0] Operation;
wait(intf.s00_axi_aresetn==1'b1);
forever begin
wait(Send.size()!=0);
begin
Operation = 2'b00;
if (Send[0].Op == WRITE) begin
                              CurrentW = Send.pop_front();
                              Operation[1]=1'b1; 
                              if(CurrentW.Immediate_Read == 1) begin
                                                               CurrentR = Send.pop_front();
                                                               Operation[0]=1'b1;
                                                               end
                         end
else begin
          CurrentR = Send.pop_front();
          Operation[0]=1'b1;
     end
fork
    if (Operation[1]==1'b1) begin                     //write operation
    fork 
        begin
        intf.cb.s00_axi_awaddr <= CurrentW.Address; intf.cb.s00_axi_awvalid <= 1'b1; 
        Write_address_ready <= 1'b0;
        @intf.cb;
        wait(intf.cb.s00_axi_awready);
        if(~CurrentW.Immediate_Read) intf.cb.s00_axi_awvalid <= 1'b0;   
        Write_address_ready <= 1'b1;
        end
        
        begin
        repeat(CurrentW.Add_Delay) @intf.cb;
        wait(Write_address_ready | intf.s00_axi_awvalid); 
        intf.cb.s00_axi_wdata <= CurrentW.Data; intf.cb.s00_axi_wvalid <= 1'b1;
        @intf.cb;
        wait(intf.cb.s00_axi_wready);
        if(~CurrentW.Immediate_Read) intf.cb.s00_axi_wvalid <= 1'b0;
        Result.push_back(CurrentW);
        end 
    join
    repeat(CurrentW.Data_Delay) @intf.cb;
    end 

    if (Operation[0]==1'b1) begin                 // read operation
    fork 
        begin
        intf.cb.s00_axi_araddr <= CurrentR.Address; intf.cb.s00_axi_arvalid <= 1'b1;
        Read_address_ready = 1'b0;
        @intf.cb;
        wait(intf.cb.s00_axi_arready);
        if(~CurrentR.Immediate_Read) intf.cb.s00_axi_arvalid <= 1'b0;
        Read_address_ready = 1'b1;
        end
        
        begin
        repeat(CurrentR.Add_Delay) @intf.cb; 
        wait(Read_address_ready | intf.s00_axi_arvalid); 
        intf.cb.s00_axi_rready <= 1'b1;
        @intf.cb;
        wait(intf.cb.s00_axi_rvalid); 
        if(~CurrentR.Immediate_Read) intf.cb.s00_axi_rready <= 1'b0;
        CurrentR.Data = intf.cb.s00_axi_rdata;
        Result.push_back(CurrentR);
        end
    join
    repeat(CurrentR.Data_Delay) @intf.cb;
    end  
join 
end
end
endtask

task automatic ARESETN_CHECK();
wait(intf.s00_axi_aresetn==1'b1);
@intf.cb;
assert(intf.cb.s00_axi_rvalid==1'b0) else $fatal(1,"rvalid is not cleared");
assert(intf.cb.s00_axi_bvalid==1'b0) else $fatal(1,"bvalid is not cleared");
assert (0 == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg0) else $fatal(1,"1st addend register is not cleared");  
assert (0 == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg1) else $fatal(1,"2nd addend register is not cleared"); 
assert (0 == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg2) else $fatal(1,"Sum register is not cleared");
assert (0 == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg3) else $fatal(1,"Extension register is not cleared");     
assert(intf.cb.s00_axi_awready==1'b0) else $display("awready is not cleared"); 
assert(intf.cb.s00_axi_wready==1'b0)  else $display("wready is not cleared"); 
assert(intf.cb.s00_axi_arready==1'b0) else $display("arready is not cleared"); 
endtask 
task TimeOut_Task();
  repeat(3115 + NUM_EXP*3300) @(intf.cb);
$fatal("Testing is in process for too long, possible deadlock");
endtask
  assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_awvalid) & ~intf.s00_axi_rvalid |-> ##[0:4]intf.s00_axi_awready) else $fatal(1,"awready is not set during 4 cycles");
    assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_wvalid) |->  ##[0:4]intf.s00_axi_wready)  else $fatal(1,"wready is not set during 4 cycles");
      assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_wvalid) |->  ##[0:4]intf.s00_axi_bvalid)  else $fatal(1,"bvalid is not set during 4 cycles");
        assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_arvalid) & ~intf.s00_axi_rvalid |-> ##[0:4]intf.s00_axi_arready) else $fatal(1,"arready is not set during 4 cycles");
          assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rready) |->  ##[0:4]intf.s00_axi_rvalid)  else $fatal(1,"rvalid is not set during 4 cycles");
            assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_bvalid) |->  ((intf.s00_axi_bresp == 2'b00)||(intf.s00_axi_bresp == 2'b10))) else $fatal(1,"BRESP is not OKAY"); 
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rvalid) |->  ((intf.s00_axi_rresp == 2'b00)||(intf.s00_axi_rresp == 2'b10))) else $fatal(1,"RRESP is not OKAY");
assert property ( @(posedge axi_aclk) $rose(intf.s00_axi_rvalid) |->  $past(intf.s00_axi_arvalid,1)) else $fatal(1,"rvalid is set without request");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid & ~intf.s00_axi_rready) |-> ##1(intf.s00_axi_rvalid )) else $fatal (1,"rvalid is removed before getting rready");
assert property ( @(posedge axi_aclk) (intf.s00_axi_arvalid & ~intf.s00_axi_arready & ~intf.s00_axi_rvalid) |-> ##1(intf.s00_axi_arvalid )) else $fatal (1,"arvalid is removed before getting arready");
assert property ( @(posedge axi_aclk) (intf.s00_axi_wvalid & ~intf.s00_axi_wready) |-> ##1(intf.s00_axi_wvalid )) else $fatal (1,"wvalid is removed before getting wready");
assert property ( @(posedge axi_aclk) (intf.s00_axi_awvalid & ~intf.s00_axi_awready) |-> ##1(intf.s00_axi_awvalid )) else $fatal (1,"awvalid is removed before getting awready");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid & ~intf.s00_axi_rready) |-> ##1 $stable(intf.s00_axi_rdata )) else $fatal (1,"rdata is unstable during rvalid = 1 and rready = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_awaddr )) |-> (intf.s00_axi_awvalid )) else $fatal (1,"awaddr is unstable during awvalid = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_wdata )) |-> (intf.s00_axi_wvalid )) else $fatal (1,"wdata is unstable during wvalid = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_rdata ) && (intf.s00_axi_aresetn==1'b1)) |-> (intf.s00_axi_rvalid )) else $fatal (1,"rdata is unstable during rvalid = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_araddr )&& (intf.s00_axi_aresetn==1'b1)) |-> (intf.s00_axi_arvalid )) else $fatal (1,"araddr is unstable during arvalid = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_bresp ) && (intf.s00_axi_aresetn==1'b1)) |-> (intf.s00_axi_bvalid )) else $fatal (1,"bresp is unstable during bvalid = 0");
assert property ( @(posedge axi_aclk) (~$stable(intf.s00_axi_rresp) && (intf.s00_axi_aresetn==1'b1)) |-> (intf.s00_axi_rvalid )) else $fatal (1,"rresp is unstable during rvalid = 0");  
assert property ( @(posedge axi_aclk) (intf.s00_axi_wvalid && intf.s00_axi_awaddr == C_S00_BASEADDR) |-> ##1($past(intf.s00_axi_wdata) == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg0)) else $fatal (1,"Addend_0 error");
assert property ( @(posedge axi_aclk) (intf.s00_axi_wvalid && intf.s00_axi_awaddr == (C_S00_BASEADDR + 4)) |-> ##1($past(intf.s00_axi_wdata) == AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg1)) else $fatal (1,"Addend_1 error");
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid && (intf.s00_axi_araddr == (C_S00_BASEADDR + 8)) && intf.s00_axi_rready) |-> ##1(intf.s00_axi_rdata == $past(AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg2))) else $fatal (1,"Sum reading error");
assert property ( @(posedge axi_aclk) (intf.s00_axi_rvalid && (intf.s00_axi_araddr == (C_S00_BASEADDR + 12)) && intf.s00_axi_rready) |-> ##1(intf.s00_axi_rdata == $past(AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg3))) else $fatal (1,"Extension reading error");
assert property ( @(posedge axi_aclk) (Write_address_ready) |-> ##1(AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg2 == 
                                                                   (AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg0 +
                                                                    AXI_TB.AXILITE_V.AXILITE_V_v1_0_S00_AXI_inst.slv_reg1))) else $fatal (1,"Internal calculation error");

initial begin
$dumpfile ("dump.vcd");
$dumpvars;
ARESETN_CHECK();
$display("The reset test is passed successfully");

fork 
Driver_Task();
ScoreBoard_Task();
TimeOut_Task();
join_none
  
DCov = new();
ACov = new();
DLCov = new();
RCov = new();
RGCov = new();
 
for(int i=0; i<NUM_EXP; i++) begin
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Op == WRITE; }); Tr.Check = 1'b1; Send.push_back(Tr); 
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Op == READ; });  Tr.Check = 1'b1; Send.push_back(Tr);  
     end
wait(Send.size()==0); 
repeat(10) @(intf.cb);    
wait(Result.size()==0);     
$display("The address test is completed");
$display("Total address coverage - %3f%%",ACov.get_coverage()); 

for(int i=0; i<NUM_EXP; i++) begin
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Address == C_S00_BASEADDR; Op == WRITE; }); Send.push_back(Tr);  
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Address == C_S00_BASEADDR + 4; Op == WRITE; }); Send.push_back(Tr);  
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Address == C_S00_BASEADDR + 8; Op == READ;  }); Send.push_back(Tr);  
     Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Address == C_S00_BASEADDR + 12; Op == READ; }); Send.push_back(Tr);
     end
wait(Send.size()==0);  
repeat(10) @intf.cb;     
wait(Result.size()==0);     
$display("The random write/read test is completed");
$display("Data coverage in random test - %3f%%",DCov.get_coverage()); 
$display("Result coverage in random test - %3f%%",RCov.get_coverage()); 
$display("Delay coverage in random test - %3f%%",DLCov.get_coverage()); 
$display("Register coverage in random test - %3f%%",RGCov.get_coverage());  

DCov = new();
DLCov = new();
RCov = new(); 
RGCov = new(); 
for(int i=0; i<NUM_EXP; i++) begin
Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { (Op == READ) -> ((Address==(C_S00_BASEADDR + 8)) || (Address==(C_S00_BASEADDR + 12))); 
                                                 (Op == WRITE) -> ((Address==C_S00_BASEADDR) || (Address==(C_S00_BASEADDR + 4))); });  Send.push_back(Tr); 
end 
wait(Send.size()==0); 
repeat(10) @intf.cb;  
wait(Result.size()==0);        
$display("The chaotic test is completed"); 
$display("Data coverage in chaotic test - %3f%%",DCov.get_coverage()); 
$display("Result coverage in chaotic test - %3f%%",RCov.get_coverage()); 
$display("Delay coverage in chaotic test - %3f%%",DLCov.get_coverage());
$display("Register coverage in chaotic test - %3f%%",RGCov.get_coverage());  

DCov = new();

for(int i=0; i<NUM_EXP; i++) 
  begin
  Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Add_Delay == 0; Data_Delay == 0; Address == C_S00_BASEADDR || Address == (C_S00_BASEADDR + 4); Op == WRITE; }); Tr.Check = 1'b1; Tr.Immediate_Read = 1; Send.push_back(Tr); 
  Tr = new(); `SV_RAND_CHECK(Tr.randomize() with { Add_Delay == 0; Data_Delay == 0; Address == (C_S00_BASEADDR + 8) || Address == (C_S00_BASEADDR + 12); Op == READ;  }); Tr.Check = 1'b1; Tr.Immediate_Read = 1; Send.push_back(Tr);
  end 
wait(Send.size()==0); 
repeat(10) @intf.cb;
wait(Result.size()==0);        
$display("The continuous test is completed"); 
$display("Data coverage in continuous test - %3f%%",DCov.get_coverage()); 

end 

final begin
assert(Error_Counter == 0) $display("The whole test is successfully passed"); else $fatal(1,"The test is failed. Number of errors is %d",Error_Counter);
end
endprogram




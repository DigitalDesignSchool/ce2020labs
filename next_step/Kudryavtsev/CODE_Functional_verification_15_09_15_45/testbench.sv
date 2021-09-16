`timescale 1ns / 1ps
// function from the book of Spear
`define SV_RAND_CHECK(r)\
do begin\
if(!r) begin\
$display("%s:%0d Randomization error \"%s\"",\
`__FILE__, `__LINE__, `"r`");\
$finish; \
end\
end while (0)

module Main_TB();
bit Clk = 0;
always #2.5 Clk = ~Clk;
DFFI intf(Clk);
Main Main_inst(intf);
test T0(intf,Clk);
endmodule

program automatic test(DFFI intf, input logic Clk);
class Transaction;
rand bit[31:0] D0;
rand bit[31:0] D1;
rand bit[1:0] Command;
constraint comm { Command dist {[0:3]}; }
endclass
Transaction Tr;
logic [31:0] Sum;

covergroup Data_Coverage;
dd0: coverpoint Tr.D0 { option.auto_bin_max = 16; }  
dd1: coverpoint Tr.D1 { option.auto_bin_max = 16; } 
ddC: coverpoint Tr.Command
 {
 bins PLUS  = {0};
 bins MINUS = {1};
 bins ANDB  = {2};
 bins ORB   = {3};
 }  
coverpoint Sum { option.auto_bin_max = 16; } 
cross dd0, dd1;
  coverpoint (int'(intf.Low) + int'(intf.Media) + int'(intf.High))
{
bins Zero = {0};
bins One = {1};
illegal_bins Illegal = {2,3};
bins m = default;  
} 
coverpoint intf.Low { bins Up = (0 => 1); bins Down = (1 => 0); } 
coverpoint intf.Media { bins Up = (0 => 1); bins Down = (1 => 0); } 
coverpoint intf.High { bins Up = (0 => 1); bins Down = (1 => 0); } 
endgroup
Data_Coverage DCov;

task automatic Reset_task();
$display("Start test");
intf.Reset <= 1'b1; 
intf.D0 <= 32'h0;
intf.D1 <= 32'h0;
intf.Command <= 2'h0;
#2 intf.Reset <= 1'b0;
endtask

function Monitor(input logic [31:0] X,Y,R, input logic [1:0] Operation);
case (Operation)   
    0: Sum = X + Y;
    1: Sum = X - Y;
    2: Sum = X & Y;
    default:  Sum = X | Y;
    endcase
if(R == Sum)  $display("Correct result: 0x%X",Sum);
else 
    case (Operation)   
    0: $display("Incorrect result: 0x%X != 0x%X + 0x%X ",R,X,Y);
    1: $display("Incorrect result: 0x%X != 0x%X - 0x%X ",R,X,Y);
    2: $display("Incorrect result: 0x%X != 0x%X & 0x%X ",R,X,Y);
    default:  $display("Incorrect result: 0x%X != 0x%X | 0x%X ",R,X,Y);
    endcase
endfunction

initial begin
$dumpfile("dump.vcd"); 
$dumpvars;    
DCov = new();
Reset_task();
@intf.cb;
  for(int i=0; i<2000; i++) begin
                         Tr = new(); `SV_RAND_CHECK(Tr.randomize());
                         intf.cb.D0 <= Tr.D0;
                         intf.cb.D1 <= Tr.D1;
                         intf.cb.Command <= Tr.Command;
                         @intf.cb;
                         if(~intf.Reset) Monitor(Tr.D0,Tr.D1,intf.Q,Tr.Command);
                         DCov.sample();
                         end
$display("Data coverage - %3f%%",DCov.get_coverage());                          
end

assert property ( @(posedge intf.Clk) ~intf.Reset |->  ##1 Main_inst.DI0 == $past(intf.D0)) else $display("D0 error");
assert property ( @(posedge intf.Clk) ~intf.Reset |->  ##1 Main_inst.DI1 == $past(intf.D1)) else $display("D1 error");
assert property ( @(posedge intf.Clk) ~intf.Reset |->  ##1 Main_inst.Instruction == $past(intf.Command)) else $display("COmmand error");
assert property ( @(posedge intf.Clk) disable iff (intf.Reset)  intf.Command == 0 |->  ##1 intf.Q == (Main_inst.DI0 + Main_inst.DI1)) else $display("ADD operation error %X + %X != %X",Main_inst.DI0,Main_inst.DI1,intf.Q);
assert property ( @(posedge intf.Clk) disable iff (intf.Reset)  intf.Command == 1 |->  ##1 intf.Q == (Main_inst.DI0 - Main_inst.DI1)) else $display("SUB operation error %X - %X != %X",Main_inst.DI0,Main_inst.DI1,intf.Q);
assert property ( @(posedge intf.Clk) disable iff (intf.Reset)  intf.Command == 2 |->  ##1 intf.Q == (Main_inst.DI0 & Main_inst.DI1)) else $display("AND operation error %X & %X != %X",Main_inst.DI0,Main_inst.DI1,intf.Q);
assert property ( @(posedge intf.Clk) disable iff (intf.Reset)  intf.Command == 3 |->  ##1 intf.Q == (Main_inst.DI0 | Main_inst.DI1)) else $display("OR error %X | %X != %X",Main_inst.DI0,Main_inst.DI1,intf.Q);
assert property ( @(posedge intf.Clk) intf.Reset |-> (Main_inst.DI0==32'h0) && (Main_inst.DI1==32'h0) && (Main_inst.Instruction==2'h0)) else $display("No reset");

final begin
$display("game over");
end

endprogram



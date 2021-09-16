`timescale 1ns / 1ps

interface DFFI(input logic Clk);
    logic [31:0] D0,D1,Q;
    logic [1:0] Command;
    logic Low,Media,High;
    logic Reset;
clocking cb @(posedge Clk);
    //default input #1 output #1;
    input Q;
    output D0;
    output D1;
    output Command;
endclocking     
endinterface   

module Main(DFFI intf);
logic [31:0] DI0,DI1;
logic [1:0] Instruction;
always_ff @(posedge intf.Clk or posedge intf.Reset)
  begin
    if (intf.Reset) begin
                    DI0 <= 32'h0;
                    DI1 <= 32'h0;
                    Instruction <= 2'h0;
                    end
    else begin
         DI0 <= intf.D0;
         DI1 <= intf.D1;
         Instruction <= intf.Command;
         end
  end
always_comb
    case (Instruction)   
    0: intf.Q <= DI0 + DI1;
    1: intf.Q <= DI0 - DI1;
    2: intf.Q <= DI0 & DI1;
    default: intf.Q <= DI0 | DI1;
    endcase
    
always_comb
    begin
     if(int'(intf.Q) < -1000000000) intf.Low <= 1'b1; else intf.Low <= 1'b0;
    if((int'(intf.Q) > -10000000)&&(int'(intf.Q) < 10000000)) intf.Media <= 1'b1;
     else intf.Media <= 1'b0;
    if(int'(intf.Q) > 1000000000) intf.High <= 1'b1; else intf.High <= 1'b0;           
    end 
endmodule

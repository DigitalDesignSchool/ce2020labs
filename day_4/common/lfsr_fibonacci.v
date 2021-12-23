`timescale 1ns / 1ps

module lfsr_fibonacci #(
    parameter WIDTH  = 16,
              TAPS   = 16'b1000000001011,
              INVERT = 0
             )
(
    input                    clk,
    input                    reset,
    input                    enable,
    output reg [WIDTH - 1:0] out
);
    wire feedback = (^(out & TAPS)) ^ INVERT;
    
    always @(posedge clk or posedge reset)
        if (reset) 
            out <= { { WIDTH - 1 { 1'b0 } }, 1'b1 };
        else if (enable) 
            out <= { feedback, out [WIDTH - 1:1] };
            
endmodule

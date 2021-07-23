`include "config.vh"

module top
(
    input         clk,
    input  [ 3:0] key,
    input  [ 3:0] sw,
    output [ 7:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb,

    output        buzzer,
    inout  [15:0] gpio
);

    assign abcdefgh  = 8'hff;
    assign digit     = 4'hf;
    assign buzzer    = 1'b1;
    assign hsync     = 1'b1;
    assign vsync     = 1'b1;
    assign rgb       = 3'b0;
	assign led       = 8'hff;
	
    wire a = ~ sw [0];
    wire b = ~ sw [1];
    
    wire result = a ^ b;

    assign led [0] = ~ result;
    
    assign led [1] = ~ (~ sw [0] ^ ~ sw [1]);

    // Exercise 1: Change the code below.
    // Assign to led [2] the result of AND operation
    
    assign led [2] = 1'b0;

    // Exercise 2: Change the code below.
    // Assign to led [3] the result of XOR operation
    // without using "^" operation.
    // Use only operations "&", "|", "~" and parenthesis, "(" and ")".

    assign led [3] = 1'b0;

endmodule

	
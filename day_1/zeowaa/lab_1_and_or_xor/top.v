`include "config.vh"

module top
(
    input        clk,
    input        reset_n,
    
    input  [3:0] key_sw,
    output [3:0] led,

    output [7:0] abcdefgh,
    output [3:0] digit,

    output       buzzer,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    assign hsync     = 1'b1;
    assign vsync     = 1'b1;
    assign rgb       = 3'b0;

    wire a = ~ key_sw [0];
    wire b = ~ key_sw [1];
    
    wire result = a ^ b;

    assign led [0] = ~ result;
    
    assign led [1] = ~ (~ key_sw [0] ^ ~ key_sw [0]);

    // Exercise 1: Change the code below.
    // Write the same for AND and OR operations
    
    assign led [2] = 1'b0;
    assign led [3] = 1'b0;

    // Exercise 2: Change the code below.
    // Turn on and off buzzer on the board using key.
    // Listen to the click sound.

    assign buzzer = 1'b0
    
    // Exercise 3: Change the code below.
    // Turn on and off segments on 7-segment indicator

    assign abcdefgh  = 8'hff;
    assign digit     = 4'b0;

endmodule

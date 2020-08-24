`include "config.vh"

module top
(
    input         clk,
    input  [ 3:0] key,
    input  [ 7:0] sw,
    output [11:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        buzzer,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb,

    inout  [18:0] gpio
);

    assign hsync = 1'b1;
    assign vsync = 1'b1;
    assign rgb   = 3'b0;

    wire a = ~ key [0];
    wire b = ~ key [1];
    
    wire result = a ^ b;

    assign led [0] = ~ result;
    
    assign led [1] = ~ (~ key [0] ^ ~ key [0]);

    // Exercise 1: Change the code below.
    // Write the same for AND and OR operations
    
    assign led [11:2] = 10'b0;

    // Exercise 2: Change the code below.
    // Turn on and off buzzer on the board using key.
    // Listen to the click sound.

    assign buzzer = 1'b1;
    
    // Exercise 3: Change the code below.
    // Turn on and off segments on 7-segment indicator

    assign abcdefgh  = 8'hff;
    assign digit     = 8'b0;

endmodule

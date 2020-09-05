`include "config.vh"

module top
(
    input           clk,

    input   [ 1:0]  key,
    input   [ 9:0]  sw,
    output  [ 9:0]  led,

    output  [ 7:0]  hex0,
    output  [ 7:0]  hex1,
    output  [ 7:0]  hex2,
    output  [ 7:0]  hex3,
    output  [ 7:0]  hex4,
    output  [ 7:0]  hex5,

    output          vga_hs,
    output          vga_vs,
    output  [ 3:0]  vga_r,
    output  [ 3:0]  vga_g,
    output  [ 3:0]  vga_b,

    inout   [35:0]  gpio
);

    assign led  = 10'b0;

    wire reset = sw [9];

    //------------------------------------------------------------------------

    reg [31:0] cnt;
    
    always @ (posedge clk or posedge reset)
      if (reset)
        cnt <= 32'b0;
      else
        cnt <= cnt + 32'b1;
        
    wire enable = (cnt [22:0] == 23'b0);

    //------------------------------------------------------------------------

    reg [7:0] shift_reg;
    
    always @ (posedge clk or posedge reset)
      if (reset)
        shift_reg <= 8'b0000_0001;
      else if (enable)
        shift_reg <= { shift_reg [0], shift_reg [7:1] };

    //------------------------------------------------------------------------

    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--  h
    //
    //  0 means light

    parameter [7:0] C = 8'b01100011,
                    E = 8'b01100001,
                    h = 8'b11010001,
                    I = 8'b11110011,
                    O = 8'b00000011,
                    P = 8'b00110001,
                    X = 8'b10010001;

    reg [7:0] letter;
    
    always @*
      case (shift_reg)
      8'b1000_0000: letter = C;
      8'b0100_0000: letter = h;
      8'b0010_0000: letter = I;
      8'b0001_0000: letter = P;

      8'b0000_1000: letter = E;
      8'b0000_0100: letter = X;
      8'b0000_0010: letter = P;
      8'b0000_0001: letter = O;
      default:      letter = E;
      endcase

    assign abcdefgh = letter;
    assign digit    = ~ shift_reg;

    // Exercise 1: Increase the frequency of enable signal
    // to the level your eyes see the letters as a solid word
    // without any blinking. What is the threshold of such frequency?

    // Exercise 2: Put your name or another word to the display.

    // Exercise 3: Comment out the "default" clause from the "case" statement
    // in the "always" block,and re-synthesize the example.
    // Are you getting any warnings or errors? Try to explain why.

endmodule

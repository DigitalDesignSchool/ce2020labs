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

    assign abcdefgh  = 8'hff;
    assign digit     = 4'hf;
    assign buzzer    = 1'b0;
    assign hsync     = 1'b1;
    assign vsync     = 1'b1;
    assign rgb       = 3'b0;
    
    //------------------------------------------------------------------------

    reg [31:0] cnt;
    
    always @ (posedge clk or negedge reset_n)
      if (~ reset_n)
        cnt <= 32'b0;
      else
        cnt <= cnt + 32'b1;
        
    wire enable = (cnt [22:0] == 25'b0);

    //------------------------------------------------------------------------

    wire button_on = ~ key_sw [0];

    reg [3:0] shift_reg;
    
    always @ (posedge clk or negedge reset_n)
      if (~ reset_n)
        shift_reg <= 4'b0;
      else if (enable)
        shift_reg <= { shift_reg [2:0], button_on };

    assign led = ~ shift_reg;

    // Exercise 1: Make the light move not from the left to the right,
    // but from the right to the left.

    // Exercise 2: Make the light moving in a loop.
    // Use another key to reset the moving lights back to no lights.

    // Exercise 3: Display the state of the shift register
    // on a seven-segment display, moving the light in a circle.

endmodule

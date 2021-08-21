`include "config.vh"

module lut
(
    input      [31:0] x,
    output reg [31:0] y
);

always @ (*)
    case (x)
`include "lut.vh"
    default: y = 32'b0;
    endcase

endmodule

module i2s
# (
    parameter N
)
(
    input       clk,    // CLK - 50 MHz
    input       reset,
    input [3:0] rshift, // Adjustable attenuation
    output      mclk,   // MCLK - 12.5 MHz
    output      bclk,   // BCLK - 3.125 MHz serial clock - for a 48 KHz Sample Rate
    output      lrclk,  // LRCLK - 32-bit L, 32-bit R
    output      sdata
);

    reg  [31:0] clk_div;
    reg  [31:0] shift;
    reg  [31:0] cnt;
    wire [31:0] value;

    always @ (posedge clk or posedge reset)
        if (reset)
            clk_div <= 0;
        else
            clk_div <= clk_div + 1;

    assign mclk  = clk_div [1];
    assign bclk  = clk_div [3];
    assign lrclk = clk_div [9];

    always @ (posedge clk or posedge reset)
        if (reset)
            cnt <= 0;
        else if (clk_div [9:0] == 10'b11_1111_1111)
            cnt <= (cnt == N - 1) ? 0 : cnt + 1;

    assign sdata = shift [31];

    always @ (posedge clk or posedge reset)
        if (reset)
            shift <= 0;
        else
        begin
            if (clk_div [8:0] == 9'b1_1111_1111)
                shift <= (value >> rshift);
            else if (clk_div [3:0] == 4'b1111)
                shift <= shift << 1;
        end

    lut lut
    (
        .x(cnt),
        .y(value)
    );

endmodule

module top
(
    input             clk,
    input      [ 3:0] key,
    input      [ 3:0] sw,
    output     [ 7:0] led,

    output     [ 7:0] abcdefgh,
    output     [ 7:0] digit,

    output            buzzer,
    inout      [15:0] gpio
);
    wire   reset  = ~ key [3];
    assign buzzer = ~ reset;

    // Turn off lights
    assign abcdefgh = 8'hFF;
    assign led = 8'hFF;

    wire mclk;
    wire bclk;
    wire lrclk;
    wire sdata;

    assign gpio [15:12] = { mclk, bclk, lrclk, sdata };

    i2s
    # (
        .N (48)
    )
    i2s
    (
        .clk(clk),
        .reset(reset),
        .mclk(mclk),
        .bclk(bclk),
        .lrclk(lrclk),
        .sdata(sdata),
        .rshift(sw)
    );

endmodule

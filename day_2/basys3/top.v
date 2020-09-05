module top
(
    input         clk,

    input         btnC,
    input         btnU,
    input         btnL,
    input         btnR,
    input         btnD,

    input  [15:0] sw,

    output [15:0] led,

    output [ 6:0] seg,
    output        dp,
    output [ 3:0] an
);

endmodule

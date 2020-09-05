module top
(
    input         clk100mhz,
    input         cpu_resetn,

    input         btnc,
    input         btnu,
    input         btnl,
    input         btnr,
    input         btnd,

    input  [15:0] sw, 

    output [15:0] led,

    output        led16_b,
    output        led16_g,
    output        led16_r,
    output        led17_b,
    output        led17_g,
    output        led17_r,

    output        ca,
    output        cb,
    output        cc,
    output        cd,
    output        ce,
    output        cf,
    output        cg,
    output        dp,

    output [ 7:0] an,

    inout  [12:1] ja,
    inout  [12:1] jb
);

endmodule

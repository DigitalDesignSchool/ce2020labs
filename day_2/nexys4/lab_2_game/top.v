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

    wire unused = ^ { ja [4:1], ja [10:7], jb [4:1], jb [10:7] };
    reg [31:0] n;
    
    always @ (posedge clk100mhz or negedge cpu_resetn)
        if (! cpu_resetn)
            n <= 32'b0;
        else
            n <= n + 1'b1;
    
    assign led = n [31:16] & sw [15:0];

    assign led16_b = n [31] & btnc;
    assign led16_g = n [30] & btnu;
    assign led16_r = n [29] & btnl;
    assign led17_b = n [28] & btnr;
    assign led17_g = n [27] & btnd;
    assign led17_r = n [26] & btnd;

    assign ca = n [31];
    assign cb = n [30];
    assign cc = n [29];
    assign cd = n [28];
    assign ce = n [27];
    assign cf = n [26];
    assign cg = n [25];
    assign dp = unused;

    assign an = n [31:24];

endmodule

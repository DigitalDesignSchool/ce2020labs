module pow_5_combinational
(
    input  [15:0] n,
    output [15:0] n_pow_5
);

    assign n_pow_5 = n * n * n * n * n;

endmodule

//--------------------------------------------------------------------

module pow_5_sequential
(
    input         clock,
    input         reset_n,
    input         run,
    input  [15:0] n,
    output        ready,
    output [15:0] n_pow_5
);

    reg [4:0] shift;

    always @(posedge clock or negedge reset_n)
        if (! reset_n)
            shift <= 0;
        else if (run)
            shift <= 5'b10000;
        else
            shift <= shift >> 1;

    assign ready = shift [0];

    reg [15:0] r_n, mul;

    always @(posedge clock)
        if (run)
        begin
            r_n <= n;
            mul <= n;
        end
        else
        begin
            mul <= mul * r_n;
        end

    assign n_pow_5 = mul;

endmodule

//--------------------------------------------------------------------

module pow_5_pipelined
(
    input             clock,
    input      [15:0] n,
    output reg [15:0] n_pow_5
);

    reg [15:0] n_1, n_2, n_3;
    reg [15:0] n_pow_2, n_pow_3, n_pow_4;

    always @(posedge clock)
    begin
        n_1 <= n;
        n_2 <= n_1;
        n_3 <= n_2;

        n_pow_2 <= n * n;
        n_pow_3 <= n_pow_2 * n_1;
        n_pow_4 <= n_pow_3 * n_2;
        n_pow_5 <= n_pow_4 * n_3;
    end

endmodule

//--------------------------------------------------------------------

module clock_divider_100_MHz_to_1_49_Hz_and_1_53_KHz
(
    input  clock_100_MHz,
    input  reset_n,
    output clock_1_49_Hz,
    output clock_1_53_KHz
);

    // 100 MHz / 2 ** 26 = 1.49 Hz
    // 100 MHz / 2 ** 16 = 1.53 KHz

    reg [25:0] counter;

    always @ (posedge clock_100_MHz)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_1_49_Hz  = counter [25];
    assign clock_1_53_KHz = counter [15];

endmodule

//--------------------------------------------------------------------

module display
(
    input             clock,
    input             reset_n,
    input      [15:0] number,

    output reg [ 6:0] seven_segments,
    output reg        dot,
    output reg [ 3:0] anodes
);

    function [6:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)
        'h0: bcd_to_seg = 'b1000000;  // a b c d e f g
        'h1: bcd_to_seg = 'b1111001;
        'h2: bcd_to_seg = 'b0100100;  //   --a--
        'h3: bcd_to_seg = 'b0110000;  //  |     |
        'h4: bcd_to_seg = 'b0011001;  //  f     b
        'h5: bcd_to_seg = 'b0010010;  //  |     |
        'h6: bcd_to_seg = 'b0000010;  //   --g--
        'h7: bcd_to_seg = 'b1111000;  //  |     |
        'h8: bcd_to_seg = 'b0000000;  //  e     c
        'h9: bcd_to_seg = 'b0011000;  //  |     |
        'ha: bcd_to_seg = 'b0001000;  //   --d-- 
        'hb: bcd_to_seg = 'b0000011;
        'hc: bcd_to_seg = 'b1000110;
        'hd: bcd_to_seg = 'b0100001;
        'he: bcd_to_seg = 'b0000110;
        'hf: bcd_to_seg = 'b0001110;
        endcase

    endfunction

    reg [1:0] i;

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
        begin
            seven_segments <=   bcd_to_seg (0);
            dot            <= ~ 0;
            anodes         <= ~ 'b0001;

            i <= 0;
        end
        else
        begin
            seven_segments <=   bcd_to_seg (number [i * 4 +: 4]);
            dot            <= ~ 0;
            anodes         <= ~ (1 << i);

            i <= i + 1;
        end
    end

endmodule

//--------------------------------------------------------------------

module basys3
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

    wire clock;
    wire display_clock;

    wire reset_n                  = ! btnU;

    wire        combinational     =   btnL;
    wire        run_sequential    =   btnC;
    wire        ready_sequential;
    wire        pipelined         =   btnR;

    wire [15:0] n                 =   sw;

    wire [15:0] n_pow_5_combinational;
    wire [15:0] n_pow_5_pipelined;
    wire [15:0] n_pow_5_sequential;

    wire [15:0] n_pow_5  =   combinational ? n_pow_5_combinational
                           : pipelined     ? n_pow_5_pipelined
                           :                 n_pow_5_sequential;

    clock_divider_100_MHz_to_1_49_Hz_and_1_53_KHz clock_divider
    (
        .clock_100_MHz  ( clk           ),
        .reset_n        ( reset_n       ),
        .clock_1_49_Hz  ( clock         ),
        .clock_1_53_KHz ( display_clock )
    );

    assign led = n_pow_5;

    display display
    (
        .clock          ( display_clock  ),
        .reset_n        ( reset_n        ),
        .number         ( n_pow_5        ),

        .seven_segments ( seg            ),
        .dot            (                ),
        .anodes         ( an             )
    );

    assign dp = ~ ready_sequential;

    pow_5_combinational pow_5_combinational
    (
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_combinational )
    );

    pow_5_sequential pow_5_sequential
    (
        .clock   ( clock                 ),
        .reset_n ( reset_n               ),
        .run     ( run_sequential        ),
        .n       ( n                     ),
        .ready   ( ready_sequential      ),
        .n_pow_5 ( n_pow_5_sequential    )
    );

    pow_5_pipelined pow_5_pipelined
    (
        .clock   ( clock                 ),
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_pipelined     )
    );

endmodule

//--------------------------------------------------------------------

module basys3_to_measure_combinational
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

    wire clock;
    wire display_clock;

    wire reset_n                  = ! btnU;

    wire        combinational     =   btnL;
    wire        run_sequential    =   btnC;
    wire        ready_sequential;
    wire        pipelined         =   btnR;

    wire [15:0] n                 =   sw;

    wire [15:0] n_pow_5_combinational;
    wire [15:0] n_pow_5_pipelined;
    wire [15:0] n_pow_5_sequential;

    /*
    wire [15:0] n_pow_5  =   combinational ? n_pow_5_combinational
                           : pipelined     ? n_pow_5_pipelined
                           :                 n_pow_5_sequential;

    clock_divider_100_MHz_to_1_49_Hz_and_1_53_KHz clock_divider
    (
        .clock_100_MHz  ( clk           ),
        .reset_n        ( reset_n       ),
        .clock_1_49_Hz  ( clock         ),
        .clock_1_53_KHz ( display_clock )
    );

    assign led = n_pow_5;

    display display
    (
        .clock          ( display_clock  ),
        .reset_n        ( reset_n        ),
        .number         ( n_pow_5        ),

        .seven_segments ( seg            ),
        .dot            (                ),
        .anodes         ( an             )
    );

    assign dp = ~ ready_sequential;
    */

    assign clock = clk;

    assign seg = 7'b0;
    assign dp  = ~ ready_sequential;
    assign an  = 4'hf;

    reg [15:0] n_pow_5;

    always @(posedge clk)
        n_pow_5 <= n_pow_5_combinational;

    assign led = n_pow_5;

    pow_5_combinational pow_5_combinational
    (
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_combinational )
    );

    /*
    pow_5_sequential pow_5_sequential
    (
        .clock   ( clock                 ),
        .reset_n ( reset_n               ),
        .run     ( run_sequential        ),
        .n       ( n                     ),
        .ready   ( ready_sequential      ),
        .n_pow_5 ( n_pow_5_sequential    )
    );

    pow_5_pipelined pow_5_pipelined
    (
        .clock   ( clock                 ),
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_pipelined     )
    );
    */

endmodule

//--------------------------------------------------------------------

module basys3_to_measure_sequential
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

    wire clock;
    wire display_clock;

    wire reset_n                  = ! btnU;

    wire        combinational     =   btnL;
    wire        run_sequential    =   btnC;
    wire        ready_sequential;
    wire        pipelined         =   btnR;

    wire [15:0] n                 =   sw;

    wire [15:0] n_pow_5_combinational;
    wire [15:0] n_pow_5_pipelined;
    wire [15:0] n_pow_5_sequential;

    /*
    wire [15:0] n_pow_5  =   combinational ? n_pow_5_combinational
                           : pipelined     ? n_pow_5_pipelined
                           :                 n_pow_5_sequential;

    clock_divider_100_MHz_to_1_49_Hz_and_1_53_KHz clock_divider
    (
        .clock_100_MHz  ( clk           ),
        .reset_n        ( reset_n       ),
        .clock_1_49_Hz  ( clock         ),
        .clock_1_53_KHz ( display_clock )
    );

    assign led = n_pow_5;

    display display
    (
        .clock          ( display_clock  ),
        .reset_n        ( reset_n        ),
        .number         ( n_pow_5        ),

        .seven_segments ( seg            ),
        .dot            (                ),
        .anodes         ( an             )
    );

    assign dp = ~ ready_sequential;
    */

    assign clock = clk;

    assign seg = 7'b0;
    assign dp  = ~ ready_sequential;
    assign an  = 4'hf;

    reg [15:0] n_pow_5;

    always @(posedge clk)
        n_pow_5 <= n_pow_5_combinational;

    assign led = n_pow_5;

    /*
    pow_5_combinational pow_5_combinational
    (
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_combinational )
    );
    */

    pow_5_sequential pow_5_sequential
    (
        .clock   ( clock                 ),
        .reset_n ( reset_n               ),
        .run     ( run_sequential        ),
        .n       ( n                     ),
        .ready   ( ready_sequential      ),
        .n_pow_5 ( n_pow_5_sequential    )
    );

    /*
    pow_5_pipelined pow_5_pipelined
    (
        .clock   ( clock                 ),
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_pipelined     )
    );
    */

endmodule

//--------------------------------------------------------------------

module basys3_to_measure_pipelined
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

    wire clock;
    wire display_clock;

    wire reset_n                  = ! btnU;

    wire        combinational     =   btnL;
    wire        run_sequential    =   btnC;
    wire        ready_sequential;
    wire        pipelined         =   btnR;

    wire [15:0] n                 =   sw;

    wire [15:0] n_pow_5_combinational;
    wire [15:0] n_pow_5_pipelined;
    wire [15:0] n_pow_5_sequential;

    /*
    wire [15:0] n_pow_5  =   combinational ? n_pow_5_combinational
                           : pipelined     ? n_pow_5_pipelined
                           :                 n_pow_5_sequential;

    clock_divider_100_MHz_to_1_49_Hz_and_1_53_KHz clock_divider
    (
        .clock_100_MHz  ( clk           ),
        .reset_n        ( reset_n       ),
        .clock_1_49_Hz  ( clock         ),
        .clock_1_53_KHz ( display_clock )
    );

    assign led = n_pow_5;

    display display
    (
        .clock          ( display_clock  ),
        .reset_n        ( reset_n        ),
        .number         ( n_pow_5        ),

        .seven_segments ( seg            ),
        .dot            (                ),
        .anodes         ( an             )
    );

    assign dp = ~ ready_sequential;
    */

    assign clock = clk;

    assign seg = 7'b0;
    assign dp  = ~ ready_sequential;
    assign an  = 4'hf;

    reg [15:0] n_pow_5;

    always @(posedge clk)
        n_pow_5 <= n_pow_5_combinational;

    assign led = n_pow_5;

    /*
    pow_5_combinational pow_5_combinational
    (
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_combinational )
    );

    pow_5_sequential pow_5_sequential
    (
        .clock   ( clock                 ),
        .reset_n ( reset_n               ),
        .run     ( run_sequential        ),
        .n       ( n                     ),
        .ready   ( ready_sequential      ),
        .n_pow_5 ( n_pow_5_sequential    )
    );
    */

    pow_5_pipelined pow_5_pipelined
    (
        .clock   ( clock                 ),
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_pipelined     )
    );

endmodule

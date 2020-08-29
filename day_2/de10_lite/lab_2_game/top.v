module top
#(
    parameter debounce_depth                     = 8,
              shift_strobe_width                 = 23,
              seven_segment_strobe_width         = 10,
              strobe_to_update_xy_counter_width  = 20
)
(
    input           adc_clk_10,
    input           max10_clk1_50,
    input           max10_clk2_50,

    input   [ 1:0]  key,
    input   [ 9:0]  sw,
    output  [ 9:0]  ledr,

    output  [ 7:0]  hex0,
    output  [ 7:0]  hex1,
    output  [ 7:0]  hex2,
    output  [ 7:0]  hex3,
    output  [ 7:0]  hex4,
    output  [ 7:0]  hex5,

    output  [ 3:0]  vga_b,
    output  [ 3:0]  vga_g,
    output          vga_hs,
    output  [ 3:0]  vga_r,
    output          vga_vs,

    output  [12:0]  dram_addr,
    output  [ 1:0]  dram_ba,
    output          dram_cas_n,
    output          dram_cke,
    output          dram_clk,
    output          dram_cs_n,
    inout   [15:0]  dram_dq,
    output          dram_ldqm,
    output          dram_ras_n,
    output          dram_udqm,
    output          dram_we_n,

    output          gsensor_cs_n,
    input   [ 2:1]  gsensor_int,
    output          gsensor_sclk,
    inout           gsensor_sdi,
    inout           gsensor_sdo,

    inout   [15:0]  arduino_io,
    inout           arduino_reset_n,

    inout   [35:0]  gpio
);

    //------------------------------------------------------------------------

    wire clk   = max10_clk1_50;
    wire reset = ~ key [0];

    //------------------------------------------------------------------------

    wire [1:0] key_db;
    wire [9:0] sw_db;

    sync_and_debounce # (.w (2), .depth (debounce_depth))
        i_sync_and_debounce_key
            (clk, reset, ~ key, key_db);

    sync_and_debounce # (.w (10), .depth (debounce_depth))
        i_sync_and_debounce_sw
            (clk, reset, sw, sw_db);

    //------------------------------------------------------------------------

    wire shift_strobe;

    strobe_gen # (.w (shift_strobe_width)) i_shift_strobe
        (clk, reset, shift_strobe);

    wire [9:0] out_reg;

    shift_register # (.w (10)) i_shift_reg
    (
        .clk     ( clk          ),
        .reset   ( reset        ),
        .en      ( shift_strobe ),
        .in      ( key_db [1]   ),
        .out_reg ( out_reg      )
    );

    assign ledr = out_reg;

    //------------------------------------------------------------------------

    wire [15:0] shift_strobe_count;

    counter # (16) i_shift_strobe_counter
    (
        .clk   ( clk                ),
        .reset ( reset              ),
        .en    ( shift_strobe       ),
        .cnt   ( shift_strobe_count )
    );

    //------------------------------------------------------------------------

    wire out_moore_fsm;

    moore_fsm i_moore_fsm
    (
        .clk   ( clk           ),
        .reset ( reset         ),
        .en    ( shift_strobe  ),
        .a     ( out_reg [0]   ),
        .y     ( out_moore_fsm )
    );

    wire [7:0] moore_fsm_out_count;

    counter # (8) i_moore_fsm_out_counter
    (
        .clk   ( clk                          ),
        .reset ( reset                        ),
        .en    ( shift_strobe & out_moore_fsm ),
        .cnt   ( moore_fsm_out_count          )
    );

    //------------------------------------------------------------------------

    wire out_mealy_fsm;

    mealy_fsm i_mealy_fsm
    (
        .clk   ( clk           ),
        .reset ( reset         ),
        .en    ( shift_strobe  ),
        .a     ( out_reg [0]   ),
        .y     ( out_mealy_fsm )
    );

    wire [7:0] mealy_fsm_out_count;

    counter # (8) i_mealy_fsm_out_counter
    (
        .clk   ( clk                          ),
        .reset ( reset                        ),
        .en    ( shift_strobe & out_mealy_fsm ),
        .cnt   ( mealy_fsm_out_count          )
    );

    //------------------------------------------------------------------------

    wire [2:0] rgb;

    assign vga_r = { 4 { rgb [2] } };
    assign vga_g = { 4 { rgb [1] } };
    assign vga_b = { 4 { rgb [0] } };

    game_top
    # (
        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk   (   clk       ),
        .reset (   reset     ),

        .key   ( ~ key [1]   ),
        .sw    (   sw  [1:0] ),

        .hsync (   vga_hs    ),
        .vsync (   vga_vs    ),
        .rgb   (   rgb       )
    );

    /*
    wire       display_on;
    wire [9:0] hpos;
    wire [9:0] vpos;

    vga i_vga
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( vga_hs     ),
        .vsync      ( vga_vs     ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );

    wire [2:0] rgb_squares
        = hpos ==  0 || hpos == 639 || vpos ==  0 || vpos == 479 ? 3'b100 :
          hpos ==  5 || hpos == 634 || vpos ==  5 || vpos == 474 ? 3'b010 :
          hpos == 10 || hpos == 629 || vpos == 10 || vpos == 469 ? 3'b001 :
          hpos <  20 || hpos >  619 || vpos <  20 || vpos >= 459 ? 3'b000 :
          { 1'b0, vpos [4], hpos [3] ^ vpos [3] };

    wire        lfsr_enable = ! hpos [9:8] & ! vpos [9:8];
    wire [15:0] lfsr_out;

    lfsr #(16, 16'b1000000001011, 0) i_lfsr
    (
        .clk    ( clk         ),
        .reset  ( reset       ),
        .enable ( lfsr_enable ),
        .out    ( lfsr_out    )
    );

    wire star_on = & lfsr_out [15:9];

    wire [2:0] rgb = lfsr_enable ?
                         (star_on ? lfsr_out [2:0] : 3'b0)
                       : rgb_squares;

    assign vga_r = { 4 { rgb [2] } };
    assign vga_g = { 4 { rgb [1] } };
    assign vga_b = { 4 { rgb [0] } };
    */

    //------------------------------------------------------------------------

    wire enc_a   = gpio [34];
    wire enc_b   = gpio [32];
    wire enc_btn = gpio [30];
    wire enc_swt = gpio [28];

    assign gpio [26] = 0;

    wire enc_a_db;
    wire enc_b_db;
    wire enc_btn_db;
    wire enc_swt_db;

    sync_and_debounce # (.w (4), .depth (debounce_depth))
        i_sync_and_debounce_enc
        (
            clk,
            reset,
            { enc_a    , enc_b    , enc_btn    , enc_swt    },
            { enc_a_db , enc_b_db , enc_btn_db , enc_swt_db }
        );

    wire [15:0] enc_value;

    rotary_encoder i_rotary_encoder
    (
        .clk        ( clk       ),
        .reset      ( reset     ),
        .a          ( enc_a_db  ),
        .b          ( enc_b_db  ),
        .value      ( enc_value )
    );

    //------------------------------------------------------------------------

    reg [31:0] number_to_display;

    always @*
        case (sw_db [0])

        1'b1:    number_to_display =
                 {
                     { 8 { enc_btn_db } },
                     { 8 { enc_swt_db } },
                     enc_value
                 };

        default: number_to_display =
                 {
                     shift_strobe_count,
                     moore_fsm_out_count,
                     mealy_fsm_out_count
                 };

        endcase

    //------------------------------------------------------------------------

    seven_segment_digit i_digit_0 ( number_to_display [ 3: 0], hex0 [6:0]);
    seven_segment_digit i_digit_1 ( number_to_display [ 7: 4], hex1 [6:0]);
    seven_segment_digit i_digit_2 ( number_to_display [11: 8], hex2 [6:0]);
    seven_segment_digit i_digit_3 ( number_to_display [15:12], hex3 [6:0]);
    seven_segment_digit i_digit_4 ( number_to_display [19:16], hex4 [6:0]);
    seven_segment_digit i_digit_5 ( number_to_display [23:20], hex5 [6:0]);

    assign { hex5 [7], hex4 [7], hex3 [7], hex2 [7], hex1 [7], hex0 [7] }
        = ~ sw_db [5:0];

endmodule

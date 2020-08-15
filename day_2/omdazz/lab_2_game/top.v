module top
# (
    parameter debounce_depth                     = 8,
              shift_strobe_width                 = 23,
              seven_segment_strobe_width         = 10,
              strobe_to_update_xy_counter_width  = 20
)
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

    wire reset = ~ reset_n;

    //------------------------------------------------------------------------

    wire [3:0] key_db;

    sync_and_debounce # (.w (4), .depth (debounce_depth))
        i_sync_and_debounce_key
            (clk, reset, ~ key_sw, key_db);

    wire [3:0] sw_db = key_db;

    //------------------------------------------------------------------------

    wire shift_strobe;

    strobe_gen # (.w (shift_strobe_width)) i_shift_strobe
        (clk, reset, shift_strobe);

    wire [3:0] out_reg;

    shift_register # (.w (4)) i_shift_reg
    (
        .clk     ( clk          ),
        .reset   ( reset        ),
        .en      ( shift_strobe ),
        .in      ( key_db [3]   ),
        .out_reg ( out_reg      )
    );

    assign led = ~ out_reg;

    //------------------------------------------------------------------------

    wire [7:0] shift_strobe_count;

    counter # (8) i_shift_strobe_counter
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
    
    wire [3:0] moore_fsm_out_count;

    counter # (4) i_moore_fsm_out_counter
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
    
    wire [3:0] mealy_fsm_out_count;

    counter # (4) i_mealy_fsm_out_counter
    (
        .clk   ( clk                          ),
        .reset ( reset                        ),
        .en    ( shift_strobe & out_mealy_fsm ),
        .cnt   ( mealy_fsm_out_count          )
    );

    //------------------------------------------------------------------------

    parameter frequency_c4_mul_100 = 26163,
              frequency_g4_mul_100 = 39200;
    
    wire note_c4, note_g4;

    frequency_gen
    # (
        .output_frequency_mul_100 ( frequency_c4_mul_100 )
    )
    gen_c4
    (
        .clk ( clk        ),
        .en  ( key_db [2] ),
        .out ( note_c4    )
    );

    frequency_gen
    # (
        .output_frequency_mul_100 ( frequency_g4_mul_100 )
    )
    gen_g4
    (
        .clk ( clk        ),
        .en  ( key_db [1] ),
        .out ( note_g4    )
    );

    assign buzzer = note_c4 | note_g4;

    //------------------------------------------------------------------------

    wire       start      =   key_db [3] | key_db [0];
    wire [1:0] left_right = { key_db [3] , key_db [0] };

    game_top
    # (
        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk   ( clk        ),
        .reset ( reset      ),

        .key   ( start      ),
        .sw    ( left_right ),

        .hsync ( hsync      ),
        .vsync ( vsync      ),
        .rgb   ( rgb        )
    );

    /*
    wire       display_on;
    wire [9:0] hpos;
    wire [9:0] vpos;

    vga i_vga
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( hpos       ),
        .vpos       ( vpos       )
    );

    wire [2:0] rgb_squares
        = hpos ==  0 || hpos == 639 || vpos ==  0 || vpos == 479 ? 3'b100 :
          hpos ==  5 || hpos == 634 || vpos ==  5 || vpos == 474 ? 3'b010 :
          hpos == 10 || hpos == 629 || vpos == 10 || vpos == 469 ? 3'b001 :
          hpos <  20 || hpos >  619 || vpos <  20 || vpos >= 459 ? 3'b000 :
          { hpos [4], vpos [4], hpos [3] ^ vpos [3] };

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

    assign rgb = lfsr_enable ?
                     (star_on ? lfsr_out [2:0] : 3'b0)
                   : rgb_squares;
    */

    //------------------------------------------------------------------------

    wire [15:0] number_to_display =
    {
        shift_strobe_count,
        moore_fsm_out_count,
        mealy_fsm_out_count
    };

    //------------------------------------------------------------------------

    wire seven_segment_strobe;

    strobe_gen # (.w (seven_segment_strobe_width))
        i_seven_segment_strobe
            (clk, reset, seven_segment_strobe);

    seven_segment #(.w (16)) i_seven_segment
    (
        .clk     ( clk                  ),
        .reset   ( reset                ),
        .en      ( seven_segment_strobe ),
        .num     ( number_to_display    ),
        .dots    ( sw_db                ),
        .abcdefg ( abcdefgh [7:1]       ),
        .dot     ( abcdefgh [0]         ),
        .anodes  ( digit                )
    );

endmodule

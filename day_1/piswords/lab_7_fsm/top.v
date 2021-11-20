module top
# (
    parameter debounce_depth             = 8,
              shift_strobe_width         = 23,
              seven_segment_strobe_width = 10
)
(
    input         clk,
    input  [ 3:0] key,
    input  [ 3:0] sw,
    output [ 7:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb,

    output        buzzer,
    inout  [15:0] gpio
);

    wire reset = ~ key[3];

    assign buzzer = 1'b1;
    assign hsync  = 1'b1;
    assign vsync  = 1'b1;
    assign rgb    = 3'b0;
    
    //------------------------------------------------------------------------

    wire [3:0] key_db;
    wire [3:0] sw_db;

    sync_and_debounce # (.w (8), .depth (debounce_depth))
        i_sync_and_debounce_key
            (clk, reset, ~ { key, sw }, { key_db, sw_db });

    //------------------------------------------------------------------------

    wire shift_strobe;

    strobe_gen # (.w (shift_strobe_width)) i_shift_strobe
        (clk, reset, shift_strobe);

    wire [7:0] out_reg;

    shift_register # (.w (8)) i_shift_reg
    (
        .clk     ( clk          ),
        .reset   ( reset        ),
        .en      ( shift_strobe ),
        .in      ( key_db [2]   ),
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

    wire [31:0] number_to_display =
    {
        16'b0,
        shift_strobe_count,
        moore_fsm_out_count,
        mealy_fsm_out_count
    };

    //------------------------------------------------------------------------

    wire seven_segment_strobe;

    strobe_gen # (.w (seven_segment_strobe_width))
        i_seven_segment_strobe
            (clk, reset, seven_segment_strobe);

    seven_segment #(.w (32)) i_seven_segment
    (
        .clk     ( clk                  ),
        .reset   ( reset                ),
        .en      ( seven_segment_strobe ),
        .num     ( number_to_display    ),
        .dots    ( { sw_db, key_db }    ),
        .abcdefg ( abcdefgh [7:1]       ),
        .dot     ( abcdefgh [0]         ),
        .anodes  ( digit                )
    );

endmodule

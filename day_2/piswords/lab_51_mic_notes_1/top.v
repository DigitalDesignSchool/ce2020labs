`include "config.vh"

// `define USE_STANDARD_FREQUENCIES
// `define USE_ONE_COMPARISON
// `define THREE_OCTAVES
// `define TWO_OCTAVES

`ifdef USE_ONE_COMPARISON
    `ifdef THREE_OCTAVES
        error USE_ONE_COMPARISON and THREE_OCTAVES are not compatible
    `endif

    `ifdef TWO_OCTAVES
        error USE_ONE_COMPARISON and TWO_OCTAVES are not compatible
    `endif
`endif

module top
# (
    parameter clk_mhz = 50,
              strobe_to_update_xy_counter_width = 20
)
(
    input             clk,
    input      [ 3:0] key,
    input      [ 3:0] sw,
    output     [ 7:0] led,

    output reg [ 7:0] abcdefgh,
    output     [ 7:0] digit,

    output            vsync,
    output            hsync,
    output     [ 2:0] rgb,

    output            buzzer,
    inout      [15:0] gpio
);

    wire   reset  = ~ key [3];
    assign buzzer = ~ reset;

    //------------------------------------------------------------------------

    wire [15:0] value;

    pmod_mic3_spi_receiver i_microphone
    (
        .clock ( clk       ),
        .reset ( reset     ),
        .cs    ( gpio  [0] ),
        .sck   ( gpio  [6] ),
        .sdo   ( gpio  [4] ),
        .value ( value     )
    );

    assign gpio [ 8] = 1'b0;  // GND
    assign gpio [10] = 1'b1;  // VCC

    //------------------------------------------------------------------------

    assign led = ~ value [13:6];

    //------------------------------------------------------------------------

    // It is enough for the counter to be 20 bit. Why?

    reg [15:0] prev_value;
    reg [19:0] counter;
    reg [19:0] distance;

    localparam [15:0] threshold = 16'h1000;

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            prev_value <= 16'h0;
            counter    <= 20'h0;
            distance   <= 20'h0;
        end
        else
        begin
            prev_value <= value;

            if (  value      > threshold
                & prev_value < threshold)
            begin
               distance <= counter;
               counter  <= 20'h0;
            end
            else if (counter != ~ 20'h0)  // To prevent overflow
            begin
               counter <= counter + 20'h1;
            end
        end

    //------------------------------------------------------------------------

    `ifdef USE_STANDARD_FREQUENCIES

    localparam freq_100_C  = 26163,
               freq_100_Cs = 27718,
               freq_100_D  = 29366,
               freq_100_Ds = 31113,
               freq_100_E  = 32963,
               freq_100_F  = 34923,
               freq_100_Fs = 36999,
               freq_100_G  = 39200,
               freq_100_Gs = 41530,
               freq_100_A  = 44000,
               freq_100_As = 46616,
               freq_100_B  = 49388;

    `else

    // Custom measured frequencies

    localparam freq_100_C  = 26163,
               freq_100_Cs = 27718,
               freq_100_D  = 29366,
               freq_100_Ds = 31113,
               freq_100_E  = 32963,
               freq_100_F  = 34923,
               freq_100_Fs = 36999,
               freq_100_G  = 39200,
               freq_100_Gs = 41530,
               freq_100_A  = 44000,
               freq_100_As = 46616,
               freq_100_B  = 49388;

    `endif

    //------------------------------------------------------------------------

    function [19:0] high_distance (input [15:0] freq_100);
       high_distance = clk_mhz * 1000 * 1000 / freq_100 * 102 / 2;  // 2 to make octave higher
    endfunction

    //------------------------------------------------------------------------

    function [19:0] low_distance (input [15:0] freq_100);
       low_distance = clk_mhz * 1000 * 1000 / freq_100 * 98;
    endfunction

    //------------------------------------------------------------------------

    function [19:0] check_freq_single_range (input [15:0] freq_100);

       `ifdef USE_ONE_COMPARISON
           return distance < high_distance (freq_100);
       `else
           return   distance > low_distance  (freq_100)
                  & distance < high_distance (freq_100)
       `endif

    endfunction

    //------------------------------------------------------------------------

    function [19:0] check_freq (input [15:0] freq_100);

       `ifdef USE_ONE_COMPARISON
           return   check_freq_single_range (freq_100);
       `elsif THREE_OCTAVES
           return   check_freq_single_range (freq_100)
                  | check_freq_single_range (freq_100 * 2)
                  | check_freq_single_range (freq_100 * 4);
       `elsif TWO_OCTAVES
           return   check_freq_single_range (freq_100)
                  | check_freq_single_range (freq_100 * 2);
       `else
           return   check_freq_single_range (freq_100);
       `endif

    endfunction

    //------------------------------------------------------------------------

    wire check_C  = check_freq (freq_100_C );
    wire check_Cs = check_freq (freq_100_Cs);
    wire check_D  = check_freq (freq_100_D );
    wire check_Ds = check_freq (freq_100_Ds);
    wire check_E  = check_freq (freq_100_E );
    wire check_F  = check_freq (freq_100_F );
    wire check_Fs = check_freq (freq_100_Fs);
    wire check_G  = check_freq (freq_100_G );
    wire check_Gs = check_freq (freq_100_Gs);
    wire check_A  = check_freq (freq_100_A );
    wire check_As = check_freq (freq_100_As);
    wire check_B  = check_freq (freq_100_B );

    `ifdef USE_ONE_COMPARISON
    wire check_Ch = check_freq (freq_100_C * 2);
    `endif

    //------------------------------------------------------------------------

    `ifdef USE_ONE_COMPARISON

    wire check_Ch = check_freq (freq_100_C * 2);

    localparam w_note = 13;

    localparam [w_note - 1:0] C  = 13'b1000_0000_0000_0,
                              Cs = 13'b1100_0000_0000_0,
                              D  = 13'b1110_0000_0000_0,
                              Ds = 13'b1111_0000_0000_0,
                              E  = 13'b1111_1000_0000_0,
                              F  = 13'b1111_1100_0000_0,
                              Fs = 13'b1111_1110_0000_0,
                              G  = 13'b1111_1111_0000_0,
                              Gs = 13'b1111_1111_1000_0,
                              A  = 13'b1111_1111_1100_0,
                              As = 13'b1111_1111_1110_0,
                              B  = 13'b1111_1111_1111_0;

    wire [w_note - 1:0] note = { check_C  , check_Cs , check_D  , check_Ds ,
                                 check_E  , check_F  , check_Fs , check_G  ,
                                 check_Gs , check_A  , check_As , check_B  ,
                                 check_Ch };

    `else  // ! ifdef USE_ONE_COMPARISON

    localparam w_note = 12;

    localparam [w_note - 1:0] C  = 12'b1000_0000_0000,
                              Cs = 12'b0100_0000_0000,
                              D  = 12'b0010_0000_0000,
                              Ds = 12'b0001_0000_0000,
                              E  = 12'b0000_1000_0000,
                              F  = 12'b0000_0100_0000,
                              Fs = 12'b0000_0010_0000,
                              G  = 12'b0000_0001_0000,
                              Gs = 12'b0000_0000_1000,
                              A  = 12'b0000_0000_0100,
                              As = 12'b0000_0000_0010,
                              B  = 12'b0000_0000_0001;

    wire [w_note - 1:0] note = { check_C  , check_Cs , check_D  , check_Ds ,
                                 check_E  , check_F  , check_Fs , check_G  ,
                                 check_Gs , check_A  , check_As , check_B  };
    `endif

    localparam no_note = { w_note { 1'b0 } };

    //------------------------------------------------------------------------

    reg  [w_note - 1:0] d_note;  // Delayed note

    always @(posedge clk or posedge reset)
        if (reset)
            d_note <= no_note;
        else
            d_note <= note;

    reg  [17:0] t_cnt;           // Threshold counter
    reg  [w_note - 1:0] t_note;  // Thresholded note

    always @(posedge clk or posedge reset)
        if (reset)
            t_cnt <= 0;
        else
            if (note == d_note)
                t_cnt <= t_cnt + 1;
            else
                t_cnt <= 0;

    always @(posedge clk or posedge reset)
        if (reset)
            t_note <= no_note;
        else
            if (& t_cnt)
                t_note <= d_note;

    //------------------------------------------------------------------------

    localparam w_state = 3;

    localparam [w_state - 1:0] st_wait_C             = 3'd0,
                               st_wait_E_or_Ds       = 3'd1,
                               st_wait_G_for_C_major = 3'd2,
                               st_wait_G_for_C_minor = 3'd3,
                               st_C_major            = 3'd4,
                               st_C_minor            = 3'd5;

    reg [w_state - 1:0] state, new_state;

    //------------------------------------------------------------------------

    always @*
    begin
        new_state = state;
        
        case (state)
        st_wait_C:
        
               if ( t_note == C  ) new_state = st_wait_E_or_Ds;
        
        st_wait_E_or_Ds:
        
               if ( t_note == E  ) new_state = st_wait_G_for_C_major;
          else if ( t_note == Ds ) new_state = st_wait_G_for_C_minor;
        
        st_wait_G_for_C_major:
        
               if ( t_note == G  ) new_state = st_C_major;
        
        st_wait_G_for_C_minor:
        
               if ( t_note == G  ) new_state = st_C_minor;
        
        st_C_major, st_C_minor:
        
               if ( t_note == C  ) new_state = st_wait_E_or_Ds;
        endcase
    end

    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
            state <= 0;
        else
            state <= new_state;

    //------------------------------------------------------------------------

    assign digit = 8'b1111_1110;

    always @ (posedge clk or posedge reset)
        if (reset)
            abcdefgh <= 8'b11111111;
        else
            case (state)
            // st_wait_C             : abcdefgh <= 8'b00000011;  // 0
            // st_wait_E_or_Ds       : abcdefgh <= 8'b10011111;  // 1
            // st_wait_G_for_C_major : abcdefgh <= 8'b00100101;  // 2
            // st_wait_G_for_C_minor : abcdefgh <= 8'b00001101;  // 3
            // st_C_major            : abcdefgh <= 8'b10001111;  // J for C major
            // st_C_minor            : abcdefgh <= 8'b10011111;  // I for C minor
            default:
                case (t_note)
                C  : abcdefgh <= 8'b01100011;  // C   // abcdefgh
                Cs : abcdefgh <= 8'b01100010;  // C#
                D  : abcdefgh <= 8'b10000101;  // D   //   --a-- 
                Ds : abcdefgh <= 8'b10000100;  // D#  //  |     |
                E  : abcdefgh <= 8'b01100001;  // E   //  f     b
                F  : abcdefgh <= 8'b01110001;  // F   //  |     |
                Fs : abcdefgh <= 8'b01110000;  // F#  //   --g-- 
                G  : abcdefgh <= 8'b01000011;  // G   //  |     |
                Gs : abcdefgh <= 8'b01000010;  // G#  //  e     c
                A  : abcdefgh <= 8'b00010001;  // A   //  |     |
                As : abcdefgh <= 8'b00010000;  // A#  //   --d--  h
                B  : abcdefgh <= 8'b11000001;  // B
                default: ;  // No assignment
                endcase
           endcase

endmodule

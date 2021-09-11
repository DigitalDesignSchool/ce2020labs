`include "config.vh"

// `define USE_STANDARD_FREQUENCIES
// `define USE_ONE_COMPARISON
`define OCTAVE_4
`define OCTAVE_5
`define OCTAVE_6

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
    output reg [ 7:0] digit,

    output            vsync,
    output            hsync,
    output     [ 2:0] rgb,

    output            buzzer,
    inout      [15:0] gpio
);

    wire   reset  = ~ key [3];
    assign buzzer = ~ reset;

    //------------------------------------------------------------------------
    //
    //  The microphone receiver
    //
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
    //
    //  Measuring frequency
    //
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
    //
    //  Determining the note
    //
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

    function [19:0] high_distance (input [18:0] freq_100);
       high_distance = clk_mhz * 1000 * 1000 / freq_100 * 102;
    endfunction

    //------------------------------------------------------------------------

    function [19:0] low_distance (input [18:0] freq_100);
       low_distance = clk_mhz * 1000 * 1000 / freq_100 * 98;
    endfunction

    //------------------------------------------------------------------------

    function [19:0] check_freq_single_range (input [18:0] freq_100);

       check_freq_single_range =

       `ifdef USE_ONE_COMPARISON
             distance < high_distance (freq_100);
       `else
             distance > low_distance  (freq_100)
           & distance < high_distance (freq_100);
       `endif

    endfunction

    //------------------------------------------------------------------------

    function [19:0] check_freq (input [18:0] freq_100);

       check_freq =

       `ifdef USE_ONE_COMPARISON
           `ifdef OCTAVE_6
               check_freq_single_range (freq_100 * 4);
           `elsif OCTAVE_5
               check_freq_single_range (freq_100 * 2)
           `else
               check_freq_single_range (freq_100);
           `endif
       `else
                 20'd0
           `ifdef OCTAVE_6
               | check_freq_single_range (freq_100 * 4)
           `endif

           `ifdef OCTAVE_5
               | check_freq_single_range (freq_100 * 2)
           `endif

           `ifdef OCTAVE_4
               | check_freq_single_range (freq_100)
           `endif
                 ;
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

    //------------------------------------------------------------------------

    localparam no_note = { w_note { 1'b0 } };

    localparam [w_note - 1:0] Db = Cs,
                              Eb = Ds,
                              Gb = Fs,
                              Ab = Gs,
                              Bb = As;

    //------------------------------------------------------------------------
    //
    //  Note filtering
    //
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
            if (& t_cnt & d_note != no_note)
                t_note <= d_note;

    //------------------------------------------------------------------------
    //
    //  FSMs
    //
    //------------------------------------------------------------------------

    localparam w_state = 4;  // Let's keep to 16 states
    localparam [3:0] recognized = 4'hf;

    reg [w_state - 1:0] state1, state2, state3;

    //------------------------------------------------------------------------

    // The story of love, part 1

    always @ (posedge clk or posedge reset)
        if (reset)
            state1 <= 0;
        else
            case (state1)
            0: if ( t_note == Bb ) state1 <= 1;
            1: if ( t_note == D  ) state1 <= 2;
            2: if ( t_note == Bb ) state1 <= 3;
            3: if ( t_note == D  ) state1 <= 4;
            4: if ( t_note == Eb ) state1 <= 5;
            5: if ( t_note == D  ) state1 <= 6;
            6: if ( t_note == C  ) state1 <= 7;
            7: if ( t_note == A  ) state1 <= recognized;
            endcase

    // The story of love, part 2

    always @ (posedge clk or posedge reset)
        if (reset)
            state2 <= 0;
        else
            case (state2)
            0: if ( t_note == C  ) state2 <= 1;
            1: if ( t_note == A  ) state2 <= 2;
            2: if ( t_note == C  ) state2 <= 3;
            3: if ( t_note == D  ) state2 <= 4;
            4: if ( t_note == C  ) state2 <= 5;
            5: if ( t_note == Bb ) state2 <= 6;
            6: if ( t_note == G  ) state2 <= recognized;
            endcase

    // Godfather

    always @ (posedge clk or posedge reset)
        if (reset)
            state3 <= 0;
        else
            case (state3)
            0: if ( t_note == G  ) state3 <= 1;
            1: if ( t_note == C  ) state3 <= 2;
            2: if ( t_note == Eb ) state3 <= 3;
            3: if ( t_note == D  ) state3 <= 4;
            4: if ( t_note == C  ) state3 <= 5;
            5: if ( t_note == Eb ) state3 <= 6;
            6: if ( t_note == C  ) state3 <= recognized;
            endcase

    //------------------------------------------------------------------------
    //
    //  The dynamic seven segment display logic
    //
    //------------------------------------------------------------------------

    reg [15:0] digit_enable_cnt;

    always @ (posedge clk or posedge reset)
        if (reset)
            digit_enable_cnt <= 0;
        else
            digit_enable_cnt <= digit_enable_cnt + 1;

    wire digit_enable = & digit_enable_cnt;

    //------------------------------------------------------------------------

    wire [7:0] new_digit = { digit [0], digit [7:1] };

    always @ (posedge clk or posedge reset)
        if (reset)
            digit <= 8'b11111110;
        else if (digit_enable)
            digit <= new_digit;

    //------------------------------------------------------------------------
    //
    //  The output to seven segment display
    //
    //------------------------------------------------------------------------

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            abcdefgh <= 8'b11111111;
        end
        else if (digit_enable)
        begin
            if (~ new_digit [3])
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
            else if (new_digit [2:0] != 3'b111)
                case (~ new_digit [2] ? state1 : ~ new_digit [1] ? state2 : state3)
                4'h0: abcdefgh <= 8'b00000011;
                4'h1: abcdefgh <= 8'b10011111;
                4'h2: abcdefgh <= 8'b00100101;
                4'h3: abcdefgh <= 8'b00001101;
                4'h4: abcdefgh <= 8'b10011001;
                4'h5: abcdefgh <= 8'b01001001;
                4'h6: abcdefgh <= 8'b01000001;
                4'h7: abcdefgh <= 8'b00011111;
                4'h8: abcdefgh <= 8'b00000001;
                4'h9: abcdefgh <= 8'b00011001;
                4'ha: abcdefgh <= 8'b00010001;
                4'hb: abcdefgh <= 8'b11000001;
                4'hc: abcdefgh <= 8'b01100011;
                4'hd: abcdefgh <= 8'b10000101;
                4'he: abcdefgh <= 8'b01100001;
                // 4'hf: abcdefgh <= 8'b01110001;  // F
                4'hf: abcdefgh <= 8'b00111001;  // Upper o - recognized
                endcase
            else
                abcdefgh <= 8'b11111111;
        end

    //------------------------------------------------------------------------
    //
    //  The auxiliary output to LED
    //
    //------------------------------------------------------------------------

    assign led = ~ { 2'b0, state1, state2 };

endmodule

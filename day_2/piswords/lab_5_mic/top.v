`include "config.vh"

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

/*
    OLD PINS

    pmod_mic3_spi_receiver i_microphone
    (
        .clock ( clk        ),
        .reset ( reset      ),
        .cs    ( gpio  [14] ),
        .sck   ( gpio  [ 8] ),
        .sdo   ( gpio  [10] ),
        .value ( value      )
    );

    assign gpio [4] = 1'b1;  // VCC
    assign gpio [6] = 1'b0;  // GND
*/

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

    localparam frq_100_C  = 26163,
               frq_100_Cs = 27718,
               frq_100_D  = 29366,
               frq_100_Ds = 31113,
               frq_100_E  = 32963,
               frq_100_F  = 34923,
               frq_100_Fs = 36999,
               frq_100_G  = 39200,
               frq_100_Gs = 41530,
               frq_100_A  = 44000,
               frq_100_As = 46616,
               frq_100_B  = 49388;

    //------------------------------------------------------------------------

    function [19:0] high_distance (input [15:0] frq_100);
       high_distance = clk_mhz * 1000 * 1000 / frq_100 * 102 / 2;  // 2 to make octave higher
    endfunction

    //------------------------------------------------------------------------

    wire lt_C  = distance < high_distance (frq_100_C );
    wire lt_Cs = distance < high_distance (frq_100_Cs);
    wire lt_D  = distance < high_distance (frq_100_D );
    wire lt_Ds = distance < high_distance (frq_100_Ds);
    wire lt_E  = distance < high_distance (frq_100_E );
    wire lt_F  = distance < high_distance (frq_100_F );
    wire lt_Fs = distance < high_distance (frq_100_Fs);
    wire lt_G  = distance < high_distance (frq_100_G );
    wire lt_Gs = distance < high_distance (frq_100_Gs);
    wire lt_A  = distance < high_distance (frq_100_A );
    wire lt_As = distance < high_distance (frq_100_As);
    wire lt_B  = distance < high_distance (frq_100_B );
    wire lt_Ch = distance < high_distance (frq_100_C * 2);

    //------------------------------------------------------------------------

    localparam w_note  = 13;
    localparam no_note = { w_note { 1'b0 } };

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

    //------------------------------------------------------------------------

    wire [w_note - 1:0] note = { lt_C  , lt_Cs , lt_D  , lt_Ds ,
                                 lt_E  , lt_F  , lt_Fs , lt_G  ,
                                 lt_Gs , lt_A  , lt_As , lt_B  ,
                                 lt_Ch };

    reg  [w_note - 1:0] d_note;     // Delayed note

    always @(posedge clk or posedge reset)
        d_note <= reset ? no_note : note;

    reg  [17:0] t_cnt;           // Threshold counter
    reg  [w_note - 1:0] t_note;  // Thresholded note

    always @(posedge clk or posedge reset)
        if (reset)
            t_cnt <= 0;
        else
            if (note == d_note)
                t_cnt <= t_cnt + 1;
            else
                t_cnt <= (t_cnt != 0) ? (t_cnt - 1) : 0;

    always @(posedge clk or posedge reset)
        if (reset)
            t_note <= no_note;
        else
            if (& t_cnt)
                t_note <= d_note;

    reg  [w_note - 1:0] d_t_note;

    always @(posedge clk or posedge reset)
        d_t_note <= reset ? no_note : t_note;

    reg  [23:0] p_cnt;      // Protection counter
    reg  [w_note - 1:0] p_note;     // Protected note

    always @(posedge clk or posedge reset)
        if (reset)
            p_cnt <= 0;
        else
            if (t_note == d_t_note)
                p_cnt <= p_cnt + 1;
            else
                p_cnt <= 0;

    always @(posedge clk or posedge reset)
        if (reset)
            p_note <= no_note;
        else
            if (t_note != no_note)
                p_note <= t_note;
            else if (& p_cnt)
                p_note <= t_note;

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
        
               if ( p_note == C  ) new_state = st_wait_E_or_Ds;
        
        st_wait_E_or_Ds:
        
               if ( p_note == E  ) new_state = st_wait_G_for_C_major;
          else if ( p_note == Ds ) new_state = st_wait_G_for_C_minor;
        
        st_wait_G_for_C_major:
        
               if ( p_note == G  ) new_state = st_C_major;
        
        st_wait_G_for_C_minor:
        
               if ( p_note == G  ) new_state = st_C_minor;
        
        st_C_major, st_C_minor:
        
               if ( p_note == C  ) new_state = st_wait_E_or_Ds;
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
            st_C_major            : abcdefgh <= 8'b10001111;  // J for C major
            st_C_minor            : abcdefgh <= 8'b10011111;  // I for C minor
            default:
                case (p_note)
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

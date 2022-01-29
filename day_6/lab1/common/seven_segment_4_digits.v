module seven_segment_4_digits
(
    input             clock,
    input             reset,
    input      [15:0] number,

    output reg [ 7:0] abcdefgh,
    output reg [ 3:0] digit
);

    function [7:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)

        'h0: bcd_to_seg = 'b00000011;  // a b c d e f g h
        'h1: bcd_to_seg = 'b10011111;
        'h2: bcd_to_seg = 'b00100101;  //   --a--
        'h3: bcd_to_seg = 'b00001101;  //  |     |
        'h4: bcd_to_seg = 'b10011001;  //  f     b
        'h5: bcd_to_seg = 'b01001001;  //  |     |
        'h6: bcd_to_seg = 'b01000001;  //   --g--
        'h7: bcd_to_seg = 'b00011111;  //  |     |
        'h8: bcd_to_seg = 'b00000001;  //  e     c
        'h9: bcd_to_seg = 'b00011001;  //  |     |
        'ha: bcd_to_seg = 'b00010001;  //   --d--  h
        'hb: bcd_to_seg = 'b11000001;
        'hc: bcd_to_seg = 'b01100011;
        'hd: bcd_to_seg = 'b10000101;
        'he: bcd_to_seg = 'b01100001;
        'hf: bcd_to_seg = 'b01110001;

        endcase

    endfunction

    reg [15:0] cnt;

    always @ (posedge clock or posedge reset)
        if (reset)
            cnt <= 16'd0;
        else
            cnt <= cnt + 16'd1;

    reg [1:0] i;

    always @ (posedge clock or posedge reset)
    begin
        if (reset)
        begin
            abcdefgh <=   bcd_to_seg (0);
            digit    <= ~ 4'b1;

            i <= 0;
        end
        else if (cnt == 16'b0)
        begin
            abcdefgh <=   bcd_to_seg (number [i * 4 +: 4]);
            digit    <= ~ (4'b1 << i);

            i <= i + 1;
        end
    end

endmodule

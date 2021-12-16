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
        'h0: bcd_to_seg = 'b11000000;
        'h1: bcd_to_seg = 'b11111001;
        'h2: bcd_to_seg = 'b10100100;
        'h3: bcd_to_seg = 'b10110000;
        'h4: bcd_to_seg = 'b10011001;
        'h5: bcd_to_seg = 'b10010010;
        'h6: bcd_to_seg = 'b10000010;
        'h7: bcd_to_seg = 'b11111000;
        'h8: bcd_to_seg = 'b10000000;
        'h9: bcd_to_seg = 'b10010000;
        'ha: bcd_to_seg = 'b10001000;
        'hb: bcd_to_seg = 'b10000011;
        'hc: bcd_to_seg = 'b11000110;
        'hd: bcd_to_seg = 'b10100001;
        'he: bcd_to_seg = 'b10000110;
        'hf: bcd_to_seg = 'b10001110;
    endcase
endfunction

reg [15:0] cnt;

always @ (posedge clock)
    if (reset)
        cnt <= 16'd0;
    else
        cnt <= cnt + 16'd1;

reg [1:0] i;

always @ (posedge clock)
begin
    if (reset)
    begin
        abcdefgh <=   bcd_to_seg(0);
        digit    <= ~ 4'b1;

        i <= 0;
    end
    else if (cnt == 16'b0)
    begin
        abcdefgh <=   bcd_to_seg(number [i * 4 +: 4]);
        digit    <= ~ (4'b1 << i);

        i <= i + 1;
    end
end

endmodule
module top
(
    input         clk,
    input         reset,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb
);

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

    assign rgb = hpos ==  0 || hpos == 639 || vpos ==  0 || vpos == 479 ? 3'b100 :
                 hpos ==  5 || hpos == 634 || vpos ==  5 || vpos == 474 ? 3'b010 :
                 hpos == 10 || hpos == 629 || vpos == 10 || vpos == 469 ? 3'b001 :
                 hpos <  20 || hpos >  619 || vpos <  20 || vpos >= 459 ? 3'b000 :
                 { hpos [4], vpos [4], hpos [3] ^ vpos [3] };

endmodule

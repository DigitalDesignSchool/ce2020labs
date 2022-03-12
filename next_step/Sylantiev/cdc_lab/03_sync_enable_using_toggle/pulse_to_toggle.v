module pulse_to_toggle
(
    input      clk,
    input      rst,
    input      pulse,
    output reg toggle
);

    always @ (posedge clk or posedge rst)
        if (rst)
            toggle <= 0;
        else
            toggle <= toggle ^ pulse;

endmodule

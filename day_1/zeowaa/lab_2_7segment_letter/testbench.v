`include "config.vh"

module testbench;

    reg [3:0] key_sw;

    top i_top (.key_sw (key_sw));

    initial
    begin
        #0
        $dumpvars;

        repeat (8) #10 key_sw <= $random;

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule

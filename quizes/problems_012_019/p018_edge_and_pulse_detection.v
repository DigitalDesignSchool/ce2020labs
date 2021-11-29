module posedge_detector (input clk, rst, a, output detected);

  reg a_r;

  always @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

// TODO

// Create an one cycle pulse (010) detector.

module one_cycle_pulse_detector (input clk, rst, a, output detected);


endmodule

//----------------------------------------------------------------------------

module testbench;

  logic clk;

  initial
  begin
    clk = '0;

    forever
      # 500 clk = ~ clk;
  end

  logic rst;
    
  initial
  begin
    rst <= 'x;
    repeat (2) @ (posedge clk);
    rst <= '1;
    repeat (2) @ (posedge clk);
    rst <= '0;
  end

  logic a, pd_detected, ocpd_detected;

  posedge_detector         pd   (.detected (pd_detected),   .*);
  one_cycle_pulse_detector ocpd (.detected (ocpd_detected), .*);

  localparam n = 16;

  localparam [0 : n - 1] seq_a                = 16'b1001011011110001;
  localparam [0 : n - 1] seq_posedge          = 16'b1001010010000001;
  localparam [0 : n - 1] seq_one_cycle_pulse  = 16'b0100100000000000;

  initial
  begin
    @ (negedge rst);

    for (int i = 0; i < 10; i ++)
    begin
      a <= seq_a [i];

      @ (posedge clk);

      $display ("%b %b (%b) %b (%b)",
        a,
        pd_detected,   seq_posedge         [i],
        ocpd_detected, seq_one_cycle_pulse [i]);

      if (   pd_detected   !== seq_posedge         [i]
          || ocpd_detected !== seq_one_cycle_pulse [i])
      begin
        $display ("%s FAIL - see above", `__FILE__);
        $finish;
      end
    end

    $display ("%s PASS", `__FILE__);

    `ifdef MODEL_TECH  // Mentor ModelSim and Questa
      $stop;
    `else
      $finish;
    `endif
  end

endmodule

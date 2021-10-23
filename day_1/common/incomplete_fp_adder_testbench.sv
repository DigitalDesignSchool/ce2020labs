// Incomplete floating-point adder testbench
// TODO: add testing pos_inf, neg_inf, nan

module incomplete_fp_adder_testbench;
  
  logic [31:0] a;
  logic [31:0] b;
  logic [31:0] sum;
  logic        pos_inf;
  logic        neg_inf;
  logic        nan;

  incomplete_fp_adder dut (.*);

  task display_fp (shortreal f);
    
    logic [31:0] b;
    b = $shortrealtobits (f);
    
    $write
    (
      "%b_%b_%b %h %f",
      b [31], b [30:23], b [22:0], b, f
    );
    
  endtask
  
  task test (shortreal fa, fb);
    
    shortreal fsum, expected_fsum;
    
    a = $shortrealtobits (fa);
    b = $shortrealtobits (fb);
    
    # 10
    
    fsum = $bitstoshortreal (sum);
    
    $write (  "Testing      ");
    display_fp (fa);
    $write ("\n           + ");
    display_fp (fb);
    $write ("\n             ----------------------------------------------------");
    $write ("\n             ");
    display_fp (fsum);
    
    expected_fsum = fa + fb;
    
    if (fsum != expected_fsum)
      begin
        $write ("\nFAIL");
        $write ("\nExpected     ");
        display_fp (expected_fsum);

        $write ("\n\nDetails:\n\n");

        $display ("{ 1'b1, a_mant } = %b", { 1'b1, dut.a_mant });

        $display ("b_exp (%d) - a_exp (%d) = %d",
          dut.b_exp, dut.a_exp,
          dut.b_exp - dut.a_exp);

        $display ("a_mant_shifted = %b", dut.a_mant_shifted);

        $display ("carry %b added_mants %b",
          dut.carry, dut.added_mants);

        $display ("sum_exp %b sum_mant %b",
          dut.sum_exp, dut.sum_mant);
      end

    $write ("\n\n");
    
  endtask
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars (0);

      $display ("*** Basic tests for positive numbers and zero ***\n");

      test (0, 0);
      test (0, 1);
      test (1, 0);
      test (1, 1);
      test (1.234, 5.678);
      test (1.234e12, 5.678);

      $display ("*** Testing negatives - will fail - TODO ***\n");

      test (-1, 2);

      $display ("*** Testing rounding - will fail - TODO ***\n");

      test ($bitstoshortreal (32'h3ef39f81),   // Approximately 0.475826
            $bitstoshortreal (32'h3cf08e8a));  // Approximately 0.029365

      $display ("*** Testing infinity - will fail - TODO ***\n");

      test ($bitstoshortreal (32'h7f800000),   // Positive infinity
            $bitstoshortreal (32'h3cf08e8a));  // Approximately 0.029365
      
      test ($bitstoshortreal (32'hff800000),   // Negative infinity
            $bitstoshortreal (32'h3cf08e8a));  // Approximately 0.029365
      
      $display ("*** Testing Not a Number (NaN) - will fail - TODO ***\n");

      test ($bitstoshortreal (32'h7ffabcde),   // NaN
            $bitstoshortreal (32'h3cf08e8a));  // Approximately 0.029365

      $display ("*** Randomized test - integers ***\n");

      repeat (5)
        test ($urandom_range (0, 100), $urandom_range (0, 100));
      
      $display ("*** Randomized test - tan ***\n");

      repeat (5)
        begin
          shortreal fa, fb;
          
          fa = $tan ($urandom);
          
          if (fa < 0)
            fa = - fa;
          
          fb = $tan ($urandom);
          
          if (fb < 0)
            fb = - fb;
          
          test (fa, fb);
        end
      
      $display ("*** Randomized test - sinh ***\n");

      repeat (5)
        test ($sinh ($urandom_range (0, 10)),
              $sinh ($urandom_range (0, 10)));

      $finish;
    end

endmodule

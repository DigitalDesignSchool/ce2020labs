typedef struct
{
  logic a, b;
}
S;

module tb;

  S s;
  logic a, b;

  initial
  begin
    $display ("%d", $bits (S));

    a = 1;
    b = 0;
    # 10
    a = 0;
    b = 1;
    # 10
    a = 1;
    b = 0;

    if ($test$plusargs ("stop_instead_of_finish"))
      $stop;
    else
      $finish;
  end

endmodule

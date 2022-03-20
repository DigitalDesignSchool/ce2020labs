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

    $finish;
  end

endmodule

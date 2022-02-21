import riscv_instruction::*;

class my_riscv_instruction extends riscv_instruction;

  // TODO additional constraints

endclass

module testbench;

  my_riscv_instruction tr = new;
  
  initial
  begin
    repeat (10)
    begin
      assert (tr.randomize ());
      $display ("random: %s", tr.str ());
    end
    
    repeat (10)
    begin
      assert (tr.randomize () with
      {
        // TODO an additional constraint
      });
      
      $display ("An additional constraint: %s", tr.str ());
    end

    $finish;
  end
  
endmodule

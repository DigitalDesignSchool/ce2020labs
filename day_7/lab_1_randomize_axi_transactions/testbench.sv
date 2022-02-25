// This AXI transaction randomization example is written by Yuri Panchul

import axi_transaction::*;

class my_axi_transaction extends axi_transaction;

  constraint adr_distr_c
  {
    adr dist
    {
      [ 0    :   16 ] :/ 50,
      [ 4000 : 4100 ] :/ 50
    };
  }
  
  constraint mine_c
  {
    len <= 6;
  }

endclass

module testbench;

  my_axi_transaction tr = new;
  
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
        burst == wrap;
      });
      
      $display ("wrap: %s", tr.str ());
    end
        
    repeat (10)
    begin
      assert (tr.randomize () with
      {
        len inside { 3, 5 };
      });
      
      $display ("len is either 3 or 5: %s", tr.str ());
    end

    repeat (10)
    begin
      assert (tr.randomize () with
      {
        adr inside { [ 4094 : 4096 ] };
        len > 1;
      });
      
      $display ("adr inside 4094..4096, len > 1: %s", tr.str ());
    end

    // TODO Exercise: Step 4:  Add a series of randomizations
    // forcing burst to be not wrap. What is the distribution of the "secure" field?

    // TODO Exercise: Step 5:  Add a series of randomizations
    // forcing burst to be wrap. What is the distribution of the "secure" field?

    // TODO Exercise: Step 6:  Add a series of randomizations
    // forcing the secure field to 0. How will it change the distribution of the "burst" field?

    // TODO Exercise: Step 7:  Add a series of randomizations
    // forcing the secure field to 1. How will it change the distribution of the "burst" field?

    $display ("No ramdomization failure:");

    assert (tr.randomize () with
    {
      size inside { [ 3 : 5 ] };
    });

    $display ("size is within [3:5]: %s", tr.str ());

    $display ("Ramdomization failure:");
  
    assert (tr.randomize () with
    {
      size inside { 3, 5 };
    });

    $display ("size is either 3 or 5: %s", tr.str ());

    $finish;
  end
  
endmodule

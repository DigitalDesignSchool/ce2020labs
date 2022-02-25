// downsizing example is created by Yuri Panchul, Dmitry Smekhov and Yaroslav Kolbasov

`include "defines.svh"

module testbench;
  
  localparam W = 32;
  
  reg clk, rst;
  
  reg  [W * 2 - 1 : 0] in_tdata;
  reg                  in_tvalid;
  wire                 in_tready;
  
  reg  [W     - 1 : 0] out_tdata;
  wire                 out_tvalid;
  reg                  out_tready;
  
  downsizing #(W) dut
  (
    .aclk    (   clk ),
    .aresetn ( ~ rst ),
    .*
  );
  
  initial
  begin
    clk = '0;
    forever #5 clk = ~ clk;
  end
  
  // default clocking my_clocking @ (posedge clk);
  
  task init ();
    in_tvalid  <= '0;
    out_tready <= '1;
  endtask
  
  task reset ();
    #3 rst <= '1;
    repeat (6) @ (posedge clk);
    rst <= 1'b0;
  endtask

  //--------------------------------------------------------------------------
  
  task wait_ready ();
    do
      @ (posedge clk);
    while (~ in_tready);
  endtask
  
  task test_random (int ready_pattern = 0);
    
    $display ("*** test_3_random: ready_pattern %d%s ***",
      ready_pattern,
      ready_pattern == 0 ? "(random)" : "");
    
    fork
    begin
      repeat (6) @ (posedge clk);
        
      repeat (3)
      begin
        in_tvalid <= '1;
        in_tdata  <= "ABCDEFGH";
        wait_ready ();
        in_tdata  <= "IJKLMONP";
        wait_ready ();
        in_tdata  <= "QWERTYUI";
        wait_ready ();
        in_tdata  <= "PQRSTUVW";
        wait_ready ();
        in_tdata  <= "STUVWXYZ";
        wait_ready ();
        in_tdata  <= "Zabcdefg";
        wait_ready ();
        in_tvalid <= '0;
      end
        
      repeat (6) @ (posedge clk);
    end

    begin
      case (ready_pattern)
        1:
        begin
          out_tready <= '1;
        end

        2:
        begin
          out_tready <= '1;
          repeat (8) @ (posedge clk);
          out_tready <= '0;
          repeat (8) @ (posedge clk);
          out_tready <= '1;
        end

        3:
        begin
          out_tready <= '1;
          
          repeat (10)
          begin
            @ (posedge clk);
            out_tready <= ~ out_tready;
          end
          
          out_tready <= '1;
        end
        
        4:
        begin
          out_tready <= '0;
          
          repeat (10)
          begin
            @ (posedge clk);
            out_tready <= ~ out_tready;
          end
          
          out_tready <= '1;
        end
        
        default:
        begin
          repeat (50)
          begin
            @ (posedge clk);
            out_tready <= $urandom;
          end
          
          out_tready <= '1;
        end
      endcase
    end
    join
    
  endtask

  //--------------------------------------------------------------------------

  logic [W - 1:0] in_queue [$], out_queue [$];

  always @ (posedge clk)
  begin
    if (in_tvalid & in_tready)
    begin
      $display ("%0d: push in=%s", $time, in_tdata [2 * W - 1:W]);
      $display ("%0d: push in=%s", $time, in_tdata [    W - 1:0]);
      
      in_queue.push_back (in_tdata [2 * W - 1:W]);
      in_queue.push_back (in_tdata [    W - 1:0]);
    end

    if (out_tvalid & out_tready)
    begin
      $display ("%0d: push out=%s", $time, out_tdata);
      out_queue.push_back (out_tdata);
    end
    
    while (in_queue.size () != 0 && out_queue.size () != 0)
    begin
      if (in_queue [0] != out_queue [0])
        $fatal ("%0d: data mismatch: in=%s out=%s",
          $time, in_queue [0], out_queue [0]);
      else
        $display ("%0d: data match: in=%s out=%s",
          $time, in_queue [0], out_queue [0]);

      void' (in_queue  .pop_front ());
      void' (out_queue .pop_front ());
    end
  end

  final
  begin
    if (in_queue.size () != 0)
      $fatal ("in_queue is not empty");

    if (out_queue.size () != 0)
      $fatal ("out_queue is not empty");
  end

  //--------------------------------------------------------------------------

  initial
  begin
    $dumpfile ("dump.vcd");
    $dumpvars;
  
    fork
    begin
      init  ();
      reset ();

      test_random (.ready_pattern (1));
      test_random (.ready_pattern (2));
      test_random (.ready_pattern (3));
      test_random (.ready_pattern (4));
      test_random (); // Random ready pattern
    end
    
    begin
      repeat (1000)
        @ (posedge clk);
      
      $display ("Timeout: design hangs");
    end
    join_any

    $finish;
  end

endmodule

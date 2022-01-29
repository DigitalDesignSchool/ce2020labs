// Code your testbench here
// or browse Examples


module tb
  #( 
      parameter         test_id=0
   )
  ();
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end
  
  string	test_name[3:0]=
  {
   "test_3", 
   "test_2", 
   "test_1", 
   "test_0" 
  };
  
task test_finish;
  		input int 	test_id;
  		input string	test_name;
        input int		result;
        input int       tr_n;
begin

    automatic int fd = $fopen( "global.txt", "a" );

    $display("");
    $display("");

    if( 1==result ) begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         DISPLAY_NUMBER=0x%4H TEST_PASSED", 
        test_id, test_name, tr_n );
        $display(      "test_id=%-5d test_name: %15s         DISPLAY_NUMBER=0x%4H TEST_PASSED", 
        test_id, test_name, tr_n );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         DISPLAY_NUMBER=0x%4H TEST_FAILED *******", 
        test_id, test_name, tr_n );
        $display(      "test_id=%-5d test_name: %15s         DISPLAY_NUMBER=0x%4H TEST_FAILED *******", 
        test_id, test_name, tr_n );
    end

    $fclose( fd );

    $display("");
    $display("");

    $finish();
end endtask  
  
// Install component   
// generate
//     if( test_id<10) begin
//             user    uut();
//     end
// endgenerate
logic           clk=0;
logic           reset_p;

logic [3:0]      key_sw_p;      // key_sw_p[0]: 1 - reset cpu
                                // key_sw_p[1]: 1 - p0_cpu step
                                // key_sw_p[2]: 1 - p1_cpu step

logic [15:0]     display_number;    // [15:12] - p0_reg_hex
                                    // [11:8]  - credit_counter
                                    // [7:4]   - p1_reg_hex
logic [3:0]      led_p;

logic            test_passed=0;
logic            test_stop=0;
logic            test_timeout=0;

always #5 clk = ~clk;

example_cpu  uut( .* );

// Main process  
initial begin  
  $display("Hello, world! test_id=%d  name: %s ", test_id, test_name[test_id]);

  reset_p <= #1 1;

  #200;

  @(posedge clk);
  
  reset_p <= #1 0;
  
  @(posedge clk iff test_stop | test_timeout );

  #200;

  //test_finish( test_id, test_name[test_id], flag_ok );
  test_finish( test_id, test_name[test_id], test_passed, display_number[15:0] );

end

initial begin
    #40000;
    $display();
    $display( "***************************  TAIMOUT  ****************************"  );
    $display();
    test_timeout = 1;
end

initial begin

    test_init();

    @(negedge reset_p );

    case( test_id )
        0: begin
            // some action for test_id==0
            fork
                test_seq_p0();    
                test_seq_p1();    
            join
           
            if( display_number[15:0]==16'h5AD4 )
                test_passed = 1;
        end

        // 1: begin
        //     // some action for test_id==1
        // end

    endcase    

    test_stop = 1;
end
  
task test_init;
    key_sw_p <= '0;
endtask

task test_seq_p0;

    #900;
    //for( int ii=0; ii<16; ii++ ) begin

        key_sw_p[3] <= 1;    
        #500;
        key_sw_p[3] <= 0;    
        #500;

        key_sw_p[2] <= 1;    
        #500;
        key_sw_p[2] <= 0;    
        #500;

    //end

    #3000;        

    key_sw_p[2] <= 1;    
    #500;
    key_sw_p[2] <= 0;    
    #500;

endtask

task test_seq_p1;

    #2000;

    //for( int ii=0; ii<16; ii++ ) begin

        key_sw_p[1] <= 1;    
        #500;
        key_sw_p[1] <= 0;    
        #800;

        key_sw_p[0] <= 1;    
        #500;
        key_sw_p[0] <= 0;    
        #800;

    //end

endtask


endmodule
// Code your testbench here
// or browse Examples


module tb
  ();
  
  int       test_id=0;

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
begin

    automatic int fd = $fopen( "global.txt", "a" );

    $display("");
    $display("");

    if( 1==result ) begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TEST_PASSED", 
        test_id, test_name );
        $display(      "test_id=%-5d test_name: %15s         TEST_PASSED", 
        test_id, test_name );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TEST_FAILED *******", 
        test_id, test_name );
        $display(      "test_id=%-5d test_name: %15s         TEST_FAILED *******", 
        test_id, test_name );
    end

    $fclose( fd );

    $display("");
    $display("");

    $finish();
end endtask  
  
// Install component   
user    uut();

// Main process  
initial begin  

  automatic int args=-1;
   
  if( $value$plusargs( "test_id=%0d", args )) begin
    if( args>=0 && args<4 )
      test_id = args;

    $display( "args=%d  test_id=%d", args, test_id );

  end

  $display("Hello, world! test_id=%d  name:", test_id, test_name[test_id] );
  
  case( test_id )
    0: begin
        // some action for test_id==0
    end

    1: begin
        // some action for test_id==1
    end

  endcase

  if( 1==test_id )
    test_finish( test_id, test_name[test_id], 1 );
  else
    test_finish( test_id, test_name[test_id], 0 );
end
  
endmodule
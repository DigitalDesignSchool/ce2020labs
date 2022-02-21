// Code your testbench here
// or browse Examples


module tb
//   #( 
//       parameter         test_id=1
//    )
  ();
  
int test_id=0;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end
  
  string	test_name[3:0]=
  {
   "test_3", 
   "test_2", 
   "full", 
   "direct" 
  };
  
task test_finish;
  		input int 	test_id;
  		input string	test_name;
        input int		result;
        input int       tr_cnt;
begin

    automatic int fd = $fopen( "global.txt", "a" );

    $display("");
    $display("");

    if( 1==result ) begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TRANSACTION=%-5d TEST_PASSED", 
        test_id, test_name, tr_cnt );
        $display(      "test_id=%-5d test_name: %15s         TRANSACTION=%-5d TEST_PASSED", 
        test_id, test_name, tr_cnt );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TRANSACTION=%-5d TEST_FAILED *******", 
        test_id, test_name, tr_cnt );
        $display(      "test_id=%-5d test_name: %15s         TRANSACTION=%-5d TEST_FAILED *******", 
        test_id, test_name, tr_cnt );
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

logic  [4:0]    req_set;
logic  [4:0]    req;
logic  [4:0]	grant;
logic  [4:0]	grant_m2;

logic           test_passed=0;
logic           test_stop=0;
logic           test_timeout=0;

logic   [4:0]   mask_grant;
logic           mask_grant_clr;

int             cnt_ok=0;
int             cnt_error=0;

int             compare_ok=0;
int             compare_error=0;

always #5 clk = ~clk;

arbiter #
(      
     .N      (   5   )
) 
uut
( 
    .rst        ( reset_p ),
    .req        ( req   ),
    .grant      ( grant ),
                    .* 
);


arbiter_m2 #
(      
     .N      (   5   )
) 
uut_m2
( 
    .rst        ( reset_p ),
    .req        ( req   ),
    .grant      ( grant_m2 ),
                    .* 
);

// Main process  
initial begin  

    automatic int args=-1;

    if( $value$plusargs( "test_id=%0d", args )) begin
        if( args>=0 && args<2 )
        test_id = args;

        $display( "args=%d  test_id=%d", args, test_id );
    end

        
  $display("arbiter     test_id=%d  name: %s  ", test_id, test_name[test_id]);

  reset_p <= #1 1;

  #200;

  @(posedge clk);
  
  reset_p <= #1 0;
  
  @(posedge clk iff test_stop | test_timeout );

  #200;

  //test_finish( test_id, test_name[test_id], flag_ok );

  test_finish( test_id, test_name[test_id], test_passed, cnt_ok );

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
            test_seq0();
            // fork
            //     test_seq_p0();    
            //     test_seq_p1();    
            // join
           
        end

        1: test_seq1_a1();
        // 1: begin
        //     fork
        //         test_seq1_a1();
        //         test_seq1_a2();
        //     join_any
        //end

    endcase    

    if( cnt_ok>0 && 0==cnt_error && compare_ok>0 && 0==compare_error)
        test_passed = 1;

    test_stop = 1;
end
  
always @(posedge clk iff ~reset_p )
    if( grant == grant_m2 )
        compare_ok++;
    else
        compare_error++;


task test_init;
    req <= '0;
    req_set <= '0;
endtask

always @(posedge clk) begin
    if( reset_p || mask_grant_clr )
        mask_grant <= #1 '0;
    else begin
        mask_grant <= #1 mask_grant | grant;
    end 
end

task test_seq0;

    @(posedge clk);

    req <= #1 5'b00001;
    @(posedge clk iff grant[0]);
    cnt_ok++;

    req <= #1 5'b00010;
    @(posedge clk iff grant[1]);
    cnt_ok++;

    req <= #1 5'b00100;
    @(posedge clk iff grant[2]);
    cnt_ok++;

    req <= #1 5'b01000;
    @(posedge clk iff grant[3]);
    cnt_ok++;

    req <= #1 5'b10000;
    @(posedge clk iff grant[4]);
    cnt_ok++;
    req <= #1 5'b00000;

    repeat (10) @(posedge clk);

    mask_grant_clr <= #1 1;
    @(posedge clk);
    mask_grant_clr <= #1 0;
    @(posedge clk);

    req <= #1 5'b11111;

    repeat (10) @(posedge clk);
    req <= #1 5'b00000;

    if( mask_grant==5'b11111)
        cnt_ok++;
    else
        cnt_error++;


    mask_grant_clr <= #1 1;
    @(posedge clk);
    mask_grant_clr <= #1 0;
    @(posedge clk);

    // req <= #1 5'b00100;
    // @(posedge clk);
    // req <= #1 5'b00101;
    // @(posedge clk);
    // req <= #1 5'b00111;
    // @(posedge clk);
    // req <= #1 5'b00101;
    // @(posedge clk);
    // req <= #1 5'b00111;
    // @(posedge clk);
    // req <= #1 5'b00101;
    // @(posedge clk);
    // req <= #1 5'b00111;
    // @(posedge clk);
    // req <= #1 5'b00101;
    // @(posedge clk);
    // req <= #1 5'b01111;
    // @(posedge clk);
    // req <= #1 5'b00101;
    // @(posedge clk);
    // req <= #1 5'b11111;

    // repeat (10) @(posedge clk);
    // req <= #1 5'b00000;

    // if( mask_grant==5'b00111)
    //     cnt_ok++;
    // else
    //     cnt_error++;

            

    mask_grant_clr <= #1 1;
    @(posedge clk);
    mask_grant_clr <= #1 0;
    @(posedge clk);
    
    req <= #1 5'b01100;
    @(posedge clk iff mask_grant==5'b01100);
    cnt_ok++;

    repeat (10) @(posedge clk);
    req <= #1 5'b00000;

    mask_grant_clr <= #1 1;
    @(posedge clk);
    mask_grant_clr <= #1 0;
    @(posedge clk);
    
    req <= #1 5'b00001;
    @(posedge clk iff mask_grant==5'b00001);
    cnt_ok++;

    repeat (10) @(posedge clk);
    
    req <= #1 5'b00000;



endtask

task test_seq1_a1;

    @(posedge clk);

    for( int ii=0; ii<34; ii++ ) begin
        req <= #1 req + 1;
        repeat (10) @(posedge clk);
    end

    req <= #1 5'b00000;

endtask



endmodule
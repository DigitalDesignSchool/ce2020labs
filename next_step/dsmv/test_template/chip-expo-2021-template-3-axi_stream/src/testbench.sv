// Code your testbench here
// or browse Examples


module tb
  ();
  
  int       test_id=0;
  
  string	test_name[1:0]=
  {
   "randomize", 
   "direct" 
  };
  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end


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
  
/////////////////////////////////////////////////////////////////

localparam  n = 5, nb = n * 8;

logic               clk=0;
logic               reset_n;

logic [nb*2 - 1:0]  in_tdata='0;
logic               in_tvalid='0;
logic               in_tready;

logic [nb - 1:0]    expect_tdata;
logic [nb - 1:0]    out_tdata;
logic               out_tvalid;
logic               out_tready='1;
  
int                 cnt_wr=0;
int                 cnt_rd=0;
int                 cnt_ok=0;  
int                 cnt_error=0;

logic               test_start=0;
logic               test_timeout=0;
logic               test_done=0;

int                 out_ready_cnt=0;

logic [7:0]         q_data  [$];

real               cv_all;

always #5 clk = ~clk;

// Unit under test
user_axis  
#( 
    .n ( n ) 
)  
uut
(  
    .*          // include all ports
);

// insert the component bind_user_axis into the component user_axis for simulation purpose
bind user_axis   bind_user_axis #( .n ( n ) )   dut(.*); 


initial begin
    #100000;
    $display( "Timeout");
    test_timeout = '1;
end


// Main process  
initial begin  

    automatic int args=-1;
    
    if( $value$plusargs( "test_id=%0d", args )) begin
        if( args>=0 && args<2 )
        test_id = args;

        $display( "args=%d  test_id=%d", args, test_id );

    end

    $display("chip-expo-2021-template-3-axi_stream  test_id=%d  name:", test_id, test_name[test_id] );
    
    reset_n = '0;

    #100;

    reset_n = '1;

    repeat (100) @(posedge clk );

    test_start <= #1 '1;


    @(posedge clk iff test_done=='1 || test_timeout=='1);

    if( test_timeout )
        cnt_error++;

    $display( "cnt_wr: %d", cnt_wr );
    $display( "cnt_rd: %d", cnt_rd );
    $display( "cnt_ok: %d", cnt_ok );
    $display( "cnt_error: %d", cnt_error );

    $display("overall coverage = %0f", $get_coverage());
    $display("coverage of covergroup cg = %0f", uut.dut.cg.get_coverage());
    $display("coverage of covergroup cg.in_tready  = %0f", uut.dut.cg.in_tready.get_coverage());
    $display("coverage of covergroup cg.in_tvalid  = %0f", uut.dut.cg.in_tvalid.get_coverage());
    $display("coverage of covergroup cg.out_tready = %0f", uut.dut.cg.out_tready.get_coverage());
    $display("coverage of covergroup cg.out_tvalid = %0f", uut.dut.cg.out_tvalid.get_coverage());
    $display("coverage of covergroup cg.i_vld_rdy  = %0f", uut.dut.cg.i_vld_rdy.get_coverage());
    $display("coverage of covergroup cg.o_vld_rdy  = %0f", uut.dut.cg.o_vld_rdy.get_coverage());

    if( 0==cnt_error && cnt_ok>0 )
        test_finish( test_id, test_name[test_id], 1 );
    else
        test_finish( test_id, test_name[test_id], 0 );

end
  
always @(posedge clk ) cv_all = $get_coverage();

// Generate test sequence 
initial begin

    @(posedge clk iff test_start=='1);
        
    case( test_id )
        0: begin
            // some action for test_id==0

                #500;
                @(posedge clk);
                write_data( "ABCDE", 0 );

                write_data( "FGHIJ", 2 );


                write_data( "KLMON", 0 );
                set_outready_cnt(4);
                write_data( "PQRST", 0 );
                write_data( "UVWXY", 0 );
                write_data( "Zabcd", 0 );
                
                
                set_outready_cnt(1);
                write_data( "efghi", 1 );
                write_data( "jklmo", 1 );
                set_outready_cnt(4);

                #100;

                write_data( "ABCDE", 0 );
                write_data( "FGHIJ", 0 );
                write_data( "KLMON", 1 ); // pause>0 is need before delay

                #100;

                write_data( "PQRST", 0 );
                write_data( "UVWXY", 0 );
                write_data( "Zabcd", 1 ); // pause>0 is need before delay

                #500;

                test_done=1;        
        end

        1: begin
            // some action for test_id==1
                #500;
                @(posedge clk);
                fork 
                write_seq();
                gen_out_tready();
                join
                #500;        
        end

    endcase
end

// Monitor
always @(posedge clk)
  if( out_tvalid & out_tready ) begin
    for( int ii=0; ii<n; ii++) begin
      expect_tdata[ii*8+:8] = q_data.pop_back();
    end

    if( expect_tdata==out_tdata ) begin
      cnt_ok++;

      if( cnt_ok<16 )
        $display( "output: %s  (%h)  ok: %-5d error: %-5d  - Ok", out_tdata, out_tdata, cnt_ok, cnt_error );
    end else begin
      cnt_error++;
      if( cnt_error<16 )
        $display( "output: %s  (%h)  expect %s (%h) ok: %-5d error: %-5d  - Error", out_tdata, out_tdata, expect_tdata, expect_tdata, cnt_ok, cnt_error );

    end

    cnt_rd++;
  end  

// Generate for out_tready signal
always @(posedge clk)
  if( out_ready_cnt>0 ) begin
      out_ready_cnt--;
      if( 0==out_ready_cnt )
        out_tready <= #1 '1;
  end  

task set_outready_cnt;
      input int cnt;        // number of delay for out_tready
begin
      out_tready <= #1 '0;
      out_ready_cnt = cnt;

end endtask


task gen_out_tready;
begin

  automatic int cnt_high;
  automatic int cnt_low;
  while(1) begin

    cnt_high = $urandom_range( 0, 6 );
    cnt_low  = $urandom_range( 1, 6 );

    @(posedge clk iff out_tready);

    if( test_done )
      break;

    if( cnt_high ) begin
        repeat(cnt_high) @(posedge clk);
    end
    set_outready_cnt( cnt_low );

  end
  
end endtask

// Driver
task write_data;
    input logic [nb-1:0]    data;
    input int               pause;  // 0 - tvalid still high
begin
      in_tdata  <= #1 data;
      in_tvalid <= #1 '1;

      for( int ii=0; ii<n; ii++ )
        q_data.push_front( data[ii*8+:8]);


      @(posedge clk iff in_tvalid & in_tready);
      cnt_wr++;
      if( cnt_wr<16 ) begin
        $display( "input: %s  (%h)", data, data );
      end

      if( pause>0 ) begin
        in_tvalid <= #1 '0;
        in_tdata  <= #1 '0;
        for( int ii=0; ii<pause; ii++ )
          @(posedge clk);
      end

end endtask


task write_seq;
begin
    automatic logic [7:0]  data_out=8'h41;
    automatic logic [nb*2-1:0]  val;
    automatic int pause;

    while(1) begin
        for( int jj=0; jj<500; jj++ ) begin

        pause = $urandom_range( 0, 3 );

        for( int ii=0; ii<n*2; ii++ ) begin
            val[ii*8+:8] = data_out;
            data_out++;
            if( 8'h5B==data_out )
            data_out=8'h41;

        end
        write_data( val, pause );
        end 
        if( 100==$get_coverage())
            break;
    end

    write_data( 0, 1 );


    #500;

    test_done=1;

end endtask

endmodule
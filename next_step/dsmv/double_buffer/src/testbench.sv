// Code your testbench here
// or browse Examples

`default_nettype none

module tb
  ();
  
  string	test_name[1:0]=
  {
   "randomize", 
   "direct" 
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
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TEST_PASSED", test_id, test_name );
        $display(      "test_id=%-5d test_name: %15s         TEST_PASSED", test_id, test_name );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TEST_FAILED *******", test_id, test_name );
        $display(      "test_id=%-5d test_name: %15s         TEST_FAILED *******", test_id, test_name );
    end

    $fclose( fd );
    
    $display("");
    $display("");

    $stop();
end endtask  
  
localparam  n = 4, nb = n * 8;
localparam  maxkeep = 2**n;

logic               aclk=0;
logic               aresetn;
logic               reset_p;

logic [nb - 1:0]    in_tdata='0;
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

int                 test_id=0;
logic               test_start=0;
logic               test_timeout=0;
logic               test_done=0;
int                 out_ready_cnt=0;

logic [7:0]         q_data  [$];

  

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end
always #5 aclk = ~aclk;
  
double_buffer  
#(
  .bits    ( nb )
)
 uut
(
    .rst                (   reset_p     ),
    .clk                (   aclk        ),
    .upstream_data      (   in_tdata    ),
    .upstream_valid     (   in_tvalid   ),
    .upstream_ready     (   in_tready   ),

    .downstream_data    (   out_tdata   ),
    .downstream_valid   (   out_tvalid  ),
    .downstream_ready   (   out_tready  )
);

assign  reset_p = ~aresetn;

task write_data;
    input logic [nb - 1:0]    data;
    input int                 pause;  // 0 - tvalid still high
begin
      in_tdata  <= #1 data;
      in_tvalid <= #1 '1;

      for( int ii=n-1; ii>=0; ii-- )
            q_data.push_front( data[(ii)*8+:8]);

      @(posedge aclk iff in_tvalid & in_tready);
      cnt_wr++;
      if( cnt_wr<16 ) begin
        $display( "input: %s  (%h) ", data, data, );
      end

      if( pause>0 ) begin
        in_tvalid <= #1 '0;
        in_tdata  <= #1 '0;
        for( int ii=0; ii<pause; ii++ )
          @(posedge aclk);
      end

end endtask


task write_seq;
begin
  automatic logic [7:0]       data_out=8'h41;
  automatic logic [nb*2-1:0]  val;
  automatic int               pause;

  //while(1) begin
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
  //   if( 100==$get_coverage())
  //     break;
  // end

  test_done=1;

end endtask

task set_outready_cnt;
      input int cnt;
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

    @(posedge aclk iff out_tready);

    if( test_done )
      break;

    if( cnt_high ) begin
        repeat(cnt_high) @(posedge aclk);
    end
    set_outready_cnt( cnt_low );

  end
  
end endtask

always @(posedge aclk)
  if( out_ready_cnt>0 ) begin
      out_ready_cnt--;
      if( 0==out_ready_cnt )
        out_tready <= #1 '1;
  end



always @(posedge aclk)
  if( out_tvalid & out_tready ) begin
    for( int ii=n-1; ii>=0; ii--) begin
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

initial begin

  @(posedge aclk iff test_start=='1);

  case( test_id )
  0: begin
      $display("Test 0: %s", test_name[0]);

            @(posedge aclk);

            write_data( "0123", 0 );
            write_data( "4567", 0 );
            write_data( "89ab", 1 );
            #500;

            set_outready_cnt( 4 );
            write_data( "0123", 0 );
            write_data( "4567", 0 );
            set_outready_cnt( 4 );
            write_data( "89ab", 1 );
            #500;

            write_data( "0123", 1 );
            write_data( "4567", 1 );
            write_data( "89ab", 1 );

            test_done=1;



  end
  1: begin
      $display("Test 1: %s", test_name[1]);
      fork
          write_seq();
          gen_out_tready();
      join
  end
  endcase

end 

initial begin
    #100000;
    $display( "Timeout");
    test_timeout = '1;
end

initial begin  
//   int fd = $fopen("test_id.txt", "r");
//   $fscanf( fd,"%d\n",test_id);
//   $fclose(fd );

  automatic int args=-1;
   
  if( $value$plusargs( "test_id=%0d", args )) begin
    if( args>=0 && args<2 )
      test_id = args;

    $display( "args=%d  test_id=%d", args, test_id );

  end


  $display("Test gearbox_packing test_id=%d  name:", test_id, test_name[test_id] );
  
  aresetn = '0;

  #100;

  aresetn = '1;

  @(posedge aclk );
  test_start = '1;

  @(posedge aclk iff test_done=='1 || test_timeout=='1);

  if( test_timeout )
    cnt_error++;

  $display( "cnt_wr: %d", cnt_wr );
  $display( "cnt_rd: %d", cnt_rd );
  $display( "cnt_ok: %d", cnt_ok );
  $display( "cnt_error: %d", cnt_error );


  // $display("overall coverage = %0f", $get_coverage());
  // $display("coverage of covergroup cg = %0f", uut.cg.get_coverage());
  // $display("coverage of covergroup cg.in_tready = %0f", uut.cg.in_tready.get_coverage());
  // $display("coverage of covergroup cg.in_tvalid = %0f", uut.cg.in_tvalid.get_coverage());
  // $display("coverage of covergroup cg.out_tready = %0f", uut.cg.out_tready.get_coverage());
  // $display("coverage of covergroup cg.out_tvalid = %0f", uut.cg.out_tvalid.get_coverage());
  // $display("coverage of covergroup cg.flag_hf = %0f", uut.cg.flag_hf.get_coverage());
  
  // $display("coverage of covergroup cg.i_vld_rdy = %0f", uut.cg.i_vld_rdy.get_coverage());
  // $display("coverage of covergroup cg.o_vld_rdy = %0f", uut.cg.o_vld_rdy.get_coverage());

  // $display("coverage of covergroup cg.o_rdy_transitions = %0f", uut.cg.o_rdy_transitions.get_coverage());
  

  if( 0==cnt_error && cnt_ok>0 )
    test_finish( test_id, test_name[test_id], 1 );  // test passed
  else
    test_finish( test_id, test_name[test_id], 0 );  // test failed



end

endmodule

`default_nettype wire


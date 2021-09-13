// Code your testbench here
// or browse Examples
`timescale 1 ns / 1 ns
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
        $display( "test_id=%-5d test_name: %15s         TEST_PASSED", test_id, test_name );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %15s         TEST_FAILED *******", test_id, test_name );
        $display( "test_id=%-5d test_name: %15s         TEST_FAILED *******", test_id, test_name );
    end

    $fclose( fd );

    $display("");
    $display("");

    $stop();
end endtask  
  


logic               aclk=0;
logic               aresetn;

logic [7:0]         in_tdata='0;
logic               in_tvalid='0;
logic               in_tready;

logic [15:0]        expect_tdata;
logic [15:0]        out_tdata;
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

logic [15:0]        q_data  [$];
int                 q_time_start [$];

int                 tick_current = 0;

localparam          MAX_TRANSACTION = 10000;
int                 calc_delay[MAX_TRANSACTION];

logic [15:0]        golden_mem[256];
  
logic [7:0]         rd_addr;
logic               rd_read;
logic [15:0]        rd_data;
logic               rd_valid;
logic [7:0]         wr_addr;
logic [15:0]        wr_data;
logic               wr_valid=0;

int                 curr_delay; 
int                 delay_min;
int                 delay_max;
real                delay_avr;
int                 cnt;
real                calc_velocity;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(2);
end
always #5 aclk = ~aclk;

ram256x16   ram
(
    .clk        ( aclk ),
                .*          
);

  
credit   uut
(
          .*
);


task write_memory;
    input logic [7:0]           addr;
    input logic [15:0]          data;

    golden_mem[addr] = data;

    @(posedge aclk);
    wr_valid <= #1 '1;
    wr_addr  <= #1 addr;
    wr_data  <= #1 data;
    @(posedge aclk);
    wr_valid <= #1 '0;

endtask


task write_data;
    input logic [7:0]       data;
    input int               pause;  // 0 - tvalid still high

      in_tdata  <= #1 data;
      in_tvalid <= #1 '1;

      q_data.push_front( golden_mem[data]);

      if( cnt_wr<MAX_TRANSACTION )
        q_time_start.push_front( tick_current );

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

endtask


task write_seq;
begin
  automatic logic [7:0]         val;
  automatic int                 pause;

  //while(1) begin
    for( int jj=0; jj<500; jj++ ) begin

      pause = $urandom_range( 0, 3 );
      val   = $urandom_range( 0, 255 );

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

    cnt_high = $urandom_range( 0, 24 );
    cnt_low  = $urandom_range( 1, 32 );

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

    expect_tdata = q_data.pop_back();

    if( expect_tdata==out_tdata ) begin
      cnt_ok++;

      if( cnt_ok<16 )
        $display( "output: %s  (%h)  ok: %-5d error: %-5d  - Ok", out_tdata, out_tdata, cnt_ok, cnt_error );
    end else begin
      cnt_error++;
      if( cnt_error<16 )
        $display( "output: %s  (%h)  expect %s (%h) ok: %-5d error: %-5d  - Error", out_tdata, out_tdata, expect_tdata, expect_tdata, cnt_ok, cnt_error );

    end

    if( cnt_rd < MAX_TRANSACTION ) begin
        calc_delay[cnt_rd] = tick_current - q_time_start.pop_back();
    end

    cnt_rd++;
  end

initial begin

  @(posedge aclk iff test_start=='1);

    for( int ii=0; ii<256; ii++ )
        write_memory( ii, 16'h0A00+ii );

  case( test_id )
  0: begin
        $display("Test 0: %s", test_name[0]);


        @(posedge aclk);

        write_data( 8'h00, 0 );
        write_data( 8'h01, 0 );
        write_data( 8'h02, 1 );
        #500;

        set_outready_cnt( 4 );
        write_data( 8'h10, 0 );
        write_data( 8'h11, 0 );
        write_data( 8'h12, 0 );
        write_data( 8'h13, 0 );
        write_data( 8'h14, 0 );
        write_data( 8'h15, 0 );
        write_data( 8'h16, 0 );
        write_data( 8'h17, 0 );
        write_data( 8'h18, 0 );
        write_data( 8'h19, 0 );
        write_data( 8'h1A, 0 );
        write_data( 8'h1B, 0 );
        write_data( 8'h1C, 0 );
        write_data( 8'h1D, 0 );
        write_data( 8'h1E, 0 );
        write_data( 8'h1F, 0 );

        set_outready_cnt( 4 );
        write_data( 8'h20, 2 );
        write_data( 8'h21, 2 );
        write_data( 8'h22, 1 );
        #500;

        set_outready_cnt( 12 );
        write_data( 8'h30, 0 );
        write_data( 8'h31, 0 );
        write_data( 8'h32, 0 );
        write_data( 8'h33, 0 );
        write_data( 8'h34, 0 );
        write_data( 8'h35, 0 );
        write_data( 8'h36, 0 );
        write_data( 8'h37, 0 );
        write_data( 8'h38, 0 );
        write_data( 8'h39, 1 );

        #500;

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

always_ff @(posedge aclk)
     if( test_start )
        tick_current <= #1 tick_current + 1;


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

    

  $display("Test test_id=%d  name:", test_id, test_name[test_id] );
  
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



    curr_delay = calc_delay[0]; 
    delay_min = curr_delay;
    delay_max = curr_delay;
    delay_avr = curr_delay;
    cnt = cnt_rd;

    if( cnt>MAX_TRANSACTION )
            cnt = MAX_TRANSACTION;

    for( int ii=1; ii<cnt; ii++ ) begin
        curr_delay = calc_delay[ii]; 

        if( curr_delay < delay_min )
            delay_min = curr_delay;

        if( curr_delay > delay_max )
            delay_max = curr_delay;

        delay_avr = delay_avr + curr_delay;
    end

    delay_avr /= cnt;

    calc_velocity = 1.0 * cnt_rd / tick_current;

    $display("");
    $display("");

    $display("Statistic:  min_delay: %2d   max_delay: %2d   avr_delay: %f   velocity: %f", delay_min, delay_max, delay_avr, calc_velocity );

    $display("");
    $display("");

  if( 0==cnt_error && cnt_ok>0 )
    test_finish( test_id, test_name[test_id], 1 );  // test passed
  else
    test_finish( test_id, test_name[test_id], 0 );  // test failed



end

endmodule

`default_nettype wire


`timescale 1 ns / 1 ns
`default_nettype none

`include "defines.svh"

/**
    ram_a содержит адрес и размер пакета который находится в памяти ram_b
    [15:8] - размер
    [7:0]  - адрес
*/

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

logic [15:0]        golden_mem_a[256];
logic [255:0]       golden_mem_b[256];
  
logic [7:0]         rd_a_addr;
logic               rd_a_read;
logic [15:0]        rd_a_data;
logic               rd_a_valid;
logic [7:0]         wr_a_addr;
logic [15:0]        wr_a_data;
logic               wr_a_valid=0;

logic [7:0]         rd_b_addr;
logic               rd_b_read;
logic [255:0]       rd_b_data;
logic               rd_b_valid;
logic [11:0]        wr_b_addr;
logic [15:0]        wr_b_data;
logic               wr_b_valid=0;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(2);
end
always #5 aclk = ~aclk;

ram256x16   ram_a
(
    .clk        (   aclk        ),

    .rd_addr    (   rd_a_addr   ),
    .rd_read    (   rd_a_read   ),
    .rd_data    (   rd_a_data   ),
    .rd_valid   (   rd_a_valid  ),

    .wr_addr    (   wr_a_addr   ),
    .wr_data    (   wr_a_data   ),
    .wr_valid   (   wr_a_valid  ),

                .*          
);

ram256x256   ram_b
(
    .clk        ( aclk ),

    .rd_addr    (   rd_b_addr   ),
    .rd_read    (   rd_b_read   ),
    .rd_data    (   rd_b_data   ),
    .rd_valid   (   rd_b_valid  ),

    .wr_addr    (   wr_b_addr   ),
    .wr_data    (   wr_b_data   ),
    .wr_valid   (   wr_b_valid  ),

                .*          
);

  
bind credit_return   binding_coverage_credit_return   dut(.*); 

credit_return   uut
(
          .*
);


task write_memory_a;
    input logic [7:0]           addr;
    input logic [15:0]          data;

    golden_mem_a[addr] = data;

    @(posedge aclk);
    wr_a_valid <= #1 '1;
    wr_a_addr  <= #1 addr;
    wr_a_data  <= #1 data;
    @(posedge aclk);
    wr_a_valid <= #1 '0;

endtask

task write_memory_b;
    input logic [11:0]          addr;
    input logic [15:0]          data;

    golden_mem_b[addr[11:4]][addr[3:0]*16+:16] = data;

    @(posedge aclk);
    wr_b_valid <= #1 '1;
    wr_b_addr  <= #1 addr;
    wr_b_data  <= #1 data;
    @(posedge aclk);
    wr_b_valid <= #1 '0;

endtask

logic [15:0]    data_a;
logic [255:0]   data_b;
logic [7:0]     size;
logic [7:0]     addr;


task write_data;
    input logic [7:0]       data;
    input int               pause;  // 0 - tvalid still high

    in_tdata  <= #1 data;
    in_tvalid <= #1 '1;

    data_a = golden_mem_a[data];
    size = data_a[11:8];
    if( 0==size )
        size = 16;
    addr = data_a[7:0];
    data_b = golden_mem_b[addr];
    for( int ii=0; ii<size; ii++ ) begin
        q_data.push_front( data_b[ii*16+:16] );
    end

    @(posedge aclk iff in_tvalid & in_tready);
    cnt_wr++;
    if( cnt_wr<16 ) begin
    $display( "input: %h ", data, );
    end

    if( pause>0 ) begin
    in_tvalid <= #1 '0;
    in_tdata  <= #1 '0;
    for( int ii=0; ii<pause; ii++ )
        @(posedge aclk);
    end

endtask


task write_seq;
    input int   count;
    input int   max_pause;
begin
  automatic logic [7:0]         val;
  automatic int                 pause;

  //while(1) begin
    for( int jj=0; jj<count; jj++ ) begin

      pause = $urandom_range( 0, max_pause );
      val   = $urandom_range( 0, 15 );

      write_data( val, pause );
    end 
    write_data( 8'h0F, 1 );
  //   if( 100==$get_coverage())
  //     break;
  // end


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

    cnt_high = $urandom_range( 0, 48 );
    cnt_low  = $urandom_range( 1, 48 );

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
        $display( "output: %h  ok: %-5d error: %-5d  - Ok", out_tdata, cnt_ok, cnt_error );
    end else begin
      cnt_error++;
      if( cnt_error<16 )
        $display( "output: %h  expect %h ok: %-5d error: %-5d  - Error", out_tdata, expect_tdata, cnt_ok, cnt_error );

    end

    cnt_rd++;
  end

logic [15:0]    val;
initial begin

  @(posedge aclk iff test_start=='1);

    for( int ii=0; ii<4096; ii++ )
        write_memory_b( ii, 16'h0A00+ii );

    for( int ii=0; ii<256; ii++ )
        write_memory_a( ii, 16'h0000 );

    for( int ii=0; ii<16; ii++ ) begin
        val[15:8] = ii+1;
        val[7:0]  = ii*2;
        write_memory_a( ii, val );
    end


  case( test_id )
  0: begin
        $display("Test 0: %s", test_name[0]);


        @(posedge aclk);

        write_data( 8'h0F, 1 );
        #500;

        set_outready_cnt( 128 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 0 );
        write_data( 8'h0F, 1 );
        #500;

        write_data( 8'h0E, 1 );
        #500;

        write_data( 8'h00, 0 );
        write_data( 8'h01, 0 );
        write_data( 8'h02, 1 );
        write_data( 8'h03, 1 );
        write_data( 8'h04, 1 );
        write_data( 8'h05, 1 );
        write_data( 8'h06, 1 );
        write_data( 8'h07, 1 );
        write_data( 8'h08, 1 );
        write_data( 8'h09, 1 );
        write_data( 8'h0A, 1 );
        write_data( 8'h0B, 1 );
        write_data( 8'h0C, 1 );
        write_data( 8'h0D, 1 );
        write_data( 8'h0E, 1 );
        write_data( 8'h0F, 1 );
        #500;


        #500;

        test_done=1;



  end
  1: begin
      $display("Test 1: %s", test_name[1]);
      fork
          begin
              write_seq( 500, 8);
              #500;
              write_seq( 200, 1000);
              #500;
              write_seq( 100, 5000);
              #500;
              test_done=1;
          end

          gen_out_tready();
      join
      #500;

  end
  endcase

end 

initial begin
    #80000000;
    $display( "Timeout");
    test_timeout = '1;
end

initial begin  
//   int fd = $fopen("test_id.txt", "r");
//   $fscanf( fd,"%d\n",test_id);
//   $fclose(fd );

  int args=-1;
   
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

`ifdef COVERAGE
   $display("overall coverage = %0f", $get_coverage());
   $display("coverage of covergroup cg = %0f", uut.dut.cg.get_coverage());
  // $display("coverage of covergroup cg.in_tready = %0f", uut.cg.in_tready.get_coverage());
  // $display("coverage of covergroup cg.in_tvalid = %0f", uut.cg.in_tvalid.get_coverage());
  // $display("coverage of covergroup cg.out_tready = %0f", uut.cg.out_tready.get_coverage());
  // $display("coverage of covergroup cg.out_tvalid = %0f", uut.cg.out_tvalid.get_coverage());
  // $display("coverage of covergroup cg.flag_hf = %0f", uut.cg.flag_hf.get_coverage());
  
  // $display("coverage of covergroup cg.i_vld_rdy = %0f", uut.cg.i_vld_rdy.get_coverage());
  // $display("coverage of covergroup cg.o_vld_rdy = %0f", uut.cg.o_vld_rdy.get_coverage());

  // $display("coverage of covergroup cg.o_rdy_transitions = %0f", uut.cg.o_rdy_transitions.get_coverage());
  
`endif
  if( 0==cnt_error && cnt_ok>0 )
    test_finish( test_id, test_name[test_id], 1 );  // test passed
  else
    test_finish( test_id, test_name[test_id], 0 );  // test failed



end

endmodule

`default_nettype wire


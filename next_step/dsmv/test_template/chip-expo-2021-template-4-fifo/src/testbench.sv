// Code your testbench here
// or browse Examples


module tb
  ();
  
  int       test_id=0;
  
  string	test_name[3:0]=
  {
   "randomize", 
   "low_write_high_read", 
   "high_write_low_read", 
   "direct_base" 
  };
  
localparam  WIDTH = 16;

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
        $fdisplay( fd, "test_id=%-5d test_name: %25s         TEST_PASSED", 
        test_id, test_name );
        $display(      "test_id=%-5d test_name: %25s         TEST_PASSED", 
        test_id, test_name );
    end else begin
        $fdisplay( fd, "test_id=%-5d test_name: %25s         TEST_FAILED *******", 
        test_id, test_name );
        $display(      "test_id=%-5d test_name: %25s         TEST_FAILED *******", 
        test_id, test_name );
    end

    $fclose( fd );

    $display("");
    $display("");

    $finish();
end endtask  
  
/////////////////////////////////////////////////////////////////


logic                   reset_p;    //! 1 - reset
logic                   clk=0;        //! clock
logic    [WIDTH-1:0]    data_i=0;
logic                   data_we=0;
logic    [WIDTH-1:0]    data_o;
logic                   data_rd=0;
logic                   full;
logic                   empty;

int                     cnt_wr=0;
int                     cnt_rd=0;
int                     cnt_ok=0;  
int                     cnt_error=0;

int                     show_ok=0;
int                     show_error=0;

logic                   test_start=0;
logic                   test_timeout=0;
logic                   test_done=0;

int                     tick_current=0;

logic [WIDTH-1:0]       q_data [$];
int                     q_start_time[$];

logic [WIDTH-1:0]       expect_data;

localparam  MAX_TRANSACTION = 10000;

int                     delay[MAX_TRANSACTION];
int                     delay_min;
int                     delay_max;
real                    delay_avr;
real                    velocity;

real                    cv_all;

always #5 clk = ~clk;

// Unit under test
fifo_w8 
#(
    .WIDTH      (   WIDTH   )
)    
uut
(
                .*  // include all ports
);


// Insert the component bind_fifo_w8 into the component fifo_w8 for simulation purpose
bind fifo_w8   bind_fifo_w8 #( .WIDTH ( WIDTH ) )   dut(.*); 

always @(posedge clk ) cv_all = $get_coverage();


initial begin
    #400000;
    $display( "Timeout");
    test_timeout = '1;
end


// Main process  
initial begin  

    automatic int args=-1;
    automatic int current_delay;
    automatic int cnt;

   
    if( $value$plusargs( "test_id=%0d", args )) begin
        if( args>=0 && args<4 )
        test_id = args;

        $display( "args=%d  test_id=%d", args, test_id );

    end

    $display("chip-expo-2021-template-4-fifo  test_id=%d  name: %s", test_id, test_name[test_id] );
    
    reset_p <= #1 '1;

    #100;

    reset_p <= #1 '0;

    repeat (100) @(posedge clk );

    test_start <= #1 '1;

    @(posedge clk iff test_done=='1 || test_timeout=='1);

    if( test_timeout )
        cnt_error++;

    $display( "cnt_wr: %d", cnt_wr );
    $display( "cnt_rd: %d", cnt_rd );
    $display( "cnt_ok: %d", cnt_ok );
    $display( "cnt_error: %d", cnt_error );

    current_delay = delay[0];
    delay_min = current_delay;
    delay_max = current_delay;
    delay_avr = current_delay;

    cnt = cnt_rd;
    if( cnt>MAX_TRANSACTION )
        cnt = MAX_TRANSACTION;

    for( int ii=1; ii<cnt; ii++ ) begin
        current_delay = delay[ii];

        if( current_delay < delay_min )
            delay_min = current_delay;

        if( current_delay > delay_max )
            delay_max = current_delay;

        delay_avr += current_delay;
    end

    delay_avr /= cnt;

    velocity = 1.0 * cnt_rd / tick_current;

    $display("");
    $display("");

    $display("Statistics -  min_delay: %-4d max_delay: %-4d  avr_delay: %-6.3f  velocity: %f Tr/clock",
        delay_min, delay_max, delay_avr, velocity
    );

    $display("overall coverage = %0f", $get_coverage());
    $display("coverage of covergroup cg = %0f", uut.dut.cg.get_coverage());
    $display("coverage of covergroup cg.data_we  = %0f", uut.dut.cg.data_we.get_coverage());
    $display("coverage of covergroup cg.full     = %0f", uut.dut.cg.full.get_coverage());
    $display("coverage of covergroup cg.data_rd  = %0f", uut.dut.cg.data_rd.get_coverage());
    $display("coverage of covergroup cg.empty    = %0f", uut.dut.cg.empty.get_coverage());
    $display("coverage of covergroup cg.cnt_wr   = %0f", uut.dut.cg.cnt_wr.get_coverage());
    $display("coverage of covergroup cg.cnt_rd   = %0f", uut.dut.cg.cnt_rd.get_coverage());    

    if( 0==cnt_error && cnt_ok>0 )
        test_finish( test_id, test_name[test_id], 1 );  // test passed
    else
        test_finish( test_id, test_name[test_id], 0 );  // test failed



end
  

always @(posedge clk)  if( test_start ) tick_current <= #1 tick_current+1;

// Generate test sequence 
initial begin

  @(posedge clk iff test_start=='1);

  case( test_id )
  0: begin
          fork
            test_seq0_write();
            test_seq0_read();
          join
  end
  1: begin
          fork
            test_seq1_write();
            test_seq1_read();
          join
  end

  2: begin
          fork
            test_seq2_write();
            test_seq2_read();
          join
  end

  3: begin
           fork 
            test_seq3_write();
            test_seq3_read();
           join
  end

  endcase


  #500;

  test_done=1;

end 

task sync_write;
    input int cnt;

    @(posedge clk iff tick_current==cnt);

endtask

task sync_read;
    input int sync_tick;

    @(posedge clk iff tick_current==sync_tick);

endtask

task write_data;
        input logic [WIDTH-1:0]     data;
        input int                   next_delay;

        data_i <= #1 data;
        data_we <= #1 '1;
        q_data.push_back( data );
        q_start_time.push_back( tick_current );

        @(posedge clk iff ~full);
        if( next_delay>0 ) begin
            data_i <= #1 '0;
            data_we <= #1 '0;

            repeat(next_delay) @(posedge clk);
        end
        cnt_wr++;
endtask

task read_data;
        input int   next_delay;
        data_rd <= #1 '1;
        @(posedge clk iff data_rd & ~empty);

        expect_data = q_data.pop_front();

        if( expect_data==data_o ) begin
            cnt_ok++;
            if( cnt_ok<16 ) begin
                    $display("cnt_ok: %-4d  cnt_error: %-4d  expect: %h  read: %h - OK",
                        cnt_ok, cnt_error, expect_data, data_o 
                    );
            end
        end else begin
            cnt_error++;
            if( cnt_error<16 ) begin
                    $display("cnt_ok: %-4d  cnt_error: %-4d  expect: %h  read: %h - ERROR",
                        cnt_ok, cnt_error, expect_data, data_o 
                    );
            end

        end


        if( cnt_rd < MAX_TRANSACTION )
            delay[cnt_rd] = tick_current - q_start_time.pop_front();
        
        if( next_delay>0 ) begin
            data_rd <= #1 '0;
            repeat(next_delay) @(posedge clk);
        end        
        cnt_rd++;
endtask

task test_seq0_write;

        write_data( 16'hA010, 1 );

        sync_write( 'h80 );

        write_data( 16'hA011, 1 );
        write_data( 16'hA012, 1 );

        sync_write( 'h90 );

        write_data( 16'hA013, 0 );
        write_data( 16'hA014, 0 );
        write_data( 16'hA015, 0 );
        write_data( 16'hA016, 0 );
        write_data( 16'hA017, 0 );
        write_data( 16'hA018, 1 );

        sync_write( 'hb0 );

        for( int ii=0; ii<32; ii++ )
            write_data( 16'hA020+ii, 0 );

        write_data( 16'hA000, 1 );

endtask;



task test_seq0_read;

        read_data( 2 );
        read_data( 2 );
        read_data( 2 );

        sync_read( 'hA0 );

        read_data( 0 );
        read_data( 0 );
        read_data( 0 );
        read_data( 0 );
        read_data( 0 );
        read_data( 1 );

        sync_read( 'hb5 );

        for( int ii=0; ii<32; ii++ )
            read_data( 0 );

        read_data( 1 );

        
endtask;


task test_seq1_write;

        for( int ii=0; ii<1000; ii++ )
            write_data( 16'hA020+ii, 0 );

        write_data( 16'hA000, 1 );

endtask;



task test_seq1_read;


        for( int ii=0; ii<1000; ii++ ) begin
            automatic int delay = $urandom_range( 1, 5 );
            read_data( delay );
        end

        read_data( 1 );

        
endtask;



task test_seq2_write;

        for( int ii=0; ii<1000; ii++ ) begin
            automatic int delay = $urandom_range( 1, 5 );
            write_data( 16'hA020+ii, delay );
        end

        write_data( 16'hA000, 1 );

endtask;



task test_seq2_read;


        for( int ii=0; ii<1000; ii++ ) begin
            read_data( 0 );
        end

        read_data( 1 );

        
endtask;


task test_seq3_write;

        while( 1 ) begin
            for( int ii=0; ii<1000; ii++ ) begin
                automatic int delay = $urandom_range( 0, 15 );
                automatic int data  = $urandom_range( 0, 65535 );
                write_data( data, delay );
            end
            if( 100==$get_coverage())
                break;
        end


        write_data( 16'hA000, 1 );

endtask;



task test_seq3_read;

        while( 1 ) begin
            for( int ii=0; ii<1000; ii++ ) begin
                automatic int delay = $urandom_range( 0, 15 );
                read_data( delay );
            end
            if( 100==$get_coverage())
                break;
        end

        read_data( 1 );

        
endtask;
endmodule
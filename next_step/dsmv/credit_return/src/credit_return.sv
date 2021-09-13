// Code your design here
`timescale 1 ns / 1 ns
`default_nettype none 

`include "defines.svh"


module credit_return
(
  input  wire               aclk,
  input  wire               aresetn,

  input  wire [7:0]         in_tdata,
  input  wire               in_tvalid,
  output reg                in_tready,

  output wire [7:0]         rd_a_addr,
  output wire               rd_a_read,
  input  wire [15:0]        rd_a_data,
  input  wire               rd_a_valid,  

  output wire [7:0]         rd_b_addr,
  output wire               rd_b_read,
  input  wire [255:0]       rd_b_data,
  input  wire               rd_b_valid,  

  output wire [15:0]        out_tdata,
  output wire               out_tvalid,
  input  wire               out_tready
);

logic               fifo_rd;
logic               fifo_full;
logic               fifo_empty;
logic               rstp;

logic [6:0]         crd_cnt;
logic [6:0]         n_crd_cnt;
logic               is_write;
logic               is_read;
logic [3:0][3:0]    size_z;

assign rd_a_addr = in_tdata;
assign rd_a_read = in_tready & in_tvalid;


assign out_tvalid = ~fifo_empty;
assign fifo_rd = ~fifo_empty & out_tready;

always @(posedge aclk) rstp <= #1 ~aresetn;

assign in_tready = crd_cnt[6];

assign is_write = in_tvalid & in_tready;
assign is_read  = out_tvalid & out_tready;

assign rd_b_addr = rd_a_data[7:0];
assign rd_b_read = rd_a_valid;

logic [4:0]     n_write;

always_comb begin

    if( 0==rd_a_data[11:8] )
        n_write = 16;
    else
        n_write = rd_a_data[11:8];

    n_crd_cnt = crd_cnt;

    if( is_write )
        n_crd_cnt = n_crd_cnt - 16;

    if( is_read )
        n_crd_cnt = n_crd_cnt + 1;

    if( rd_a_valid )
        n_crd_cnt = n_crd_cnt + (16-n_write);

end



always_ff @(posedge aclk)
    if( rstp )
        crd_cnt <= #1 7'b1000000;
    else
        crd_cnt <= #1 n_crd_cnt;

always_ff @(posedge aclk) begin

    for( int ii=0; ii<3; ii++ )
        size_z[ii+1] <= #1 size_z[ii];

    size_z[0] <= #1 rd_a_data[11:8];
end


fifo_256
fifo
(
    .reset_p            (   rstp    ),    //! 1 - reset
    .clk                (   aclk    ),        //! clock

    .data_i             (   rd_b_data   ),
    .size_i             (   size_z[3]   ),     //! число слов на data_i, 0 - 16 слов
    .data_we            (   rd_b_valid  ),

    .data_o             (   out_tdata   ),
    .data_rd            (   fifo_rd     ),

    .full               (   fifo_full   ),
    .empty              (   fifo_empty  )

);
  

endmodule

`default_nettype wire
// Code your design here
`timescale 1 ns / 1 ns
`default_nettype none 

module conv_with_fifo
(
  input  wire               aclk,
  input  wire               aresetn,

  input  wire [7:0]         in_tdata,
  input  wire               in_tvalid,
  output reg                in_tready,

  output wire [7:0]         rd_addr,
  output wire               rd_read,
  input  wire [15:0]        rd_data,
  input  wire               rd_valid,  

  output wire [15:0]        out_tdata,
  output wire               out_tvalid,
  input  wire               out_tready
);

logic           fifo_rd;
logic           fifo_full;
logic           fifo_empty;
logic           rstp;
logic           fifo_prog_full;

assign rd_addr = in_tdata;
assign rd_read = in_tready & in_tvalid;


assign out_tvalid = ~fifo_empty;
assign fifo_rd = ~fifo_empty & out_tready;

always @(posedge aclk) rstp <= #1 ~aresetn;

assign in_tready = ~fifo_prog_full;

fifo_w8
#(
    .WIDTH              (   16  )
)    
fifo
(
    .reset_p            (   rstp    ),    //! 1 - reset
    .clk                (   aclk    ),        //! clock

    .data_i             (   rd_data  ),
    .data_we            (   rd_valid ),

    .data_o             (   out_tdata   ),
    .data_rd            (   fifo_rd     ),

    .prog_full          (   fifo_prog_full  ),
    .full               (   fifo_full   ),
    .empty              (   fifo_empty  )

);
  

endmodule

`default_nettype wire
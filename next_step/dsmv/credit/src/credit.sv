// Code your design here
`timescale 1 ns / 1 ns
`default_nettype none 

module credit
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

logic [3:0]     crd_cnt;
logic           is_write;
logic           is_read;

assign rd_addr = in_tdata;
assign rd_read = in_tready & in_tvalid;


assign out_tvalid = ~fifo_empty;
assign fifo_rd = ~fifo_empty & out_tready;

always @(posedge aclk) rstp <= #1 ~aresetn;

assign in_tready = crd_cnt[3];

assign is_write = in_tvalid & in_tready;
assign is_read  = out_tvalid & out_tready;

always @(posedge aclk)
    if( rstp )
        crd_cnt <= 4'b1111;
    else
        case( {is_write, is_read})
            2'b01: crd_cnt <= #1 crd_cnt + 1; // read
            2'b10: crd_cnt <= #1 crd_cnt - 1; // write

            // 2'b11 - write and read - do not change
            // 2'b00 - no operation   - do not change
        endcase

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

    .full               (   fifo_full   ),
    .empty              (   fifo_empty  )

);
  

endmodule

`default_nettype wire
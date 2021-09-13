// Code your design here
`default_nettype none 

module double_buffer_wrp
# (
  parameter n = 5, nb = n * 8
)
(
  input  wire             aclk,
  input  wire             aresetn,

  input  wire [nb - 1:0]  in_tdata,
  input  wire             in_tvalid,
  output reg              in_tready,

  output reg [nb - 1:0]   out_tdata,
  output reg              out_tvalid,
  input  reg              out_tready
);

logic  rst;

assign rst = ~aresetn;

double_buffer  
#(
  .bits    ( nb )
)
 uut
(
    .rst                (   rst         ),
    .clk                (   aclk        ),
    .upstream_data      (   in_tdata    ),
    .upstream_valid     (   in_tvalid   ),
    .upstream_ready     (   in_tready   ),

    .downstream_data    (   out_tdata   ),
    .downstream_valid   (   out_tvalid  ),
    .downstream_ready   (   out_tready  )
);

endmodule

`default_nettype wire
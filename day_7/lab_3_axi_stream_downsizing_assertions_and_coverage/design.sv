// downsizing example is created by Yuri Panchul, Dmitry Smekhov and Yaroslav Kolbasov
// To run this example in EDA Playground, use https://edaplayground.com/x/rrPv

`include "defines.svh"

module downsizing
#(
  parameter W = 32
)
(
  input aclk,
  input aresetn,

  input      [W * 2 - 1:0]  in_tdata,
  input                     in_tvalid,
  output                    in_tready,

  output reg [W      - 1:0] out_tdata,
  output reg                out_tvalid,
  input                     out_tready
);

  reg sel;

  always @ (posedge aclk)
    if (~ aresetn)
      sel <= '0;
    else if (out_tvalid & out_tready)
      sel <= ~ sel;

  assign out_tdata  = sel ? in_tdata [W - 1:0] : in_tdata [W * 2 - 1 : W];
  assign in_tready  = sel & out_tready;
  assign out_tvalid = in_tvalid;

endmodule

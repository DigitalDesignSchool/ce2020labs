// downsizing example is created by Yuri Panchul, Dmitry Smekhov and Yaroslav Kolbasov

`include "defines.svh"

module downsizing_assertions
#(
  parameter W = 32
)
(
  input aclk,
  input aresetn,

  input     [W * 2 - 1:0]  in_tdata,
  input                    in_tvalid,
  input                    in_tready,

  input reg [W      - 1:0] out_tdata,
  input reg                out_tvalid,
  input                    out_tready
);

  keep_in_tvalid_until_in_tready: assert property
    (@ (posedge aclk) disable iff (~ aresetn)
        in_tvalid & ~ in_tready |-> ##1 in_tvalid)
    else
        $fatal ("in_tvalid is removed before getting in_tready");

  // TODO Exercise 2: write an assertion stating that
  // we expect two (out_tvalid & out_tready) events
  // after every (in_valid & in_ready).

endmodule

bind downsizing downsizing_assertions # (.W (W)) assertions (.*);

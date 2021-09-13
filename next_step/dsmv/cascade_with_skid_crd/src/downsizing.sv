// Code your design here
`default_nettype none 

module downsizing
# (
  parameter n = 5, nb = n * 8
)
(
  input  wire             aclk,
  input  wire             aresetn,

  input  wire [nb*2 - 1:0]  in_tdata,
  input  wire             in_tvalid,
  output wire             in_tready,

  output wire [nb - 1:0] out_tdata,
  output wire             out_tvalid,
  input  wire             out_tready
);

logic             flag_hf;


always @(posedge aclk)
  if( ~aresetn )
    flag_hf <= #1 '0;
  else if( out_tvalid & out_tready )
    flag_hf <= #1 ~flag_hf;



assign   out_tdata = (flag_hf) ?  in_tdata[0+:nb] : in_tdata[nb+:nb];

assign in_tready = flag_hf & out_tready;

assign out_tvalid = in_tvalid;

  


endmodule

`default_nettype wire
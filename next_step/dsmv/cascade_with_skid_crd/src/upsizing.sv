// Code your design here

`default_nettype none 

module upsizing
# (
  parameter n = 5, nb = n * 8
)
(
  input  wire             aclk,
  input  wire             aresetn,

  input  wire [nb - 1:0]  in_tdata,
  input  wire             in_tvalid,
  output wire             in_tready,

  output wire [nb*2- 1:0] out_tdata,
  output wire             out_tvalid,
  input  wire             out_tready
);

logic             flag_hf;
logic [nb-1:0]    reg_hf;

always @(posedge aclk)
  if( ~aresetn )
    flag_hf <= #1 '0;
  else if( in_tvalid & in_tready )
    flag_hf <= #1 ~flag_hf;

always  @(posedge aclk) 
  if( in_tvalid & in_tready & ~flag_hf )
    reg_hf <= #1 in_tdata;

assign out_tdata = { reg_hf, in_tdata };

assign in_tready = ~flag_hf | out_tready;

assign out_tvalid = flag_hf & in_tvalid;





endmodule

`default_nettype wire
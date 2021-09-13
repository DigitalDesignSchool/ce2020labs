// Example component

`default_nettype none 

module user_axis
# (
  parameter                 n = 5,          //! Number of bytes
  parameter                 nb = n * 8      //! Number of bits
)
(
  input  wire               clk,            //! clok
  input  wire               reset_n,        //! 0 - reset

  input  wire [nb*2 - 1:0]  in_tdata,       //! input data
  input  wire               in_tvalid,      //! 1 - input data is valid
  output wire               in_tready,      //! 1 - ready for get data

  output wire [nb - 1:0]    out_tdata,      //! output data
  output wire               out_tvalid,     //! 1 - output data is valid
  input  wire               out_tready      //! 1 - ready for get data
);

assign out_tdata    = in_tdata;
assign out_tvalid   = in_tvalid  & reset_n;
assign in_tready    = out_tready & reset_n;

endmodule

`default_nettype wire
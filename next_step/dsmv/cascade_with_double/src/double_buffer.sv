// Code your design here
`default_nettype none 


module double_buffer
# (
  parameter bits = 32
)
(
  input  wire             clk,
  input  wire             rst,

  input  wire [bits - 1:0]  upstream_data,
  input  wire               upstream_valid,
  output reg                upstream_ready,

  output reg [bits - 1:0]   downstream_data,
  output reg                downstream_valid,
  input  reg                downstream_ready
);
  
logic [bits-1:0]     data_a;
logic [bits-1:0]     data_b;
logic                valid_a, valid_b;

logic [bits-1:0]     data_a_nxt, data_b_nxt;
logic                valid_a_nxt, valid_b_nxt;

assign  downstream_data = data_a;
assign  downstream_valid = valid_a;

assign data_b_nxt   =
    rst ? 0
        : ( ~downstream_ready & upstream_ready  ? upstream_data 
                                                : data_b );

assign data_a_nxt = 
    rst ? 0
        : ( ~downstream_ready   ? data_a
                                : (upstream_ready   ? upstream_data   
                                                    : data_b ));

assign valid_b_nxt = 
    rst ? 0
        : ( ~downstream_ready & upstream_ready  ? upstream_valid
                                                : valid_b);

assign valid_a_nxt = 
    rst ? 0
        : ( ~downstream_ready   ? valid_a
                                : (upstream_ready   ? upstream_valid   
                                                    : valid_b ));

wire    upstream_ready_nxt = rst ? 1: downstream_ready;

always_ff @(posedge clk) begin
    
    data_a <= #1 data_a_nxt;
    data_b <= #1 data_b_nxt;

    valid_a <= #1 valid_a_nxt;
    valid_b <= #1 valid_b_nxt;

    upstream_ready <= #1 upstream_ready_nxt;
end

endmodule

`default_nettype wire
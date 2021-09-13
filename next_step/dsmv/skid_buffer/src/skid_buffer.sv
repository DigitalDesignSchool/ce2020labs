// Code your design here
`default_nettype none 

module skid_buffer
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
  input  wire             out_tready
);


(* keep = "true" *) logic [1:0]         state; // 10 - empty, 11 - half, 01 - full
logic [nb-1:0]      buf_tdata;

logic               is_write;
logic               is_read;

(* keep = "true" *) logic               in_ready_i;

assign  is_write    = in_tvalid & in_ready_i;
assign  is_read     = out_tvalid & out_tready;

assign in_tready    = state[1];
assign out_tvalid   = state[0];


always_ff @(posedge aclk) begin

    if( is_write )
        buf_tdata <= #1 in_tdata;

    case( state )
        2'b10: begin // empty: in_tready=1, out_tvalid=0
            out_tdata <= #1 in_tdata;
            if( is_write ) begin
                state <= #1 2'b11;
            end
            in_ready_i <= #1 '1;
        end

        2'b11: begin // half: in_tready=1, out_tvalid=1
            case( {is_write, is_read })
                2'b01: begin  // read
                        state <= #1 2'b10;
                end

                2'b10: begin   // write
                        state <= #1 2'b01;
                        in_ready_i <= #1 '0;
                end

                2'b11: begin   // write & read
                    out_tdata <= #1 in_tdata;
                end
            endcase

        end

        2'b01: begin    // full: in_tready=0, out_tvalid=1
               if( is_read ) begin
                   state <= #1 2'b11;
                   out_tdata <= #1 buf_tdata;
                   in_ready_i <= #1 '1;
               end 
        end

    endcase

    if( ~aresetn ) begin
        state <= 2'b10;
    end 
end
  
endmodule

`default_nettype wire
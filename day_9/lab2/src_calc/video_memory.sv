`default_nettype none

module video_memory
#(
    parameter   [7:0]               INIT_VALUE                  
)
(
    input wire                      clk,
    input wire                      reset_p,
    output wire                     reset_done,

    // Read port 
    input wire  [11:0]              r_addr,
    output reg [7:0]                r_data,
    
    // Write port 
    input wire [11:0]               w_addr,
    input wire [7:0]                w_data,
    input wire				        w_valid
  );

// Memory
reg [11:0] memory [4096];

logic [11:0]      w_addr_x;
logic [7:0]       w_data_x;
logic             w_valid_x;
  
logic [1:0]       stp;
logic [12:0]      cnt;

logic             rstp;

always @(posedge clk)  rstp <= #1 reset_p;

always @(posedge clk) begin

    case( stp )
        0: begin
            cnt <= #1 '0;
            stp <= 1;
        end

        1: begin
            cnt <= #1 cnt + 1;
            if( cnt[12] )
                stp <= #1 2;
        end

    endcase

    if( rstp )
        stp <= #1 0;

end

assign w_addr_x = (cnt[12]) ? w_addr : cnt[11:0];
assign w_data_x = (cnt[12]) ? w_data : INIT_VALUE;
assign w_valid_x = (cnt[12]) ? w_valid : 1;

assign reset_done = cnt[12];

// Write data to memory
always @(posedge clk)
    if( w_valid_x )    
        memory[w_addr_x] <= #1 w_data_x;

always @(posedge clk)   r_data <= #1 memory[r_addr];     

endmodule

`default_nettype wire
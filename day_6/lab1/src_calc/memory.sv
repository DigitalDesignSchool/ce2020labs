`default_nettype none
/* 
 * Pseudo dual port memory (1 read port and 1 write port)
 * with read latency
 */
module pseudo_dual_port_memory
  #(
    parameter  DATA_WIDTH = 32,
    parameter  ADDR_WIDTH = 4,
    parameter  DATA_LAT   = 2,		   		    // Delay in cycles between data request and data output 
    parameter  ADDR_MAX   = {ADDR_WIDTH{1'b1}} 	// 2 ^ ADDR_WIDTH -1
  )(
    input wire clk,
    input wire rst,

    // Read port 
    input wire [ADDR_WIDTH-1:0]  r_addr,
    input wire      		 	 r_avalid,

    output wire				     r_dvalid,
    output wire [DATA_WIDTH-1:0] r_data,
    
    // Write port 
    input wire [ADDR_WIDTH-1:0]  w_addr,
    input wire [DATA_WIDTH-1:0]  w_data,
    input wire				     w_valid
  );

  // Memory as multi-dimensional array
  reg [DATA_WIDTH-1:0] memory [ADDR_MAX-1:0];

  // Write data to memory
  always @(posedge clk)
    if( w_valid )    
      memory[w_addr] <= #1 w_data;

  // Read data from memory with latency
  reg 			       r_dvalid_shift [DATA_LAT-1:0];
  reg [DATA_WIDTH-1:0] r_data_shift   [DATA_LAT-1:0];

  always @(posedge clk) begin
    if (rst)
      r_dvalid_shift <= #1 '{DATA_LAT{0}};
    else begin
      r_dvalid_shift[0] <= #1 r_avalid;

      // Forwarding
      if( w_valid && w_addr == r_addr )
        r_data_shift[0]  <= #1 w_data;
      else 
        r_data_shift[0]  <= #1 memory[r_addr];

      // Shifting
      for (int i = 1; i < DATA_LAT; i++) begin
        r_dvalid_shift[i] <= #1 r_dvalid_shift[i - 1];
        r_data_shift[i]   <= #1 r_data_shift[i - 1];
      end
    end
  end
  
  assign r_dvalid = r_dvalid_shift [DATA_LAT-1];
  assign r_data   = r_data_shift   [DATA_LAT-1];
endmodule

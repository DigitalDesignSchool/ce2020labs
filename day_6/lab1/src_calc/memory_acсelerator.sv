

`default_nettype none 

//
// reg_control
//   8: 1 -  write start
//   9: 1 -  read start
//
//  reg_mode
//   7:0    - start value
//   15:8   - start_addr
//   23:16  - count
//
//  reg_calculate
//  15:0    - sum of read data
//
module memory_accelerator
(
  
    input wire                      clk,
    input wire                      reset_p,

    input wire                      reg_control_we,
    input wire [31:0]               reg_control,
    input wire [31:0]               reg_mode_adr,
    input wire [31:0]               reg_mode_data,
    input wire [31:0]               reg_mode_cnt,
    output wire [31:0]              reg_calculate,

    output reg                      w_done,
    output reg                      r_done,

    output reg [3:0]                r_addr,
    output reg   					r_avalid,
    input wire 				        r_aready,
    
    input wire      			    r_dvalid,
    input wire [7:0]                r_data,
    
    output reg [3:0]                w_addr,
    output reg [7:0]                w_data,
    output reg   				    w_valid,
    
    input wire 			            w_ready
);

logic                   rstp;

logic [3:0]             n_w_addr;
logic [7:0]             n_w_data;
logic   				n_w_valid;
logic [3:0]             n_w_cnt;
logic                   n_w_done;
logic [3:0]             w_cnt;



always @(posedge clk)   rstp <= #1 reset_p;

always_comb begin
    n_w_cnt  = w_cnt;
    n_w_addr = w_addr;
    n_w_data = w_data;
    n_w_valid = w_valid;
    n_w_done = w_done;


    if( n_w_valid & w_ready ) begin
        n_w_addr = n_w_addr + 1;
        n_w_data = n_w_data + 1;
        n_w_cnt  = n_w_cnt - 1;
    end

    if( 0==n_w_cnt ) begin
        n_w_valid = 0;
        n_w_done = 1;
    end


    if( reg_control_we & reg_control[8] ) begin
        n_w_cnt  = reg_mode_cnt[3:0];
        n_w_addr = reg_mode_adr[3:0];
        n_w_data = reg_mode_data[7:0];
        n_w_done = 0;
        n_w_valid = 1;
    end 
end


always @(posedge clk) begin
    if( rstp ) begin
        
        w_addr  <= #1 '0;
        w_data  <= #1 '0;
        w_valid <= #1 '0;
        w_cnt   <= #1 '0;
        w_done  <= #1 '0;

    end else begin

        w_addr  <= #1 n_w_addr;
        w_data  <= #1 n_w_data;
        w_valid <= #1 n_w_valid;
        w_done  <= #1 n_w_done;
        w_cnt   <= #1 n_w_cnt;
    end
    
end

////////////////////////////////////////////////////////

logic [3:0]         n_r_addr;
logic               n_r_avalid;
logic [3:0]         n_r_acnt;
logic [3:0]         r_acnt;
logic [3:0]         n_r_dcnt;
logic [3:0]         r_dcnt;
logic               n_r_done;
logic [15:0]        r_sum;
logic [15:0]        n_r_sum;

always_comb begin
   
    n_r_addr      = r_addr;
    n_r_avalid    = r_avalid;
    n_r_acnt      = r_acnt;
    n_r_dcnt      = r_dcnt;
    n_r_done      = r_done;  
    n_r_sum       = r_sum;  

    if( n_r_avalid && r_aready ) begin
        n_r_acnt = n_r_acnt - 1;
        n_r_addr = n_r_addr + 1;
    end

    if( 0==n_r_acnt ) begin
        n_r_avalid = 0;
    end 

    if( r_dvalid ) begin
        n_r_dcnt = n_r_dcnt - 1;
        n_r_sum = n_r_sum + { 8'h0, r_data };
    end

    if( 0==n_r_dcnt ) begin
        n_r_done = 1;
    end

    if( reg_control_we & reg_control[9] ) begin
        n_r_acnt = reg_mode_cnt[3:0];
        n_r_dcnt = reg_mode_cnt[3:0];
        n_r_addr = reg_mode_adr[3:0];
        n_r_done = '0;
        n_r_sum  = '0;
        n_r_avalid = 1;

    end

end

always @(posedge clk) begin
        if( rstp ) begin
            r_addr      <= #1 '0;
            r_avalid    <= #1 '0;
            r_acnt      <= #1 '0;
            r_dcnt      <= #1 '0;
            r_done      <= #1 '0;  
            r_sum       <= #1 '0;  
        end else begin
            r_addr      <= #1 n_r_addr;
            r_avalid    <= #1 n_r_avalid;
            r_acnt      <= #1 n_r_acnt;
            r_dcnt      <= #1 n_r_dcnt;
            r_done      <= #1 n_r_done;  
            r_sum       <= #1 n_r_sum;  
            
        end
end

assign reg_calculate[15:0] = r_sum;
assign reg_calculate[31:16] = '0;


endmodule

`default_nettype wire

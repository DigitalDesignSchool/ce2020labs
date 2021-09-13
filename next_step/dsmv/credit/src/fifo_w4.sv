
`timescale 1 ns / 1 ns
`default_nettype none 

//! Example for complex credit
module fifo_w4
#(
    parameter               WIDTH
)    
(
    input   wire                    reset_p,    //! 1 - reset
    input   wire                    clk,        //! clock

    input   wire    [WIDTH-1:0]     data_i,
    input   wire                    data_we,

    output  wire    [WIDTH-1:0]     data_o,
    input   wire                    data_rd,

    output  wire                    full,
    output  wire                    empty

);

logic   [WIDTH-1:0]         mem[4];

logic   [2:0]               cnt_wr;
logic   [2:0]               cnt_rd;
logic                       rstp;

always @(posedge clk) begin

    rstp <= #1 reset_p;

    if( ~full & data_we ) begin
        mem[cnt_wr[1:0]] <= #1 data_i;
        cnt_wr <= #1 cnt_wr + 1;
    end

    if( ~empty & data_rd ) begin
        cnt_rd <= #1 cnt_rd + 1;
    end

    if( rstp ) begin
        cnt_wr      <= # 2'b000;
        cnt_rd      <= # 2'b000;
    end 

end

//assign  full    = (cnt_wr_next==cnt_rd) ? 1 : 0;
assign  full    = (cnt_rd[1:0]==cnt_wr[1:0] && cnt_rd[2]!=cnt_wr[2]) ? 1 : 0;
assign  empty   = (cnt_wr==cnt_rd) ? 1 : 0;

assign  data_o  = mem[cnt_rd[1:0]];

endmodule

`default_nettype wire 
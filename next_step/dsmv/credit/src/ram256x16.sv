
`timescale 1 ns / 1 ns
`default_nettype none 

//! Memory block
module ram256x16
(
    input   wire            aresetn,    //! 0 - reset
    input   wire            clk,        //! clock

    input   wire [7:0]      rd_addr,
    input   wire            rd_read,
    output  wire [15:0]     rd_data,
    output  wire            rd_valid,

    input   wire  [7:0]     wr_addr,
    input   wire  [15:0]    wr_data,
    input   wire            wr_valid
    
);

logic               rstp;

logic   [15:0]      mem[256];

logic   [15:0]       data_z0;
logic   [15:0]       data_z1;
logic   [15:0]       data_z2;
logic   [15:0]       data_z3;
logic   [15:0]       data_z4;
logic   [15:0]       data_o;

logic               data_vld_z0;
logic               data_vld_z1;
logic               data_vld_z2;
logic               data_vld_z3;
logic               data_vld_z4;
logic               data_o_vld;


initial begin
    for( int ii=0; ii<256; ii++ )
        mem[ii] = 0;
end


assign  rd_data = data_o;
assign  rd_valid = data_o_vld;

always @ (posedge clk) begin

    data_vld_z0 <= #1 aresetn & rd_read;

    data_vld_z1 <= #1 data_vld_z0; 
    data_vld_z2 <= #1 data_vld_z1; 
    data_vld_z3 <= #1 data_vld_z2; 
    data_vld_z4 <= #1 data_vld_z3; 
    data_o_vld  <= #1 data_vld_z4; 

    data_z0 <= #1 mem[rd_addr];

    data_z1 <= #1 data_z0;
    data_z2 <= #1 data_z1;
    data_z3 <= #1 data_z2;
    data_z4 <= #1 data_z3;
    data_o  <= #1 data_z4;

end

always @(posedge clk iff wr_valid) begin
    mem[wr_addr] <= #1 wr_data;
end



endmodule

`default_nettype wire
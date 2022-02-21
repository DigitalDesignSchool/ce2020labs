
`default_nettype none 

module example_cpu
#(
    parameter               DEPTH
)
(
  
    input   wire            clk,
    input   wire            reset_p,

    input   wire [3:0]      key_sw_p,           // key_sw_p[0]: 1 - reset cpu
                                                // key_sw_p[1]: 1 - p0_cpu step
                                                // key_sw_p[2]: 1 - p1_cpu step

    output  wire [15:0]     display_number,     // [15:12] - p0_reg_hex
                                                // [11:8]  - credit_counter
                                                // [7:4]   - p1_reg_hex
    output  wire [3:0]      led_p
    
); 

logic                           rstp;
logic   [3:0]                   key_sw_p_z1;
logic   [3:0]                   key_sw_p_z2;



logic                           p0_reset_n;
logic   [31:0]                  p0_vcu_reg_control;            //! control register for video control unit (vcu)  
logic                           p0_vcu_reg_control_we;         //! 1 - new data in the vcu_reg_control
logic   [31:0]                  p0_vcu_reg_wdata;              //! data register for video control unit (vcu)
logic                           p0_vcu_reg_wdata_we;           //! 1 - new data in the vcu_reg_wdata
logic   [31:0]                  p0_vcu_reg_rdata;              //! input data 
logic   [ 4:0]                  p0_regAddr = 0;                // debug access reg address
logic   [31:0]                  p0_regData;                    // debug access reg data
logic   [31:0]                  p0_imAddr;
logic   [31:0]                  p0_imData;
logic   [3:0]                   p0_reg_hex;
logic   [7:0]                   p0_reg_status;

logic                           p1_reset_n;
logic   [31:0]                  p1_vcu_reg_control;            //! control register for video control unit (vcu)  
logic                           p1_vcu_reg_control_we;         //! 1 - new data in the vcu_reg_control
logic   [31:0]                  p1_vcu_reg_wdata;              //! data register for video control unit (vcu)
logic                           p1_vcu_reg_wdata_we;           //! 1 - new data in the vcu_reg_wdata
logic   [31:0]                  p1_vcu_reg_rdata;              //! input data 
logic   [ 4:0]                  p1_regAddr = 0;                // debug access reg address
logic   [31:0]                  p1_regData;                    // debug access reg data
logic   [31:0]                  p1_imAddr;
logic   [31:0]                  p1_imData;
logic   [3:0]                   p1_reg_hex;
logic   [7:0]                   p1_reg_status;

logic   [3:0]                   credit_counter;
logic                           is_write_enable;
logic [31:0]                    fifo_i_data;
logic [31:0]                    fifo_o_data;
logic                           fifo_i_data_we;
logic                           fifo_o_data_rd;
logic                           fifo_prog_full;
logic                           fifo_full;
logic                           fifo_empty;


always @(posedge clk) begin
    rstp <= #1 reset_p | key_sw_p[0];
    p0_reset_n <= #1 ~rstp;
    p1_reset_n <= #1 ~rstp;

    key_sw_p_z1 <= #1 key_sw_p;
    key_sw_p_z2 <= #1 key_sw_p_z1;
end 

// sm_rom 
// #(
//         .SIZE               (       128             ),
//         .PROG_NAME          (   "p0_program.hex"    )
// ) p0_rom
// (
//     .a                      (       p0_imAddr       ), 
//     .rd                     (       p0_imData       )
// );

sm_rom_p0
#(
        .SIZE               (       128             )
) p0_rom
(
    .a                      (       p0_imAddr       ), 
    .rd                     (       p0_imData       )
);


sr_cpu_vc  p0_sm_cpu_vc
(
    .clk                    (       clk                     ),    // clock
    .rst_n                  (       p0_reset_n              ),    // reset
    .regAddr                (       p0_regAddr              ),    // debug access reg address
    .regData                (       p0_regData              ),    // debug access reg data
    .imAddr                 (       p0_imAddr               ),
    .imData                 (       p0_imData               ),

    .vcu_reg_control        (       p0_vcu_reg_control      ),   // control register for video control unit (vcu)
    .vcu_reg_control_we     (       p0_vcu_reg_control_we   ),   // 1 - new data in the vcu_reg-control
    .vcu_reg_wdata          (       p0_vcu_reg_wdata        ),   // данные на запись
    .vcu_reg_wdata_we       (       p0_vcu_reg_wdata_we     ),   // 1 - запись данных
    .vcu_reg_rdata          (       p0_vcu_reg_rdata        )    // данные для чтения
);

// sm_rom 
// #(
//         .SIZE               (       128             ),
//         .PROG_NAME          (   "p1_program.hex"    )
// ) p1_rom
// (
//     .a                      (       p1_imAddr       ), 
//     .rd                     (       p1_imData       )
// );

sm_rom_p1
#(
        .SIZE               (       128             )
) p1_rom
(
    .a                      (       p1_imAddr       ), 
    .rd                     (       p1_imData       )
);


sr_cpu_vc  p1_sm_cpu_vc
(
    .clk                    (       clk                     ),    // clock
    .rst_n                  (       p1_reset_n              ),    // reset
    .regAddr                (       p1_regAddr              ),    // debug access reg address
    .regData                (       p1_regData              ),    // debug access reg data
    .imAddr                 (       p1_imAddr               ),
    .imData                 (       p1_imData               ),

    .vcu_reg_control        (       p1_vcu_reg_control      ),   // control register for video control unit (vcu)
    .vcu_reg_control_we     (       p1_vcu_reg_control_we   ),   // 1 - new data in the vcu_reg-control
    .vcu_reg_wdata          (       p1_vcu_reg_wdata        ),   // данные на запись
    .vcu_reg_wdata_we       (       p1_vcu_reg_wdata_we     ),   // 1 - запись данных
    .vcu_reg_rdata          (       p1_vcu_reg_rdata        )    // данные для чтения
);


always @(posedge clk) begin
    if( ~p0_reset_n )
        p0_reg_hex <= #1 '0;
    else if( p0_vcu_reg_wdata_we ) begin
        if( p0_vcu_reg_control[3:0]== 4'b0001 )
                p0_reg_hex <= #1 p0_vcu_reg_wdata[3:0];
    end
end


always @(posedge clk) begin
    if( ~p0_reset_n || (p0_vcu_reg_control[3:0]==4'b0010 && p0_vcu_reg_wdata_we) )
         p0_reg_status[0] <= #1 0;
    else if( key_sw_p_z1[3] & ~key_sw_p_z2[3] )
        p0_reg_status[0] <= #1 1;
end         

assign p0_reg_status[7:1]   = '0;

always_comb begin
        case( p0_vcu_reg_control[3:0] ) 
        2: p0_vcu_reg_rdata <= { 24'h0, p0_reg_status };
        4: p0_vcu_reg_rdata <= { 30'h0, is_write_enable };
        default: p0_vcu_reg_rdata <= '0;
        endcase
end


always @(posedge clk) begin
    if( ~p1_reset_n )
        p1_reg_hex <= #1 '0;
    else if( p1_vcu_reg_wdata_we ) begin
        if( p1_vcu_reg_control[3:0]== 4'b0001 )
                p1_reg_hex <= #1 p1_vcu_reg_wdata[3:0];
    end
end


always @(posedge clk) begin
    if( ~p1_reset_n || (p1_vcu_reg_control[3:0]==4'b0010 && p1_vcu_reg_wdata_we) )
         p1_reg_status[0] <= #1 0;
    else if( key_sw_p_z1[2] & ~key_sw_p_z2[2] )
        p1_reg_status[0] <= #1 1;
end         

assign p1_reg_status[7:1]   = '0;

always_comb begin
        case( p1_vcu_reg_control[3:0] ) 
        2: p1_vcu_reg_rdata <= { 24'h0, p1_reg_status };
        3: p1_vcu_reg_rdata <= { 30'h0, ~fifo_empty };
        9: p1_vcu_reg_rdata <= fifo_o_data;
        default: p1_vcu_reg_rdata <= '0;
        endcase
end


assign display_number[15:12]    = p0_reg_hex;
assign display_number[11:8]     = credit_counter; 
assign display_number[7:4]      = p1_reg_hex;
assign display_number[3:0]      = '0;

assign led_p[0] = fifo_empty;
assign led_p[1] = fifo_prog_full;
assign led_p[2] = fifo_full;
assign led_p[3] = is_write_enable;

// assign fifo_i_data      = p0_vcu_reg_wdata;
// assign fifo_i_data_we   = (p0_vcu_reg_control[3:0]==4'b1000) ? p0_vcu_reg_wdata_we : 0;

// assign fifo_o_data_rd   = (p1_vcu_reg_control[3:0]==4'b0101) ? p1_vcu_reg_control_we : 0;

// assign is_write_enable = (credit_counter=='0) ? 0 : 1;
//assign is_write_enable = 1

assign credit_counter = '0;
// always @(posedge clk) begin
//     if( rstp )
//         credit_counter <= #1 4'h8;
//     else if( fifo_i_data_we & ~fifo_o_data_rd ) 
//         credit_counter <= #1 credit_counter - 1;
//     else if( ~fifo_i_data_we & fifo_o_data_rd ) 
//         credit_counter <= #1 credit_counter + 1;

// end

// fifo_simple
// #(
//     .WIDTH                  (       32      ),
//     .DEPTH                  (       8       ),
//     .PROG_FULL              (       4       )
// )    
// fifo_msg
// (
//     .reset_p                (       rstp    ),    
//     .clk                    (       clk     ),    

//     .data_i                 (       fifo_i_data     ),
//     .data_we                (       fifo_i_data_we  ),

//     .data_o                 (       fifo_o_data     ),
//     .data_rd                (       fifo_o_data_rd  ),
//     .prog_full              (       fifo_prog_full  ),
//     .full                   (       fifo_full       ),
//     .empty                  (       fifo_empty      )

// );

endmodule

`default_nettype wire
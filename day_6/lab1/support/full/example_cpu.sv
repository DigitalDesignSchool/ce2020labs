//
//
//  REG_CONTROL:
//   3:0 - register address 
//   7:4 -
//    8  - 1 - start write cycle
//    9  - 1 - start read cycle
//
// Register map on reg_control[3:0]
//
// 00 - 
// 01 - REG_HEX
// 02 - REG_KEY_0
// 03 - REG_KEY_1
// 04 - REG_W_DONE
// 05 - REG_R_DONE
// 06 - REG_CALCULATE
// 07 -
// 08 - REG_MODE_ADR
// 09 - REG_MODE_DATA
// 0A - REG_MODE_CNT
//

`default_nettype none 

module example_cpu
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
logic                           p0_reset_p;
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
logic                           p0_reg_key0;
logic                           p0_reg_key1;
logic [31:0]                    p0_reg_mode_adr;
logic [31:0]                    p0_reg_mode_data;
logic [31:0]                    p0_reg_mode_cnt;
logic [31:0]                    p0_reg_calculate;
logic                           p0_w_done;
logic                           p0_r_done;


logic                           p1_reset_n;
logic                           p1_reset_p;
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
logic                           p1_reg_key0;
logic                           p1_reg_key1;
logic [31:0]                    p1_reg_mode_adr;
logic [31:0]                    p1_reg_mode_data;
logic [31:0]                    p1_reg_mode_cnt;
logic [31:0]                    p1_reg_calculate;
logic                           p1_w_done;
logic                           p1_r_done;

localparam  REQUESTERS = 2;
localparam  DATA_WIDTH = 8;
localparam  ADDR_WIDTH = 4;

// read ports
logic[REQUESTERS-1:0][ADDR_WIDTH-1:0]   r_addr;
logic[REQUESTERS-1:0]					r_avalid;

logic[REQUESTERS-1:0]     			    r_dvalid;
logic[REQUESTERS-1:0][DATA_WIDTH-1:0]   r_data;
logic[REQUESTERS-1:0]				    r_aready;

// write ports
logic[REQUESTERS-1:0][ADDR_WIDTH-1:0]   w_addr;
logic[REQUESTERS-1:0][DATA_WIDTH-1:0]   w_data;
logic[REQUESTERS-1:0]  				    w_valid;

logic [REQUESTERS-1:0]			        w_ready;


always @(posedge clk) begin
    //rstp <= #1 reset_p | key_sw_p[0];
    rstp <= #1 reset_p;
    p0_reset_n <= #1 ~rstp;
    p1_reset_n <= #1 ~rstp;

    p0_reset_p <= #1 rstp;
    p1_reset_p <= #1 rstp;

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
    if( ~p0_reset_n ) begin
        p0_reg_hex <= #1 '0;
        p0_reg_mode_adr <= #1 '0;
        p0_reg_mode_data <= #1 '0;
        p0_reg_mode_cnt <= #1 '0;
    end else if( p0_vcu_reg_wdata_we ) begin
        case( p0_vcu_reg_control[3:0] )
        1: p0_reg_hex <= #1 p0_vcu_reg_wdata[3:0];
        8: p0_reg_mode_adr <= #1 p0_vcu_reg_wdata;
        9: p0_reg_mode_data <= #1 p0_vcu_reg_wdata;
        10: p0_reg_mode_cnt <= #1 p0_vcu_reg_wdata;
        endcase
    end
end


always @(posedge clk) begin
    if( ~p0_reset_n || (p0_vcu_reg_control[3:0]==4'b0010 && p0_vcu_reg_wdata_we) )
         p0_reg_key0 <= #1 0;
    else if( key_sw_p_z1[3] & ~key_sw_p_z2[3] )
        p0_reg_key0 <= #1 1;
end         

always @(posedge clk) begin
    if( ~p0_reset_n || (p0_vcu_reg_control[3:0]==4'b0011 && p0_vcu_reg_wdata_we) )
         p0_reg_key1 <= #1 0;
    else if( key_sw_p_z1[2] & ~key_sw_p_z2[2] )
        p0_reg_key1 <= #1 1;
end         




always_comb begin
        case( p0_vcu_reg_control[3:0] ) 
        2: p0_vcu_reg_rdata <= { 31'h0, p0_reg_key0 };
        3: p0_vcu_reg_rdata <= { 31'h0, p0_reg_key1 };
        4: p0_vcu_reg_rdata <= { 31'h0, p0_w_done };
        5: p0_vcu_reg_rdata <= { 31'h0, p0_r_done };
        6: p0_vcu_reg_rdata <= p0_reg_calculate;
        default: p0_vcu_reg_rdata <= '0;
        endcase
end



always @(posedge clk) begin
    if( ~p1_reset_n ) begin
        p1_reg_hex <= #1 '0;
        p1_reg_mode_adr <= #1 '0;
        p1_reg_mode_data <= #1 '0;
        p1_reg_mode_cnt <= #1 '0;
    end else if( p1_vcu_reg_wdata_we ) begin
        case( p1_vcu_reg_control[3:0] )
        1: p1_reg_hex <= #1 p1_vcu_reg_wdata[3:0];
        8: p1_reg_mode_adr <= #1 p1_vcu_reg_wdata;
        9: p1_reg_mode_data <= #1 p1_vcu_reg_wdata;
        10: p1_reg_mode_cnt <= #1 p1_vcu_reg_wdata;
        endcase
    end
end


always @(posedge clk) begin
    if( ~p1_reset_n || (p1_vcu_reg_control[3:0]==4'b0010 && p1_vcu_reg_wdata_we) )
         p1_reg_key0 <= #1 0;
    else if( key_sw_p_z1[1] & ~key_sw_p_z2[1] )
        p1_reg_key0 <= #1 1;
end         

always @(posedge clk) begin
    if( ~p1_reset_n || (p1_vcu_reg_control[3:0]==4'b0011 && p1_vcu_reg_wdata_we) )
         p1_reg_key1 <= #1 0;
    else if( key_sw_p_z1[0] & ~key_sw_p_z2[0] )
        p1_reg_key1 <= #1 1;
end         


always_comb begin
        case( p1_vcu_reg_control[3:0] ) 
        2: p1_vcu_reg_rdata <= { 31'h0, p1_reg_key0 };
        3: p1_vcu_reg_rdata <= { 31'h0, p1_reg_key1 };
        4: p1_vcu_reg_rdata <= { 31'h0, p1_w_done };
        5: p1_vcu_reg_rdata <= { 31'h0, p1_r_done };
        6: p1_vcu_reg_rdata <= p1_reg_calculate;
        default: p1_vcu_reg_rdata <= '0;
        endcase
end


assign display_number[15:12]    = w_data[0][3:0];
assign display_number[11:8]     = p0_reg_hex; 
assign display_number[7:4]      = w_data[1][3:0];
assign display_number[3:0]      = p1_reg_hex;

assign led_p[0] = w_valid[0];
assign led_p[1] = r_dvalid[0];
assign led_p[2] = w_valid[1];
assign led_p[3] = r_dvalid[1];





multi_memory
#(
    .REQUESTERS     (   REQUESTERS  ),
    .DATA_WIDTH     (   DATA_WIDTH  ),
    .ADDR_WIDTH     (   ADDR_WIDTH  )
)
multi_memory
(
    .clk                    (       clk                  ),
    .rst                    (       rstp                 ),
    .r_addr                 (       r_addr               ),
    .r_avalid               (       r_avalid             ),
    .r_aready               (       r_aready             ),
    .r_dvalid               (       r_dvalid             ),
    .r_data                 (       r_data               ),
    .w_addr                 (       w_addr               ),
    .w_data                 (       w_data               ),
    .w_valid                (       w_valid              ),
    .w_ready                (       w_ready              )
);



memory_accelerator  p0_memory_accelerator
(
  
    .clk                    (       clk     ),
    .reset_p                (       p0_reset_p  ),
    .reg_control_we         (       p0_vcu_reg_control_we   ),
    .reg_control            (       p0_vcu_reg_control      ),
    .reg_mode_adr           (       p0_reg_mode_adr         ),
    .reg_mode_data          (       p0_reg_mode_data        ),
    .reg_mode_cnt           (       p0_reg_mode_cnt         ),
    .reg_calculate          (       p0_reg_calculate        ),
    .w_done                 (       p0_w_done               ),
    .r_done                 (       p0_r_done               ),
    .r_addr                 (       r_addr[0]               ),
    .r_avalid               (       r_avalid[0]             ),
    .r_aready               (       r_aready[0]             ),
    .r_dvalid               (       r_dvalid[0]             ),
    .r_data                 (       r_data[0]               ),
    .w_addr                 (       w_addr[0]               ),
    .w_data                 (       w_data[0]               ),
    .w_valid                (       w_valid[0]              ),
    .w_ready                (       w_ready[0]              )
);

memory_accelerator  p1_memory_accelerator
(
  
    .clk                    (       clk     ),
    .reset_p                (       p1_reset_p  ),
    .reg_control_we         (       p1_vcu_reg_control_we   ),
    .reg_control            (       p1_vcu_reg_control      ),
    .reg_mode_adr           (       p1_reg_mode_adr         ),
    .reg_mode_data          (       p1_reg_mode_data        ),
    .reg_mode_cnt           (       p1_reg_mode_cnt         ),
    .reg_calculate          (       p1_reg_calculate        ),
    .w_done                 (       p1_w_done               ),
    .r_done                 (       p1_r_done               ),
    .r_addr                 (       r_addr[1]               ),
    .r_avalid               (       r_avalid[1]             ),
    .r_aready               (       r_aready[1]             ),
    .r_dvalid               (       r_dvalid[1]             ),
    .r_data                 (       r_data[1]               ),
    .w_addr                 (       w_addr[1]               ),
    .w_data                 (       w_data[1]               ),
    .w_valid                (       w_valid[1]              ),
    .w_ready                (       w_ready[1]              )
);


endmodule

`default_nettype wire
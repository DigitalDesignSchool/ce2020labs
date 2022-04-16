//
//
//  REG_CONTROL:
//   3:0 - register address 
//   7:4 -
//
// Register map on reg_control[3:0]
//
// 00 - 
// 01 - REG_HEX
// 02 - REG_KEY_0
// 03 - REG_KEY_1
// 04 - 
// 05 - 
// 06 - 
// 07 -
// 08 - REG_MODE_ADR
// 09 - REG_MODE_DATA
// 0A - 
//

`default_nettype none 

module example_cpu
# (
    parameter clk_mhz = 50
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
    output  wire [3:0]      led_p,

    output  wire            hsync,
    output  wire            vsync,
    output  reg [2:0]      rgb    
    
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
logic   [15:0]                  p0_reg_hex;
logic                           p0_reg_key0;
logic                           p0_reg_key1;
logic [31:0]                    p0_reg_mode_adr;
logic [31:0]                    p0_reg_mode_data;
logic [31:0]                    p0_reg_mode_cnt;
logic [31:0]                    p0_reg_calculate;
logic                           p0_w_done;
logic                           p0_r_done;


// logic                           p1_reset_n;
// logic                           p1_reset_p;
// logic   [31:0]                  p1_vcu_reg_control;            //! control register for video control unit (vcu)  
// logic                           p1_vcu_reg_control_we;         //! 1 - new data in the vcu_reg_control
// logic   [31:0]                  p1_vcu_reg_wdata;              //! data register for video control unit (vcu)
// logic                           p1_vcu_reg_wdata_we;           //! 1 - new data in the vcu_reg_wdata
// logic   [31:0]                  p1_vcu_reg_rdata;              //! input data 
// logic   [ 4:0]                  p1_regAddr = 0;                // debug access reg address
// logic   [31:0]                  p1_regData;                    // debug access reg data
// logic   [31:0]                  p1_imAddr;
// logic   [31:0]                  p1_imData;
// logic   [3:0]                   p1_reg_hex;
// logic                           p1_reg_key0;
// logic                           p1_reg_key1;
// logic [31:0]                    p1_reg_mode_adr;
// logic [31:0]                    p1_reg_mode_data;
// logic [31:0]                    p1_reg_mode_cnt;
// logic [31:0]                    p1_reg_calculate;
// logic                           p1_w_done;
// logic                           p1_r_done;




`define SCREEN_WIDTH   640
`define SCREEN_HEIGHT  480

`define X_WIDTH        11  // X coordinate width in bits
`define Y_WIDTH        10  // Y coordinate width in bits

`define RGB_WIDTH      3

`define N_MIXER_PIPE_STAGES     2


logic                  display_on;
logic [`X_WIDTH - 1:0] pixel_x;
logic [`Y_WIDTH - 1:0] pixel_y;

logic [`X_WIDTH - 1:0] pixel_x_q;
logic [`X_WIDTH - 1:0] pixel_x_q2;

logic [11:0]                    video_r_addr;
logic [7:0]                     video_r_data;
logic [11:0]                    video_w_addr;
logic [7:0]                     video_w_data;
logic                           video_w_valid;
logic                           video_reset_done;

always @(posedge clk) begin
    rstp <= #1 reset_p | key_sw_p[0];
    //rstp <= #1 reset_p;
    p0_reset_n <= #1 ~rstp & video_reset_done;
    //p1_reset_n <= #1 ~rstp;

    p0_reset_p <= #1 rstp;
    //p1_reset_p <= #1 rstp;

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


always @(posedge clk) begin
    if( ~p0_reset_n ) begin
        p0_reg_hex <= #1 '0;
        p0_reg_mode_adr <= #1 '0;
        p0_reg_mode_data <= #1 '0;
        p0_reg_mode_cnt <= #1 '0;
    end else if( p0_vcu_reg_wdata_we ) begin
        case( p0_vcu_reg_control[3:0] )
        1: p0_reg_hex <= #1 p0_vcu_reg_wdata[15:0];
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




// assign display_number[15:12]    = 4'hA;
// assign display_number[11:8]     = 0; 
// assign display_number[7:4]      = 0;
// assign display_number[3:0]      = 0;

assign display_number[15:0]      = p0_reg_hex[15:0];

assign led_p[0] = 0;
assign led_p[1] = 0;
assign led_p[2] = video_reset_done;
assign led_p[3] = rstp;



vga
# (
    .N_MIXER_PIPE_STAGES ( `N_MIXER_PIPE_STAGES ),

    .HPOS_WIDTH          ( `X_WIDTH             ),
    .VPOS_WIDTH          ( `Y_WIDTH             ),


    // Horizontal constants

    //.H_DISPLAY           ( 1024  ),  // Horizontal display width
    .H_DISPLAY           ( 1024  ),  // Horizontal display width
    .H_FRONT             (   24  ),  // Horizontal right border (front porch)
    .H_SYNC              (  136  ),  // Horizontal sync width
    .H_BACK              (  160  ),  // Horizontal left border (back porch)

    // Vertical constants

    .V_DISPLAY           (  768  ),  // Vertical display height
    .V_BOTTOM            (  29   ),  // Vertical bottom border
    .V_SYNC              (  6    ),  // Vertical sync # lines
    .V_TOP               (  3    ),  // Vertical top border
    
    .CLK_MHZ                (  65  ),   // Clock frequency (50 or 100 MHz)
    .VGA_CLOCK              (  65  )  // Pixel clock of VGA in MHz

     //.CLK_MHZ                (  50  )   // Clock frequency (50 or 100 MHz)

)
i_vga
(
    .clk        ( clk        ),
    .reset      ( rstp       ),
    .hsync      ( hsync      ),
    .vsync      ( vsync      ),
    .display_on ( display_on ),
    .hpos       ( pixel_x    ),
    .vpos       ( pixel_y    )
);

logic [7:0]         index; // Character Index
logic [2:0]         sub_index; // Y position in character
logic [7:0]         bitmap_out;        // 8 bit horizontal slice of character

text_rom    text_rom
  (
   .clock           (       clk         ), // Clock
   .index           (       index       ), // Character Index
   .sub_index       (       sub_index   ), // Y position in character

   .bitmap_out      (       bitmap_out  )         // 8 bit horizontal slice of character
   );

always @(posedge clk) begin
 
    pixel_x_q <= #1 pixel_x;
    pixel_x_q2 <= #1 pixel_x_q;

    rgb <= display_on & (bitmap_out[pixel_x_q2[3:1]]) ? 3'b111 : 0;

end

assign sub_index = pixel_y[3:1];

// Step 1 - direct digit

assign index = (pixel_y[9:4]=='d16 && pixel_x[9:4]=='d32) ? 8'h32 : 0;

// Step 1 - end

// Step 2 - Video Memory

// assign video_r_addr = { pixel_y[9:4], pixel_x[9:4] };
// assign index = video_r_data;

// video_memory
// #(
//     .INIT_VALUE                  ( 8'h41 )
//     //.INIT_VALUE                  ( 8'h20 )
// ) video_memory
// (
//     .clk                (       clk     ),
//     .reset_p            (       rstp    ),
//     .reset_done         (       video_reset_done ),
//     .r_addr             (       video_r_addr     ),
//     .r_data             (       video_r_data    ),
//     .w_addr             (       video_w_addr    ),
//     .w_data             (       video_w_data    ),
//     .w_valid            (       video_w_valid   )
//   );

// assign video_w_addr = 0;
// assign video_w_data = 0;
// assign video_w_valid = 0;

// Step 2 - end


// Step 3 - Add CPU Access

// assign video_w_addr = p0_reg_mode_adr[11:0];
// assign video_w_data = p0_vcu_reg_wdata[7:0];
// assign video_w_valid = (p0_vcu_reg_control[3:0]==9) ? p0_vcu_reg_wdata_we : 0;

// Step 3 - end

endmodule

`default_nettype wire
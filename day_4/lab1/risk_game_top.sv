`include "game_config.vh"

module risk_game_top
# (
    parameter clk_mhz = 50,
              strobe_to_update_xy_counter_width = 20
)
(
    input        clk,
    input        reset,

    input        launch_key,
    input  [1:0] left_right_keys,

    output       hsync,
    output       vsync,
    output [2:0] rgb
);

    //------------------------------------------------------------------------

    wire                  display_on;
    wire [`X_WIDTH - 1:0] pixel_x;
    wire [`Y_WIDTH - 1:0] pixel_y;

    vga
    # (
        .N_MIXER_PIPE_STAGES ( `N_MIXER_PIPE_STAGES ),

        .HPOS_WIDTH          ( `X_WIDTH             ),
        .VPOS_WIDTH          ( `Y_WIDTH             ),
        
        .CLK_MHZ             ( clk_mhz              )
    )
    i_vga
    (
        .clk        ( clk        ),
        .reset      ( reset      ),
        .hsync      ( hsync      ),
        .vsync      ( vsync      ),
        .display_on ( display_on ),
        .hpos       ( pixel_x    ),
        .vpos       ( pixel_y    )
    );

    //------------------------------------------------------------------------

    wire [15:0] random;

    game_random random_generator (clk, reset, random);

    //------------------------------------------------------------------------

    wire                    sprite_target_write_xy;
    wire                    sprite_target_write_dxy;

    reg  [`X_WIDTH   - 1:0] sprite_target_write_x;
    wire [`Y_WIDTH   - 1:0] sprite_target_write_y;

    reg  [             1:0] sprite_target_write_dx;
    wire                    sprite_target_write_dy;

    wire                    sprite_target_enable_update;

    wire [`X_WIDTH   - 1:0] sprite_target_x;
    wire [`Y_WIDTH   - 1:0] sprite_target_y;

    wire                    sprite_target_within_screen;

    wire [`X_WIDTH   - 1:0] sprite_target_out_left;
    wire [`X_WIDTH   - 1:0] sprite_target_out_right;
    wire [`Y_WIDTH   - 1:0] sprite_target_out_top;
    wire [`Y_WIDTH   - 1:0] sprite_target_out_bottom;

    wire                    sprite_target_rgb_en;
    wire [             2:0] sprite_target_rgb;

    //------------------------------------------------------------------------

    always @*
    begin
        if (random [7])
        begin
            sprite_target_write_x  = 10'd0;
            sprite_target_write_dx = 2'b01;
        end
        else
        begin
            sprite_target_write_x  = `SCREEN_WIDTH - 8;
            sprite_target_write_dx = { 1'b1, random [6] };
        end
    end

    assign sprite_target_write_y  = `SCREEN_HEIGHT / 10 + random [5:0];
    assign sprite_target_write_dy = 1'd0;

    //------------------------------------------------------------------------

    // game_sprite_top
    // #(
    //     .SPRITE_WIDTH  ( 8 ),
    //     .SPRITE_HEIGHT ( 8 ),

    //     .DX_WIDTH      ( 2 ),
    //     .DY_WIDTH      ( 1 ),

    //     .ROW_0 ( 32'h000bb000 ),
    //     .ROW_1 ( 32'h00099000 ),
    //     .ROW_2 ( 32'h00099000 ),
    //     .ROW_3 ( 32'hb99ff99b ),
    //     .ROW_4 ( 32'hb99ff99b ),
    //     .ROW_5 ( 32'h00099000 ),
    //     .ROW_6 ( 32'h00099000 ),
    //     .ROW_7 ( 32'h000bb000 ),

    //     .strobe_to_update_xy_counter_width
    //     (strobe_to_update_xy_counter_width)
    // )
    // sprite_target
    // (
    //     .clk                   ( clk                          ),
    //     .reset                 ( reset                        ),

    //     .pixel_x               ( pixel_x                      ),
    //     .pixel_y               ( pixel_y                      ),

    //     .sprite_write_xy       ( sprite_target_write_xy       ),
    //     .sprite_write_dxy      ( sprite_target_write_dxy      ),

    //     .sprite_write_x        ( sprite_target_write_x        ),
    //     .sprite_write_y        ( sprite_target_write_y        ),

    //     .sprite_write_dx       ( sprite_target_write_dx       ),
    //     .sprite_write_dy       ( sprite_target_write_dy       ),

    //     .sprite_enable_update  ( sprite_target_enable_update  ),

    //     .sprite_x              ( sprite_target_x              ),
    //     .sprite_y              ( sprite_target_y              ),

    //     .sprite_within_screen  ( sprite_target_within_screen  ),

    //     .sprite_out_left       ( sprite_target_out_left       ),
    //     .sprite_out_right      ( sprite_target_out_right      ),
    //     .sprite_out_top        ( sprite_target_out_top        ),
    //     .sprite_out_bottom     ( sprite_target_out_bottom     ),

    //     .rgb_en                ( sprite_target_rgb_en         ),
    //     .rgb                   ( sprite_target_rgb            )
    // );

    //------------------------------------------------------------------------

    wire                    sprite_torpedo_write_xy;
    wire                    sprite_torpedo_write_dxy;

    wire [`X_WIDTH   - 1:0] sprite_torpedo_write_x;
    wire [`Y_WIDTH   - 1:0] sprite_torpedo_write_y;

    reg  [             1:0] sprite_torpedo_write_dx;
    reg  [             2:0] sprite_torpedo_write_dy;

    wire                    sprite_torpedo_enable_update;

    wire [`X_WIDTH   - 1:0] sprite_torpedo_x;
    wire [`Y_WIDTH   - 1:0] sprite_torpedo_y;

    wire                    sprite_torpedo_within_screen;

    wire [`X_WIDTH   - 1:0] sprite_torpedo_out_left;
    wire [`X_WIDTH   - 1:0] sprite_torpedo_out_right;
    wire [`Y_WIDTH   - 1:0] sprite_torpedo_out_top;
    wire [`Y_WIDTH   - 1:0] sprite_torpedo_out_bottom;

    wire                    sprite_torpedo_rgb_en;
    wire [             2:0] sprite_torpedo_rgb;

    //------------------------------------------------------------------------

    // assign sprite_torpedo_write_x  = `SCREEN_WIDTH / 2 + random [15:10];
    // assign sprite_torpedo_write_y  = `SCREEN_HEIGHT - 16;

    // always @*
    // begin
    //     case (left_right_keys)
    //     2'b00: sprite_torpedo_write_dx = 2'b00;
    //     2'b01: sprite_torpedo_write_dx = 2'b01;
    //     2'b10: sprite_torpedo_write_dx = 2'b11;
    //     2'b11: sprite_torpedo_write_dx = 2'b00;
    //     endcase

    //     case (left_right_keys)
    //     2'b00: sprite_torpedo_write_dy = 3'b111;
    //     2'b01: sprite_torpedo_write_dy = 3'b110;
    //     2'b10: sprite_torpedo_write_dy = 3'b110;
    //     2'b11: sprite_torpedo_write_dy = 3'b110;
    //     endcase
    // end

    //------------------------------------------------------------------------

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 8 ),
        .SPRITE_HEIGHT ( 8 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 3 ),

        .ROW_0 ( 32'h000cc000 ),
        .ROW_1 ( 32'h00cccc00 ),
        .ROW_2 ( 32'h0cceecc0 ),
        .ROW_3 ( 32'hcccccccc ),
        .ROW_4 ( 32'hcc0cc0cc ),
        .ROW_5 ( 32'hcc0cc0cc ),
        .ROW_6 ( 32'hcc0cc0cc ),
        .ROW_7 ( 32'hcc0cc0cc ),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_torpedo
    (
        .clk                   ( clk                           ),
        .reset                 ( reset                         ),

        .pixel_x               ( pixel_x                       ),
        .pixel_y               ( pixel_y                       ),

        .sprite_write_xy       ( sprite_torpedo_write_xy       ),
        .sprite_write_dxy      ( sprite_torpedo_write_dxy      ),

        .sprite_write_x        ( sprite_torpedo_write_x        ),
        .sprite_write_y        ( sprite_torpedo_write_y        ),

        .sprite_write_dx       ( sprite_torpedo_write_dx       ),
        .sprite_write_dy       ( sprite_torpedo_write_dy       ),

        .sprite_enable_update  ( sprite_torpedo_enable_update  ),

        .sprite_x              ( sprite_torpedo_x              ),
        .sprite_y              ( sprite_torpedo_y              ),

        .sprite_within_screen  ( sprite_torpedo_within_screen  ),

        .sprite_out_left       ( sprite_torpedo_out_left       ),
        .sprite_out_right      ( sprite_torpedo_out_right      ),
        .sprite_out_top        ( sprite_torpedo_out_top        ),
        .sprite_out_bottom     ( sprite_torpedo_out_bottom     ),

        .rgb_en                ( sprite_torpedo_rgb_en         ),
        .rgb                   ( sprite_torpedo_rgb            )
    );

    //------------------------------------------------------------------------

    wire collision;

    // game_overlap overlap
    // (
    //     .clk       ( clk                        ),
    //     .reset     ( reset                      ),

    //     .left_1    ( sprite_target_out_left     ),
    //     .right_1   ( sprite_target_out_right    ),
    //     .top_1     ( sprite_target_out_top      ),
    //     .bottom_1  ( sprite_target_out_bottom   ),

    //     .left_2    ( sprite_torpedo_out_left    ),
    //     .right_2   ( sprite_torpedo_out_right   ),
    //     .top_2     ( sprite_torpedo_out_top     ),
    //     .bottom_2  ( sprite_torpedo_out_bottom  ),

    //     .overlap   ( collision                  )
    // );

    //------------------------------------------------------------------------

    wire end_of_game_timer_start;
    wire end_of_game_timer_running;

    // game_timer # (.width (25)) timer
    // (
    //     .clk     ( clk                       ),
    //     .reset   ( reset                     ),
    //     .value   ( 25'h1000000               ),
    //     .start   ( end_of_game_timer_start   ),
    //     .running ( end_of_game_timer_running )
    // );

    //------------------------------------------------------------------------

    wire game_won;

    game_mixer mixer
    (
        .clk                           ( clk                           ),
        .reset                         ( reset                         ),

        .display_on                    ( display_on                    ),

        .sprite_target_rgb_en          ( sprite_target_rgb_en          ),
        .sprite_target_rgb             ( sprite_target_rgb             ),

        .sprite_torpedo_rgb_en         ( sprite_torpedo_rgb_en         ),
        .sprite_torpedo_rgb            ( sprite_torpedo_rgb            ),

        .game_won                      ( game_won                      ),
        .end_of_game_timer_running     ( end_of_game_timer_running     ),
        .random                        ( random [0]                    ),

        .rgb                           ( rgb                           )
    );

    assign sprite_target_rgb_en = 0;
    assign sprite_target_rgb    = '0;
    assign end_of_game_timer_running = 0;
    assign game_won = 0;
    //------------------------------------------------------------------------

    // `GAME_MASTER_FSM_MODULE master_fsm
    // (
    //     .clk                           ( clk                           ),
    //     .reset                         ( reset                         ),

    //     .launch_key                    ( launch_key                    ),

    //     .sprite_target_write_xy        ( sprite_target_write_xy        ),
    //     .sprite_torpedo_write_xy       ( sprite_torpedo_write_xy       ),

    //     .sprite_target_write_dxy       ( sprite_target_write_dxy       ),
    //     .sprite_torpedo_write_dxy      ( sprite_torpedo_write_dxy      ),

    //     .sprite_target_enable_update   ( sprite_target_enable_update   ),
    //     .sprite_torpedo_enable_update  ( sprite_torpedo_enable_update  ),

    //     .sprite_target_within_screen   ( sprite_target_within_screen   ),
    //     .sprite_torpedo_within_screen  ( sprite_torpedo_within_screen  ),

    //     .collision                     ( collision                     ),

    //     .game_won                      ( game_won                      ),
    //     .end_of_game_timer_start       ( end_of_game_timer_start       ),

    //     .end_of_game_timer_running     ( end_of_game_timer_running     )
    // );

// Сигналы для управления спрайтом

    // sprite_torpedo_write_xy
    // sprite_torpedo_write_dxy
    // sprite_torpedo_write_x
    // sprite_torpedo_write_y
    // sprite_torpedo_write_dx
    // sprite_torpedo_write_dy
    // sprite_torpedo_enable_update    

localparam NUM_SPRITE   = 1;    

localparam  DX_WIDTH    = 2;
localparam  DY_WIDTH    = 3;

logic  [NUM_SPRITE-1:0]                             sprite_write_xy;   //! 1 - запись координат спрайта
logic  [NUM_SPRITE-1:0]                             sprite_write_dxy;  //! 1 - запись приращения координат спрайта
logic  [NUM_SPRITE-1:0]     [`X_WIDTH   - 1:0]      sprite_write_x;    //! координата X спрайта; запись при sprite_write_xy==1
logic  [NUM_SPRITE-1:0]     [`Y_WIDTH   - 1:0]      sprite_write_y;    //! координата Y спрайта; запись при sprite_write_xy==1
logic  [NUM_SPRITE-1:0]     [ DX_WIDTH  - 1:0]      sprite_write_dx;   //! приращение координаты X спрайта; запись при sprite_write_dxy==1
logic  [NUM_SPRITE-1:0]     [ DY_WIDTH  - 1:0]      sprite_write_dy;   //! приращение координаты Y спрайта; запись при sprite_write_dxy==1
logic  [NUM_SPRITE-1:0]                             sprite_enable_update;  //! 1 - разрешение обновления координат спрайта через приращение
logic  [NUM_SPRITE-1:0]    [`X_WIDTH   - 1:0]       sprite_x;       //! текущая координата X спрайта
logic  [NUM_SPRITE-1:0]    [`Y_WIDTH   - 1:0]       sprite_y;       //! текущая координата Y спрайта

logic [31:0]                   vcu_reg_control;            //! control register for video control unit (vcu)  
logic                          vcu_reg_control_we;         //! 1 - new data in the vcu_reg_control
logic [31:0]                   vcu_reg_wdata;              //! data register for video control unit (vcu)
logic                          vcu_reg_wdata_we;           //! 1 - new data in the vcu_reg_wdata
logic [31:0]                   vcu_reg_rdata;              //! input data 


assign sprite_torpedo_write_xy          = sprite_write_xy[0];
assign sprite_torpedo_write_dxy         = sprite_write_dxy[0];
assign sprite_torpedo_write_x           = sprite_write_x[0];
assign sprite_torpedo_write_y           = sprite_write_y[0];
assign sprite_torpedo_write_dx          = sprite_write_dx[0];
assign sprite_torpedo_write_dy          = sprite_write_dy[0];
assign sprite_torpedo_enable_update     = sprite_enable_update[0];

assign sprite_x[0] = sprite_torpedo_x;
assign sprite_y[0] = sprite_torpedo_y;

risk_sprite_engine     
#(
    .NUM_SPRITE             (   NUM_SPRITE  ),
    .DX_WIDTH               (   DX_WIDTH    ),
    .DY_WIDTH               (   DY_WIDTH    )
)
risk_sprite_engine
(
    .clk                    (   clk     ),
    .reset                  (   reset   ),              //  1 - сброс

    .sprite_write_xy        (   sprite_write_xy     ),  // 1 - запись координат спрайта
    .sprite_write_dxy       (   sprite_write_dxy    ),  // 1 - запись приращения координат спрайта

    .sprite_write_x         (   sprite_write_x      ),  // координата X спрайта, запись при sprite_write_xy==1
    .sprite_write_y         (   sprite_write_y      ),  // координата Y спрайта, запись при sprite_write_xy==1

    .sprite_write_dx        (   sprite_write_dx     ),  // приращение координаты X спрайта, запись при sprite_write_dxy==1
    .sprite_write_dy        (   sprite_write_dy     ),  // приращение координаты Y спрайта, запись при sprite_write_dxy==1

    .sprite_enable_update   (   sprite_enable_update),  // 1 - разрешение обновления координат спрайта через приращение

    .sprite_x               (   sprite_x            ),  // текущая координата X спрайта
    .sprite_y               (   sprite_y            ),  // текущая координата Y спрайта

    .vcu_reg_control        (   vcu_reg_control     ),  // регистр управления
    .vcu_reg_control_we     (   vcu_reg_control_we  ),  // 1 - запись данных в регистр управления
    .vcu_reg_wdata          (   vcu_reg_wdata       ),   // данные на запись
    .vcu_reg_wdata_we       (   vcu_reg_wdata_we    ),   // 1 - запись данных
    .vcu_reg_rdata          (   vcu_reg_rdata       ),   // данные для чтения
    .vsync                  (   vsync               )

);

logic   [ 4:0]  regAddr = '0;    // debug access reg address
logic  [31:0]   regData;        // debug access reg data

    //instruction memory
wire    [31:0]  imAddr;
wire    [31:0]  imData;
sm_rom reset_rom(imAddr, imData);


sr_cpu_vc  sm_cpu_vc
(
    .clk                (       clk         ),    // clock
    .rst_n              (       ~reset      ),    // reset
    .regAddr            (       regAddr     ),    // debug access reg address
    .regData            (       regData     ),    // debug access reg data
    .imAddr             (       imAddr      ),
    .imData             (       imData      ),

    .vcu_reg_control    (       vcu_reg_control     ),   // control register for video control unit (vcu)
    .vcu_reg_control_we (       vcu_reg_control_we  ),   // 1 - new data in the vcu_reg-control
    .vcu_reg_wdata          (   vcu_reg_wdata       ),   // данные на запись
    .vcu_reg_wdata_we       (   vcu_reg_wdata_we    ),   // 1 - запись данных
    .vcu_reg_rdata          (   vcu_reg_rdata       )    // данные для чтения
);


endmodule


`default_nettype none 

module top
# (
    parameter clk_mhz = 50
)
(
    input   wire        clk,
    input   wire        reset_n,
    
    input   wire [3:0]  key_sw,
    output  wire [3:0]  led,

    output  wire [7:0]  abcdefgh,
    output  wire [3:0]  digit,

    output  wire        buzzer,

    output  wire        hsync,
    output  wire        vsync,
    output  wire [2:0]  rgb
);

//assign led       = key_sw;
//assign abcdefgh  = { key_sw, key_sw };
//assign digit     = 4'b0;
assign buzzer       = 1'b0;
assign  hsync       = 0;
assign  vsync       = 0;
assign  rgb         = '0;

 logic              reset_p;
 logic [10:0]       transaction_cnt;
 logic              step_error;
 logic              flag_ok;
 logic              flag_error;

 logic              interface_rstp;
 logic [15:0]       display_number;

 logic [3:0]        key_sw_z;

 logic [3:0]        key_sw_p;

 logic [3:0]        led_p;


sync_and_debounce 
#(
    .w          (   4   ),
    .depth      (   8   )
)
sync_and_debounce 
(   
    .clk            (       clk           ),
    .reset          (       interface_rstp  ),
    .sw_in          (       key_sw          ),
    .sw_out         (       key_sw_z        )
);

 seven_segment_4_digits display
 (
     .clock         (       clk             ),
     .reset         (       interface_rstp    ),
     .number        (       display_number  ),
 
     .abcdefgh      (       abcdefgh        ),
     .digit         (       digit           )
 );

always @(posedge clk) interface_rstp <= #1 ~reset_n;

always @(posedge clk) reset_p <= #1 ~reset_n;

logic   [3:0]       devide = 4'b1111;
logic   cpu_clk;


example_cpu example_cpu 
(
    .clk            (       cpu_clk         ),
    .reset_p        (       reset_p         ),
    .key_sw_p       (       key_sw_p        ),
    .display_number (       display_number  ),
    .led_p          (       led_p           )   
);

assign key_sw_p     = ~ key_sw_z;
assign led          = ~led_p;


//tunable clock devider
sm_clk_divider  
#(
    .shift          (           24      )
)
sm_clk_divider
(
    .clkIn          (       clk         ),
    .rst_n          (       reset_n     ),
    .devide         (       devide      ),
    .enable         (       1           ),
    .clkOut         (       cpu_clk     )
);



endmodule

`default_nettype wire
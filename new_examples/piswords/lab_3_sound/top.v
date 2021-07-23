`include "config.vh"

module top
# (
    parameter clk_mhz = 50,
              strobe_to_update_xy_counter_width = 20
)

(
    input         clk,
    input  [ 3:0] key,
    input  [ 3:0] sw,
    output [ 7:0] led,

    output [ 7:0] abcdefgh,
    output [ 7:0] digit,

    output        vsync,
    output        hsync,
    output [ 2:0] rgb,

    output        buzzer,
    inout  [15:0] gpio
);

    wire   reset  = ~ key [3];
    assign buzzer = ~ reset;

    //------------------------------------------------------------------------

    wire [15:0] value;
	wire [15:0] cs_count;
	
  
    pmod_als_spi_receiver_sound i_light_sensor
    (
        .clock    ( clk        ),
        .reset    ( reset      ),
        .cs       ( gpio  [14] ),
        .sck      ( gpio  [ 8] ),
        .sdo   	  ( gpio  [10] ),
		.value 	  (   value    )
    );

    assign gpio [4] = 1'b1;  // VCC
    assign gpio [6] = 1'b0;  // GND

    //------------------------------------------------------------------------

    seven_segment_8_digits_sound i_display
    (
        .clock    ( clk      ),
        .reset    ( reset    ),
        .number   ( cs_count ),
        .abcdefgh ( abcdefgh ),
        .digit    ( digit    )
    );

    //------------------------------------------------------------------------
	frequency_counter fc //(input clk , reset, input [15:0] value, output reg [15:0] cs_count );
	(
		.clk		(  clk    ),
		.reset		(  reset  ),
		.value		(  value  ),
		.cs_count	( cs_count)

	);
	
	//------------------------------------------------------------------------
	
    wire c, d, e, f, g, b, a;
	
	assign c=((cs_count>745/2)&&(cs_count<747/2)); //c 1
	assign d=((cs_count>661/2)&&(cs_count<663/2)); //d 2
	assign e=((cs_count>588/2)&&(cs_count<592/2)); //e 4
	assign f=((cs_count>553/2)&&(cs_count<557/2)); //f 8
	assign g=((cs_count>493/2)&&(cs_count<497/2)); //g 16
	assign a=((cs_count>437/2)&&(cs_count<442/2)); //a 32
	assign b=((cs_count>384/2)&&(cs_count<393/2)); //b 64
	
    assign led[0] = ~ c;
	assign led[1] = ~ d;
	assign led[2] = ~ e;
	assign led[3] = ~ f;
	assign led[4] = ~ g;
	assign led[5] = ~ a;
	assign led[6] = ~ b;
	

endmodule

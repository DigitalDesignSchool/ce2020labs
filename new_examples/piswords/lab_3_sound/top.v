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
    wire cs;
    assign buzzer = ~ reset;
    
	always @ (posedge clk or posedge reset)
		begin       
			if (reset)
				cnt <= 8'b100;
			else
				cnt <= cnt + 8'b1;
		end
		assign cs  =   cnt [7]; 

    //------------------------------------------------------------------------

    wire [15:0] value;

    pmod_mic3_spi_receiver i_microphone
    (
        .clock ( clk        ),
        .reset ( reset      ),
        .cs    ( gpio  [14] ),
        .sck   ( gpio  [ 8] ),
        .sdo   ( gpio  [10] ),
        .value ( value      )
    );

    assign gpio [4] = 1'b1;  // VCC
    assign gpio [6] = 1'b0;  // GND

    //------------------------------------------------------------------------

    assign led = ~ value [13:6];

    //------------------------------------------------------------------------

	reg [1:0] state;
	reg [ 7:0] cnt;
	reg [31:0] count;
	reg [31:0] distance;
	reg [31:0] segments;
    
   

	localparam [3:0] idle    = 0;
	localparam [3:0] tick_1  = 1;
	localparam [3:0] tick_2  = 2;

	wire pos_level;
	wire neg_level;

	assign pos_level=(value>16'h1000);
	assign neg_level=(value<16'h1000);


	always @(posedge cs)
	if(reset) state<=idle;
	else
	begin
		case(state)
		idle:
			begin
			 count<=0;
			 if (pos_level)
			  state<=tick_1;
			end
		tick_1:
			begin
				if(pos_level)
				 count<=count+1;
				else if(neg_level)
				 state<=tick_2;
			end
		tick_2:
			begin
				if(neg_level)
				 count<=count+1;
				 else if(pos_level)
				begin
                  state<=idle;
				 distance<=count;
				end
			end
		endcase
	end
	
					
     always @(posedge cs)
	 casex(distance)
		 32'h2ex:segments=32'hc4;
         32'h2bx:segments=32'hdb4;
		 32'h29x:segments=32'hd4;
         32'h27x:segments=32'heb4;
		 32'h24x:segments=32'he4;
		 32'h22x:segments=32'hf4;
         32'h20x:segments=32'h9b4;
		 32'h1fx:segments=32'h94;
         32'h1dx:segments=32'hab4;
		 32'h1bx:segments=32'ha4;
         32'h1ax:segments=32'hbb4;
		 32'h18x:segments=32'hb4;
         32'h17x:segments=32'hc5;
		 default:segments=32'h0000;
     endcase
/*  
	reg [15:0] prev_value;
    reg [31:0] counter;
    reg [31:0] distance;

    localparam [15:0] threshold = 16'h1000;

    always @ (posedge clk or posedge reset)
        if (reset)
        begin
            prev_value <= 16'h0;
            counter    <= 32'h0;
            distance   <= 32'h0;
        end
        else
        begin
            prev_value <= value;

            if (  value      > threshold
                & prev_value < threshold)
            begin
               distance <= counter;
               counter  <= 32'h0;
            end
            else
            begin
               counter <= counter + 32'h1;
            end
        end
*/
    //------------------------------------------------------------------------ 

    seven_segment_8_digits i_display
    (
        .clock    ( clk      ),
        .reset    ( reset    ),
        .number   ( segments ),
        .abcdefgh ( abcdefgh ),
        .digit    ( digit    )
    );

endmodule

`timescale 1ns / 1ps

`define SIZE 100
`define MAX_TONE_VALUE 1_000_0


module top(
	input clk,
	input a,
	input b,
	output reg [7:0] signal
    );
	 //########################//
	 reg [31:0] sin1[0:`SIZE];
	 
	 initial begin
		sin1[0] = 31;

		sin1[1] = 32;

		sin1[2] = 34;

		sin1[3] = 36;

		sin1[4] = 38;

		sin1[5] = 40;

		sin1[6] = 42;

		sin1[7] = 44;

		sin1[8] = 45;

		sin1[9] = 47;

		sin1[10] = 49;

		sin1[11] = 50;

		sin1[12] = 52;

		sin1[13] = 53;

		sin1[14] = 54;

		sin1[15] = 56;

		sin1[16] = 57;

		sin1[17] = 58;

		sin1[18] = 59;

		sin1[19] = 59;

		sin1[20] = 60;

		sin1[21] = 61;

		sin1[22] = 61;

		sin1[23] = 61;

		sin1[24] = 61;

		sin1[25] = 62;

		sin1[26] = 61;

		sin1[27] = 61;

		sin1[28] = 61;

		sin1[29] = 61;

		sin1[30] = 60;

		sin1[31] = 59;

		sin1[32] = 59;

		sin1[33] = 58;

		sin1[34] = 57;

		sin1[35] = 56;

		sin1[36] = 54;

		sin1[37] = 53;

		sin1[38] = 52;

		sin1[39] = 50;

		sin1[40] = 49;

		sin1[41] = 47;

		sin1[42] = 45;

		sin1[43] = 44;

		sin1[44] = 42;

		sin1[45] = 40;

		sin1[46] = 38;

		sin1[47] = 36;

		sin1[48] = 34;

		sin1[49] = 32;

		sin1[50] = 31;

		sin1[51] = 29;

		sin1[52] = 27;

		sin1[53] = 25;

		sin1[54] = 23;

		sin1[55] = 21;

		sin1[56] = 19;

		sin1[57] = 17;

		sin1[58] = 16;

		sin1[59] = 14;

		sin1[60] = 12;

		sin1[61] = 11;

		sin1[62] = 9;

		sin1[63] = 8;

		sin1[64] = 7;

		sin1[65] = 5;

		sin1[66] = 4;

		sin1[67] = 3;

		sin1[68] = 2;

		sin1[69] = 2;

		sin1[70] = 1;

		sin1[71] = 0;

		sin1[72] = 0;

		sin1[73] = 0;

		sin1[74] = 0;

		sin1[75] = 0;

		sin1[76] = 0;

		sin1[77] = 0;

		sin1[78] = 0;

		sin1[79] = 0;

		sin1[80] = 1;

		sin1[81] = 2;

		sin1[82] = 2;

		sin1[83] = 3;

		sin1[84] = 4;

		sin1[85] = 5;

		sin1[86] = 7;

		sin1[87] = 8;

		sin1[88] = 9;

		sin1[89] = 11;

		sin1[90] = 12;

		sin1[91] = 14;

		sin1[92] = 16;

		sin1[93] = 17;

		sin1[94] = 19;

		sin1[95] = 21;

		sin1[96] = 23;

		sin1[97] = 25;

		sin1[98] = 27;

		sin1[99] = 29;
	 end
	 //#######################################//
	  
	 reg [7:0] index = 0;
	 reg [31:0] tone = 0;
	 
	 wire [2:0] value;
	 encoder enc(.clk(clk),.a(a),.b(b),.q(value));
	 
	 always@(posedge clk)
	 begin
		tone = tone + 1;
		if(tone >= `MAX_TONE_VALUE)
		begin
			signal = value * sin1[index]/2;
			index = index + 1;
			
			tone = 0;
			if(index == `SIZE) index = 0;
		end
	end
	 
endmodule




`timescale 1ns / 1ps

`define limit 10_000

`define READ_ENC  0
`define INC_VALUE 1

module encoder(
	input clk,
	input a,
	input b,
	output reg [2:0] q = 0
    );
	reg state = 0;
	 
	 reg [15:0] count_a = 0;
	 reg [15:0] count_b = 0;
	 
	 reg first_reg = 0;
	 
	 
	 reg end_read_reg_a = 0;
	 reg end_read_reg_b = 0;
		
	
	always@(posedge clk)
	begin
	//read a
		if(a == 0)count_a = count_a + 1;
		else count_a = 0;
		
		if(count_a >= `limit )
		begin
				first_reg = 0;
				end_read_reg_a = 1;
				count_a = 0;
		end
		
		//read b
		if(b == 0)count_b = count_b + 1;
		else count_b = 0;
		
		if(count_b >= `limit)
		begin
				first_reg = 1;
				end_read_reg_b = 1;
				count_b = 0;
		end
		///////////////////////////////////////////
		
		//end of reading
		if((end_read_reg_a == 1) && (end_read_reg_b == 1))
		begin
		/*
			if(((a == 0) && (b == 1))||((a == 1) && (b == 0)))
			begin
				if(first_reg == 1) q = q + 1;
				else q = q - 1;
			end
			*/
			if(((a == 0) && (b == 1)))
			begin
				q = q + 1;
			end
			if(((a == 1) && (b == 0)))
			begin
				q = q - 1;
			end
			
			//reset to begin state
			first_reg = 0;
			end_read_reg_a = 0;
			end_read_reg_b = 0;
		end
	end
	

endmodule

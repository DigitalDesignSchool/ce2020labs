module other_single_port_ram21
#( parameter  RAMLENGTH=800, //RAMLENGTH*DATAWIDTH = 4800 = 80x60 RAM RESOLUTION
				  RAM_INITIAL_VALUE=6'b111111, //default value for memreset
				  DATA_WIDTH=6,
				  ADDR_WIDTH=10
 )
(
	input [DATA_WIDTH-1:0]data,		//RAM words' write input			
	input [ADDR_WIDTH-1:0] addr,				 //ln(RAMLENGTH)/ln(2)
	input we, clk, memenable,
	input [ADDR_WIDTH:0] resetcnt,
	output [DATA_WIDTH-1:0]q	//RAM words' read input
);

	//memreset variable
	//integer i;

	// Declare the RAM variable
	
	(* ramstyle = "M9K" *) reg  [DATA_WIDTH-1:0]ramblock[3*RAMLENGTH-1:0] ;
	//(* ramstyle = "M9K" *) - synthesis attribute for making ramblocks of Altera M9K memory blocks
	// !!! Not sure in its usefullness
	
	// Variable to hold the registered read address, write data, and we
	reg [ADDR_WIDTH-1:0] addr_reg;
	reg [DATA_WIDTH-1:0] data_reg;
	reg we_reg;

    wire [ADDR_WIDTH-1:0] addr_x;
    wire [DATA_WIDTH-1:0] data_x;
    wire                  we_x;

    
	
	// always @ (posedge clk)begin
	// //memory reset
	// if(memreset) counter<='d800;
	// else if(counter!=0) 
	// 	begin 
	// 	counter<=counter-1;
	// 	ramblock[counter-1]<=RAM_INITIAL_VALUE;
	// 	end
	// //R/W operations 
	// else if(enable) begin
	// 		addr_reg <= addr;
	// 		data_reg <= data;
	// 		we_reg<=we;
	// 	// Write
	// 		if (we_reg) begin
	// 			ramblock[addr_reg]<=data_reg;
	// 		end
	// end
    // end

    assign addr_x = (memenable) ? addr : resetcnt;
    assign data_x = (memenable) ? data : '0;
    assign we_x   = (memenable) ? we   : 1;
	 
	always @ (posedge clk)begin
	addr_reg <= addr_x;
	we_reg<=we_x;
	data_reg <= data_x;
	if (we_reg) begin ramblock[addr_reg]<=data_reg;
					end
	end
	
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ramblock[addr_reg];
	
endmodule
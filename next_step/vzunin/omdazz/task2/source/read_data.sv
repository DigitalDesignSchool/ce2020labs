module read_data
#(  parameter DATA_WIDTH = 8, 
    parameter ARRAY_W_W  = 4, //Строк в массиве весов
    parameter ARRAY_W_L  = 4, //Столбцов в массиве весов
    parameter ARRAY_A_W  = 4, //Строк в массиве данных
    parameter ARRAY_A_L  = 4) //Столбцов в массиве данных
(   input clk,
    input reset_n,

    output reg [0:ARRAY_W_W - 1] [0:ARRAY_W_L - 1] [DATA_WIDTH - 1:0]     data_rom_w,
    output reg [0:ARRAY_A_W - 1] [0:ARRAY_A_L - 1] [DATA_WIDTH - 1:0]     data_rom_b,
    output reg [0:ARRAY_W_W - 1] [0:ARRAY_A_L - 1] [2 * DATA_WIDTH - 1:0] result
);

always @(posedge clk) 
begin
    if (~reset_n)
    begin
        data_rom_w <= {'{8'h00, 8'h01, 8'h02, 8'h03, 8'h04}, 
                       '{8'h0a, 8'h0b, 8'h0c, 8'h0d, 8'h0e}};
        data_rom_b <= {'{8'h00, 8'h01}, 
                       '{8'h02, 8'h03}, 
                       '{8'h04, 8'h05}, 
                       '{8'h06, 8'h07}, 
                       '{8'h08, 8'h09}};
        result     <= {'{16'h003c, 16'h0046}, 
                       '{16'h0104, 16'h0140}};
    end
end
endmodule

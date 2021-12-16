// Данный модуль производит считывание данных из файлов и сохраняет их в регистры.
// После это с использованием сигнала change можно производить 
// поочередное считывание данных. Таким образом, проводится циклическая 
// подача восьми различных вариантов входных и выходных данных 
// основного вычислителя модуля систолического массива.

module read_data 
#(parameter DATA_WIDTH=8)(
    input                       clk,
    input                       reset_n,
    input                       change,

    output [2:0]                code,

    output [DATA_WIDTH-1:0]     inp,
    output [DATA_WIDTH-1:0]     par,
    output [2*DATA_WIDTH-1:0]   prop,
    output [2*DATA_WIDTH-1:0]   result    
 );


reg [0:7] [DATA_WIDTH-1:0]   data_inp;
reg [0:7] [DATA_WIDTH-1:0]   data_param;
reg [0:7] [2*DATA_WIDTH-1:0] data_prop;
reg [0:7] [2*DATA_WIDTH-1:0] data_result;

reg [2:0] code_b;

always @(posedge clk)
begin
    if (~reset_n)
    begin
        code_b = 'd0;
        // Индексация    0      1      2      3      4      5      6      7
        data_inp    = {8'hf1, 8'hf7, 8'hc8, 8'h4c, 8'h50, 8'hd9, 8'h32, 8'h85};
        data_param  = {8'hc8, 8'h6d, 8'h83, 8'hd1, 8'hd7, 8'h4b, 8'h17, 8'h82};
        // Индексация      0         1         2         3         4         5         6         7
        data_prop   = {16'h001b, 16'h0031, 16'h00de, 16'h0032, 16'h00b9, 16'h0057, 16'h00d7, 16'h00e6};
        data_result = {16'hbc63, 16'h695c, 16'h6736, 16'h3e3e, 16'h43e9, 16'h3fea, 16'h0555, 16'h4470};
    end
    else
        if (change)
            code_b = code_b + 1;
end

assign inp    = data_inp[code_b];
assign par    = data_param[code_b];
assign prop   = data_prop[code_b];
assign result = data_result[code_b];


// Для RZRD
assign code = ~{code_b[0], code_b[1], code_b[2]};
// Для omdazz
//assign code = ~code_b;
 
endmodule

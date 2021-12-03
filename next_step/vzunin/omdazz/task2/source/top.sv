module top 
#(  parameter DATA_WIDTH = 8,
    parameter ARRAY_W_W = 2, //Строк в массиве весов
    parameter ARRAY_W_L = 5, //Столбцов в массиве весов
    parameter ARRAY_A_W = 5, //Строк в массиве данных
    parameter ARRAY_A_L = 2) //Столбцов в массиве данных
(   input                   clk,
    input                   reset_n,
    input           [3:0]   key_sw,
    output  wire    [3:0]   led,
    output                  buzzer,
    output          [7:0]   segment,
    output          [3:0]   digit
);

wire ready;
wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0]   input_data_b;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0]   input_data_a;
wire [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] result;

reg [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] out_data;

// Модуль считывания матриц
read_data 
#(  .DATA_WIDTH(DATA_WIDTH), 
    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
rd1
(   .clk(clk), 
    .reset_n(reset_n),
    .data_rom_w(input_data_a),
    .data_rom_b(input_data_b),
    .result(result)
);

wire load_params, start_comp, next;

button_debouncer bd1 (
    .clk(clk),
    .reset(~reset_n),
    .key(key_sw[0]),
 
    .key_state_o(load_params)
);

button_debouncer bd2 (
    .clk(clk),
    .reset(~reset_n),
    .key(key_sw[1]),

    .key_state_o(start_comp)
);


// Модуль вычислителя
sys_array_fetcher 
#(  .DATA_WIDTH(DATA_WIDTH), 
    .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
    .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
fetching_unit (
    .clk(clk),
    .reset_n(reset_n),
    .load_params(load_params),
    .start_comp(start_comp),
    .input_data_b(input_data_b),
    .input_data_w(input_data_a),

    .ready(ready),
    .out_data(out_data)
);

reg [2*DATA_WIDTH-1:0] data;

// Подклюаем модуль для вывода результата на семисегментные индикаторы.
seven_segment_4_digits ds1 (
    .clock(clk),
    .reset(~reset_n),
    .number(data),
    .abcdefgh(segment),
    .digit(digit)
);

reg [1:0] ind;

wire next_item;

button_debouncer deb4 (
    .clk(clk),
    .reset(~reset_n),
    .key(key_sw[2]),
 
    .key_down_o(next_item),
); 

always @(posedge clk)
begin
    if (~reset_n)
        ind <= 2'b0;
    else
    begin
        data <= out_data[ind[1]][ind[0]];
        if (next_item)
            ind  <= ind + 1;
    end
end

assign led[0] = ~ready;
assign led[1] = ~(data == result[ind[1]][ind[0]]);
assign led[2] = ~ind[1];
assign led[3] = ~ind[0];


endmodule

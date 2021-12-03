module top (
    input           clk,
    input           reset_n,
    input   [3:0]   key_sw,
    output  [3:0]   led,
    output          buzzer,
    output  [7:0]   segment,
    output  [3:0]   digit
);

localparam DATA_WIDTH = 8;

wire change_preset, param_load;
wire [2:0] code;

reg [DATA_WIDTH - 1:0] inp;
reg [DATA_WIDTH - 1:0] par;
reg [2 * DATA_WIDTH - 1:0] prop;
reg [2 * DATA_WIDTH - 1:0] result;

button_debouncer bd1 (
    .clk(clk),
    .reset(~reset_n),
    .key(key_sw[0]),
 
    .key_down_o(change_preset)
);

button_debouncer bd2 (
    .clk(clk),
    .reset(~reset_n),
    .key(key_sw[1]),

    .key_down_o(param_load)
);

// Индикация работы вычислительного модуля
// Корректность подсчета
assign led[0] = ~(data == result);
// Номер пресета данных
assign led[3:1] = code;


// Подключаем модуль для считывания тестовых данных.
read_data 
#(.DATA_WIDTH(DATA_WIDTH)) rd1 (
    .clk(clk),
    .reset_n(reset_n),
    .change(change_preset),

    .code(code),
    .inp(inp),
    .par(par),
    .prop(prop),
    .result(result)
 );

// Подключаем основной вычислительный модуль систолического массива.
sys_array_cell 
#(.DATA_WIDTH(DATA_WIDTH)) sac1
// Задание 1. Подключите недостающие сигналы
(   .clk(clk),
    .reset_n(reset_n),
    .param_load(param_load),
    .input_data(inp),
    .prop_data(prop),
    .param_data(par),
    
    .out_data(),
    .prop_param()
);

// Подклюаем модуль для вывода результата на семисегментные индикаторы.
seven_segment_4_digits ss4d1
// Задание 1. Подключите недостающие сигналы
(   .clock(),
    .reset(),
    .number(),
    .abcdefgh(),
    .digit()
);

endmodule

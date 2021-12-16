// Модуль создания систолического массива.
// В данном модуле происходит соединение всех вычислительных модулей 
// для формирования систолического массива.
module sys_array_basic
#(
    parameter DATA_WIDTH = 8,
    parameter ARRAY_W_W  = 4, //Строк в массиве весов
    parameter ARRAY_W_L  = 4, //Столбцов в массиве весов
    parameter ARRAY_A_W  = 4, //Строк в массиве данных
    parameter ARRAY_A_L  = 4) //Столбцов в массиве данных
(   input                                                           clk,
    input                                                           reset_n,
    input                                                           weights_load,
    input                   [0:ARRAY_A_W-1]     [DATA_WIDTH-1:0]    input_data,
    input [0:ARRAY_W_W-1]   [0:ARRAY_W_L-1]     [DATA_WIDTH-1:0]    weight_data,

    output                  [0:ARRAY_W_W-1]     [2*DATA_WIDTH-1:0]  output_data
);

wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [2*DATA_WIDTH-1:0] temp_output_data;
wire [0:ARRAY_W_W-1] [0:ARRAY_W_L-1] [DATA_WIDTH-1:0] propagate_module;

genvar i;
genvar j;
genvar t;
// Генерация массива вычислительных ячеек
// Задание 2. Допишите необходимые входные и выходные сигналы.
generate
    for(i = 0; i < ARRAY_W_W; i = i + 1) begin : generate_array_proc
         for (j = 0; j < ARRAY_W_L; j = j + 1) begin : generate_array_proc2
         if ((i == 0) && (j == 0)) // i - строка, j - столбец
         begin
              sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst ( 
              .clk(clk),
              .reset_n(reset_n),
              .param_load(weights_load),
              .input_data(input_data[0]),
              .prop_data({2*DATA_WIDTH{1'b0}}),
              .param_data(weight_data[0][0]),
              .out_data(temp_output_data[0][0]),
              .prop_param(propagate_module[0][0])
              );
         end
         else if (i == 0) // Первая строка
         begin
              sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
              .clk(),
              .reset_n(),
              .param_load(),
              .input_data(),
              .prop_data(),
              .param_data(),
              .out_data(),
              .prop_param()
              );
         end
         else if (j == 0) // Первый столбец
         begin
              sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
              .clk(),
              .reset_n(),
              .param_load(),
              .input_data(),
              .prop_data(),
              .param_data(),
              .out_data(),
              .prop_param()
              );
         end
         else
         begin // Остальные элементы
              sys_array_cell #(.DATA_WIDTH(DATA_WIDTH)) cell_inst (
              .clk(),
              .reset_n(),
              .param_load(),
              .input_data(),
              .prop_data(),
              .param_data(),
              .out_data(),
              .prop_param()
              );
         end
         end
    end
endgenerate

// Генерация связей для выходных данных
generate
    for (t=0;t<ARRAY_W_W;t=t+1) begin: output_prop
        assign output_data[t] = temp_output_data[t][ARRAY_W_L-1];
    end
endgenerate

endmodule

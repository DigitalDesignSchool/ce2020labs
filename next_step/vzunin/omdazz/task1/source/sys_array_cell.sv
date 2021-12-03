//Основной вычислительный модуль систолического массива.

module sys_array_cell
#(parameter DATA_WIDTH = 8)
(   input                                     clk,
    input                                     reset_n,
    input                                     param_load,
    input      signed [DATA_WIDTH - 1:0]      input_data,
    input      signed [2 * DATA_WIDTH - 1:0]  prop_data,
    input      signed [DATA_WIDTH - 1:0]      param_data,
     
    output reg signed [2 * DATA_WIDTH - 1:0]  out_data,
    output reg signed [DATA_WIDTH - 1:0]      prop_param
);

reg signed [DATA_WIDTH - 1:0] par;

always @(posedge clk)
begin
    if (~reset_n) begin // Сброс
        out_data <= {2 * DATA_WIDTH{1'b0}};
        par <= {DATA_WIDTH{1'b0}};
    end
    else if (param_load) begin // Загрузка параметра
        par <= param_data;
    end
    else begin // Вычисление данных
        // Задание 1. Реализуйте основные вычисления модуля.        
    end
end
    
endmodule

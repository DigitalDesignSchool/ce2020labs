// Модуль для автоматизированной подачи данных в систолический массив и расчета результата.
module sys_array_fetcher
#(  parameter DATA_WIDTH = 8,
    parameter ARRAY_W_W = 2, //Строк в массиве весов
    parameter ARRAY_W_L = 5, //Столбцов в массиве весов
    parameter ARRAY_A_W = 5, //Строк в массиве данных
    parameter ARRAY_A_L = 2) //Столбцов в массиве данных
(   input                                                                 clk,
    input                                                                 reset_n,
    input                                                                 load_params,
    input                                                                 start_comp,
    input      [0:ARRAY_A_W - 1] [0:ARRAY_A_L - 1] [DATA_WIDTH - 1:0]     input_data_b,
    input      [0:ARRAY_W_W - 1] [0:ARRAY_W_L - 1] [DATA_WIDTH - 1:0]     input_data_w,

    output reg                                                            ready,
    output reg [0:ARRAY_W_W - 1] [0:ARRAY_A_L - 1] [2 * DATA_WIDTH - 1:0] out_data
);

// Необходимое количество циклов clk для выполнения выборки и возврата результатов
localparam FETCH_LENGTH = ARRAY_A_L + ARRAY_A_W + ARRAY_W_W + 1; 

reg [15:0] cnt; // Счетчик
reg [ARRAY_A_W-1:0] [1:0] control_sr_read; // Контрольные сигналы регистра чтения
reg [ARRAY_W_W-1:0] [1:0] control_sr_write; // Контрольные сигналы регистра записи

wire [0:ARRAY_A_W-1] [DATA_WIDTH-1:0] input_sys_array;
wire [0:ARRAY_A_W-1] [DATA_WIDTH-1:0] empty_wire_reads;
wire [0:ARRAY_A_W-1] [0:ARRAY_A_L-1] [DATA_WIDTH-1:0] empty_wire2_reads;
wire [0:ARRAY_W_W-1] [0:ARRAY_A_L-1] [2*DATA_WIDTH-1:0] empty_wire_writes;
wire [0:ARRAY_W_W-1] [2*DATA_WIDTH-1:0] empty_wire2_writes;
wire [0:ARRAY_W_W-1] [2*DATA_WIDTH-1:0] output_sys_array;
wire [0:ARRAY_W_W - 1] [0:ARRAY_A_L - 1] [2 * DATA_WIDTH - 1:0] output_wire;

genvar i,j;

generate
    for (i=0;i<ARRAY_A_W; i=i+1) begin: generate_reads_shift_reg
        shift_reg #(.DATA_WIDTH(DATA_WIDTH), .LENGTH(ARRAY_A_L)) reads
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_read[i]),
            .data_in(input_data_b[i]),
            .data_write(empty_wire_reads[i]),
            .data_read(input_sys_array[i]),
            .data_out(empty_wire2_reads[i])
        );
    end
endgenerate

generate
    for (i=0;i<ARRAY_W_W;i=i+1) begin: generate_writes_shift_reg
        shift_reg #(.DATA_WIDTH(2*DATA_WIDTH), .LENGTH(ARRAY_A_L)) writes
        (   .clk(clk),
            .reset_n(reset_n),
            .ctrl_code(control_sr_write[i]),
            .data_in(empty_wire_writes[i]),
            .data_write(output_sys_array[i]),
            .data_read(empty_wire2_writes[i]),
            .data_out(output_wire[i])
        );
    end
endgenerate

sys_array_basic #(.DATA_WIDTH(DATA_WIDTH), 
                  .ARRAY_W_W(ARRAY_W_W), .ARRAY_W_L(ARRAY_W_L),
                  .ARRAY_A_W(ARRAY_A_W), .ARRAY_A_L(ARRAY_A_L)) 
systolic_array
(
    .clk(clk),
    .reset_n(reset_n),
    .weights_load(load_params),
    .weight_data(input_data_w),
    .input_data(input_sys_array),
    .output_data(output_sys_array)
);

always @(posedge clk)
begin
    if (~reset_n) begin // Сброс
        cnt              <= 15'd0;
        control_sr_read  <= {ARRAY_A_W * 2{1'b0}};
        control_sr_write <= {ARRAY_W_W * 2{1'b0}};
        out_data         <= 'b0;
        ready            <= 1'b0;
    end
    else if(start_comp) begin // Начало вычислений
        cnt <= 15'd1;
        control_sr_read <= {ARRAY_A_W{2'b01}}; //initiate loading read registers
    end
    else  
        if (cnt > 0) begin // Основные вычисления
            if (cnt == 1) begin // Задание сигналова на первом такте вычислений
                control_sr_read[ARRAY_A_W - 1:1] <= {2 * (ARRAY_A_W - 1){1'b0}};
                control_sr_read[0] <= 2'b11;
                cnt <= cnt + 1'b1; end
            else
            begin // Задание логических сигналов
                if (cnt < ARRAY_W_L + 1) // Включение регистров чтения
                    control_sr_read[cnt-1] <= 2'b11; 
                if ((cnt > ARRAY_A_L) && (cnt < ARRAY_A_L + ARRAY_W_L + 1)) // Старт отключения регистров чтения
                    control_sr_read[cnt - ARRAY_A_L - 1] <= 2'b00;
                if ((cnt > ARRAY_W_L + 1) && (cnt < ARRAY_W_L + ARRAY_W_W + 2)) // Включение регистров записи
                    control_sr_write[cnt - ARRAY_W_L - 2] <= 2'b10;
                if ((cnt > ARRAY_W_L + ARRAY_A_L + 1) && (cnt <= FETCH_LENGTH)) // Старт отключения регистров записи
                    control_sr_write[cnt - (ARRAY_W_L + ARRAY_A_L) - 2] <= 2'b00;
                
                if (cnt <= FETCH_LENGTH+1)
                    cnt <= cnt + 1'b1;
                else begin // Выдача итогового результата
                    cnt      <= 15'd0;
                    out_data <= output_wire;
                    ready    <= 1'b1;
                end
            end
    end
end
endmodule



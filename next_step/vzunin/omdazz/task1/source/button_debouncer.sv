// Модуль предотвращения дребезга контактов
module button_debouncer
#(parameter CNT_WIDTH = 16)
(   input       clk,
    input       reset,
    input       key,  
 
    output reg  key_state_o,  
    output reg  key_down_o,  
    output reg  key_up_o   
);
 
// Синхронизируем вход с текущим тактовым доменом.
reg  [1:0] key_reg;
always @ (posedge clk)
begin
    if (reset)
        key_reg <= 2'b00;
    else
        key_reg <= {key_reg[0], ~key};
end
 
reg [CNT_WIDTH - 1:0] key_count;

wire key_change_f = (key_state_o != key_reg[1]);
wire key_cnt_max = &key_count;    
 
always @(posedge clk)
begin
    if (reset)
    begin
        key_count <= 0;
        key_state_o <= 0;
    end 
    else if(key_change_f)    
        begin
            key_count <= key_count + 'd1;  
            if(key_cnt_max) 
                key_state_o <= ~key_state_o;  
        end
        else  
            key_count <= 0;
end
 
always @(posedge clk)
begin
    key_down_o <= key_change_f & key_cnt_max & ~key_state_o;
    key_up_o   <= key_change_f & key_cnt_max &  key_state_o;
end
 
endmodule
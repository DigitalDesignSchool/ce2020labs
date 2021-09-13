
`timescale 1 ns / 1 ns
`default_nettype none 

//! Example for complex credit
module fifo_256
(
    input   wire                    reset_p,    //! 1 - reset
    input   wire                    clk,        //! clock

    input   wire    [255:0]         data_i,     //! данные, от 1 до 16 слов по 16 бит
    input   wire    [3:0]           size_i,     //! число слов на data_i, 0 - 16 слов
    input   wire                    data_we,    //! 1 - запись size_i слов с шины data_i

    output  wire    [15:0]          data_o,     //! данные для чтения
    input   wire                    data_rd,    //! 1 - чтение данных

    output  wire                    full,
    output  wire                    empty

);

logic   [255:0]             mem[4];

logic                       rstp;

logic   [255:0]             data_z;     //! предыдущее значение data_i

logic   [3:0]               start_word; //! текущая позиция записи в FIFO
logic   [6:0]               cnt_wr;     //! счётчик записи
logic   [6:0]               cnt_wr_z;   //! счётчик записи с задержкой на такт для компенсации цикла записи в память
logic   [6:0]               cnt_rd;     //! счётчик чтения
logic   [5:0]               word_cnt;   //! общее число слов в FIFO
logic   [4:0]               last;       //! число слов оставшееся для записи в память с прошлого цикла
logic   [3:0]               start_last; //! номер слова в регистре data_z с которого надо начинать запись
logic   [255:0]             w_data;     //! слово для записи в память
logic   [15:0]              w_valid;    //! маска разрешения записи слова в память

logic   [3:0]               n_start_word;
logic   [6:0]               n_cnt_wr;
logic   [5:0]               n_word_cnt;
logic   [4:0]               n_last;
logic   [3:0]               n_start_last;
logic   [255:0]             n_w_data;
logic   [15:0]              n_w_valid;

logic   [4:0]               n_current;  //! число слов которое пришло по шине data_i в текущем цикле
logic   [4:0]               n_write;    //! число слов которое будет записано в память в текущем цикле

always_comb begin

    n_word_cnt = word_cnt;
    n_cnt_wr   = cnt_wr;
    n_last     = last;
    n_start_word = start_word;
    

    if( data_we & ~full) begin
        if( 0==size_i ) begin
            n_current = 16;
        end else begin
            n_current = size_i;
        end
    end else begin
        n_current = 0;
    end 


    n_write = n_current + n_last; // определяем сколько слов надо записать, n_last - осталось с прошлого такта, n_current - пришло в этом такте

    if( n_write+n_start_word>16 ) begin
        n_last = n_write+n_start_word-16; // мы не можем записать больше 16-ти слов, остаток остаётся на следующий такт. Учитывается последнее записанное слово
        n_write = n_write - n_last;
        //n_start_last = n_write;
        if( n_write==16 )
            n_start_last = n_current-n_last;
        else 
            n_start_last = n_write;
    end else begin
        n_last = 0;  // на следующий такт ничего не осталось
        n_start_last = 0;
    end

    n_start_word = n_start_word + n_write;

    n_w_valid = '0;

    for( int ii=0; ii<start_word; ii++ ) begin
        n_w_valid[ii] = '0;
        n_w_data[16*ii+:16] = '0;
    end

    for( int ii=0; ii<last; ii++ ) begin
        n_w_valid[ii+start_word] = 1;
        n_w_data[16*(ii+start_word)+:16] = data_z[(start_last+ii)*16+:16];
    end

    for( int ii=0; ii<(n_write-last); ii++ ) begin
        n_w_valid[ii+start_word+last] = 1;
        n_w_data[16*(ii+start_word+last)+:16] = data_i[ii*16+:16];
    end

    n_word_cnt = n_word_cnt + n_write;
    n_cnt_wr   = n_cnt_wr + n_write;


    if( data_rd & ~empty )
        n_word_cnt = n_word_cnt - 1;
end

always_ff @(posedge clk) begin
    if( rstp ) begin
        word_cnt    <= #1 '0;
        cnt_wr      <= #1 '0;
        start_word  <= #1 '0;
        w_data      <= #1 '0;
        w_valid     <= #1 '0;
        last        <= #1 '0;
        start_last  <= #1 '0;
    end else begin
        word_cnt    <= #1 n_word_cnt;
        cnt_wr      <= #1 n_cnt_wr;
        start_word  <= #1 n_start_word;
        w_data      <= #1 n_w_data;
        w_valid     <= #1 n_w_valid;
        last        <= #1 n_last;
        start_last  <= #1 n_start_last;

    end

    data_z <= #1 data_i;
    cnt_wr_z <= #1 cnt_wr;

end

always_ff @(posedge clk) begin
    for( int ii=0; ii<16; ii++ )
        if( w_valid[ii] )
            mem[cnt_wr_z[5:4]][16*ii+:16] <= #1 w_data[ii*16+:16];
end


always @(posedge clk) begin

    rstp <= #1 reset_p;

    if( data_rd & ~empty ) begin
        cnt_rd <= #1 cnt_rd + 1;
    end


    if( rstp ) begin
        cnt_rd      <= #1 '0;
    end 

end


//assign  full    = (cnt_wr_z[5:0]==cnt_rd[5:0] && cnt_wr_z[6]!=cnt_rd[6]) ? 1 : 0;
//assign  full    = (word_cnt >= 48) ? 1 : 0;
assign  full    = (word_cnt >= 32) ? 1 : 0;
assign  empty   = (cnt_wr_z==cnt_rd) ? 1 : 0;

assign  data_o  = mem[cnt_rd[5:4]][cnt_rd[3:0]*16+:16];

endmodule

`default_nettype wire 
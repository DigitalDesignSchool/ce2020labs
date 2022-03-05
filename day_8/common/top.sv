
module top (
    input clock,
    input reset_n,
    input rx,

    output reg       tx,
    output reg [7:0] abcdefgh,
    output reg [3:0] nx_digit
);

  wire byte_ready;
  wire [7:0] ascii_data;

  uart_receiver listener (
      .clock  (clock),
      .reset_n(reset_n),
      .rx     (rx),

      .byte_data (ascii_data),
      .byte_ready(byte_ready)
  );

  wire separator, add, multiply, enter, clear, error_ascii;
  wire [3:0] digit;

  ascii_to_action translator (
      .clock(clock),
      .start(byte_ready),
      .reset(~reset_n),
      .data (ascii_data),

      .separator(separator),
      .add      (add),
      .multiply (multiply),
      .digit    (digit),
      .enter    (enter),
      .clear    (clear),
      .error    (error_ascii)
  );


  // Prepare and accumulate data 

  logic [7:0] number;
  logic enter_occured;

  data_aggregator aggregator (
      .clock    (clock),
      .reset    (~reset_n),
      .enter    (enter),
      .add      (add),
      .multiply (multiply),
      .separator(separator),
      .data     (digit),

      .number       (number),
      .enter_occured(enter_occured)
  );

  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  wire [15:0] result;
  wire overflow, newresult;
  wire [3:0] error_calculator;
  wire is_tx_busy;

  calculator calculator (
      .clock   (clock),
      .reset   (~reset_n || clear),
      .enter   (separator & enter_occured),
      .add     (add),
      .multiply(multiply),
      .data    (number),

      .newresult(newresult),
      .result   (result),
      .overflow (overflow),
      .error    (error_calculator)
  );

  seven_segment_4_digits display (
      .clock (clock),
      .reset (~reset_n),
      .number(result),

      .digit   (nx_digit),
      .abcdefgh(abcdefgh)
  );

  uart_transmitter loader (
      .clock(clock),
      .reset(~reset_n),
      .start(newresult),
      .data (result),

      .q   (tx),
      .busy(is_tx_busy)
  );


endmodule

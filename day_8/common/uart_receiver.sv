
module uart_receiver (
    input clock,
    input reset_n,
    input rx,

    output reg [7:0] byte_data,
    output           byte_ready
);
  parameter clock_frequency = 50000000;
  parameter baud_rate       = 9600;
  parameter clock_cycles_in_bit = clock_frequency / baud_rate;

  enum {IDLE, START, DATA, STOP} state;
  reg [31:0] counter;
  reg [3:0] bit_count;
  reg [1:0] rx_filter;

  always @(posedge clock) begin

    if (!reset_n) begin
      counter <= 0;
      state <= IDLE;
      rx_filter<= 0;
    end else begin

      rx_filter <= {rx_filter[0], rx};
      case (state)

        IDLE: begin
          byte_ready <= 0;
          if (rx_filter == 2'b10) begin  // Edge for start bit
            state <= START;
            bit_count <= 0;
            counter <= 0;
          end
        end

        START: begin
          counter <= counter + 1;
          if ((2 * counter) >= clock_cycles_in_bit) begin  // First indent is a half values
            counter <= 0;
            state <= DATA;
          end
        end

        DATA: begin
          counter <= counter + 1;
          if (counter == clock_cycles_in_bit) begin
            counter <= 0;
            bit_count <= bit_count + 1;
            byte_data <= {rx, byte_data[7:1]};
          end
          if (bit_count == 4'b1000) state <= STOP;
        end

        STOP: begin
          state <= IDLE;
          byte_ready <= 1;
        end

        default: state <= IDLE;
      endcase
    end

  end

endmodule

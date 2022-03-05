module uart_transmitter (
    input        clock,
    input        start,
    input        reset,
    input [15:0] data,

    output reg q,
    output     busy
);

  parameter clock_frequency = 50000000;
  parameter baud_rate       = 9600;
  parameter clock_cycles_in_bit = clock_frequency / baud_rate;
  
  reg [12:0] cnt;
  reg [3:0]  bit_num;

  wire bit_start = (cnt == clock_cycles_in_bit);
  wire idle = (bit_num == 4'hF);
  assign busy = ~idle;

  reg byte_state;
  wire [7:0] word = byte_state ? data[7:0] : data[15:8];

  always @(posedge clock) begin
    if (reset) cnt <= 13'b0;
    else if (start && idle) cnt <= 13'b0;
    else if (bit_start) cnt <= 13'b0;
    else cnt <= cnt + 13'b1;
  end

  always @(posedge clock) begin
    if (reset) begin
      bit_num    <= 4'hF;
      byte_state <= 1'b0;
      q <= 1'b1;
    end else if (start && idle) begin
      bit_num    <= 4'h0;
      byte_state <= 1'b0;
      q <= 1'b1;
    end else if (bit_start) begin
      case (bit_num)
        4'h0: begin bit_num <= 4'h1; q <= 1'b0;    end // start
        4'h1: begin bit_num <= 4'h2; q <= word[0]; end
        4'h2: begin bit_num <= 4'h3; q <= word[1]; end
        4'h3: begin bit_num <= 4'h4; q <= word[2]; end
        4'h4: begin bit_num <= 4'h5; q <= word[3]; end
        4'h5: begin bit_num <= 4'h6; q <= word[4]; end
        4'h6: begin bit_num <= 4'h7; q <= word[5]; end
        4'h7: begin bit_num <= 4'h8; q <= word[6]; end
        4'h8: begin bit_num <= 4'h9; q <= word[7]; end
        4'h9: begin bit_num <= 4'ha; q <= 1'b1;        // finish
            if (!byte_state) begin
                byte_state <= 1'b1;
                bit_num <= 4'h0; 
            end
        end
        default: begin bit_num <= 4'hF; end            // Stop
      endcase
    end
  end

endmodule

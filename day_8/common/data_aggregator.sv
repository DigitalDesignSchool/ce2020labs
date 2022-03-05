module data_aggregator (
    input       clock,
    input       reset,
    input       enter,
    input       add,
    input       multiply,
    input       separator,
    input [3:0] data,

    output reg [7:0] number,
    output reg enter_occured
);

  always @(posedge clock) begin
    if (reset) begin
      number <= 8'b0;
      enter_occured <= 1'b0;
    end else if (enter) begin
      number <= {number[3:0], data};
      enter_occured <= 1'b1;
    end else if (add || multiply) begin
      enter_occured <= 1'b0;
    end else if (separator) begin
      number <= 8'b0;
    end
  end

endmodule


module ascii_to_action (
    input       clock,
    input       start,
    input       reset,
    input [7:0] data,

    output           separator,
    output           add,
    output           multiply,
    output reg [3:0] digit,
    output           enter,
    output           clear,
    output           error
);

  always @(posedge clock) begin

    separator <= 1'b0;
    add <= 1'b0;
    multiply  <= 1'b0;
    enter <= 1'b0;
    clear <= 1'b0;
    error <= 1'b0;
    digit <= 1'b0;

    if (!reset && start) begin

      enter <= (data >= 'h30 && data <= 'h39) ||  // 0-9
               (data >= 'h41 && data <= 'h46) ||  // A-F
               (data >= 'h61 && data <= 'h66);  // a-f

      case (data)
        'h30: digit <= 'h0;
        'h31: digit <= 'h1;
        'h32: digit <= 'h2;
        'h33: digit <= 'h3;
        'h34: digit <= 'h4;
        'h35: digit <= 'h5;
        'h36: digit <= 'h6;
        'h37: digit <= 'h7;
        'h38: digit <= 'h8;
        'h39: digit <= 'h9;

        'h41: digit <= 'hA;
        'h42: digit <= 'hB;
        'h43: digit <= 'hC;
        'h44: digit <= 'hD;
        'h45: digit <= 'hE;
        'h46: digit <= 'hF;

        'h61: digit <= 'ha;
        'h62: digit <= 'hb;
        'h63: digit <= 'hc;
        'h64: digit <= 'hd;
        'h65: digit <= 'he;
        'h66: digit <= 'hf;

        'h2a: multiply  <= 1'b1; // *
        'h2b: add   <= 1'b1;     // +
        'h0a: separator <= 1'b1; // LF
        'h0d: separator <= 1'b1; // CR
        'h20: separator <= 1'b1; // SPACE
        'h52: clear <= 1'b1;  //R (Reset)
        'h72: clear <= 1'b1;  //r (Reset)

        default: error  <= 1'b1;
      endcase
    end
  end


endmodule

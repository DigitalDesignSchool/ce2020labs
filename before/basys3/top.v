module top
(
    input btnc,
    input btnu,
    input btnl,
    input btnr,
    input btnd,

    output [15:0] led
);

    wire a = ~ btnl;
    wire b = ~ btnr;
    
    wire result = a ^ b;

    assign led [0] = ~ result;

    assign led [1] = ~ (~ btnl ^ ~ btnr);

    // Exercise: Change the code below.
    // Write the same for led [2] - logic operation AND 
    // Write the same for led [3] - logic operation OR
    
    assign led [2] = 1'b0;
    assign led [3] = 1'b1;
    
endmodule

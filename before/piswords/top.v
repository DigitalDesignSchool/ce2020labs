module top
(
    input  [3:0] key,
    input  [3:0] sw,
    output [7:0] led,

    output       buzzer
);

    wire a = ~ key [0];
    wire b = ~ key [1];
    
    wire result = a ^ b;

    assign led [0] = ~ result;

    assign led [1] = ~ (~ key [0] ^ ~ key [1]);

    // Exercise 1: Change the code below.
    // Write the same for led [2] - logic operation AND 
    // Write the same for led [3] - logic operation OR
    
    assign led [2] = 1'b0;
    assign led [3] = 1'b1;

    // Exercise 2: Change the code below.
    // Turn on and off buzzer on the board using key.
    // Listen to the click sound.

    assign buzzer = 1'b0;
    
endmodule

`ifndef CONFIG_VH
`define CONFIG_VH

`timescale 1 ns / 1 ps

`define USE_STRUCTURAL_IMPLEMENTATION

//  `define CLK_100_MHZ
    `define CLK_50_MHZ
//  `define CLK_25_MHZ

`ifdef CLK_100_MHZ
    `define CLK_FREQUENCY  100000000
`elsif CLK_50_MHZ
    `define CLK_FREQUENCY   50000000
`elsif CLK_25_MHZ
    `define CLK_FREQUENCY   25000000
`else
    `error_either_CLK_100_MHZ_or_CLK_50_MHZ_or_CLK_25_MHZ_has_to_be_set
`endif

`endif

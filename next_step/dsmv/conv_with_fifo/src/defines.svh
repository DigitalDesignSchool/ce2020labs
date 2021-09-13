`ifndef DEFINES_SVH
`define DEFINES_SVH

`timescale 1 ns / 1ns

`ifdef VCS         // Synopsys
`elsif INCA        // Cadence
`elsif QUESTA      // Mentor
`elsif MODEL_TECH  // Mentor
`else
  `define NO_COVERAGE
`endif

`ifndef NO_COVERAGE
  `define COVERAGE
`endif

`endif

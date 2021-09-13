//`include "defines.svh"
`default_nettype none 

module  bind_fifo_w8
#(
    parameter               WIDTH = 16
)    
(
    input   wire                    reset_p,    //! 1 - reset
    input   wire                    clk,        //! clock

    input   wire    [WIDTH-1:0]     data_i,
    input   wire                    data_we,

    input   wire    [WIDTH-1:0]     data_o,
    input   wire                    data_rd,

    input   wire                    full,
    input   wire                    empty,

    input   wire   [3:0]            cnt_wr,
    input   wire   [3:0]            cnt_rd    

);
  
  covergroup cvr @ (posedge clk iff ~reset_p);
    option.comment      = "Comment for the report: fifo_w8";
    option.per_instance = 1;

    // First we check that every signal was toggled

    coverpoint data_we
    {
      bins we    = { 1 };
      bins no_we = { 0 };
    }

    coverpoint data_rd
    {
      bins rd    = { 1 };
      bins no_rd = { 0 };
    }
    
    coverpoint full
    {
      bins full    = { 1 };
      bins no_full = { 0 };
    }
    
    coverpoint empty
    {
      bins empty    = { 1 };
      bins no_empty = { 0 };
    }
    
    coverpoint cnt_wr;

    coverpoint cnt_rd;

    // Crosses

    we_full: cross data_we, full;
    rd_empy: cross data_rd, empty;


    
  endgroup
      
  cvr cg = new ();
      

     
  
endmodule

`default_nettype wire
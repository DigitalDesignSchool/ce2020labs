//`include "defines.svh"

`default_nettype none 

`include "defines.svh"

module  binding_coverage_credit_return
  (
    input wire aclk,
    input wire aresetn,

    input wire [7:0]    in_tdata,
    input wire          in_tvalid,
    input wire          in_tready,
  
    input  wire [15:0]  rd_a_data,
    input  wire         rd_a_valid,  

    input wire [15:0]   out_tdata,
    input wire          out_tvalid,
    input wire          out_tready


  );
  

logic [3:0] size;

assign size = rd_a_data[11:8];
  
  
`ifdef COVERAGE

//   wire [3:0] all_cases
//       = { in_tvalid, lower_bits, out_tvalid, out_tready };

  covergroup cvr @ (posedge aclk iff aresetn);
    option.comment      = "Comment for the report: upsizing covergroup";
    option.per_instance = 1;

    // First we check that every signal was toggled

    coverpoint in_tvalid
    {
      bins ivld    = { 1 };
      bins no_ivld = { 0 };
    }
    
    coverpoint in_tready
    {
      bins irdy    = { 1 };
      bins no_irdy = { 0 };
    }
    
    coverpoint out_tvalid
    {
      bins ovld    = { 1 };
      bins no_ovld = { 0 };
    }
    
    coverpoint out_tready
    {
      bins ordy    = { 1 };
      bins no_ordy = { 0 };
    }
    
    // Crosses

    i_vld_rdy: cross in_tvalid, in_tready;
    o_vld_rdy: cross out_tvalid, out_tready;



    rd_size: coverpoint { rd_a_valid, size  };
        
    o_rdy_transitions: coverpoint out_tready
    {
      bins ordy_010             = ( 0 => 1 => 0 );
      bins ordy_101             = ( 1 => 0 => 1 );
      bins ordy_1001            = ( 1 => 0 => 0 => 1 );
      bins ordy_101_or_1001     = ( 1 => 0 => 1 ), ( 1 => 0 => 0 => 1 );
      bins ordy_10001           = ( 1 => 0 [*3] => 1 );
      bins ordy_1_from_3_5_0_1  = ( 1 => 0 [*3:5] => 1 );
    }
    
  endgroup
      
	cvr cg = new ();
      
  
    logic [15:0] ccc;
      
 always @ (posedge aclk)
   ccc <= cg.o_rdy_transitions.get_coverage ();

`endif
      
  
endmodule

`default_nettype wire
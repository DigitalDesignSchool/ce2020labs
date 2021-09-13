//`include "defines.svh"

module  bind_user_axis
  #(
    parameter                n = 5,          //! Number of bytes
    parameter                nb = n * 8      //! Number of bits
  )
  (
  input  wire               clk,            //! clok
  input  wire               reset_n,        //! 0 - reset

  input  wire [nb*2 - 1:0]  in_tdata,       //! input data
  input  wire               in_tvalid,      //! 1 - input data is valid
  input  wire               in_tready,      //! 1 - ready for get data

  input  wire [nb - 1:0]    out_tdata,      //! output data
  input  wire               out_tvalid,     //! 1 - output data is valid
  input  wire               out_tready      //! 1 - ready for get data
  );
  
  


  covergroup cvr @ (posedge clk iff reset_n);
    option.comment      = "Comment for the report: user_axis";
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

    i_vld_rdy: cross in_tvalid,  in_tready;
    o_vld_rdy: cross out_tvalid, out_tready;




        
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
      
 always @ (posedge clk)
   ccc <= cg.o_rdy_transitions.get_coverage ();

      
  
endmodule
// downsizing example is created by Yuri Panchul, Dmitry Smekhov and Yaroslav Kolbasov

`include "defines.svh"

module downsizing_coverage
#(
  parameter W = 32
)
(
  input aclk,
  input aresetn,

  input     [W * 2 - 1:0]  in_tdata,
  input                    in_tvalid,
  input                    in_tready,

  input reg [W      - 1:0] out_tdata,
  input reg                out_tvalid,
  input                    out_tready,
  
  input                    sel
);
  
  covergroup cvr @ (posedge aclk iff aresetn);

    option.comment      = "Comment for the report: downsizing covergroup";
    option.per_instance = 1;

    // First we check that every signal was toggled

    coverpoint in_tvalid
    {
      bins ivld    = { 1 };
      bins no_ivld = { 0 };
    }

    coverpoint_without_bins_for_illustration: coverpoint in_tvalid;
    
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
    
    coverpoint sel
    {
      bins lower = { 1 };
      bins upper = { 0 };
    }
    
    // Crosses

    o_vld_rdy: cross out_tvalid, out_tready;

    // There is a coverage hole here
    
    i_vld_i_rdy_lower_upper: cross in_tvalid, in_tready, sel
    {
      // bins illegal
      //   = (binsof (sel) intersect { 1 }) && (binsof (in_tready) intersect { 0 });
    }

    o_rdy_transitions: coverpoint out_tready
    {
      bins ordy_010             = ( 0 => 1 => 0 );
      bins ordy_101             = ( 1 => 0 => 1 );
      bins ordy_1001            = ( 1 => 0 => 0 => 1 );
      bins ordy_101_or_1001     = ( 1 => 0 => 1 ), ( 1 => 0 => 0 => 1 );
      bins ordy_10001           = ( 1 => 0 [*3] => 1 );
      bins ordy_1_from_3_5_0_1  = ( 1 => 0 [*3:5] => 1 );
    }

    // Data
    
    out_tdata_auto: coverpoint in_tdata;

    out_tdata_fancy: coverpoint in_tdata
      iff (in_tvalid & in_tready)
    {
      bins          ABCDE                       = {   40'h4142434445 };
      bins          ABCDE_or_PQRST              = {   40'h4142434445 , 40'h5051525354   };
      bins          from_ABCDE_till_PQRST       = { [ 40'h4142434445 : 40'h5051525354 ] };
      bins          from_ABCDE_till_PQRST_3 [3] = { [ 40'h4142434445 : 40'h5051525354 ] };

      bins          mixed                       = { [ 40'h4142434445 : 40'h5051525354 ],
                                                      40'h5a61626364 };
      
      illegal_bins  AABCD                       = {   40'h4141424344 };
      ignore_bins   FGHIJ                       = {   40'h464748494a };
      bins          others                      = default;
    }

    in_tdata_wild: coverpoint out_tdata
      iff (in_tvalid & in_tready)
    {
      wildcard bins all_4X          = { 80'h4?4?4?4?4?_4?4?4?4?4? };
      wildcard bins five_4X_five_5X = { 80'h4?4?4?4?4?_5?5?5?5?5? };
      wildcard bins four_4X_six_5X  = { 80'h4?4?4?4?5?_5?5?5?5?5? };
      wildcard bins end_with_4      = { 80'h??????????_?????????4 };
      wildcard bins end_with_hexA   = { 80'h??????????_?????????A };
    }

    // TODO Exercise 1: find all illegal bins here
    
    i_vld_lower_o_vld_o_rdy: coverpoint
    { in_tvalid, out_tready, sel, out_tvalid }
    {
      bins i_vld_o_rdy_lower_o_vld_0000 = { 4'b0000 };
      bins i_vld_o_rdy_lower_o_vld_0001 = { 4'b0001 };
      bins i_vld_o_rdy_lower_o_vld_0011 = { 4'b0011 };
      bins i_vld_o_rdy_lower_o_vld_0100 = { 4'b0100 };
      bins i_vld_o_rdy_lower_o_vld_0101 = { 4'b0101 };
      bins i_vld_o_rdy_lower_o_vld_0110 = { 4'b0110 };
      bins i_vld_o_rdy_lower_o_vld_0111 = { 4'b0111 };
      bins i_vld_o_rdy_lower_o_vld_1000 = { 4'b1000 };
      bins i_vld_o_rdy_lower_o_vld_1001 = { 4'b1001 };
      bins i_vld_o_rdy_lower_o_vld_1010 = { 4'b1010 };
      bins i_vld_o_rdy_lower_o_vld_1011 = { 4'b1011 };
      bins i_vld_o_rdy_lower_o_vld_1100 = { 4'b1100 };
      bins i_vld_o_rdy_lower_o_vld_1101 = { 4'b1101 };
      bins i_vld_o_rdy_lower_o_vld_1110 = { 4'b1110 };
      bins i_vld_o_rdy_lower_o_vld_1111 = { 4'b1111 };
    }

  endgroup
      
  cvr cg = new ();

  final
  begin
    $display ("Total coverage                   : %0d", cg.get_coverage ());
    $display ("i_vld_lower_o_vld_o_rdy coverage : %0d", cg.o_rdy_transitions.get_coverage ());
  end

endmodule

bind downsizing downsizing_coverage # (.W (W)) coverage (.*);

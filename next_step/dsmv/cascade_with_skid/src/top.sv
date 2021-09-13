`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/10/2021 09:10:12 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none 

module top(

  input  wire             aclk,
  input  wire             aresetn,

  input  wire [255:0]     in_tdata,
  input  wire             in_tvalid,
  output wire             in_tready,

  output wire [255:0]     out_tdata,
  output wire             out_tvalid,
  input  wire             out_tready


);

logic [255:0]           c0_tdata;
logic                   c0_tvalid;
logic                   c0_tready;

logic [511:0]           c1_tdata;
logic                   c1_tvalid;
logic                   c1_tready;

logic [255:0]           c2_tdata;
logic                   c2_tvalid;
logic                   c2_tready;

logic [511:0]           c3_tdata;
logic                   c3_tvalid;
logic                   c3_tready;

logic [255:0]           c4_tdata;
logic                   c4_tvalid;
logic                   c4_tready;


logic [511:0]           c1s_tdata;
logic                   c1s_tvalid;
logic                   c1s_tready;

logic [255:0]           c2s_tdata;
logic                   c2s_tvalid;
logic                   c2s_tready;

logic [511:0]           c3s_tdata;
logic                   c3s_tvalid;
logic                   c3s_tready;

    
axis_register_slice_32 reg_i (
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 
  .s_axis_tvalid                (   in_tvalid       ), 
  .s_axis_tready                (   in_tready       ), 
  .s_axis_tdata                 (   in_tdata        ), 
  .m_axis_tvalid                (   c0_tvalid       ), 
  .m_axis_tready                (   c0_tready       ), 
  .m_axis_tdata                 (   c0_tdata        )  
);


upsizing    
#(
  .n                            (   32              )
)
upsizing_0
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c0_tdata        ),
  .in_tvalid                    (   c0_tvalid       ),
  .in_tready                    (   c0_tready       ),

  .out_tdata                    (   c1_tdata        ),
  .out_tvalid                   (   c1_tvalid       ),
  .out_tready                   (   c1_tready       )
);


skid_buffer
#(
  .n                            (   64              )
)
skid_0
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c1_tdata        ),
  .in_tvalid                    (   c1_tvalid       ),
  .in_tready                    (   c1_tready       ),

  .out_tdata                    (   c1s_tdata        ),
  .out_tvalid                   (   c1s_tvalid       ),
  .out_tready                   (   c1s_tready       )
);


downsizing    
#(
  .n                            (   32              )
)
downsizing_0
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c1s_tdata        ),
  .in_tvalid                    (   c1s_tvalid       ),
  .in_tready                    (   c1s_tready       ),

  .out_tdata                    (   c2_tdata        ),
  .out_tvalid                   (   c2_tvalid       ),
  .out_tready                   (   c2_tready       )
);

skid_buffer
#(
  .n                            (   32              )
)
skid_1
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c2_tdata        ),
  .in_tvalid                    (   c2_tvalid       ),
  .in_tready                    (   c2_tready       ),

  .out_tdata                    (   c2s_tdata        ),
  .out_tvalid                   (   c2s_tvalid       ),
  .out_tready                   (   c2s_tready       )
);


upsizing    
#(
  .n                            (   32              )
)
upsizing_1
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c2s_tdata        ),
  .in_tvalid                    (   c2s_tvalid       ),
  .in_tready                    (   c2s_tready       ),

  .out_tdata                    (   c3_tdata        ),
  .out_tvalid                   (   c3_tvalid       ),
  .out_tready                   (   c3_tready       )
);

skid_buffer
#(
  .n                            (   64              )
)
skid_2
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c3_tdata        ),
  .in_tvalid                    (   c3_tvalid       ),
  .in_tready                    (   c3_tready       ),

  .out_tdata                    (   c3s_tdata        ),
  .out_tvalid                   (   c3s_tvalid       ),
  .out_tready                   (   c3s_tready       )
);


downsizing    
#(
  .n                            (   32              )
)
downsizing_1
(
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 

  .in_tdata                     (   c3s_tdata        ),
  .in_tvalid                    (   c3s_tvalid       ),
  .in_tready                    (   c3s_tready       ),

  .out_tdata                    (   c4_tdata        ),
  .out_tvalid                   (   c4_tvalid       ),
  .out_tready                   (   c4_tready       )
);


axis_register_slice_32 reg_0 (
  .aclk                         (   aclk            ), 
  .aresetn                      (   aresetn         ), 
  .s_axis_tvalid                (   c4_tvalid       ), 
  .s_axis_tready                (   c4_tready       ), 
  .s_axis_tdata                 (   c4_tdata        ), 
  .m_axis_tvalid                (   out_tvalid      ), 
  .m_axis_tready                (   out_tready      ), 
  .m_axis_tdata                 (   out_tdata       )  
);


endmodule

`default_nettype wire
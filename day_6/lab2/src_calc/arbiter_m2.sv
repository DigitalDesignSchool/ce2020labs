`default_nettype none
/*
 * Round-robin arbiter {from Intel Cookbook} 
 * The round-robin pointer is updated by moving the pointer 
 * to the requester after the one which just received the grant (III type).
 */
module arbiter_m2
  #(
    parameter N = 5 // Number of requesters
  )(
    input wire		    rst,
    input wire			clk,
    input wire  [N-1:0] req,
    output wire [N-1:0]	grant
  );

localparam NP = $clog2(N);

logic [NP-1:0]   pointer;
logic           update_pointer;
logic [N-1:0]   v_pointer;
logic [N-1:0]   n_pointer;
logic [N-1:0]   n_grant;
  
always_comb begin

    v_pointer = (pointer+1==N) ? 0 : pointer+1; 
    //v_pointer = (pointer==0) ? N-1 : pointer-1; 
    n_grant = '0;
    update_pointer = 0;

    for( int ii=0; ii<N; ii++ ) begin
        if( req[v_pointer] ) begin
            n_grant[v_pointer] = 1;
            update_pointer = 1;
            break;
        end
        v_pointer = (v_pointer+1==N) ? 0 : v_pointer+1; 
        //v_pointer = (v_pointer==0) ? N-1 : v_pointer-1; 

    end

    n_pointer = (update_pointer) ? v_pointer : pointer;

end

assign grant = n_grant;

always_ff @ (posedge clk)
    if (rst )
      pointer <= #1 1;
    else	 
      pointer <= #1 n_pointer;


endmodule

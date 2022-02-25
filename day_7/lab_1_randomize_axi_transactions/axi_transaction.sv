// This AXI transaction randomization example is written by Yuri Panchul

// To see the details of AXI protocol, google: amba axi protocol specification
// To run this example in EDA Playground, use https://edaplayground.com/x/Y_SF

package axi_transaction;

  parameter adr_width    = 32;
  parameter data_width   = 32;

  parameter max_size     = 128;
  parameter max_len      = 256;
  parameter max_delay    = 100;

  parameter size_width   = $clog2 (max_size  + 1);
  parameter len_width    = $clog2 (max_len   + 1);
  parameter delay_width  = $clog2 (max_delay + 1);

  //--------------------------------------------------------------------------

  typedef logic [adr_width   - 1:0] adr_t;
  typedef logic [data_width  - 1:0] data_t;
  typedef logic [size_width  - 1:0] size_t;
  typedef logic [len_width   - 1:0] len_t;
  typedef bit   [delay_width - 1:0] delay_t;

  typedef enum { read, write } op_t;
  typedef enum { fixed, incr, wrap } burst_t;

  //--------------------------------------------------------------------------

  class axi_transaction;

    rand op_t    op;
    rand adr_t   adr;
    rand size_t  size;
    rand len_t   len;
    rand burst_t burst;
    rand data_t  data [];
    rand delay_t delay_adr;
    rand delay_t delay_data;

    // TODO Exercise: Step 1: Add a new 1-bit field called "secure"

    //------------------------------------------------------------------------

    constraint size_c
    {
      size inside { 1, 2, 4, 8, 16, 32, 64, 128 };
      size <= data_width / 8;
    }

    constraint len_c
    {
      len == data.size;
      len > 0 && len <= max_len;
    }

    // AXI has the following rules governing the use of bursts:
    // * for wrapping bursts, the burst length must be 2, 4, 8, or 16
    // * a burst must not cross a 4KB address boundary
    
    constraint burst_c
    {
      burst == wrap
        -> len inside { 2, 4, 8, 16 };
    }

    constraint adr_c
    {
      adr % size == 0;

      // For the incremental bursts, all data should be within 4096 byte page
      
      if (burst == incr)
        adr / 4096 == (adr + len - 1) / 4096;
    }

    constraint adr_distr_c
    {
      adr dist
      {
        [            0 :            1 ] := 25,
        [ 32'hffff0000 : 32'hffffffff ] :/ 25,
        [            2 : 32'hfffeffff ] :/ 25
      };
    }

    constraint adr_data_delay
    {
      delay_adr  <= max_delay;
      delay_data <= max_delay;
      
      signed' (delay_data) - signed' (delay_adr) dist
      {
                  0   := 30,
        [ -  1 :  1 ] := 30,
        [ -  3 :  3 ] := 35,
        [ - 20 : 20 ] := 5
      };
    }
    
    // TODO Exercise: Step 2:
    // Add a constraint that forces the "secure" field to 0
    // when burst is not wrap

    //------------------------------------------------------------------------

    function string str ();

      string s;

      $sformat (s, "%s adr='h%0h size=%0d len=%0d burst=%s dly_adr=%0d dly_data=%0d d=",
                op.name, adr, size, len, burst.name, delay_adr, delay_data);

      // TODO Exercise: Step 3: Add the "secure" field to this function

      for (int i = 0; i < data.size (); i++)
        s = { s, $sformatf (" 'h%h", data [i]) };

      return s;

    endfunction

  endclass

endpackage

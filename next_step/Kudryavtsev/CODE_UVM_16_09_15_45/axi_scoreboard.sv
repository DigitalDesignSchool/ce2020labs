`ifndef AXI_SCOREBOARD 
`define AXI_SCOREBOARD

class axi_scoreboard extends uvm_scoreboard;
  uvm_tlm_analysis_fifo#(axi_transaction) transaction_fifo;
  axi_transaction trans;
  ///////////////////////////////////////////////////////////////////////////////
  `uvm_component_utils(axi_scoreboard)
  ///////////////////////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : build phase 
  // Description : Constructor 
  ///////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    transaction_fifo = new("transaction_fifo", this);
    trans = axi_transaction::type_id::create("trans", this);
    `uvm_info(get_full_name(),"Build stage complete.",UVM_LOW)
  endfunction: build_phase
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : run 
  // Description : comparing expected and actual transactions
  ///////////////////////////////////////////////////////////////////////////////
  virtual task run_phase(uvm_phase phase);
  bit [31:0] Addend_0 = 0, Addend_1 = 0, Sum = 0;
   super.run_phase(phase);
    forever begin
     transaction_fifo.get(trans);
     if(trans!=null) 
     begin 
     case(trans.Address)
          `C_S00_BASEADDR : begin Addend_0 = trans.Data; Sum = Addend_1 + trans.Data; end
          `C_S00_BASEADDR + 4 : begin Addend_1 = trans.Data; Sum = Addend_0 + trans.Data; end
          `C_S00_BASEADDR + 8 : if(trans.Check == 0) assert (Sum == trans.Data) else begin
                                `uvm_error(get_full_name(),$sformatf("SUM ERROR: Sum=0x%X, Addend0=0x%X, Addend1=0x%X, Read.data=0x%X",Sum,Addend_0,Addend_1,trans.Data)); end
          `C_S00_BASEADDR + 12 : begin
            					 if(trans.Check == 0) assert(trans.Data == {32{(~Addend_0[31] & ~Addend_1[31] & Sum[31]) | (Addend_0[31] & Addend_1[31] & ~Sum[31])}}) 
                                 else begin `uvm_error(get_full_name(),$sformatf("EXTENSION ERROR")) end
          						 end
     endcase
    end         
   end
  endtask

endclass : axi_scoreboard

`endif

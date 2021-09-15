`ifndef AXI_BASIC_SEQ 
`define AXI_BASIC_SEQ

class axi_basic_seq extends uvm_sequence#(axi_transaction);
  `uvm_object_utils(axi_basic_seq)
  //////////////////////////////////////////////////////////////////////////////
  function new(string name = "axi_basic_seq");
    super.new(name);
  endfunction
  ///////////////////////////////////////////////////////////////////////////////
  // Method name : body 
  // Description : Body of sequence to send randomized transaction through
  // sequencer to driver
  //////////////////////////////////////////////////////////////////////////////
  virtual task body();
   for(int i=0; i<`NO_OF_TRANSACTIONS; i++) begin
      req = axi_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { (Op == READ) -> ((Address==(`C_S00_BASEADDR + 8)) || (Address==(`C_S00_BASEADDR + 12))); 
                                    (Op == WRITE) -> ((Address==`C_S00_BASEADDR) || (Address==(`C_S00_BASEADDR + 4))); });
      req.Last_Transaction = i; 
      //`uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      finish_item(req);
      end
      $display("---------------------------------------------------");
      $display("------ INFO : CHAOTIC TEST PASSED -----------------");
      $display("---------------------------------------------------");
      
      for(int i=0; i<`NO_OF_TRANSACTIONS; i++) begin
      req = axi_transaction::type_id::create("req");
      start_item(req);
      if(i==15) assert(req.randomize() with { Address == `C_S00_BASEADDR; Op == WRITE; Data==32'h72ba1264; }); 
      else assert(req.randomize() with { Address == `C_S00_BASEADDR; Op == WRITE; }); 
      //`uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      finish_item(req); 
      //req = axi_transaction::type_id::create("req");
      start_item(req);
      if(i==15) assert(req.randomize() with { Address == `C_S00_BASEADDR + 4; Op == WRITE; Data==32'h71b891ef; });      
      else assert(req.randomize() with { Address == `C_S00_BASEADDR + 4; Op == WRITE; });
      //`uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      finish_item(req);
      //req = axi_transaction::type_id::create("req");
      start_item(req);       
      assert(req.randomize() with { Address == `C_S00_BASEADDR + 8; Op == READ; }); 
     // `uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      finish_item(req); 
      //req = axi_transaction::type_id::create("req");
      start_item(req);      
      assert(req.randomize() with { Address == `C_S00_BASEADDR + 12; Op == READ; });
      req.Last_Transaction = i; 
      //`uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      finish_item(req);  
      end 
      $display("---------------------------------------------------");
      $display("------ INFO : RANDOM TEST PASSED ------------------");
      $display("---------------------------------------------------");
    
      
      for(int i=0; i<`NO_OF_TRANSACTIONS; i++) begin
      req = axi_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { Op == WRITE; });
      req.Check = 1; 
      finish_item(req);
      start_item(req); 
      assert(req.randomize() with { Op == READ; });
      req.Check = 1; 
      req.Last_Transaction = i; 
      finish_item(req); 
      //`uvm_info(get_full_name(),$sformatf("RANDOMIZED TRANSACTION FROM SEQUENCE %d",i),UVM_LOW)
      end 
      $display("---------------------------------------------------");
      $display("------ INFO : ADDRESS TEST PASSED -----------------");
      $display("---------------------------------------------------"); 
    
      
      for(int i=0; i<`NO_OF_TRANSACTIONS; i++) begin
      req = axi_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { Add_Delay == 0; Data_Delay == 0; Address == `C_S00_BASEADDR || Address == (`C_S00_BASEADDR + 4); Op == WRITE; });
      req.Check = 1; 
      req.Immediate_Read = 1; 
      finish_item(req); 
      start_item(req);      
      assert(req.randomize() with { Add_Delay == 0; Data_Delay == 0; Address == (`C_S00_BASEADDR + 8) || Address == (`C_S00_BASEADDR + 12); Op == READ; }); 
      req.Check = 1; 
      req.Immediate_Read = 1; 
      req.Last_Transaction = i; 
      finish_item(req);
      end 
      $display("---------------------------------------------------");
      $display("------ INFO : CONTINUOUS TEST PASSED --------------");
      $display("---------------------------------------------------");  
  endtask
  
endclass

`endif

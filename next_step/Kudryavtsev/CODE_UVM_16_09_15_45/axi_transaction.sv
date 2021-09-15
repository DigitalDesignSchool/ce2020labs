`ifndef AXI_TRANSACTION 
`define AXI_TRANSACTION

class axi_transaction extends uvm_sequence_item;
bit Check;
bit Immediate_Read;
int Last_Transaction;
rand write_read_e Op;
rand bit [31:0] Address;  
rand bit [31:0] Data;         
rand int Add_Delay;             //Delay between address and data transfers
rand int Data_Delay;            //delay after data transmissions
  //////////////////////////////////////////////////////////////////////////////
  `uvm_object_utils_begin(axi_transaction)
    `uvm_field_enum(write_read_e,Op,UVM_ALL_ON)
    `uvm_field_int(Check,UVM_ALL_ON)
    `uvm_field_int(Immediate_Read,UVM_ALL_ON)
    `uvm_field_int(Last_Transaction,UVM_ALL_ON)
    `uvm_field_int(Address,UVM_ALL_ON)
    `uvm_field_int(Data,UVM_ALL_ON)
    `uvm_field_int(Add_Delay,UVM_ALL_ON)
    `uvm_field_int(Data_Delay,UVM_ALL_ON)
  `uvm_object_utils_end
   
  //////////////////////////////////////////////////////////////////////////////
  //Constructor
  //////////////////////////////////////////////////////////////////////////////
  function new(string name = "axi_transaction");
    super.new(name);
  endfunction
  //////////////////////////////////////////////////////////////////////////////
  // Declaration of Constraints
  //////////////////////////////////////////////////////////////////////////////
  constraint AD_c { Add_Delay  dist { 0:/30, [1 : 5]:/70 }; }
  constraint DD_c { Data_Delay dist { 0:/30, [1 : 5]:/70 }; }
  constraint DATA     { Data dist    {[32'h00000000 : 32'h00000080]:/400, 
                                     [32'h70000000 : 32'h7FFFFFFF]:/200, 
                                     [32'h80000000 : 32'h8FFFFFFF]:/400,
                                     [32'hFFFFFF80 : 32'hFFFFFFFF]:/200 }; }
  constraint ADDRESSR { Address dist {[`C_S00_BASEADDR : `C_S00_BASEADDR + 13]:/100, 
                                      [`C_S00_BASEADDR + 14 : 32'h7FFFFFFF]:/1,
                                      [32'h80000000 : 32'hFFFFFFFF]:/1 }; }  
  //////////////////////////////////////////////////////////////////////////////
  // Method name : post_randomize();
  // Description : To display transaction info after randomization
  //////////////////////////////////////////////////////////////////////////////
  //function void post_randomize();
  //endfunction  
   
endclass


`endif



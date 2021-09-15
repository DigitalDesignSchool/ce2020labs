`ifndef AXI_COVERAGE
`define AXI_COVERAGE

class axi_coverage#(type T=axi_transaction) extends uvm_subscriber#(T);
axi_transaction cov_trans;
`uvm_component_utils(axi_coverage)
///////////////////////////////////////////////////////////////////////////////
covergroup axi_cg_address;
   option.per_instance=1;
   option.goal=100;
 coverpoint cov_trans.Address
{
  bins A0  = {`C_S00_BASEADDR};
  bins A4  = {`C_S00_BASEADDR + 4};
  bins A8  = {`C_S00_BASEADDR + 8};
  bins AC  = {`C_S00_BASEADDR + 12};
  bins Pos = {[`C_S00_BASEADDR + 13 : 32'h7FFFFFFF]};
  bins Neg = {[32'h80000000 : 32'hFFFFFFFF]};
  bins others = default;
}
endgroup

covergroup axi_cg_data;
   option.per_instance=1;
   option.goal=100;
coverpoint cov_trans.Data  {
 bins Low_positive = {[32'h00000000 : 32'h00000080]};
 bins Low_negative = {[32'hFFFFFF80 : 32'hFFFFFFFF]};
 bins High_positive = {[32'h70000000 : 32'h7FFFFFFF]};
 bins High_negative = {[32'h80000000 : 32'h8FFFFFFF]};
 bins others = default;
}
endgroup

covergroup axi_cg_delay;
   option.per_instance=1;
   option.goal=100; 
coverpoint cov_trans.Add_Delay {
 bins B0 = {0};
 bins B1 = {1};
 bins B2 = {2};
 bins B3 = {3};
 bins B4 = {4};
 bins B5 = {5};
 bins others = default;
}
coverpoint cov_trans.Data_Delay {
 bins B0 = {0};
 bins B1 = {1};
 bins B2 = {2};
 bins B3 = {3};
 bins B4 = {4};
 bins B5 = {5};
 bins others = default;
}
endgroup
//////////////////////////////////////////////////////////////////////////////
//constructor
//////////////////////////////////////////////////////////////////////////////
function new(string name="axi_coverage", uvm_component parent);
 super.new(name,parent);
 axi_cg_address = new();
 axi_cg_data = new();
 axi_cg_delay = new();
 cov_trans = new();
endfunction
///////////////////////////////////////////////////////////////////////////////
// Method name : sample
// Description : sampling axi coverage
///////////////////////////////////////////////////////////////////////////////
function void write(T t);
  this.cov_trans = t;
  if(cov_trans.Check == 1)
    begin
    if(cov_trans.Immediate_Read==0)  axi_cg_address.sample();
    else axi_cg_data.sample();
    end
  else
      begin
      axi_cg_data.sample();
      axi_cg_delay.sample();                  
      end
  if(cov_trans.Last_Transaction==(`NO_OF_TRANSACTIONS-1)) print_coverage();
endfunction

function void report_phase(uvm_phase phase);
endfunction : report_phase

function void print_coverage();
if(cov_trans.Check == 1)
    begin
    if(cov_trans.Immediate_Read==0)  `uvm_info(get_full_name(), $sformatf("Address coverage score = %3.1f%%", axi_cg_address.get_inst_coverage()), UVM_LOW)
    else `uvm_info(get_full_name(), $sformatf("Data coverage score = %3.1f%%", axi_cg_data.get_inst_coverage()), UVM_LOW)
    end
  else
      begin
      `uvm_info(get_full_name(), $sformatf("Data coverage score = %3.1f%%", axi_cg_data.get_inst_coverage()), UVM_LOW)
      `uvm_info(get_full_name(), $sformatf("Delay coverage score = %3.1f%%", axi_cg_delay.get_inst_coverage()), UVM_LOW)                  
      end
endfunction

endclass

`endif




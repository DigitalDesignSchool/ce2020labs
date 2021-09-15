covergroup Data_Coverage;
coverpoint Current.Data  {
 bins Low_positive = {[32'h00000000 : 32'h00000080]};
 bins Low_negative = {[32'hFFFFFF80 : 32'hFFFFFFFF]};
 bins High_positive = {[32'h70000000 : 32'h7FFFFFFF]};
 bins High_negative = {[32'h80000000 : 32'h8FFFFFFF]};
 bins others = default;
}
endgroup
Data_Coverage DCov;

covergroup Result_Coverage;
  SB: coverpoint Sum { option.auto_bin_max = 4; }
EB: coverpoint Extension {
 bins No = {32'h00000000};
 bins Yes = {32'hFFFFFFFF};
 illegal_bins bad = { [32'h00000001 : 32'hFFFFFFFE] };
}
cross SB,EB;    
endgroup
Result_Coverage RCov;

covergroup Delay_Coverage;
coverpoint Current.Add_Delay {
 bins B0 = {0};
 bins B1 = {1};
 bins B2 = {2};
 bins B3 = {3};
 bins B4 = {4};
 bins B5 = {5};
 bins others = default;
}
coverpoint Current.Data_Delay {
 bins B0 = {0};
 bins B1 = {1};
 bins B2 = {2};
 bins B3 = {3};
 bins B4 = {4};
 bins B5 = {5};
 bins others = default;
}
endgroup
Delay_Coverage DLCov;

covergroup Register_Coverage;
coverpoint Current.Address
{
  bins R0  = {C_S00_BASEADDR};
  bins R4  = {C_S00_BASEADDR + 4};
  bins R8  = {C_S00_BASEADDR + 8};
  bins RC  = {C_S00_BASEADDR + 12};
  bins others = default;
}
endgroup  
Register_Coverage RGCov;
  
covergroup Address_Coverage;
coverpoint Current.Address
{
  bins A0  = {C_S00_BASEADDR};
  bins A4  = {C_S00_BASEADDR + 4};
  bins A8  = {C_S00_BASEADDR + 8};
  bins AC  = {C_S00_BASEADDR + 12};
  bins Pos = {[C_S00_BASEADDR + 13 : 32'h7FFFFFFF]};
  bins Neg = {[32'h80000000 : 32'hFFFFFFFF]};
  bins others = default;
} 
coverpoint BRESP {
bins OKAY = {2'b00};
bins SLAVERR = {2'b10};
illegal_bins Bad = { 2'b01, 2'b11 };
}
coverpoint RRESP {
bins OKAY = {2'b00};
bins SLAVERR = {2'b10};
illegal_bins Bad = { 2'b01, 2'b11 };
} 
endgroup
Address_Coverage ACov;


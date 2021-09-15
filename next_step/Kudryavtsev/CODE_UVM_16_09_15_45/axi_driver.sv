`ifndef AXI_DRIVER
`define AXI_DRIVER

class axi_driver extends uvm_driver #(axi_transaction);
  axi_transaction CurrentR,CurrentW;
  virtual AXI vif;
  `uvm_component_utils(axi_driver)
  uvm_analysis_port#(axi_transaction) drv2sb_port;
  //////////////////////////////////////////////////////////////////////////////
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //////////////////////////////////////////////////////////////////////////////
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual AXI)::get(this, "", "intf", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    drv2sb_port = new("drv2sb_port", this); // to send transactions to the scoreboard
  endfunction: build_phase
  //////////////////////////////////////////////////////////////////////////////
  // Method name : run_phase 
  // Description : Drive the transaction info to DUT
  //////////////////////////////////////////////////////////////////////////////
  virtual task run_phase(uvm_phase phase);
    reset();
    forever begin
    seq_item_port.get_next_item(req);
    drive();
    //req.print();
    end
  endtask : run_phase
  //////////////////////////////////////////////////////////////////////////////
  // Method name : drive 
  // Description : Driving the dut inputs
  //////////////////////////////////////////////////////////////////////////////
  task automatic drive();
  bit [1:0] Operation;
begin    
  wait(vif.s00_axi_aresetn);
  Operation = 2'b00;
  if (req.Op == WRITE) begin
                             $cast (CurrentW, req.clone());
                             Operation[1]=1'b1;
                             if(CurrentW.Immediate_Read == 1) begin
                                                              seq_item_port.item_done();
                                                              seq_item_port.get_next_item(req);
                                                              $cast(CurrentR,req.clone());
                                                              Operation[0]=1'b1;
                                                              end 
                       end
  else begin
          $cast(CurrentR,req.clone());
          Operation[0]=1'b1;
       end    
fork
    if (Operation[1]==1'b1) begin                     //write operation
    fork 
        begin
        vif.cb.s00_axi_awaddr <= CurrentW.Address; vif.cb.s00_axi_awvalid <= 1'b1; 
        $root.axi_tb_top.Write_address_ready = 1'b0;
		wait(vif.cb.s00_axi_awready & vif.s00_axi_awvalid);
        @vif.cb;
        if(~CurrentW.Immediate_Read) vif.cb.s00_axi_awvalid <= 1'b0;   
        $root.axi_tb_top.Write_address_ready = 1'b1;
        end
        
        begin
        repeat(CurrentW.Add_Delay) @vif.cb;
        while(($root.axi_tb_top.Write_address_ready==0) && (vif.s00_axi_awvalid == 0))  @vif.cb; 
        vif.cb.s00_axi_wdata <= CurrentW.Data; vif.cb.s00_axi_wvalid <= 1'b1; //end
        @vif.cb;
        wait(vif.cb.s00_axi_wready & vif.s00_axi_wvalid);
        drv2sb_port.write(CurrentW); 
        if(~CurrentW.Immediate_Read) vif.cb.s00_axi_wvalid <= 1'b0;
        $root.axi_tb_top.Write_address_ready = 1'b0;
        repeat(CurrentW.Data_Delay) @vif.cb;
        if(~CurrentW.Immediate_Read) seq_item_port.item_done();
        end 
    join
    end 

    if (Operation[0]==1'b1) begin                 // read operation
    fork 
        begin
        $root.axi_tb_top.Read_address_ready = 1'b0;
        vif.cb.s00_axi_araddr <= CurrentR.Address; vif.cb.s00_axi_arvalid <= 1'b1;
        @vif.cb;
        wait(vif.cb.s00_axi_arready & vif.s00_axi_arvalid );
        if(~CurrentR.Immediate_Read) vif.cb.s00_axi_arvalid <= 1'b0;
        $root.axi_tb_top.Read_address_ready = 1'b1;
        end
        
        begin
        repeat(CurrentR.Add_Delay) @vif.cb;
        wait($root.axi_tb_top.Read_address_ready | vif.s00_axi_arvalid);
        vif.cb.s00_axi_rready <= 1'b1;
        wait(vif.cb.s00_axi_rvalid & vif.s00_axi_rready); 
        @vif.cb;
        CurrentR.Data = vif.cb.s00_axi_rdata;
        if(~CurrentR.Immediate_Read & ~vif.s00_axi_arvalid) vif.cb.s00_axi_rready <= 1'b0;
        drv2sb_port.write(CurrentR); 
        repeat(CurrentR.Data_Delay) @vif.cb;
        seq_item_port.item_done();
        end
    join
    end  
join 
end  
  endtask
  //////////////////////////////////////////////////////////////////////////////
  // Method name : reset 
  // Description : Driving the dut inputs
  //////////////////////////////////////////////////////////////////////////////
  task reset();
  vif.s00_axi_awaddr <= 'X;
  vif.s00_axi_aresetn <= 1'b0;
  vif.s00_axi_awvalid <= 1'b0;
  vif.s00_axi_arvalid <= 1'b0;
  vif.s00_axi_wvalid <= 1'b0;
  vif.s00_axi_rready <= 1'b0;
  vif.s00_axi_bready <= 1'b1;
  #23 vif.s00_axi_aresetn <= 1'b1;
  endtask

endclass : axi_driver

`endif






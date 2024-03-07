//VE-UVM

//Including UVM files
import uvm_pkg::*;
`include "uvm_macros.svh"

//Day 1: Design RTL, interface, sequence_item, sequencer, driver
`include "apb_interface.sv"
`include "apb_seq_item.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"

//Day 2: Design Agent, Scoreboard, Envt, test
`include "apb_agent.sv"
`include "apb_scoreboard.sv"
`include "apb_environment.sv"
`include "apb_sequence.sv"
`include "apb_base_test.sv"

module top;
  
  bit pclk;
  bit prst;
  
  //taking instance of interface
  apb_intf vif(pclk,prst);
  
  //dut interface
  APB_m DUT(.pclk(pclk),.prst(prst),.psel(vif.psel),.penable(vif.penable),.paddr(vif.paddr),.pwdata(vif.pwdata),.pwrite(vif.pwrite),.prdata(vif.prdata),.pready(vif.pready),.pslverr(vif.pslverr));
  
  //clk generator
  initial begin
    forever begin
      #5 pclk = ~pclk;
    end
  end
  
  initial begin
    prst = 1;
    @(posedge vif.pclk);
    prst = 0;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
    #200 $finish;
  end
  
  initial begin
    run_test("apb_base_test");
  end
  
  
  initial begin
    //setting intf into config db
    uvm_config_db#(virtual apb_intf)::set(null,"*","vif",vif);
  end
  
endmodule

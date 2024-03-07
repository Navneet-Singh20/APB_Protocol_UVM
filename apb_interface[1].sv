interface apb_intf(input logic pclk,prst);
  
  //signals
  logic psel;
  logic penable;
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic pwrite;
  logic pready;
  logic pslverr;
  
  //you can also declaring clocking block and modport also
  
endinterface
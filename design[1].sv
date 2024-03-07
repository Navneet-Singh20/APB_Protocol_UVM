// RTL are here

module APB_m(input pclk,
             input prst,
             input psel,
             input penable,
             input [31:0] paddr,
             input [31:0] pwdata,
             input pwrite,
             output reg [31:0] prdata,
             output reg pready,
             output reg pslverr);
  
  //State 1: Idle 
  //State 2: Setup
  //State 3: Access
  
  //memory creating
  reg [31:0] mem[10];
  
  always @(posedge pclk, posedge prst) begin
    if(prst) begin
      pready  <= 0;
      pslverr <= 0;
      prdata  <= 32'h0000_0000;
    end else begin
      if(psel && penable) begin
        if(pwrite) begin
          mem[paddr] <= pwdata;
        end else begin
          prdata     <= mem[paddr];
        end
        pready <= 1;
      end else begin
        pready  <= 0;
        pslverr <= 0;
      end
    end
  end
  
endmodule

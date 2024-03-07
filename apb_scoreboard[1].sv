class apb_scoreboard extends uvm_scoreboard;
  
  //Factory registration
  `uvm_component_utils(apb_scoreboard)
  
  //analysis import
  uvm_analysis_imp #(apb_seq_item,apb_scoreboard) sb_analysis_imp;
  
  //taking a queue to store pkt
  apb_seq_item queue[$];
  
  //taking instance of seq pkt
  apb_seq_item req;
  
  //local memory
  bit [31:0] mem[10];
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_analysis_imp = new("sb_analysis_imp",this);
  endfunction
  
  //write task
  virtual function void write(apb_seq_item pkt);
    queue.push_back(pkt);
  endfunction
  
  //run task
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      wait(queue.size > 0); 
      req = queue.pop_front();
        if(req.pwrite == 1) begin
          mem[req.paddr] = req.pdata;
          `uvm_info("SB","Write done in Scoreboard memory",UVM_LOW);
        end else begin
          if(mem[req.paddr] == req.pdata) begin
            `uvm_info("SB","Data is Matched",UVM_LOW)
          end else begin
            `uvm_error("SB","Data is Not-Matched")
          end
        end
    end
  endtask
  
endclass
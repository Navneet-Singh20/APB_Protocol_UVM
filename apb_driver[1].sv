class apb_driver extends uvm_driver#(apb_seq_item);
  
  //Factory registration
  `uvm_component_utils(apb_driver)
  
  //interface handle
  virtual apb_intf vif;
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif)) begin
      `uvm_fatal(get_full_name(),"INTERFACE Didn't connected on DRIVER")
    end
  endfunction
  
  //run task phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);  
    reset_t();
    forever begin
      apb_seq_item req;
      `uvm_info(get_type_name(),"DRIVER : Waiting for seq pkt from SQR",UVM_LOW)      
      seq_item_port.get_next_item(req);
      //req.print();
      `uvm_info({get_type_name," : ID"},$psprintf("Printing Object \n %s",req.sprint()),UVM_LOW)
      drive_t(req);
      seq_item_port.item_done();
    end
  endtask
  
  //reset task
  task reset_t();
    `uvm_info("RESET ST","WAITING for reset signal",UVM_LOW)
    wait(vif.prst);
    vif.psel <= 0;
    vif.penable <= 0;
    vif.paddr   <= 32'h0000_0000;
    vif.pwdata  <= 32'h0000_0000;
    vif.pwrite  <= 1'b0;
    wait(!vif.prst);
    `uvm_info("RESET END","------RESET ENDED-----",UVM_LOW)
  endtask
  
  //drive task
  task drive_t(apb_seq_item req);
    vif.psel     <= 1;
    vif.paddr    <= req.paddr;
    vif.pwrite   <= req.pwrite;
    if(req.pwrite) begin
      vif.pwdata <= req.pdata;
    end
    @(posedge vif.pclk);
    vif.penable  <= 1;
    wait(vif.pready);
    //@(posedge vif.pclk);
    vif.penable  <= 0;
    @(posedge vif.pclk);
  endtask
  
  
endclass
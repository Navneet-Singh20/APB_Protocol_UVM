class apb_monitor extends uvm_monitor;
  
  //Factory reg
  `uvm_component_utils(apb_monitor)
  
  //interface
  virtual apb_intf vif;
  
  //instance of seq item
  apb_seq_item req;
  
  //analysis port
  uvm_analysis_port#(apb_seq_item) mon_analysis_port;
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","vif",vif)) 		begin
      `uvm_fatal(get_type_name(),"INTERFACE didn't got at Monitor")
    end
    mon_analysis_port = new("mon_analysis_port",this);
    req = apb_seq_item::type_id::create("req");
  endfunction
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    wait(!vif.prst);
    forever begin
      wait(vif.pready);
      req.paddr  = vif.paddr;
      req.pwrite = vif.pwrite;
      if(vif.pwrite) begin
      	req.pdata  = vif.pwdata;
      end else begin
      	req.pdata  = vif.prdata;
      end
      mon_analysis_port.write(req);
      `uvm_info({get_type_name," : ID"},$psprintf("Printing Object \n %s",req.sprint()),UVM_LOW)
      @(posedge vif.pclk);
      //@(posedge vif.pclk);
    end
  endtask
  
endclass
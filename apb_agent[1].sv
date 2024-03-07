class apb_agent extends uvm_agent;
  
  //Factory registration
  `uvm_component_utils(apb_agent)
  
  //Taking instance of sqr, drv, mon
  apb_sequencer sqr;
  apb_driver    drv;
  apb_monitor   mon;
  
  //new constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //if agent is Active
    sqr = apb_sequencer::type_id::create("sqr",this);
    drv = apb_driver::type_id::create("drv",this);
    mon = apb_monitor::type_id::create("mon",this);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //if agent is active
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass
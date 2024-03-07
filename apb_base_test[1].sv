class apb_base_test extends uvm_test;
  
  //factory registration
  `uvm_component_utils(apb_base_test)
  
  //instance of env and seq
  apb_sequence seq;
  apb_environment env;
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = apb_environment::type_id::create("env",this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  //run task
  virtual task run_phase(uvm_phase phase);
    seq = apb_sequence::type_id::create("seq");
    //raise objection
    phase.raise_objection(this);
    $display($time,"start method started");
    //start seq on sqr
    seq.start(env.agt.sqr);
    //set drain time
    phase.phase_done.set_drain_time(this,50);
    $display($time,"start method ended");
    //drop objection
    phase.drop_objection(this);
  endtask
  
endclass
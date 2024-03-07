class apb_environment extends uvm_env;
  
  //Factory registration
  `uvm_component_utils(apb_environment)
  
  //instance of agent and sb
  apb_agent agt;
  apb_scoreboard sb;
  
  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = apb_agent::type_id::create("agt",this);
    sb  = apb_scoreboard::type_id::create("sb",this);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.mon_analysis_port.connect(sb.sb_analysis_imp);
  endfunction
  
endclass
class apb_sequence extends uvm_sequence;
  
  //Factory registration
  `uvm_object_utils(apb_sequence)
  
  //constructor
  function new(string name="apb_seq");
    super.new(name);
  endfunction
  
  //body seq
  virtual task body();
    //`uvm_do(req) Alter
    //Write 1
    apb_seq_item req;
    req = apb_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {req.pwrite==1; req.paddr==5;});
    //req.print();			//In-built method we get from factory registration
    `uvm_info({get_type_name," : ID"},$psprintf("Printing Object \n %s",req.sprint()),UVM_LOW)
    finish_item(req);
    
    //read 
    `uvm_do_with(req,{req.pwrite==0;req.paddr==5;});
  endtask
  
endclass
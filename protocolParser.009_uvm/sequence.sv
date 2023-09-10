//OBJECT CLASS
class tb_sequence item extends uvm_sequence;
`uvm_object_utils(tb_sequence)

//--------------------------------------------------------
//Constructor
//--------------------------------------------------------
function new(string name= "alu_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
endfunction

//--------------------------------------------------------
//Body Task
//--------------------------------------------------------
task body();
    `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
endtask: body

endclass: tb_sequence
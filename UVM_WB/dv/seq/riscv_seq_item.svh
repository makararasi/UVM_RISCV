//typedef enum int {li_x1_1020, sw_x0_0x1, loop_lw_x2_x1, addi_x2_x2_1, sw_x2_0x1, j_loop} num;

class riscv_seq_item extends uvm_sequence_item;
  //data and control fields
  rand bit [31:0] data; 
  rand int kind;
  rand bit valid;

constraint content {(kind == 0)         -> data == 32'h3fc00193;
		            (kind == 1)        -> data == 32'h0001a023;
		            (kind == 2)     -> data == 32'h0001a103;
		            (kind == 3)       -> data == 32'h00110113;
                    (kind == 4)        -> data == 32'h0021a023;
                    (kind == 5)             -> data == 32'hff5ff06f;
		}

constraint order {solve kind  before data;}
 
  
  //Utility and Field macros,
  `uvm_object_utils_begin(riscv_seq_item)
    `uvm_field_int(data,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //Constructor
  function new(string name = "mem_seq_item");
    super.new(name);
  endfunction
  
  
endclass

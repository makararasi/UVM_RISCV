class sequence_base extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_base)
  riscv_seq_item req;
  int count = 0,jal = 6;
 // enum int {li_x1_1020, sw_x0_0x1, loop_lw_x2_x1, addi_x2_x2_1, sw_x2_0x1, j_loop} num;
  //Constructor
  function new(string name = "sequence_base");
    super.new(name);
  endfunction
   
  virtual task body();
  while(jal >= 0)
  begin
   // num = num.first;
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    if(count  <= 5)
    begin
        assert(req.randomize with{req.kind == count;});
        if(req.data[6:0] == 7'b1101111)
            begin
            jal = 150; //unconditional jump
            end
    end
    finish_item(req);
    jal = jal - 1;
    count = count + 1;
  //  num = num.next;
    end
 
  endtask
   
endclass

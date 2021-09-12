class sequence_base extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_base)
  riscv_seq_item req;
  int count = 0,jal;
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
        assert(req.randomize with{req.kind == count;
                                  req.valid == 1;});
        jal = jal + 1;
        if(req.data[6:0] == 7'b1101111)
            begin
            jal = 150;
            end
    end
    else
    assert(req.randomize with{req.data == 0;
                              req.valid == 0;});
    finish_item(req);
    jal = jal - 1;
    count = count + 1;
  //  num = num.next;
    end
 
  endtask
   
endclass



class sequence_li extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_li)
  riscv_seq_item req;
  int count = 0;
   //Constructor
  function new(string name = "sequence_li");
    super.new(name);
  endfunction
   
  virtual task body();
  while(count >= 0)
  begin
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize with{req.data == 32'h 3fc00093; req.valid == 1;});  //       li      x1,1020
    finish_item(req);
    count = count - 1;
  end
 
  endtask
   
endclass


class sequence_sw extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_sw)
  riscv_seq_item req;
  int count = 0,rdata;
   //Constructor
  function new(string name = "sequence_sw");
    super.new(name);
  endfunction

  function get_rdata(int data);
  this.rdata = data;
  endfunction   

  virtual task body();
  while(count >= 0)
  begin
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize with{req.data == rdata; req.valid == 1;});  //       sw      x0,0(x1)   32'h 0020a023; //       sw      x2,0(x1) 
    finish_item(req);
    count = count - 1;
  end
 
  endtask
   
endclass

class sequence_lw extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_lw)
  riscv_seq_item req;
  int count = 0;
   //Constructor
  function new(string name = "sequence_lw");
    super.new(name);
  endfunction
   
  virtual task body();
  while(count >= 0)
  begin
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize with{req.data == 32'h 0000a103; req.valid == 1;});  //       lw      x2,0(x1)    
    finish_item(req);
    count = count - 1;
  end
 
  endtask
   
endclass


class sequence_addi extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_addi)
  riscv_seq_item req;
  int count = 0;
   //Constructor
  function new(string name = "sequence_addi");
    super.new(name);
  endfunction
   
  virtual task body();
  while(count >= 0)
  begin
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    assert(req.randomize with{req.data == 32'h 00110113; req.valid == 1;});  //       addi    x2,x2,1    
    finish_item(req);
    count = count - 1;
  end
 
  endtask
   
endclass


class sequence_j extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_j)
  riscv_seq_item req;
  int count = 0,jal;
   //Constructor
  function new(string name = "sequence_j");
    super.new(name);
  endfunction
   
  virtual task body();
  while(count >= 0)
  begin
    req = riscv_seq_item::type_id::create("req");
    start_item(req);
    if(jal >= 1)
	begin
	assert(req.randomize with{req.data == 0; req.valid == 0;});
	end
    else
	begin
    	assert(req.randomize with{req.data == 32'h ff5ff06f; req.valid == 1;});
	jal = jal + 1;
	count = 15000;
	end									  //       j       <loop> 
    finish_item(req);
    count = count - 1;
  end
 
  endtask
   
endclass



class sequence_test extends uvm_sequence#(riscv_seq_item);
   
  `uvm_object_utils(sequence_test)
  riscv_seq_item req;
  riscv_seqr     seqr;
  sequence_li    li;
  sequence_j     j;
  sequence_addi  addi;
  sequence_lw    lw;
  sequence_sw    sw;

   //Constructor
  function new(string name = "sequence_test");
    super.new(name);
  endfunction
   
  function void get_sequencer(riscv_seqr main_seqr);
  this.seqr = main_seqr;
  endfunction

  virtual task body();
    begin
	begin
	li = sequence_li::type_id::create("li");
	li.start(seqr);
	$display("---------------li---------------");
	end
	begin
	sw = sequence_sw::type_id::create("sw");
	sw.get_rdata(32'h 0000a023);
	sw.start(seqr);
	$display("---------------sw---------------");
	end
	begin
	lw = sequence_lw::type_id::create("lw");
	lw.start(seqr);
	$display("---------------lw---------------");
	end
	begin
	addi = sequence_addi::type_id::create("addi");
	addi.start(seqr);
	$display("---------------addi---------------");
	end
	begin
	sw = sequence_sw::type_id::create("sw");
	sw.get_rdata(32'h 0020a023);
	sw.start(seqr);
	$display("---------------sw---------------");
	end
	begin
	j = sequence_j::type_id::create("j");
	j.start(seqr);
	$display("---------------j---------------");
	end	
    end
 
  endtask
   
endclass









	/*	memory[0] = 32'h 3fc00093; //       li      x1,1020
		memory[1] = 32'h 0000a023; //       sw      x0,0(x1)
		memory[2] = 32'h 0000a103; // loop: lw      x2,0(x1)
		memory[3] = 32'h 00110113; //       addi    x2,x2,1
		memory[4] = 32'h 0020a023; //       sw      x2,0(x1)
		memory[5] = 32'h ff5ff06f; //       j       <loop> */





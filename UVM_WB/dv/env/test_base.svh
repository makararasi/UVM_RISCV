
class test_base extends uvm_test;

    `uvm_component_utils(test_base)

    env e;
    sequence_base seq;

    function new(string name="test_base", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
	seq = sequence_base::type_id::create("seq");
    endfunction

    task run_phase(uvm_phase phase);
      // We raise objection to keep the test from completing
      phase.raise_objection(this);
      begin
        seq.start(e.riscv_agent.seqr);
      end
      // We drop objection to allow the test to complete
        //#100000;
      phase.drop_objection(this);
    endtask
  
endclass



class test_1 extends uvm_test;

    `uvm_component_utils(test_1)

    env e;
    sequence_test seq;

    function new(string name="test_1", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    seq = sequence_test::type_id::create("seq");
    //e.riscv_agent.driver.count = 0 ;//setting start address
    endfunction

    task run_phase(uvm_phase phase);
      // We raise objection to keep the test from completing
      phase.raise_objection(this);
      begin
	e.riscv_agent.driver.count = 0 ;
	seq.get_sequencer(e.riscv_agent.seqr);
        seq.start(e.riscv_agent.seqr);
      end
      // We drop objection to allow the test to complete
        //#100000;
      phase.drop_objection(this);
    endtask
  
endclass



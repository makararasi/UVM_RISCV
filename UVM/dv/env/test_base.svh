
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

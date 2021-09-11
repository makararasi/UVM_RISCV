
class env extends uvm_env;

    `uvm_component_utils(env)

    riscv_mem_agent riscv_agent;

    function new(string name="env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        riscv_agent  = riscv_mem_agent::type_id::create("riscv_agent", this);
    endfunction

endclass

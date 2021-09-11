
class riscv_mem_monitor extends uvm_monitor;

    `uvm_component_utils(riscv_mem_monitor)

    function new(string name="riscv_mem_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        // TODO : monitor code
        `uvm_info("MONITOR", "Monitor in place", UVM_MEDIUM)
    endtask

endclass

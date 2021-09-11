

class riscv_mem_agent extends uvm_agent;

    `uvm_component_utils(riscv_mem_agent)

    riscv_mem_driver  driver;
    riscv_mem_monitor monitor;
    riscv_seqr seqr;

    function new(string name="riscv_mem_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver  = riscv_mem_driver::type_id::create("driver", this);
        monitor = riscv_mem_monitor::type_id::create("monitor", this);
	seqr    = uvm_sequencer#(riscv_seq_item)::type_id::create("seqr", this);
    endfunction

     function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        // TODO : add agent code if required
        `uvm_info("AGENT", "Agent in place", UVM_MEDIUM)
    endtask

endclass

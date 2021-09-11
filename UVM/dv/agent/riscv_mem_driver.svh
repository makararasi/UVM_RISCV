class riscv_mem_driver extends uvm_driver#(riscv_seq_item);

    `uvm_component_utils(riscv_mem_driver)

    virtual riscv_mem_if vif;
   // riscv_seq_item req;
    bit [31:0] memory[int];
    int count=0,ev;

    function new(string name="riscv_mem_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	if( !uvm_config_db#(virtual riscv_mem_if)::get(this,"*", "vif", vif))
		`uvm_fatal(get_full_name(),{"virtual interface must be set for:",".mem_vif"} )
    endfunction

    task run_phase(uvm_phase phase);
        // TODO : driver code
	forever
	    begin

       // `uvm_info(get_type_name(), "Driver in place-Start", UVM_MEDIUM)
        
	        seq_item_port.get_next_item(req);
            memory[count] = req.data;
           // $display(req.data);
            count = count + 1;
	        do begin
            run_wb();
            end while(!ev) ;
            ev = 0;
	        seq_item_port.item_done();
	  //  `uvm_info(get_type_name(), "Driver in place-End"  , UVM_MEDIUM) 

	end

    endtask

    

task run_wb();
	begin
		fork
			begin
			@(negedge vif.wb_clk_i);
			if((vif.wbm_cyc_o && vif.wbm_stb_o))
			begin
			vif.wbm_ack_i <= 1'b1;	
//$display("fff");	
ev = 1;
			end
			else                            		 //WB-handshake
			begin
			vif.wbm_ack_i <= 1'b0;
//$display("else");
			end
			end

			begin
			@(negedge vif.wb_clk_i);
			if((vif.wbm_cyc_o && vif.wbm_stb_o && !vif.wbm_we_o))
			begin
			vif.wbm_dat_i <= memory[vif.wbm_adr_o >> 2]; 
             //transaction_q[addr >> 2] and while ending test keep delay of 1000000
			//$display((vif.wbm_adr_o >> 2) , "addr" , $time);
			end
			end

			begin
			@(negedge vif.wb_clk_i);
			if((vif.wbm_cyc_o && vif.wbm_stb_o && vif.wbm_we_o))
			begin
            if(!memory.exists(vif.wbm_adr_o >> 2))
            begin
            memory[vif.wbm_adr_o >> 2] = 0;
            end
			memory[vif.wbm_adr_o >> 2] = vif.wbm_dat_o;	                          //WB-write transaction
			//$display(vif.wbm_dat_o, "^^^^^^^",$time, "addr", (vif.wbm_adr_o >> 2) );
			end
			end			
						
		join_any
	end
     endtask

endclass

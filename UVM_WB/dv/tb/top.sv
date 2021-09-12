
/*--------------UVM_code_example-----------------------

  class transaction;

  randc int data[];
  rand int sizenum;

  constraint size { data.size == 1;
  foreach(data[i]) {
  data[i] inside {[0:50]};
  }
  }

  endclass

  int data[];
  transaction t;
  repeat(50)
  begin
  t = new;
  t.randomize; 
  data = new[$size(data) + 1]({data,t.data});        //here we have to write 50 constraints each for each type of instruction and randomize tha data for that 	  $display("%p", data); 		 	       instruction and we can also use inline for customized immediate transaction or instruction and in the 
  test class we can use #100000 delay to wait for transaction to be completed i.e if we generate all the 
  transactions in 100ns also we delay and processor waits till the delay to complete all transactions 
  present in array.

  writing to memory data = new[(wbm_adr_o >> 2) - $size(data) + 1](data) to create that memory location and then data[(wbm_adr_o >> 2)]
  end
  ----------------------------------------------------------*/



module top;

import uvm_pkg::*;
import test_pkg::*;
`include "uvm_macros.svh"
`include "picorv32.v" 

riscv_mem_if inf();


bit[31:0] memory[0:1021];	


initial
begin
inf.wb_clk_i = 0;
forever
#5 inf.wb_clk_i = ~inf.wb_clk_i;	  
end


initial
begin
inf.wb_rst_i     = 1;
#20 inf.wb_rst_i = 0; 
end


/*-----------------------------DUT-INSTANCE-START-----------------------------------*/

	picorv32_wb pico_dut (
			.wb_rst_i	(inf.wb_rst_i)	,
			.wb_clk_i	(inf.wb_clk_i)	,
			.wbm_adr_o	(inf.wbm_adr_o)	,
			.wbm_dat_o	(inf.wbm_dat_o)	,
			.wbm_dat_i	(inf.wbm_dat_i)	,
			.wbm_we_o	(inf.wbm_we_o)	,
			.wbm_sel_o	(inf.wbm_sel_o)	,
			.wbm_stb_o	(inf.wbm_stb_o)	,
			.wbm_ack_i	(inf.wbm_ack_i)	,
			.wbm_cyc_o	(inf.wbm_cyc_o)

			);
/*-----------------------------DUT-INSTANCE-END-----------------------------------*/



	initial
	begin
	// uvm_config_db#(virtual riscv_mem_if)::set(null,"*","vif",inf)
	uvm_config_db#(virtual riscv_mem_if)::set(null, "*", "vif", inf);

	//`uvm_fatal(get_full_name(),{"virtual interface must be set for:","vif"} )
	end

	initial
	run_test();

	initial
	begin
	$dumpfile("riscv_wb.vcd");
	$dumpvars(0,top);
	// $log(display_wb.txt);
	end

	endmodule

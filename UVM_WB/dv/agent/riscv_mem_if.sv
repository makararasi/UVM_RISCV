interface riscv_mem_if;
   
    // TODO : Update signals names & width based on DUT requirements
    // TODO : Add any more signals that might be needed
    

    
	// WB master memory interface

	logic 		wb_rst_i;
	logic 		wb_clk_i;
	logic [31:0] 	wbm_adr_o;
	logic [31:0] 	wbm_dat_o;
	logic [31:0] 	wbm_dat_i;
	logic		wbm_we_o;
	logic [3:0] 	wbm_sel_o;
	logic 		wbm_stb_o;
	logic 		wbm_ack_i;
	logic 		wbm_cyc_o;

/*	input 			wb_rst_i,
	input			wb_clk_i,

	output reg 	[31:0] 	wbm_adr_o,
	output reg 	[31:0] 	wbm_dat_o,
	input 		[31:0] 	wbm_dat_i,
	output reg 		wbm_we_o,                  //WB master Interface picorv32
	output reg 	[3:0]	wbm_sel_o,
	output reg 		wbm_stb_o,
	input 			wbm_ack_i,
	output reg		wbm_cyc_o, 

*/





endinterface

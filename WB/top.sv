
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
 
`include "riscv_mem_if.sv"
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
       	memory[0] = 32'h3fc00093; //       li      x1,1020
	memory[1] = 32'h0000a023; //       sw      x0,0(x1)
	memory[2] = 32'h0000a103; // loop: lw      x2,0(x1)
	memory[3] = 32'h00110113; //       addi    x2,x2,1
	memory[4] = 32'h0020a023; //       sw      x2,0(x1)
	memory[5] = 32'hff5ff06f; //       j       <loop>
	forever
		begin
			get_next();
			//transaction_q = new[$size(transaction_q) + 1](transaction_q);
			//transaction_q[transaction.count] = data;
			run_wb();
			item_done();
		end
     end



       
    initial
	#11000 $finish; 
        
    initial
     begin
		$dumpfile("riscv_wb.vcd");
		$dumpvars(0,top);
     end








task get_next();
endtask

task item_done();
endtask







task run_wb();
	begin
		fork
			begin
			@(negedge inf.wb_clk_i);
			if((inf.wbm_cyc_o && inf.wbm_stb_o))
			begin
			inf.wbm_ack_i <= 1'b1;		
			end
			else                            		 //WB-handshake
			begin
			inf.wbm_ack_i <= 1'b0;
			end
			end

			begin
			@(negedge inf.wb_clk_i);
			if((inf.wbm_cyc_o && inf.wbm_stb_o && !inf.wbm_we_o))
			begin
			inf.wbm_dat_i <= memory[inf.wbm_adr_o >> 2];  //transaction_q[addr >> 2] and while ending test keep delay of 1000000
			$display((inf.wbm_adr_o >> 2) , "addr" , $time);
			end
			end

			begin
			@(negedge inf.wb_clk_i);
			if((inf.wbm_cyc_o && inf.wbm_stb_o && inf.wbm_we_o))
			begin
			memory[inf.wbm_adr_o >> 2] = inf.wbm_dat_o;	                          //WB-write transaction
			$display(inf.wbm_dat_o, "^^^^^^^",$time, "addr", (inf.wbm_adr_o >> 2) );
			end
			end

			
						
		join_any
	end
     endtask



//https://github.com/google/riscv-dv

endmodule








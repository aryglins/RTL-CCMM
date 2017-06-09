/************************************
*
*/
//`include "cache_structs_def.sv"
//=================================================
// Import the Packages
//=================================================
module cache_tb;
timeunit 1ns;
timeprecision 100ps;
	
	logic clk;
	logic rst;
	logic fl_complete;
	realtime clk_period = 20ns;

	initial clk = 0;
	always begin 
		#(clk_period/2)  clk=~clk;
	end
		
	initial begin
		rst = 1;
		#clk_period;
		rst = 0;
		while(fl_complete == 'b0) begin
			#clk_period;
		end
		$stop;
	end
	
    rv_cache_sint_top riscv_cache (
		.rst(rst),
		.clk(clk),
		.fl_complete(fl_complete)
	);
	
endmodule // End of Module ram_sp_sr_sws


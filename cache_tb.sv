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
	realtime clk_period = 20ns;

	initial clk = 0;
	always begin 
		#(clk_period/2)  clk=~clk;
	end
		
	initial begin
		rst = 1;
		#clk_period;
		rst = 0;
	end
	
    rv_cache_sint_top riscv_cache (
		.rst(rst),
		.clk(clk)	
	);
	
endmodule // End of Module ram_sp_sr_sws


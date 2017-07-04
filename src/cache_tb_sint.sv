/************************************
*
*/
//`include "cache_structs_def.sv"
//=================================================
// Import the Packages
//=================================================
import cache_parameters::*;

module cache_tb_sint;
timeunit 1ns;
timeprecision 100ps;

	memory_request_t mrq;
	memory_response_t mrs;
	
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
	
    riscv_cache_top riscv_cache (
		.rst(rst),
		.clk(clk),
		.fl_complete(fl_complete),
		.mrq_addr(mrq.addr),
		.mrq_cs(mrq.cs),
		.mrq_rw(mrq.rw),
		.mrq_data_1_0(mrq.data[1][0]) ,
		.mrq_data_1_1(mrq.data[1][1]) ,
		.mrq_data_1_2(mrq.data[1][2]) ,
		.mrq_data_1_3(mrq.data[1][3]) ,
		.mrq_data_1_4(mrq.data[1][4]) ,
		.mrq_data_1_5(mrq.data[1][5]) ,
		.mrq_data_1_6(mrq.data[1][6]) ,
		.mrq_data_1_7(mrq.data[1][7]) ,
		.mrq_data_1_8(mrq.data[1][8]) ,
		.mrq_data_1_9(mrq.data[1][9]) ,
		.mrq_data_1_10(mrq.data[1][10]) ,
		.mrq_data_1_11(mrq.data[1][11]) ,
		.mrq_data_1_12(mrq.data[1][12]) ,
		.mrq_data_1_13(mrq.data[1][13]) ,
		.mrq_data_1_14(mrq.data[1][14]) ,
		.mrq_data_1_15(mrq.data[1][15]) ,
		.mrq_data_1_16(mrq.data[1][16]) ,
		.mrq_data_1_17(mrq.data[1][17]) ,
		.mrq_data_1_18(mrq.data[1][18]) ,
		.mrq_data_1_19(mrq.data[1][19]) ,
		.mrq_data_1_20(mrq.data[1][20]) ,
		.mrq_data_1_21(mrq.data[1][21]) ,
		.mrq_data_1_22(mrq.data[1][22]) ,
		.mrq_data_1_23(mrq.data[1][23]) ,
		.mrq_data_1_24(mrq.data[1][24]) ,
		.mrq_data_1_25(mrq.data[1][25]) ,
		.mrq_data_1_26(mrq.data[1][26]) ,
		.mrq_data_1_27(mrq.data[1][27]) ,
		.mrq_data_1_28(mrq.data[1][28]) ,
		.mrq_data_1_29(mrq.data[1][29]) ,
		.mrq_data_1_30(mrq.data[1][30]) ,
		.mrq_data_1_31(mrq.data[1][31]),
		
		.mrq_data_0_0(mrq.data[0][0]) ,
		.mrq_data_0_1(mrq.data[0][1]) ,
		.mrq_data_0_2(mrq.data[0][2]) ,
		.mrq_data_0_3(mrq.data[0][3]) ,
		.mrq_data_0_4(mrq.data[0][4]) ,
		.mrq_data_0_5(mrq.data[0][5]) ,
		.mrq_data_0_6(mrq.data[0][6]) ,
		.mrq_data_0_7(mrq.data[0][7]) ,
		.mrq_data_0_8(mrq.data[0][8]) ,
		.mrq_data_0_9(mrq.data[0][9]) ,
		.mrq_data_0_10(mrq.data[0][10]) ,
		.mrq_data_0_11(mrq.data[0][11]) ,
		.mrq_data_0_12(mrq.data[0][12]) ,
		.mrq_data_0_13(mrq.data[0][13]) ,
		.mrq_data_0_14(mrq.data[0][14]) ,
		.mrq_data_0_15(mrq.data[0][15]) ,
		.mrq_data_0_16(mrq.data[0][16]) ,
		.mrq_data_0_17(mrq.data[0][17]) ,
		.mrq_data_0_18(mrq.data[0][18]) ,
		.mrq_data_0_19(mrq.data[0][19]) ,
		.mrq_data_0_20(mrq.data[0][20]) ,
		.mrq_data_0_21(mrq.data[0][21]) ,
		.mrq_data_0_22(mrq.data[0][22]) ,
		.mrq_data_0_23(mrq.data[0][23]) ,
		.mrq_data_0_24(mrq.data[0][24]) ,
		.mrq_data_0_25(mrq.data[0][25]) ,
		.mrq_data_0_26(mrq.data[0][26]) ,
		.mrq_data_0_27(mrq.data[0][27]) ,
		.mrq_data_0_28(mrq.data[0][28]) ,
		.mrq_data_0_29(mrq.data[0][29]) ,
		.mrq_data_0_30(mrq.data[0][30]) ,
		.mrq_data_0_31(mrq.data[0][31]),
		
		.mrs_ack(mrs.ack),
		.mrs_data_1_0(mrs.data[1][0]),
		.mrs_data_1_1(mrs.data[1][1]),
		.mrs_data_1_2(mrs.data[1][2]),
		.mrs_data_1_3(mrs.data[1][3]),
		.mrs_data_1_4(mrs.data[1][4]),
		.mrs_data_1_5(mrs.data[1][5]),
		.mrs_data_1_6(mrs.data[1][6]),
		.mrs_data_1_7(mrs.data[1][7]),
		.mrs_data_1_8(mrs.data[1][8]),
		.mrs_data_1_9(mrs.data[1][9]),
		.mrs_data_1_10(mrs.data[1][10]),
		.mrs_data_1_11(mrs.data[1][11]),
		.mrs_data_1_12(mrs.data[1][12]),
		.mrs_data_1_13(mrs.data[1][13]),
		.mrs_data_1_14(mrs.data[1][14]),
		.mrs_data_1_15(mrs.data[1][15]),
		.mrs_data_1_16(mrs.data[1][16]),
		.mrs_data_1_17(mrs.data[1][17]),
		.mrs_data_1_18(mrs.data[1][18]),
		.mrs_data_1_19(mrs.data[1][19]),
		.mrs_data_1_20(mrs.data[1][20]),
		.mrs_data_1_21(mrs.data[1][21]),
		.mrs_data_1_22(mrs.data[1][22]),
		.mrs_data_1_23(mrs.data[1][23]),
		.mrs_data_1_24(mrs.data[1][24]),
		.mrs_data_1_25(mrs.data[1][25]),
		.mrs_data_1_26(mrs.data[1][26]),
		.mrs_data_1_27(mrs.data[1][27]),
		.mrs_data_1_28(mrs.data[1][28]),
		.mrs_data_1_29(mrs.data[1][29]),
		.mrs_data_1_30(mrs.data[1][30]),
		.mrs_data_1_31(mrs.data[1][31]),
		
		.mrs_data_0_0(mrs.data[0][0]),
		.mrs_data_0_1(mrs.data[0][1]),
		.mrs_data_0_2(mrs.data[0][2]),
		.mrs_data_0_3(mrs.data[0][3]),
		.mrs_data_0_4(mrs.data[0][4]),
		.mrs_data_0_5(mrs.data[0][5]),
		.mrs_data_0_6(mrs.data[0][6]),
		.mrs_data_0_7(mrs.data[0][7]),
		.mrs_data_0_8(mrs.data[0][8]),
		.mrs_data_0_9(mrs.data[0][9]),
		.mrs_data_0_10(mrs.data[0][10]),
		.mrs_data_0_11(mrs.data[0][11]),
		.mrs_data_0_12(mrs.data[0][12]),
		.mrs_data_0_13(mrs.data[0][13]),
		.mrs_data_0_14(mrs.data[0][14]),
		.mrs_data_0_15(mrs.data[0][15]),
		.mrs_data_0_16(mrs.data[0][16]),
		.mrs_data_0_17(mrs.data[0][17]),
		.mrs_data_0_18(mrs.data[0][18]),
		.mrs_data_0_19(mrs.data[0][19]),
		.mrs_data_0_20(mrs.data[0][20]),
		.mrs_data_0_21(mrs.data[0][21]),
		.mrs_data_0_22(mrs.data[0][22]),
		.mrs_data_0_23(mrs.data[0][23]),
		.mrs_data_0_24(mrs.data[0][24]),
		.mrs_data_0_25(mrs.data[0][25]),
		.mrs_data_0_26(mrs.data[0][26]),
		.mrs_data_0_27(mrs.data[0][27]),
		.mrs_data_0_28(mrs.data[0][28]),
		.mrs_data_0_29(mrs.data[0][29]),
		.mrs_data_0_30(mrs.data[0][30]),
		.mrs_data_0_31(mrs.data[0][31])
	);
	
	
	mem_ctrl mc
	(
		.rst(rst),					// Reset Input
		.clk(clk), 
		.mem_req(mrq),			// memory request
		.mem_res(mrs)
	);
	
	reference_ram reference_ram
	(
		.clock(clk),
		.address(12'd0),
		.wren(1'b0),
		.data(32'd0)
	);
	
endmodule // End of Module ram_sp_sr_sws


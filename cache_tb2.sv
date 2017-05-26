/************************************
*
*/
`include "cache_structs_def.sv"
//=================================================
// Import the Packages
//=================================================
import cache_structs_def::*;

module cache_tb2;
timeunit 1ns;
timeprecision 100ps;

	localparam ADDR_WIDTH 		= 32;		//Bit width of address
	localparam DATA_WIDTH 		= 32;		//Bit width of data bus
	localparam CACHE_SIZE 		= 32;		//Cache size in bytes
	localparam BLOCK_SIZE 		= 4;		//Block size in bytes
	localparam NUMBER_OF_SETS 	= 1;		//Quantity of sets
	
	logic clk;
	logic rst;
	logic hit;
	realtime clk_period = 40ns;
	
	processor_request_t proc_req;
	memory_request_t mem_req;
	memory_response_t mem_res; 
	logic proc_req_dr;
	wire [DATA_WIDTH-1:0] proc_req_data;
	logic [DATA_WIDTH-1:0] data_reg;
	
	integer rand1, rand2;
	// Data hit
	
	logic [DATA_WIDTH-1:0] data_to_save[6] = {'h12, 'h0a, 'h99, 'h55, 'ha5, 'hbb};
	
	logic [ADDR_WIDTH-1:0] op_addr[3] = {'hff, 'haa, 'h20};
	
	initial clk = 0;
	always begin 
		#(clk_period/2)  clk=~clk;
	end
	
	logic cs, rw;
	assign proc_req.cs = cs;
	assign proc_req.rw = rw;
		
	assign proc_req_data = (cs == 'b1 && rw == 'b1) ? data_reg : 'Z;
	
	initial begin
		rst = 1;
		#clk_period;
		rst = 0;
		$monitor("%t ns MONITOR	addr=%h data_bus=%h cs=%b rw=%b hit=%b",$time/10, proc_req.addr,proc_req_data,cs,rw,hit);
			for (int i=0; i<=128; i=i+32) begin
				rand1 = $urandom_range(0,5); 
				rand2 = $urandom_range(0,2); 
				data_reg = 32'hbeefdead;
				proc_req.addr = i;
				cs = 1;
				rw = 1;
				#clk_period;
				while(proc_req_dr == 'b0) begin
					#clk_period;
				end
				#clk_period;
			end
	end
	
	cache cache1
	(
		.rst(rst),					// Reset Input
		.clk(clk), 				// Clock Input
		.proc_req(proc_req),			// processor request
		
		/// PROCESSOR <-> CACHE
		.proc_req_data(proc_req_data), 			// Processor request bi-directional data
		
		/// PROCESSOR <- CACHE
		.proc_req_dr(proc_req_dr)	,	// Processor request data ready
		
		/// CACHE -> MEMORY
		.mem_req(mem_req), 			// memory request
		
		/// CACHE <- MEMORY
		.mem_res(mem_res),
		
		.hit_out(hit)
	);
	
	mem_ctrl mc
	(
		.rst(rst),					// Reset Input
		.clk(clk), 
		.mem_req(mem_req),			// memory request
		.mem_res(mem_res)
	);
	
// End of Module ram_sp_sr_sws1	
endmodule 
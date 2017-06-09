/************************************
*
*/
//=================================================
// Import the Packages
//=================================================
import cache_structs_def::*;

module rv_cache_sint_top 	
(
	input wire				rst,					// Reset Input
	
	input wire              clk						// Clock Input
);
	
	logic [15:0] inst_addr;
	logic [67:0] inst;
	logic increment_inst;
	
	memory_request_t mem_req;
	memory_response_t mem_res;
	
	/// PROCESSOR -> CACHE
	processor_request_t		proc_req;			// processor request
	
	/// PROCESSOR <- CACHE
	processor_response_t		proc_res;
	
	wire [DATA_WIDTH-1:0] 	proc_res_data;
	
	typedef enum {fetch_inst, load_op, store_op, flush_op, idle} fake_processor_st;
	
	fake_processor_st current_st;
	fake_processor_st next_st;
	
	
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			inst_addr <= 'b0;
			current_st <= fetch_inst;
		end
		else begin
			current_st <= next_st;
			
			if(increment_inst) begin
				inst_addr <= inst_addr + 16'd1;
			end
			
		end
	end
	
	always_comb begin
		case(current_st)
		
			fetch_inst: begin
			
				proc_req.addr = inst[63:32];
				proc_req.cs = 'b0;
				proc_req.rw = 'b0;
				proc_req.flush = 'b0;
				increment_inst = 0;
				
				case(inst[67:64])
					'd0: begin
						next_st = load_op;
					end
					'd1: begin
						next_st = store_op;
					end
					'd2: begin
						next_st = flush_op;
					end
				endcase
			end
			
			load_op: begin
				proc_req.addr = inst[63:32];
				proc_req.cs = 'b1;
				proc_req.rw = 'b0;
				proc_req.flush = 'b0;
				proc_req.data = inst[31:0];
				
				if(proc_res.hold_cpu == 'b1) begin
					next_st = load_op;
					increment_inst = 0;
				end
				else begin
					next_st = fetch_inst;
					increment_inst = 1;
				end
			end
			
			store_op: begin
				proc_req.addr = inst[63:32];
				proc_req.cs = 'b1;
				proc_req.rw = 'b1;
				proc_req.flush = 'b0;
				proc_req.data = inst[31:0];
				
				if(proc_res.hold_cpu == 'b1) begin
					next_st = store_op;
					increment_inst = 0;
				end
				else begin
					next_st = fetch_inst;
					increment_inst = 1;
				end
			end
			
			flush_op: begin
				proc_req.addr = inst[63:32];
				proc_req.cs = 'b0;
				proc_req.rw = 'b0;
				proc_req.flush = 'b1;
				proc_req.data = inst[31:0];
				
				if(proc_res.hold_cpu == 'b1) begin
					next_st = flush_op;
					increment_inst = 0;
				end
				else begin
					next_st = idle;
					increment_inst = 1;
				end
			end
			
			idle: begin
				next_st = idle;
			end
		
		endcase
	end
				
	cache cache1
	(
		.rst(rst),					// Reset Input
		.clk(clk), 				// Clock Input
		
		.proc_req(proc_req),			// processor request
		
		/// PROCESSOR <-> CACHE
		.proc_res(proc_res), 			// Processor request bi-directional data
		
		.proc_res_data(proc_res_data),
			
		/// CACHE -> MEMORY
		.mem_req(mem_req), 			// memory request
		
		/// CACHE <- MEMORY
		.mem_res(mem_res)
		
	);
	
	mem_ctrl mc
	(
		.rst(rst),					// Reset Input
		.clk(clk), 
		.mem_req(mem_req),			// memory request
		.mem_res(mem_res)
	);
	
	reference_ram reference_ram
	(
		.clock(clk),
		.address(12'd0),
		.wren(1'b0),
		.data(32'd0)
	);
	
	inst_ram inst_ram
	(
		.clock(clk),
		.address(inst_addr),
		.wren(1'b0),
		.data(68'd0),
		.q(inst)
	);
		
	
// End of Module ram_sp_sr_sws1	
endmodule 
/************************************
*
*/
//`include "cache_structs_def.sv"
//=================================================
// Import the Packages
//=================================================
import cache_parameters::*;

module cache_tb_sim;
timeunit 1ns;
timeprecision 100ps;
	
	logic clk;
	logic rst;
	realtime clk_period = 40ns;
	
	wire[WORD_WIDTH-1:0] rram_q;
	processor_request_t proc_req;
	processor_response_t proc_res;
	wire [WORD_WIDTH-1:0] proc_res_data;
	memory_request_t mem_req;
	memory_response_t mem_res; 

	logic [WORD_WIDTH-1:0] data_reg;
	logic [ADDR_WIDTH - 1 + 2: 0] addr_buf;
	
	
	initial clk = 0;
	always begin 
		#(clk_period/2)  clk=~clk;
	end
	logic cs, rw;
	assign proc_req.cs = cs;
	assign proc_req.rw = rw;
		
	initial begin
		static integer fd = $fopen("C:/Workspace/TG/inst_gen/inst.in", "r"); 
		if (fd == 0) begin
			$display("ERROR : CAN NOT OPEN THE FILE");
		end
		rst = 1;
		#(clk_period/2);
		rst = 1;
		#clk_period;
		rst = 0;
		#clk_period;
		
		while(proc_res.hold_cpu == 'b1) begin
			#clk_period;
		end
		
		while(!$feof(fd)) begin		
			
			string inst;
			int status;
			status = $fscanf(fd, "%s", inst);
			 
			cs = 1;
			case(inst)
				"LD": begin
					rw = 0;
					$fscanf(fd, "%h\n",  addr_buf);
				end
				"ST": begin
					rw = 1;
					$fscanf(fd, "%h %h\n",  addr_buf, proc_req.data);
					
				end
				default: $display("ERROR : INSTRUCTION NOT WELL FORMED");
			endcase
			
			proc_req.addr = addr_buf[WORD_WIDTH-1 + 2:2];
			
			#clk_period;
			
			while(proc_res.hold_cpu == 'b1) begin
			
				if(proc_req.addr == 'h17c || mem_req.addr == 'h17c) begin
					//$stop;
				end
				#clk_period;
			end
			
			if(proc_req.rw) begin
				$display("Written %x on address %x", proc_req.data, proc_req.addr);
			end
			else begin
				$display("Read %x from address %x", proc_res.data, proc_req.addr);
			end		
		end
		
		/*cs = 'b1;
		proc_req.flush = 'b1;
		#clk_period;
		while(proc_res.hold_cpu == 'b1) begin
			#clk_period;
		end
		proc_req.flush = 'b0;
		cs = 'b0;*/
		
		$stop;
	end
	
	cache cache1
	(
		.rst(rst),					// Reset Input
		.clk(clk), 				// Clock Input
		
		.proc_req(proc_req),			// processor request
		
		/// PROCESSOR <-> CACHE
		.proc_res(proc_res), 			// Processor request bi-directional data
			
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
		.data(32'd0),
		.q(rram_q)
	);
	
	
// End of Module ram_sp_sr_sws1	
endmodule 
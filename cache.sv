/************************************
*
*/
//`include "cache_structs_def.sv"
//=================================================
// Import the Packages
//=================================================
import cache_structs_def::*;

module cache 	
(
	input wire						rst,					// Reset Input
	
	input wire                  	clk, 				// Clock Input
	
	/// PROCESSOR -> CACHE
	input processor_request_t		proc_req,			// processor request
	
	/// PROCESSOR <- CACHE
	output processor_response_t		proc_res,
	
	output wire [DATA_WIDTH-1:0] 	proc_res_data,
	
	/// CACHE -> MEMORY
	output memory_request_t			mem_req,			// memory request
	
	/// CACHE <- MEMORY
	input  memory_response_t		mem_res
);
	
	//--------------Internal STRUCTS---------------- 
	set_t						sets [NUMBER_OF_SETS];
	replaced_buf_t				rep_buf;
	cache_state_t 				state;
	//------------
	
	//BUFFERS
	reg [TAG_WIDTH-1:0] tag_buf;
	reg [LINE_WIDTH-1:0] line_buf;
	reg [OFFSET_WIDTH:0] offset_buf;
		
	//REGISTERS
	logic [LINE_WIDTH:0] line_count;
	logic [SET_COUNT_WIDTH:0] set_count;
	logic write_data_ack;
	
	//AUXILIARY MEMORYS
	reg	[SET_COUNT_WIDTH-1:0] set_to_replace[LINES_PER_SET];
	
	//WIRES
	logic [NUMBER_OF_SETS-1:0]	hit_array;
	logic write_cache;
	logic write_data;
	logic read_data;
	wire miss;				// Data miss
	wire hit;				// Data hit
	wire [TAG_WIDTH-1:0] addr_tag;
	wire [LINE_WIDTH-1:0] addr_line;
	wire [OFFSET_WIDTH:0] addr_offset;
	wire proc_valid_read;
	wire proc_valid_write;
	wire proc_valid_flush;
	wire proc_valid_op;

	//CONTINUOUS ASSIGNMENTS
	assign proc_valid_flush = proc_req.cs & proc_req.flush & ~rst;
	assign proc_valid_read = proc_req.cs  & ~proc_req.rw & ~proc_req.flush & ~rst; //VALID READ REQUEST
	assign proc_valid_write = proc_req.cs & proc_req.rw & ~proc_req.flush & ~rst; //VALID WRITE REQUEST
	assign proc_valid_op = proc_valid_read | proc_valid_write; //VALID OPERATION REQUEST
	
	assign addr_tag = proc_req.addr[TAG_MSB:TAG_LSB];
	assign addr_line = proc_req.addr[LINE_MSB:LINE_LSB];

	assign hit = |(hit_array) & proc_valid_op;
	assign miss = ~(|(hit_array)) & proc_valid_op;	
	
	generate
		if(OFFSET_WIDTH > 0) begin
			assign addr_offset[OFFSET_MSB+1] = 1'b0;
			assign addr_offset[OFFSET_MSB:OFFSET_LSB] = proc_req.addr[OFFSET_MSB:OFFSET_LSB];
		end
		else begin
			assign addr_offset[0] = 'b0;
		end
	endgenerate
	
	genvar i;
	
	generate
		for ( i=0; i < NUMBER_OF_SETS; i=i+1) begin : out_gen// <-- example block name
			
			/**HIT MUX*/
			assign hit_array[i] = sets[i].valid[addr_line] & (sets[i].tag[addr_line] == addr_tag);
			 
			/**READ_DATA MUX*/
			assign proc_res_data[DATA_WIDTH-1:0] = (hit_array[i] & read_data) ? sets[i].data[addr_line][addr_offset] : 'Z;
			
				
			/**WRITE DATA FLIP FLOP*/
			always_ff @(posedge clk or posedge rst) begin : DATA_WRITE
			
				if(rst) begin
					write_data_ack <= 'b0;
					for(int j=0; j < LINES_PER_SET; j=j+1) begin
						sets[i].valid[j] <= 'b0;
					end
				end
				
				else begin
					if(hit_array[i] && write_data) begin
						 sets[i].data[addr_line][addr_offset] <= proc_req.data[DATA_WIDTH-1:0];
						 sets[i].dirty[addr_line] <= 'b1;
					end
					else if (mem_res.ack && write_cache && set_to_replace[line_buf] == i) begin
						sets[i].data[line_buf] <= mem_res.data;
						sets[i].valid[line_buf] <= 'b1;
						sets[i].dirty[line_buf] <= 'b0;
						sets[i].tag[line_buf] <= tag_buf;
					end
										
				end
			end
		end 
	endgenerate
			
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			tag_buf <= 'b0;
			line_buf <= 'b0;
			offset_buf <= 'b0;
			rep_buf.addr <= 'b0;
			line_count <= 'd0;
			set_count <= 'd0;
			for(int i=0; i < LINES_PER_SET; i=i+1) begin
				set_to_replace[i] <= 'd0;
			end
		end
		
		else begin
			case(state)
				idle: begin
					if(miss == 'b1) begin				
						tag_buf <= addr_tag;
						line_buf <= addr_line;
						offset_buf <= addr_offset;
					end
					else if (proc_req.flush == 'b1) begin
						line_count <= 'b0;
					end
				end
				
				def_set_replaced: begin		
					if(sets[set_to_replace[line_buf]].valid[line_buf] 
						&& sets[set_to_replace[line_buf]].dirty[line_buf]) begin
						
						rep_buf.addr[TAG_MSB:TAG_LSB] <= sets[set_to_replace[line_buf]].tag[line_buf];
						rep_buf.addr[LINE_MSB:LINE_LSB] <= line_buf;
						rep_buf.addr[OFFSET_MSB:OFFSET_LSB] <= 'h0;
						rep_buf.data <= sets[set_to_replace[line_buf]].data[line_buf];
						
					end
				end
				
				allocate: begin
					if(mem_res.ack) begin
						set_to_replace[line_buf] <= set_to_replace[line_buf] + 'd1;
					end
				end
			
				write_back: begin

				end
				
				rw_op : begin
				
				end
				
				flush_op: begin
					if(set_count < NUMBER_OF_SETS) begin
						if(line_count < LINES_PER_SET) begin
							if(sets[set_count].valid[line_count] && sets[set_count].dirty[line_count]) begin
								rep_buf.addr[TAG_MSB:TAG_LSB] <= sets[set_count].tag[line_count];
								rep_buf.addr[LINE_MSB:LINE_LSB] <= line_count;
								rep_buf.addr[OFFSET_MSB:OFFSET_LSB] <= 'b0;
								rep_buf.data <= sets[set_count].data[line_count];
								line_count <= line_count + 'd1;
							end
							else begin
								line_count <= line_count + 'd1;
							end
						end
						else begin
							line_count <= 'd0;
							set_count <= set_count + 'd1;
						end
					end
					else begin
						line_count <= 'd0;
						set_count <= set_count + 'd0;
					end
				end		
			endcase
		end
	end
	
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			state <= idle;
		end
		else begin
			case(state)
				idle: begin
					if(miss == 'b1) begin				
						state <= def_set_replaced;
					end
					else if (proc_valid_flush == 'b1) begin
						state <= flush_op;
						line_count <= 'b0;
					end
					else if (proc_valid_write) begin
						state <= rw_op;
					end
					else if (proc_valid_read) begin
						state <= rw_op;
					end
					else begin
						state <= idle;
					end
				end			
				def_set_replaced: begin		
					if(sets[set_to_replace[line_buf]].valid[line_buf] &&
						sets[set_to_replace[line_buf]].dirty[line_buf]) begin
						
						state <= write_back;
					end
					else begin
						state <= allocate;
					end
				end
				
				allocate: begin
					if(mem_res.ack) begin
						state <= idle;
					end
					else begin
						state <= allocate;
					end
				end
				
				write_back: begin
					if(mem_res.ack == 'b0) begin
						state <= write_back;
					end
					else begin
						if(proc_req.flush == 'b1) begin
							state <= flush_op;
						end
						else begin
							state <= allocate;
						end
					end
				end
				
				rw_op : begin
					state <= idle;
				end
				
				flush_op: begin
					if(set_count < NUMBER_OF_SETS) begin
						if(line_count < LINES_PER_SET) begin
							if(sets[set_count].valid[line_count] && sets[set_count].dirty[line_count]) begin
								state <= write_back;
							end
						end
					end
					else begin
						state <= idle;
					end
				end
			endcase
		end
	end 
	
	always_comb begin
		case(state)
			idle: begin
				write_data = 'b0;
				write_cache = 'b0;
				mem_req.cs = 'b0;
				mem_req.rw = 'b0;
				mem_req.addr = 'h0;
				
				for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
					mem_req.data[i] = 'b0;
				end		

				if(miss == 'b1) begin				
					proc_res.hold_cpu = 'b1;
					write_data = 'b0;
					read_data = 'b0;					
				end
				else if (proc_valid_flush == 'b1) begin
					proc_res.hold_cpu = 'b1;
					write_data = 'b0;
					read_data = 'b0;					
				end
				else if (proc_valid_read) begin
					proc_res.hold_cpu = 'b1;
					write_data = 'b0;
					read_data = 'b1;
				end
				else if (proc_valid_write) begin
					proc_res.hold_cpu = 'b1;
					write_data = 'b1;
					read_data = 'b0;
				end
				else begin
					proc_res.hold_cpu = 'b0;
					write_data = 'b0;
					read_data = 'b0;					
				end
				
			end
			allocate: begin
				proc_res.hold_cpu = 'b1;
				read_data = 'b0;
				write_data = 'b0;
				
				if(mem_res.ack == 'b0) begin
					write_cache = 'b0;
					mem_req.cs = 'b1;
					mem_req.rw = 'b0;
					mem_req.addr[TAG_MSB:TAG_LSB] = tag_buf;
					mem_req.addr[LINE_MSB:LINE_LSB] = line_buf;
					mem_req.addr[OFFSET_MSB:OFFSET_LSB] <= 'b0;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end
				end
				else begin
					write_cache = 'b1;
					mem_req.cs = 'b0;
					mem_req.rw = 'b0;
					mem_req.addr = 'b0;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end					
				end
			end			
			
			write_back: begin
				proc_res.hold_cpu = 'b1;
				read_data = 'b0;
				write_data = 'b0;
				
				if(mem_res.ack == 'b0) begin
					write_cache = 'b0;
					mem_req.cs = 'b1;
					mem_req.rw = 'b1;
					mem_req.addr = rep_buf.addr;
					mem_req.data = rep_buf.data;
				end
				else begin
					write_cache = 'b0;
					mem_req.cs = 'b0;
					mem_req.rw = 'b0;
					mem_req.addr = 'b0;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end					
				end
			end
			
			flush_op: begin
				read_data = 'b0;
				write_data = 'b0;
				write_cache = 'b0;
				mem_req.cs = 'b0;
				mem_req.rw = 'b0;
				mem_req.addr = 'b0;
				for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
					mem_req.data[i] = 'b0;
				end
				if(set_count < NUMBER_OF_SETS) begin
					proc_res.hold_cpu = 'b1;
				end
				else begin
					proc_res.hold_cpu = 'b0;
				end
			end
			
			rw_op : begin
			
				if(proc_valid_read) begin
					read_data = 'b1;
					write_data = 'b0;
				end
				else if (proc_valid_write) begin
					read_data = 'b0;
					write_data = 'b1;
				end
				proc_res.hold_cpu = 'b0;
				write_cache = 'b0;
				mem_req.cs = 'b0;
				mem_req.rw = 'b0;
				mem_req.addr = 'b0;
				for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
					mem_req.data[i] = 'b0;
				end		
			
			end
			
			default: begin
				proc_res.hold_cpu = 'b1;
				read_data = 'b0;
				write_data = 'b0;
				write_cache = 'b0;
				mem_req.cs = 'b0;
				mem_req.rw = 'b0;
				mem_req.addr = 'b0;
				for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
					mem_req.data[i] = 'b0;
				end				
			end
			
		endcase
	end
  
 
endmodule // End of Module ram_sp_sr_sws

/************************************
*
*/
`include "cache_structs_def.sv"
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
	inout wire [DATA_WIDTH-1:0] 	proc_req_data, 			// Processor request bi-directional data
	
	/// PROCESSOR <- CACHE
	output wire						proc_req_dr,		// Processor request data ready
	
	/// CACHE -> MEMORY
	output memory_request_t			mem_req,			// memory request
	
	/// CACHE <- MEMORY
	input  memory_response_t		mem_res,
	
	output logic					hit_out
);
	
	//--------------Internal variables---------------- 
	logic [NUMBER_OF_SETS-1:0]	hit_array;
	set_t						sets [NUMBER_OF_SETS];
	replaced_buf_t				rep_buf;
	//------------
	
	reg [DATA_WIDTH-1:0] write_miss_data_buffer;
	wire [TAG_WIDTH-1:0] addr_tag;
	wire [LINE_WIDTH-1:0] addr_line;
	wire [OFFSET_WIDTH-1:0] addr_offset;
	wire proc_req_ops;
	
	
	reg [ADDR_WIDTH-1:0] addr_buf;
	reg [TAG_WIDTH-1:0] tag_buf;
	reg [LINE_WIDTH-1:0] line_buf;
	reg [OFFSET_WIDTH-1:0] offset_buf;
	
	assign proc_valid_read = proc_req.cs  & ~proc_req.rw & ~rst; //VALID READ REQUEST
	assign proc_valid_write = proc_req.cs & proc_req.rw & ~rst; //VALID WRITE REQUEST
	assign proc_valid_op = proc_valid_read | proc_valid_write; //VALID OPERATION REQUEST
	
	assign addr_tag = proc_req.addr[TAG_MSB:TAG_LSB];
	assign addr_line = proc_req.addr[LINE_MSB:LINE_LSB];
	
	wire miss;				// Data miss
	wire hit;				// Data hit
	
	assign proc_req_dr = hit;
	assign hit_out = hit;
	assign hit = |(hit_array) & proc_valid_op;
	assign miss = ~(|(hit_array)) & proc_valid_op;
	
	assign addr_offset[OFFSET_LSB+1:OFFSET_LSB] = 2'b00;
	
	cache_state_t state;
	
	generate
		if(OFFSET_WIDTH > 2) begin
			assign addr_offset[OFFSET_MSB:OFFSET_LSB+2] = proc_req.addr[OFFSET_MSB:OFFSET_LSB+2];
		end
	endgenerate
		
	generate
		for (genvar i=0; i < NUMBER_OF_SETS; i=i+1) begin : out_gen// <-- example block name
			
			//*RESET//
			always_ff @(posedge clk or posedge rst) begin : RESET
				if(rst) begin
					for(int j=0; j < LINES_PER_SET; j=j+1) begin
						sets[i].valid[j] <= 'b0;
					end
				end
			end

			/**HIT MUX*/
			assign hit_array[i] = sets[i].valid[addr_line] & (sets[i].tag[addr_line] == addr_tag);
			 
			/**READ_DATA MUX*/
			for(genvar j = 0; j < DATA_WIDTH; j=j+8) begin : READ_MUX
				assign proc_req_data[j+7:j] = (hit_array[i] & proc_valid_read) ? sets[i].data[addr_line][addr_offset + j/8] : 'Z;
			end
				
			/**WRITE DATA FLIP FLOP*/
			for(genvar j = 0; j < DATA_WIDTH; j+=8) begin
				always_ff @(posedge clk) begin : DATA_WRITE
					if(hit_array[i] & proc_valid_write) begin
						 sets[i].data[addr_line][addr_offset + j/8] <= proc_req_data[j+7:j];
						 sets[i].dirty[addr_line] <= 'b1;
					end
				end
			end	
		end 
	endgenerate
		
	always_ff @(posedge clk or posedge rst) begin
		if(rst) begin
			state <= idle;
			write_miss_data_buffer <= 'b0;
			tag_buf <= 'b0;
			line_buf <= 'b0;
			offset_buf <= 'b0;
			rep_buf.addr <= 'b0;
		end
		
		else begin
			case(state)
				idle: begin
					if(miss == 'b1) begin				
						state <= def_set_replaced;
						addr_buf <= proc_req.addr;
						tag_buf <= addr_tag;
						line_buf <= addr_line;
						offset_buf <= addr_offset;
						write_miss_data_buffer <= proc_req_data;
					end
					else begin
						state <= idle;
					end
				end
				def_set_replaced: begin
					for(int i = 1; i < NUMBER_OF_SETS; i++) begin
						sets[i].valid[line_buf] <= sets[i-1].valid[line_buf];
						sets[i].dirty[line_buf] <= sets[i-1].dirty[line_buf];
						sets[i].tag[line_buf]   <= sets[i-1].tag[line_buf];
						sets[i].data[line_buf] <= sets[i-1].data[line_buf];
					end
					
					if(sets[NUMBER_OF_SETS-1].dirty[line_buf]) begin
						state <= write_back;
						rep_buf.addr[TAG_MSB:TAG_LSB] <= sets[NUMBER_OF_SETS-1].tag[line_buf];
						rep_buf.addr[LINE_MSB:LINE_LSB] <= line_buf;
						rep_buf.addr[OFFSET_MSB:OFFSET_LSB] <= '0;
						rep_buf.data <= sets[NUMBER_OF_SETS-1].data[line_buf];
					end
					else begin
						state <= allocate;
					end
				end
				
				allocate: begin
					if(mem_res.ack) begin
						sets[0].data[line_buf] <= mem_res.data;
						sets[0].valid[line_buf] <= 'b1;
						sets[0].dirty[line_buf] <= 'b0;
						sets[0].tag[line_buf] <= tag_buf;
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
						state <= allocate;
					end
				end
			endcase
		end
	end
	
	always_comb begin
		case(state)
			allocate: begin
				if(mem_res.ack == 'b0) begin
					mem_req.cs = 'b1;
					mem_req.rw = 'b0;
					mem_req.addr = addr_buf;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end
					
				end
				else begin
					mem_req.cs = 'b0;
					mem_req.rw = 'b0;
					mem_req.addr = 'b0;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end					
				end
			end			
			
			write_back: begin
				if(mem_res.ack == 'b0) begin
					mem_req.cs = 'b1;
					mem_req.rw = 'b1;
					mem_req.addr = rep_buf.addr;
					mem_req.data = rep_buf.data;
				end
				else begin
					mem_req.cs = 'b0;
					mem_req.rw = 'b0;
					mem_req.addr = addr_buf;
					for(int i = 0; i < BLOCK_SIZE; i = i + 1) begin
						mem_req.data[i] = 'b0;
					end					
				end
			end
			default: begin
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

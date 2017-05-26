package cache_structs_def;

	function integer clog2;
		input integer value;
    begin
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
        end
    end
	endfunction
	
	parameter ADDR_WIDTH 		= 12;		//Bit width of address
	parameter DATA_WIDTH 		= 32;		//Bit width of data
	parameter CACHE_SIZE 		= 64;		//Cache size in bytes
	parameter BLOCK_SIZE 		= 8;		//Block size in bytes
	parameter NUMBER_OF_SETS 	= 2; 		//Quantity of sets
	
	parameter DATA_SIZE	= DATA_WIDTH/8; //Data size in bytes
	parameter LINES_PER_SET = CACHE_SIZE/(BLOCK_SIZE*NUMBER_OF_SETS);
	parameter LINE_WIDTH = clog2(LINES_PER_SET);
	parameter OFFSET_WIDTH = clog2(BLOCK_SIZE);
	parameter TAG_WIDTH = ADDR_WIDTH - (LINE_WIDTH + OFFSET_WIDTH);
	parameter TAG_MSB = ADDR_WIDTH - 1;
	parameter TAG_LSB = ADDR_WIDTH - TAG_WIDTH;
	parameter LINE_MSB = TAG_LSB - 1;
	parameter LINE_LSB = TAG_LSB - LINE_WIDTH;
	parameter OFFSET_MSB = LINE_LSB-1;
	parameter OFFSET_LSB = 0;
	
	
	typedef struct { 
		logic [7:0] data [LINES_PER_SET][BLOCK_SIZE];
		logic [TAG_WIDTH-1:0] tag [LINES_PER_SET];
		logic valid [LINES_PER_SET];
		logic dirty [LINES_PER_SET];
	} set_t; 
	
	typedef struct { 
		logic [7:0] data [BLOCK_SIZE];
		logic [ADDR_WIDTH-1:0]  addr; 	// Address Input
	} replaced_buf_t; 
	
	typedef struct {
		logic [ADDR_WIDTH-1:0] 	addr;	// Address Input
		logic                  	cs; 	// Chip Select
		logic                  	rw;		// Read 0/Write 1 - 
	} processor_request_t;
	
	typedef struct {
		logic [ADDR_WIDTH-1:0] 		addr; 	// Address Input
		logic                  		cs; 	// Chip Select
		logic                  		rw;		// Read 0/Write 1
		logic [7:0] 				data[BLOCK_SIZE]; 		// Data bi-directional
	} memory_request_t;
	
	
	typedef struct {
		logic                  		ack; 	// Chip Select
		logic [7:0] 				data[BLOCK_SIZE];	// Data bi-directional
	} memory_response_t;
	
	typedef enum {idle, def_set_replaced, allocate, write_back} cache_state_t;
	
endpackage
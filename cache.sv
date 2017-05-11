/************************************
*
*
*
*
*/
module cache 	
#(		
	parameter ADDR_WIDTH 		= 32,		//Bit width of address
	parameter DATA_WIDTH 		= 32,		//Bit width of data
	parameter CACHE_SIZE 		= 32,		//Cache size in bytes
	parameter BLOCK_SIZE 		= 4,		//Block size in bytes
	parameter NUMBER_OF_SETS 	= 1 		//Quantity of sets
)
(
	input wire                  	clk      , 	// Clock Input
	input wire [ADDR_WIDTH-1:0] 	addr     , 	// Address Input
	input wire                  	cs       , 	// Chip Select
	input wire                  	we	   	 ,	// Write Enable/Read Enable
	input wire                  	re	   	 , 	// Write Enable/Read Enable
	input wire						rpe		 ,	// Replace enable
	input wire [0:NUMBER_OF_SETS-1]	set_sel	 ,
	inout wire [DATA_WIDTH-1:0] 	data     , 	// Data bi-directional
	output wire						hit		   	// Data hit
);
	function integer clog2;
		input integer value;
    begin
        value = value - 1;
        for (clog2 = 0; value > 0; clog2 = clog2 + 1) begin
            value = value >> 1;
        end
    end
	endfunction
	    
	localparam LINES_PER_SET = CACHE_SIZE/(BLOCK_SIZE*NUMBER_OF_SETS);
	localparam LINE_WIDTH = clog2(LINES_PER_SET);
	localparam OFFSET_WIDTH = clog2(BLOCK_SIZE);
	localparam TAG_WIDTH = DATA_WIDTH - (LINE_WIDTH + OFFSET_WIDTH);
	localparam TAG_BEGIN = DATA_WIDTH-1;
	localparam TAG_END= DATA_WIDTH - TAG_WIDTH;
	localparam LINE_BEGIN = TAG_END - 1;
	localparam LINE_END = TAG_END - LINE_WIDTH;
	localparam OFFSET_BEGIN = LINE_END-1;
	localparam OFFSET_END = 0;
	
	/*typedef struct { 
		reg valid;
		reg [TAG_WIDTH-1:0] tag;
		reg [DATA_WIDTH-1:0] data;	
	} cache_line; 
	*/
	typedef struct { 
		//cache_line lines [LINES_PER_SET];
		//reg [7:0] data [LINES_PER_SET][BLOCK_SIZE];
		reg [TAG_WIDTH-1:0] tag [LINES_PER_SET];
		reg valid [LINES_PER_SET];
		
	} set; 
	 
	wire hit_indicator;
	wire ops = cs  & (we ^ re ^ rpe);
	wire [TAG_WIDTH-1:0] addr_tag;
	wire [LINE_WIDTH-1:0] addr_line;
	wire [OFFSET_WIDTH-1:0] addr_offset;
		
	assign addr_tag = addr[TAG_BEGIN:TAG_END];
	assign addr_line = addr[LINE_BEGIN:LINE_END];
	
	assign addr_offset[OFFSET_END+1:OFFSET_END] = 2'b00;
	generate
		if(OFFSET_WIDTH > 2) begin
			assign addr_offset[OFFSET_BEGIN:OFFSET_END+2] = addr[OFFSET_BEGIN:OFFSET_END+2];
		end
	endgenerate

	
			
	//--------------Internal variables---------------- 
	logic [NUMBER_OF_SETS-1:0]	hit_sel;
	set 						sets [NUMBER_OF_SETS];
	//------------
	
	assign hit = |(hit_sel) & ops & ~rpe;
	
	generate
		for (genvar i=0; i < NUMBER_OF_SETS; i=i+1) begin : out_gen// <-- example block name
			 
			 /*==============*/
			/**HIT MUX*/
			assign hit_sel[i] = sets[i].valid[addr_line] & (sets[i].tag[addr_line] == addr_tag);
			 
			/**READ_DATA MUX*/
			assign data[7:0] = (hit_sel[i] & ops & re & set_sel[i]) ? sets[i].data[addr_line][addr_offset] : 'Z;
			assign data[15:8] = (hit_sel[i] & ops & re & set_sel[i]) ? sets[i].data[addr_line][addr_offset+1] : 'Z;			
			assign data[23:16] = (hit_sel[i] & ops & re & set_sel[i]) ? sets[i].data[addr_line][addr_offset+2] : 'Z;
			assign data[31:24] = (hit_sel[i] & ops & re & set_sel[i]) ? sets[i].data[addr_line][addr_offset+3] : 'Z;
			
			always_ff @(posedge clk) begin : DATA_WRITE
				if(hit_sel[i] & ops & we & set_sel[i]) begin
					sets[i].data[addr_line][addr_offset]   <= data[7:0];
					sets[i].data[addr_line][addr_offset+1] <= data[15:8];
					sets[i].data[addr_line][addr_offset+2] <= data[23:16];
					sets[i].data[addr_line][addr_offset+3] <= data[31:24];
				end
			end	
			
			always_ff @(posedge clk) begin : REPLACE_BLOCK
				if(ops && rpe) begin
					sets[i].data[addr_line][addr_offset]   <= data[7:0];
					sets[i].data[addr_line][addr_offset+1] <= data[15:8];
					sets[i].data[addr_line][addr_offset+2] <= data[23:16];
					sets[i].data[addr_line][addr_offset+3] <= data[31:24];	
					sets[i].tag[addr_line] 			  		 <= addr_tag;
					sets[i].valid[addr_line] 			   	 <= 1'b1;
				end
			end	
			
		end 
	endgenerate
  
 
endmodule // End of Module ram_sp_sr_sws

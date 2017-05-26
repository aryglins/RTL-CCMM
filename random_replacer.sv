/************************************
*
*
*
*
*/
module random_replacer 	
#(		
	parameter ADDR_WIDTH 		= 32,		//Bit width of address
	parameter DATA_WIDTH 		= 32,		//Bit width of data
	parameter CACHE_SIZE 		= 32,		//Cache size in bytes
	parameter BLOCK_SIZE 		= 4,		//Block size in bytes
	parameter NUMBER_OF_SETS 	= 1 		//Quantity of sets
)
(
	input wire 						rst		 ,	// Reset input
	input wire                  	clk      , 	// Clock Input
	input wire [ADDR_WIDTH-1:0] 	addr     , 	// Address Input
	inout wire [DATA_WIDTH-1:0] 	data     , 	// Data bi-directional
	input wire [0:NUMBER_OF_SETS-1] valid_bits,	// Valid bits from a line
	output wire[0:NUMBER_OF_SETS-1]	set_sel	 ,	// 
	output wire						miss	 ,	// Data miss
	output wire                  	cache_sel,	//Cache memory chip select
	output wire						mem_sel	 ,	//Main mem chip select
	output wire						wait_req 
	
);
	
	
	
endmodule // End of Module ram_sp_sr_sws

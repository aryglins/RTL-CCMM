/************************************
*
*
*
*
*/
module cache_tb2;
timeunit 1ns;
timeprecision 100ps;

	localparam ADDR_WIDTH 		= 32;		//Bit width of address
	localparam DATA_WIDTH 		= 32;		//Bit width of data bus
	localparam CACHE_SIZE 		= 32;		//Cache size in bytes
	localparam BLOCK_SIZE 		= 4;		//Block size in bytes
	localparam NUMBER_OF_SETS 	= 1;		//Quantity of sets
	
	bit clk = 0;
	realtime clk_period = 40ns;
	logic [ADDR_WIDTH-1:0] addr;
	
	wire [DATA_WIDTH-1:0] data_bus;	// Data bi-directional
	reg [DATA_WIDTH-1:0] data_reg;	// Data bi-directional
	logic cs;					 	// Chip Select
	logic we;						// Write Enable/Read Enable
	logic re;						// Write Enable/Read Enable
	logic hit;
	logic rpe;
	integer rand1, rand2;
	// Data hit
	
	reg [DATA_WIDTH-1:0] data_to_save[6] = {'h12, 'h0a, 'h99, 'h55, 'ha5, 'hbb};
	
	reg [ADDR_WIDTH-1:0] addr_to_save[3] = {'hff, 'haa, 'h20};
	
	always begin 
		#(clk_period/2)  clk=~clk;
	end
		
	assign data_bus = (cs == 'b1 && (we == 'b1 || rpe == 'b1) && re == 'b0) ? data_reg : 'Z;
	
	initial begin
		$monitor("%t ns MONITOR	addr=%h data_bus=%h cs=%b we=%b re=%b rpe=%b hit=%b",$time/10, addr,data_bus,cs,we,re,rpe,hit);
			for (int i=0; i<4; i=i+1) begin
				for (int j=8; j<13; j=j+1) begin
					rand1 = $urandom_range(0,5); 
					rand2 = $urandom_range(0,2); 
					data_reg = data_to_save[rand1];
					addr = addr_to_save[rand2];
					{cs,re,we,rpe} = j;
					#clk_period;
				end
			end
	end
	
	cache  #(		
		.ADDR_WIDTH(ADDR_WIDTH)	,
		.DATA_WIDTH(DATA_WIDTH)	,			//Bit width of data
		.CACHE_SIZE(CACHE_SIZE)	,			//Cache size in bytes
		.BLOCK_SIZE(BLOCK_SIZE)	,			//Block size in bytes
		.NUMBER_OF_SETS(NUMBER_OF_SETS)		//Quantity of sets
	) cache1
	(
		.clk	(clk)      	, // Clock Input
		.addr	(addr)     	, // Address Input
		.data	(data_bus)  , // Data bi-directional
		.cs		(cs)       	, // Chip Select
		.we		(we)		, // Write Enable/Read Enable
		.re	   	(re)		, // Write Enable/Read Enable
		.hit	(hit)		, // Data hit
		.rpe	(rpe)
	);
		
endmodule // End of Module ram_sp_sr_sws


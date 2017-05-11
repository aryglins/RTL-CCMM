/************************************
*
*
*
*
*/
module cache_tb;
timeunit 1ns;
timeprecision 100ps;

	localparam ADDR_WIDTH 		= 32;		//Bit width of address
	localparam DATA_WIDTH 		= 32;		//Bit width of data
	localparam CACHE_SIZE 		= 32;		//Cache size in bytes
	localparam BLOCK_SIZE 		= 4;		//Block size in bytes
	localparam BYTE_SIZE		= 8;		//Size of a byte
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
	// Data hit
	
	always begin 
		#(clk_period/2)  clk=~clk;
	end
		
	assign data_bus = (cs == 'b1 && (we == 'b1 || rpe == 'b1) && re == 'b0) ? data_reg : 'Z;
	
	initial begin
		$display("SIMULATION STARTED");	
		re	 = 'b0;
		we	 = 'b0;
		cs	 = 'b1;
		data_reg = 'hff;
		addr = 'hff;
		rpe  = 'b1;
		$display("==================================");
		$display("Data: %0h", data_bus);
		$display("Address: %0h", addr);
		$display("Chip Select: %0b", cs);
		$display("Hit bit: %0b", hit);
		$display("Read Enable: %0b", re);
		$display("Write Enable: %0b", we);
		$display("Replace Enable: %0b", rpe);		
		#clk_period
		cs	 = 'b0;
		rpe	 = 'b0;
		$display("==================================");
		$display("Data: %0h", data_bus);
		$display("Address: %0h", addr);
		$display("Chip Select: %0b", cs);
		$display("Hit bit: %0b", hit);
		$display("Read Enable: %0b", re);
		$display("Write Enable: %0b", we);
		$display("Replace Enable: %0b", rpe);
		#clk_period;
		cs	 = 'b1;
		re	 = 'b1;
		we	 = 'b0;
		addr = 'hff;
		$display("==================================");
		$display("Data: %0h", data_bus);
		$display("Address: %0h", addr);
		$display("Chip Select: %0b", cs);
		$display("Hit bit: %0b", hit);
		$display("Read Enable: %0b", re);
		$display("Write Enable: %0b", we);
		$display("Replace Enable: %0b", rpe);
		#clk_period;
		cs	 = 'b1;
		re	 = 'b0;
		we	 = 'b1;
		addr = 'hff;
		data_reg = 'h7;
		$display("==================================");
		$display("Data: %0h", data_bus);
		$display("Address: %0h", addr);
		$display("Chip Select: %0b", cs);
		$display("Hit bit: %0b", hit);
		$display("Read Enable: %0b", re);
		$display("Write Enable: %0b", we);
		$display("Replace Enable: %0b", rpe);
		#clk_period;
		cs	 = 'b1;
		re	 = 'b1;
		we	 = 'b0;
		addr = 'hff;
		$display("==================================");
		$display("Data: %0h", data_bus);
		$display("Address: %0h", addr);
		$display("Chip Select: %0b", cs);
		$display("Hit bit: %0b", hit);
		$display("Read Enable: %0b", re);
		$display("Write Enable: %0b", we);
		$display("Replace Enable: %0b", rpe);
	end
	
	cache  #(		
		.ADDR_WIDTH(ADDR_WIDTH)	,
		.DATA_WIDTH(DATA_WIDTH)	,			//Bit width of data
		.CACHE_SIZE(CACHE_SIZE)	,			//Cache size in bytes
		.BLOCK_SIZE(BLOCK_SIZE)	,			//Block size in bytes
		.BYTE_SIZE(BYTE_SIZE)	,			//Size of a byte
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


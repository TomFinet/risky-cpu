`include "cpu.v"
`include "memory.v"

module machine;

    // instantiate clock
    wire clock_enable=1;
    reg clock;

    clock clock (
        .enable ( clock_enable ),
        
        .clock  ( clock ),
    );

    reg [31:0] A;
    reg [31:0] Din;
    reg [31:0] Dout;

    // instantiate cpu

    reg reset;
    reg halt;

	cpu cpu (
		.reset ( reset ),
		.halt  ( halt ),
		.clock ( clock ),

		.Din   ( Din ),

		.A     ( A ),
		.Dout  ( Dout )
	);

	// instantiate BRAM
    reg mem_enable;
    reg mem_reset;
    reg mem_rw;

    memory memory (
        .clock  ( clock ),
        .enable ( mem_enable ),
        .reset  ( mem_reset ),

        .rw     ( mem_rw ),
        .ain    ( A ),
        .din    ( Dout ),

        .dout   ( Din ),
    );


endmodule
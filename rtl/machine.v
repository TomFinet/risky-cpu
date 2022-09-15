`ifndef MACHINE
`define MACHINE

`include "./rtl/cpu.v"
`include "./rtl/memory.v"

module machine (
    input clock,
    input reset,
    input halt
);

    reg [31:0] inst_aout;
    reg [31:0] inst_din;

    reg mem_rw;
    reg [31:0] mem_aout;
    reg [31:0] mem_dout;
    reg [31:0] mem_din;

	cpu cpu_module (
		.reset     ( reset ),
		.halt      ( halt ),
		.clock     ( clock ),

        .inst_aout ( inst_aout ),
        .inst_din  ( inst_din ),

	    .mem_rw    ( mem_rw ),
        .mem_aout  ( mem_aout ),
        .mem_dout  ( mem_dout ),
        .mem_din   ( mem_din )
    );

    memory memory_module (
        .clock     ( clock ),
        
        .inst_ain  ( inst_aout ),
        .inst_dout ( inst_din ),

        .rw        ( mem_rw ),
        .ain       ( mem_aout ),
        .din       ( mem_dout ),

        .dout      ( mem_din )
    );


endmodule

`endif
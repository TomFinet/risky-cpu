`ifndef MACHINE
`define MACHINE

`include "./rtl/cpu.v"
`include "./rtl/memory.v"

module machine (
    input wire clock,
    input wire reset
);

    wire [31:0] inst_aout;
    wire [31:0] inst_din;

    wire mem_rw;
    wire [31:0] mem_aout;
    wire [31:0] mem_dout;
    wire [31:0] mem_din;

	cpu cpu_m (
		.reset     ( reset ),
		.clock     ( clock ),

        .inst_aout ( inst_aout ),
        .inst_din  ( inst_din ),

	    .mem_rw    ( mem_rw ),
        .mem_aout  ( mem_aout ),
        .mem_dout  ( mem_dout ),
        .mem_din   ( mem_din )
    );

    memory memory_m (
        .clock     ( clock ),
        .reset     ( reset ),
        
        .inst_ain  ( inst_aout ),
        .inst_dout ( inst_din ),

        .rw        ( mem_rw ),
        .ain       ( mem_aout ),
        .din       ( mem_dout ),

        .dout      ( mem_din )
    );


endmodule

`endif
`ifndef REG_BANK
`define REG_BANK
/* 
 * Provides two combinational read ports and a sequential write port. 
 */

module register_bank(
	input wire clock,

	input wire        we,
	input wire [4:0]  ain,
	input wire [31:0] din,

	// read both of these registers
	input wire [4:0] rs1,
	input wire [4:0] rs2,

	output wire [31:0] rs1_val,
	output wire [31:0] rs2_val
);

	/*
	 * r0 initialised to 0x0000
	 * r1 return address of call
	 * r2 stack pointer
	 * r3-r4 general purpose
	 * r5 used as alternate link register
	 * r6-r31 general purpose
	 */
	reg[31:0] r[31:0];

    assign rs1_val = r[rs1];
    assign rs2_val = r[rs2];

	always @(posedge clock) begin
		r[0] <= 0;
        if(we && ain != 5'b00000) begin
			r[ain] <= din;
        end
	end

endmodule

`endif
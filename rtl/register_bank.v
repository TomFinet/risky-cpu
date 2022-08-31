/* 
 * Provides two combinational read ports and a sequential write port. 
 */

module register_bank(
	input clock,

	input we,
	input [4:0] ain,
	input [31:0] din,

	// read both of these registers
	input [4:0] rs,
	input [4:0] ra,

	output wire [31:0] rs_val,
	output wire [31:0] ra_val,
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

    assign rs_val = r[rs];
    assign ra_val = r[ra];

	always @(posedge clock) begin
		if(we) begin
			r[ain] <= din;
        end
	end

endmodule
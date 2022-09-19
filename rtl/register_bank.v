`ifndef REG_BANK
`define REG_BANK
/* 
 * Provides two combinational read ports and a sequential write port. 
 */

module register_bank(
	input wire clock,
    input wire reset,

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
        if (reset) begin
            r[0]  <= 0;
            r[1]  <= 0;
            r[2]  <= 0;
            r[3]  <= 0;
            r[4]  <= 0;
            r[5]  <= 0;
            r[6]  <= 0;
            r[7]  <= 0;
            r[8]  <= 0;
            r[9]  <= 0;
            r[10] <= 0;
            r[11] <= 0;
            r[12] <= 0;
            r[13] <= 0;
            r[14] <= 0;
            r[15] <= 0;
            r[16] <= 0;
            r[17] <= 0;
            r[18] <= 0;
            r[19] <= 0;
            r[20] <= 0;
            r[21] <= 0;
            r[22] <= 0;
            r[23] <= 0;
            r[24] <= 0;
            r[25] <= 0;
            r[26] <= 0;
            r[27] <= 0;
            r[28] <= 0;
            r[29] <= 0;
            r[30] <= 0;
            r[31] <= 0;
        end
        else begin
            r[0] <= 0;
            if(we && ain != 5'b00000) begin
                r[ain] <= din;
            end
        end
	end

endmodule

`endif
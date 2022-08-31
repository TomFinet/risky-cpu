// we have 7 bits for opcode
// our opcodes for the base integer instruction set.
`define OP_IMM   7'b0000000
`define OP       7'b0000001
`define LUI      7'b0000010
`define AUIPC    7'b0000011
`define JAL      7'b0000100
`define JALR     7'b0000101
`define BRANCH   7'b0000110
`define LOAD     7'b0000111
`define STORE    7'b0001000
`define MISC_MEM 7'b0001001
`define SYSTEM   7'b0001010


module decoder (
	input clock,
	input enable,

	input [31:0] instruction,

	output reg alu_op,
    output reg [3:0] func,
	output reg [11:0] imm,
	output reg [4:0] rd, rs, rs2

    output reg reg_we; // register bank write enable
);

	always @(posedge clock && enable) begin
		
        case (instruction[6:0])

            OP_IMM:
                rd     <= instruction[11:7];
                func   <= {instruction[30], instruction[14:12]};
                rs     <= instruction[19:15]; 
                imm    <= {{20{instruction[31]}}, instruction[31:20]};
                reg_re <= 1;

            OP:
                rd     <= instruction[11:7];
                func   <= {instruction[30], instruction[14:12]};
                rs     <= instruction[19:15];
                rs2    <= instruction[24:20];
                imm    <= {{20{instruction[31]}}, instruction[31:20]};
                reg_re <= 1;

            LUI:
                rd     <= instruction[11:7];
                imm    <= {instruction[31:12], {12{0}}};
             
            AUIPC:
                rd     <= instruction[11:7];
                imm    <= {instruction[31:12], {12{0}}};

            JAL:
                rd     <= instruction[11:7];
                imm    <= instruction[31:12];

            JALR:
                rd     <= instruction[11:7];


            BRANCH:
                rs     <= instruction[19:15];
                rs2    <= instruction[24:20];
                func   <= instruction[14:12];
                imm    <= // offsets

            LOAD:
                rd     <= instruction[11:7];
                func   <= instruction[14:12];
                rs     <= instruction[19:15];
                imm    <= instruction[31:20];

            STORE:
                func   <= instruction[14:12];
                rs     <= instruction[19:15];
                rs2    <= instruction[24:20];
                imm    <= instruction[31:25];

            MISC_MEM:


            SYSTEM:



        endcase
	end

endmodule
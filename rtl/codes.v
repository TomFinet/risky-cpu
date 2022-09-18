`ifndef CODES
`define CODES

// Opcodes
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

// Mem functions
`define LW  3'b000
`define LH  3'b001
`define LHU 3'b010
`define LB  3'b011
`define LBU 3'b100

`define SW 3'b000
`define SH 3'b001
`define SB 3'b010

// ALU functions
`define ADD  4'b0000
`define LT   4'b0001
`define LTU  4'b0010
`define AND  4'b0011
`define OR   4'b0100
`define XOR  4'b0101
`define SLL  4'b0110
`define SRL  4'b0111
`define SRA  4'b1000
`define SUB  4'b1001
`define EQ   4'b1010
`define NE   4'b1011
`define GE   4'b1100
`define GEU  4'b1101

// PC select
`define PC_PLUS_4 2'b00
`define PC_JAL    2'b01
`define PC_JALR   2'b10
`define PC_BRANCH 2'b11

// Register write enable
`define REG_NO_WRITE 1'b0
`define REG_WRITE    1'b1

// Register write-back select
`define REG_RES        2'b00
`define REG_PC_PLUS_4  2'b01
`define REG_MEM        2'b10

// a select
`define A_0   2'b00
`define A_PC  2'b01
`define A_REG 2'b10

// b select
`define B_IMM 1'b0
`define B_REG 1'b1

// lui select
`define LUI_0  1'b0
`define LUI_PC 1'b1

// main memory control
`define MEM_READ  1'b0
`define MEM_WRITE 1'b1

`define MEM_NOT_ENABLE 1'b0
`define MEM_ENABLE     1'b1

// store select
`define STORE_W 0
`define STORE_H 1
`define STORE_B 2

// load select
`define LOAD_W  0
`define LOAD_H  1
`define LOAD_HU 2
`define LOAD_B  3
`define LOAD_BU 4

// branch select
`define NO_BRANCH  1'b0
`define YES_BRANCH 1'b1

// NOP instruction encoding
`define NOP 32'h00000000

`define ZERO_REG 5'b00000

`define IR_SEL_NOP  1'b0
`define IR_SEL_INST 1'b1

`endif
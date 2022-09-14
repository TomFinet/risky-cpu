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
`define PC_PLUS_4       3
`define PC_PLUS_IMM     2
`define PC_REG_PLUS_IMM 1
`define PC_BRANCH       0

// Register write enable
`define REG_WRITE    1
`define REG_NO_WRITE 0

// Register write-back select
`define REG_RES        0
`define REG_PC_PLUS_4  1
`define REG_IMM        2
`define REG_RAM        3

// b select
`define B_IMM 0
`define B_REG 1

// lui select
`define LUI_0  0
`define LUI_PC 1

// main memory control
`define MEM_READ  0
`define MEM_WRITE 1

`define MEM_NOT_ENABLE 0
`define MEM_ENABLE     1

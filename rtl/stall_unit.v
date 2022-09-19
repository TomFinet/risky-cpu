`ifndef STALL_UNIT
`define STALL_UNIT

`include "./rtl/codes.v"

module stall_unit (
    input wire [4:0] if_rs1,
    input wire [4:0] if_rs2,
    input wire [6:0] if_opcode,

    input wire [6:0] rr_opcode,
    input wire [6:0] alu_opcode,
    input wire [6:0] mem_opcode,

    input wire [4:0] rr_rd,
    input wire [4:0] alu_rd,
    input wire [4:0] mem_rd,

    output wire data_stall,
    output wire control_stall
);

assign data_stall =
                (
                    if_opcode == `LUI   ||
                    if_opcode == `AUIPC ||
                    if_opcode == `JAL
                ) ? 0 :
                (
                    if_rs1 != `ZERO_REG && (
                    if_rs1 == rr_rd && rr_opcode != `STORE ||
                    if_rs1 == alu_rd ||
                    if_rs1 == mem_rd)
                ) || (
                    if_rs2 != `ZERO_REG && (
                    if_rs2 == rr_rd && rr_opcode != `STORE ||
                    if_rs2 == alu_rd ||
                    if_rs2 == mem_rd)
                ) ? 1 : 0;

assign control_stall =
                    (
                        rr_opcode == `JAL  ||
                        rr_opcode == `JALR ||
                        rr_opcode == `BRANCH
                    ); /*||
                    (
                        alu_opcode == `JAL  ||
                        alu_opcode == `JALR ||
                        alu_opcode == `BRANCH
                    );*/

endmodule

`endif
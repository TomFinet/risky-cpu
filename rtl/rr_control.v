`ifndef RR_CONTROL
`define RR_CONTROL

`include "./rtl/codes.v"

module rr_control (
    input wire clock,
    input wire reset,

    input wire [31:0] inst,
    
    output reg [31:0] inst_out,

    output reg [4:0]  rs1,
    output reg [4:0]  rs2,
    output reg [31:0] imm,

    output reg [1:0]  pc_sel,
    output reg [1:0]  a_sel,
    output reg        b_sel,
    output reg [4:0]  rd,
    output reg [6:0]  opcode
);

always @(posedge clock) begin
    if (reset) begin
        inst_out <= `NOP;
        rd       <= `ZERO_REG;
        opcode   <= 0;
        pc_sel   <= `PC_PLUS_1;
    end
    else begin

        inst_out <= inst;
        rd       <= inst[11:7];
        opcode   <= inst[6:0];
        rs1      <= inst[19:15];
        rs2      <= inst[24:20];

        case (inst[6:0])
            `OP_IMM: begin
                
                if ({1'b0, inst[14:12]} == `LTU) begin
                    imm <= {{20{1'b0}}, inst[31:20]};
                end
                else begin
                    imm <= {{20{inst[31]}}, inst[31:20]};
                end

                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_REG;
                b_sel  <= `B_IMM;
            end

            `OP: begin
                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_REG;
                b_sel  <= `B_REG;
            end

            `LUI: begin
                imm    <= {inst[31:12], {12{1'b0}}};
                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_0;
                b_sel  <= `B_IMM;
            end

            `AUIPC: begin
                imm    <= {inst[31:12], {12{1'b0}}};
                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_PC;
                b_sel  <= `B_IMM;
            end

            `JAL: begin
                imm    <= {    
                            {12{inst[31]}},
                            inst[19:12],
                            inst[20],
                            inst[30:21],
                            1'b0
                        };
                pc_sel <= `PC_JUMP;
                a_sel  <= `A_PC;
                b_sel  <= `B_IMM;
            end

            `JALR: begin
                imm    <= {{20{inst[31]}}, inst[31:20]};
                pc_sel <= `PC_JUMP;
                a_sel  <= `A_REG;
                b_sel  <= `B_IMM;
            end

            `BRANCH: begin
                imm    <= {
                            {20{inst[31]}},
                            inst[7],
                            inst[30:25],
                            inst[11:8],
                            1'b0
                        };
                pc_sel <= `PC_BRANCH;
                a_sel  <= `A_REG;
                b_sel  <= `B_REG;
            end

            `LOAD: begin
                imm    <= {{20{inst[31]}}, inst[31:20]};
                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_REG;
                b_sel  <= `B_IMM;
            end

            `STORE: begin
                imm    <= {
                            {20{inst[31]}},
                            inst[31:25],
                            inst[11:8],
                            inst[7]
                        };
                pc_sel <= `PC_PLUS_1;
                a_sel  <= `A_REG;
                b_sel  <= `B_IMM;
            end
            
            default: pc_sel <= `PC_PLUS_1; // could modify to call exception

        endcase
    end
end

endmodule

`endif
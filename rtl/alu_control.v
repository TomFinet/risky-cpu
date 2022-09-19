`ifndef ALU_CONTROL
`define ALU_CONTROL

`include "./rtl/codes.v"

module alu_control (
    input wire clock,
    input wire reset,

    input wire [31:0] inst,
    output reg [31:0] inst_out,

    output reg [3:0]  alu_op,

    output reg [1:0]  pc_sel,

    output reg [31:0] imm,
    output reg [4:0]  rd,
    output reg [6:0]  opcode
);

always @(posedge clock) begin
    if (reset) begin
        inst_out   <= `NOP;
        rd         <= `ZERO_REG;
        opcode     <= 0;
        pc_sel <= `PC_PLUS_1;
    end
    else begin
        inst_out <= inst;
        imm      <= {
                        {20{inst[31]}},
                        inst[7],
                        inst[30:25],
                        inst[11:8],
                        1'b0
                    };

        rd       <= inst[11:7];
        opcode   <= inst[6:0];

        case (inst[6:0])
            `OP_IMM:  begin
                alu_op <= {inst[30], inst[14:12]};
                pc_sel <= `PC_PLUS_1;
            end

            `OP: begin
                alu_op <= {inst[30], inst[14:12]};
                pc_sel <= `PC_PLUS_1;
            end

            `BRANCH: begin
                pc_sel <= `PC_BRANCH;
                
                if (
                    inst[14:12] == 3'b001 || 
                    inst[14:12] == 3'b010
                ) begin
                    alu_op <= {1'b0, inst[14:12]};
                end
                else begin
                    alu_op <= {1'b1, inst[14:12]};
                end
            end
            
            `JAL: begin
                alu_op     <= `ADD;
                pc_sel     <= `PC_JUMP; 
            end

            `JALR: begin
                alu_op     <= `ADD;
                pc_sel     <= `PC_JUMP; 
            end

            default: begin
                alu_op <= `ADD;
                pc_sel <= `PC_PLUS_1;
            end

        endcase
    end
end

endmodule

`endif
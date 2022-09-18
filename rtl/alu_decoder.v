`ifndef ALU_DECODER
`define ALU_DECODER

`include "./rtl/codes.v"

module alu_decoder (
    input wire clock,

    input wire [31:0] inst,

    output reg [31:0] imm,
    output reg [3:0]  alu_op
);

always @(posedge clock) begin

    imm    <= {
                {20{inst[31]}},
                inst[7],
                inst[30:25],
                inst[11:8],
                1'b0
            };

    case (inst[6:0])
        `OP_IMM:  begin
            alu_op <= {inst[30], inst[14:12]};
        end
        `OP: begin
            alu_op <= {inst[30], inst[14:12]};
        end

        `BRANCH: begin
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
        
        default: alu_op <= `ADD;

    endcase

end

endmodule

`endif
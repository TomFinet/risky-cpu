`ifndef ALU_DECODER
`define ALU_DECODER

`include "./rtl/codes.v"

module alu_decoder (
    input clock,

    input [31:0] inst,

    output reg [31:0] imm,

    output reg [3:0] alu_op
);

always @(posedge clock) begin

    case (inst[6:0])
        `OP_IMM:  alu_op <= {inst[30], inst[14:12]};
        `OP:      alu_op <= {inst[30], inst[14:12]}; 

        `BRANCH: begin
            if (
                    inst[14:12] === 3'b001 || 
                    inst[14:12] === 3'b010
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
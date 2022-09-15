`include "../codes.v"

module rr_decoder (
    input clock,

    input [31:0] inst,

    output reg [31:0] imm,

    output reg [3:0] alu_op,
);

always @(posedge clock) begin

    case (inst[6:0])
        OP_IMM:  alu_op <= {inst[30], inst[14:12]};
        OP:      alu_op <= {inst[30], inst[14:12]}; 

        BRANCH: 
            if (
                    inst[14:12] === BLT[3:1] || 
                    inst[14:12] === BLTU[3:1]
                ) begin
                    func <= {1'b0, inst[14:12]};
                end
                else begin
                    func <= {1'b1, inst[14:12]}
                end

        default: alu_op <= ADD;
    endcase

end

endmodule
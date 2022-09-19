`ifndef ALU
`define ALU

`include "./rtl/codes.v"

module alu (
    input wire [3:0] alu_op,
    input wire [31:0] a, b,

	output wire [31:0] res,
    output wire cond
);

    assign res =
                (alu_op == `ADD) ? a + b   :
                (alu_op == `AND) ? a & b   :
                (alu_op == `OR ) ? a | b   :
                (alu_op == `XOR) ? a ^ b   :
                (alu_op == `SLL) ? a << b  :
                (alu_op == `SRL) ? a >> b  :
                (alu_op == `SUB) ? a - b   :
                (alu_op == `SRA) ? a >>> b : 0;
    
    assign cond =
                (alu_op == `LT  ) ? $signed(a) < $signed(b)  :
                (alu_op == `LTU ) ? a < b                    :
                (alu_op == `EQ  ) ? a == b                   :
                (alu_op == `NE  ) ? a != b                   :
                (alu_op == `GE  ) ? $signed(a) >= $signed(b) :
                (alu_op == `GEU ) ? a >= b                   : 0;

endmodule

`endif
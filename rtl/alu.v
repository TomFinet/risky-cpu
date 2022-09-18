`ifndef ALU
`define ALU

`include "./rtl/codes.v"

module alu (
    input wire clock,
   
    input wire [3:0] alu_op,

    input wire [31:0] a, b,

	output reg [31:0] res,
    output reg cond
);

    always @(posedge clock) begin
        case (alu_op)
            `ADD     : res <= a + b;
            `LT      : cond <= $signed(a) < $signed(b);
            `LTU     : cond <= a < b;
            `AND     : res <= a & b;
            `OR      : res <= a | b;
            `XOR     : res <= a ^ b;
            `SLL     : res <= a << b;
            `SRL     : res <= a >> b;
            `SUB     : res <= a - b;
            `SRA     : res <= a >>> b;
            
            `EQ      : cond <= a == b;
            `NE      : cond <= a != b;
            `GE      : cond <= $signed(a) >= $signed(b);
            `GEU     : cond <= a >= b;

            default : begin
                res  <= 0;
                cond <= 0;
            end
        endcase

    end

endmodule

`endif
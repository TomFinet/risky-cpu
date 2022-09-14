`include "codes.v"

module alu (
    input clock,
    input enable,
   
    input [3:0] func,

    input [31:0] a, b,

	output [31:0] res
);

    always @(posedge clock && enable) begin
        
        case (func)
            ADD     : res <= a + b;
            LT      : res <= $signed(a) < $signed(b);
            LTU     : res <= a < b;
            AND     : res <= a & b;
            OR      : res <= a | b;
            XOR     : res <= a ^ b;
            SLL     : res <= a << b;
            SRL     : res <= a >> b;
            SUB     : res <= a - b;
            SRA     : res <= a >>> b;
            
            EQ      : res <= a === b;
            NE      : res <= a !== b;
            LE      : res <= $signed(a) >= $signed(b);
            LEU     : res <= a >= b;

            default : res <= 0;
        endcase

    end

endmodule
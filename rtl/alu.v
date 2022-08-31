/* Reg -- Reg instructions */
`define ADD  4'b0000
`define SLT  4'b0001
`define SLTU 4'b0010
`define AND  4'b0011
`define OR   4'b0100
`define XOR  4'b0101
`define SLL  4'b0110
`define SRL  4'b0111
`define SUB  4'b1000
`define SRA  4'b1001

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
            SLT     : res <= a < b;
            AND     : res <= a & b;
            OR      : res <= a | b;
            XOR     : res <= a ^ b;
            SLL     : res <= a << b;
            SRL     : res <= a >> b;
            SUB     : res <= a - b;
            SRA     : res <= a >>> b;
            default : res <= 0;
        endcase

    end

endmodule
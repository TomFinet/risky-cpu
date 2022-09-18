`ifndef PC
`define PC

`include "./rtl/codes.v"

module pc (
    input wire clock,
    input wire reset,

    input wire [1:0]  pc_sel,
    input wire [31:0] jal,
    input wire [31:0] jalr,
    input wire [31:0] branch,

    output reg [31:0] pc
);

always @(posedge clock) begin
    if(reset) begin
        pc <= 0;
    end
    else begin
        case (pc_sel)
        `PC_PLUS_4 : pc <= pc + 1;
        `PC_JAL    : pc <= jal;
        `PC_JALR   : pc <= jalr;
        `PC_BRANCH : pc <= branch;
        endcase
    end
end

endmodule

`endif
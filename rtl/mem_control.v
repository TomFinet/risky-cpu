`ifndef MEM_CONTROL
`define MEM_CONTROL

`include "./rtl/codes.v"

module mem_control (
    input wire clock,
    input wire reset,
    
    input wire [31:0] inst,
    output reg [31:0] inst_out,

    output reg       rw,
    output reg [1:0] store_sel,
    output reg [4:0] rd,
    output reg [6:0] opcode
);

always @(posedge clock) begin
    if (reset) begin
        inst_out <= `NOP;
        rw       <= `MEM_READ;
        rd       <= `ZERO_REG;
        opcode   <= 0;
    end
    else begin
        inst_out <= inst; 
        rd       <= inst[11:7];
        opcode   <= inst[6:0];
        
        case (inst[6:0])
            `STORE: begin
                rw <= `MEM_WRITE;

                case (inst[14:12])
                    `SH:      store_sel <= `STORE_H;
                    `SB:      store_sel <= `STORE_B;
                    default:  store_sel <= `STORE_W;
                endcase
            end
            
            default: rw <= `MEM_READ;
        endcase
    end
end

endmodule

`endif
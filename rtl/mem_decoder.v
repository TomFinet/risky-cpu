`ifndef MEM_DECODER
`define MEM_DECODER

`include "./rtl/codes.v"

module mem_decoder (
    input wire clock,
    
    input wire [31:0] inst,

    output reg       rw,
    output reg [1:0] store_sel
);

always @(posedge clock) begin
    case (inst[6:0])
        `STORE: begin
            rw = `MEM_WRITE;

            case (inst[14:12])
                `SH:      store_sel = `STORE_H;
                `SB:      store_sel = `STORE_B;
                default:  store_sel = `STORE_W;
            endcase
        end
        
        default: rw = `MEM_READ;
    endcase
end

endmodule

`endif
`ifndef MEM_DECODER
`define MEM_DECODER

`include "./rtl/codes.v"

module mem_decoder (
    input wire clock,
    
    input wire [31:0] inst,
    output reg [31:0] inst_out,

    output reg       rw,
    output reg [1:0] store_sel,
    output reg [4:0] rd
);

always @(posedge clock) begin
    inst_out <= inst; 
    rd       <= inst[11:7];
    
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

endmodule

`endif
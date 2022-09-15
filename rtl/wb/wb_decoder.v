`include "../codes.v"

module wb_decoder (
    input clock,

    input [31:0] inst,

    output reg [2:0] load_sel,
    output reg reg_we,
    output reg [1:0] reg_sel,
);

    always @(posedge clock) begin
        case (inst[6:0])
            OP_IMM: 
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_RES;
            
            OP:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_RES;
            
            LUI:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_RES;
            
            AUIPC:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_RES;
            
            JAL:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_PC_PLUS_4;
            
            JALR:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_PC_PLUS_4;
            
            LOAD:
                reg_we   <= REG_WRITE;
                reg_sel  <= REG_MEM;
                
                case (inst[14:12])
                    LW:  load_sel <= LOAD_W;
                    LH:  load_sel <= LOAD_H;
                    LHU: load_sel <= LOAD_HU;
                    LB:  load_sel <= LOAD_B;
                    LBU: load_sel <= LOAD_BU;
                endcase

            default:
                reg_we   <= REG_NO_WRITE;
        endcase
    end

endmodule

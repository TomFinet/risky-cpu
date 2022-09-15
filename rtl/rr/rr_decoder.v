`include "../codes.v"

module rr_decoder (
    input clock,

    input [31:0] inst,

    output reg [4:0]  rs1,
    output reg [4:0]  rs2,
    output reg [31:0] imm,

    output reg [1:0]  pc_sel,
    output reg [1:0]  a_sel,
    output reg        b_sel,
);

always @(posedge clock) begin

    case (inst[6:0])
        OP_IMM:
            rs1 <= inst[11:7];

            if (inst[14:12] === SRA[3:1]) begin
                imm <= {{27{1'b0}}, inst[24:20]}
            end
            else begin
                imm <= {{20{inst[31]}}, inst[31:20]};
            end

            pc_sel <= PC_PLUS_4;
            a_sel  <= A_REG;
            b_sel  <= B_IMM;
        
        OP:
            rs1    <= inst[19:15];
            rs2    <= inst[24:20];
            
            pc_sel <= PC_PLUS_4;
            a_sel  <= A_REG;
            b_sel  <= B_REG;
        
        LUI:
            imm    <= {inst[31:12], {12{0}}};

            pc_sel <= PC_PLUS_4;
            a_sel  <= A_0;
            b_sel  <= B_IMM;

        AUIPC:
            imm    <= {inst[31:12], {12{0}}};

            pc_sel <= PC_PLUS_4;
            a_sel  <= A_PC;
            b_sel  <= B_IMM;
        
        JAL:
            imm    <= {    
                        {12{inst[31]}},
                        inst[19:12],
                        inst[20],
                        inst[30:21],
                        1'b0
                    };
            
            pc_sel <= PC_JAL;
            a_sel  <= A_PC;
            b_sel  <= B_IMM;

        JALR:
            rs1    <= inst[19:15];
            imm    <= {{20{inst[31]}}, inst[31:20]};

            pc_sel <= PC_JALR;
            a_sel  <= A_REG;
            b_sel  <= B_IMM;

        BRANCH:
            rs1    <= inst[19:15];
            rs2    <= inst[24:20];
            imm    <= {
                        {20{inst[31]}},
                        inst[7],
                        inst[30:25],
                        inst[11:8],
                        1'b0
                    };
            
            pc_sel <= PC_BRANCH;
            a_sel  <= A_REG;
            b_sel  <= B_REG;

        LOAD:
            rs1    <= inst[19:15];
            imm    <= {{20{inst[31]}}, inst[31:20]};

            pc_sel <= PC_PLUS_4;
            a_sel  <= A_REG;
            b_sel  <= B_IMM;

        STORE:
            rs1    <= inst[19:15];
            rs2    <= inst[24:20];
            imm    <= {
                            {20{inst[31]}},
                            inst[31:25],
                            inst[11:8],
                            inst[7]
                        };

            pc_sel <= PC_PLUS_4;
            a_sel  <= A_REG;
            b_sel  <= B_IMM;

        default: 
    endcase

end

endmodule
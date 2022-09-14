`include "codes.v"

module decoder (
	input clock,
	input enable,

	input [31:0] inst,

    output reg [3:0] func,
	output reg [11:0] imm,
	output reg [4:0] rd, rs, rs2

    output reg [3:0] store_func,
    output reg [3:0] load_func,

    /* control signals */
    output reg reg_we,
    output reg reg_sel,
    output reg lui_sel,
    output reg pc_sel,
    output reg b_sel
);

	always @(posedge clock && enable) begin
		
        case (inst[6:0])

            OP_IMM:
                rd      <= inst[11:7];
                rs      <= inst[19:15]; 
                func    <= {inst[30], inst[14:12]};

                if (inst[14:12] === SRA[3:1]) begin
                    imm <= {{27{1'b0}}, inst[24:20]}
                end
                else begin
                    imm <= {{20{inst[31]}}, inst[31:20]};
                end
                
                // control signals
                reg_we  <= REG_WRITE;
                reg_sel <= REG_RES;
                b_sel   <= B_IMM;
                lui_sel <= LUI_0;
                pc_sel  <= PC_PLUS_4;
                mem_enable <= MEM_NOT_ENABLE;

            OP:
                rd      <= inst[11:7];
                func    <= {inst[30], inst[14:12]};
                rs      <= inst[19:15];
                rs2     <= inst[24:20];
                imm     <= {{20{inst[31]}}, inst[31:20]};
                
                reg_we  <= REG_WRITE;
                reg_sel <= REG_RES;
                b_sel   <= B_REG;
                lui_sel <= LUI_0;
                pc_sel  <= PC_PLUS_4;
                mem_enable <= MEM_NOT_ENABLE;

            LUI:
                rd      <= inst[11:7];
                imm     <= {inst[31:12], {12{0}}};
                
                reg_we  <= REG_WRITE;
                reg_sel <= REG_IMM;
                lui_sel <= LUI_0;
                pc_sel  <= PC_PLUS_4;
                mem_enable <= MEM_NOT_ENABLE;
             
            AUIPC:
                rd      <= inst[11:7];
                imm     <= {inst[31:12], {12{0}}};
                
                reg_we  <= REG_WRITE;
                reg_sel <= REG_IMM;
                lui_sel <= LUI_PC;
                pc_sel  <= PC_PLUS_4;
                mem_enable <= MEM_NOT_ENABLE;

            JAL:
                rd      <= inst[11:7];
                imm     <= {
                                {12{inst[31]}},
                                inst[19:12],
                                inst[20],
                                inst[30:21],
                                1'b0
                            };
                
                reg_we  <= REG_WRITE;
                reg_sel <= REG_PC_PLUS_4;
                lui_sel <= LUI_PC;
                pc_sel  <= PC_PLUS_IMM;
                mem_enable <= MEM_NOT_ENABLE;

            JALR:
                rd      <= inst[11:7];
                rs      <= ins[19:15];
                imm     <= {{20{inst[31]}}, inst[31:20]};

                func    <= ADD;
                
                b_sel   <= B_IMM;
                reg_we  <= REG_WRITE;
                reg_sel <= REG_PC_PLUS_4;
                pc_sel  <= PC_REG_PLUS_IMM;
                lui_sel <= LUI_0;
                mem_enable <= MEM_NOT_ENABLE;

            BRANCH:
                rs       <= inst[19:15];
                rs2      <= inst[24:20];
                
                if (
                    inst[14:12] === BLT[3:1] || 
                    inst[14:12] === BLTU[3:1]
                ) begin
                    func <= {1'b0, inst[14:12]};
                end
                else begin
                    func <= {1'b1, inst[14:12]}
                end
                imm      <= { // offset
                                {20{inst[31]}},
                                inst[7],
                                inst[30:25],
                                inst[11:8],
                                1'b0
                            }
                
                reg_we   <= REG_NO_WRITE;
                b_sel    <= B_REG;
                lui_sel  <= LUI_PC;
                pc_sel   <= PC_BRANCH;
                mem_enable <= MEM_NOT_ENABLE;

            LOAD:
                rd      <= inst[11:7];
                load_func <= inst[14:12];
                func    <= ADD;
                rs      <= inst[19:15];
                imm     <= {{20{inst[31]}}, inst[31:20]};
                
                reg_we  <= REG_WRITE;
                reg_sel <= REG_RAM;
                b_sel   <= B_IMM;
                lui_sel <= LUI_0;
                pc_sel  <= PC_PLUS_4;
                mem_rw  <= MEM_READ;
                mem_enable <= MEM_ENABLE;
                
            STORE:
                func   <= ADD;
                store_func <= inst[14:12];
                rs     <= inst[19:15];
                rs2    <= inst[24:20];
                imm    <= {
                            {20{inst[31]}},
                            inst[31:25],
                            inst[11:8],
                            inst[7]
                         };

                b_sel   <= B_IMM;
                lui_sel <= LUI_0;
                reg_we  <= REG_NO_WRITE;
                pc_sel  <= PC_PLUS_4;
                mem_rw  <= MEM_WRITE;
                mem_enable <= MEM_ENABLE;
        endcase
	end

endmodule
`ifndef CPU
`define CPU

`include "./rtl/codes.v"
`include "./rtl/pc.v"
`include "./rtl/register_bank.v"

`include "./rtl/rr_decoder.v"
`include "./rtl/alu_decoder.v"
`include "./rtl/mem_decoder.v"
`include "./rtl/wb_decoder.v"

`include "./rtl/alu.v"


module cpu (
	input wire reset,
    input wire clock,

    input wire [31:0] inst_din,
    input wire [31:0] mem_din,

    output wire [31:0] inst_aout,

    output wire mem_rw,
    output wire [31:0] mem_aout,
    output wire [31:0] mem_dout
);

    /* PC pipeline registers */
    reg [31:0] pc_pipe[3:0];

    /* IR pipeline */
    reg [31:0] ir_pipe[2:0];

    /* Data pipeline registers */
    reg [31:0] d_pipe[1:0];
    reg [31:0] r_pipe[1:0];

    /* Control signals */
    wire [1:0] pc_sel;

    wire [1:0] a_sel;
    wire b_sel;

    wire [1:0] store_sel;
    wire [2:0] load_sel;
    wire [1:0] reg_sel;
    wire reg_we;

    wire ir_sel;
    wire branch_sel;
    wire stall;
    wire data_stall;
    wire control_stall;
    
    /* Other signals */
    wire [31:0] branch_res;
    wire [31:0] branch;

    /* program counter */    
    wire [31:0] pc;
    wire        pc_on;
    wire [31:0] alu_res;

    pc pc_module (
        .clock  ( pc_on ),
        .reset  ( reset ),

        .pc_sel ( pc_sel ),
        .jal    ( alu_res ),
        .jalr   ( alu_res ),
        .branch ( branch_res ),

        .pc     ( pc )
    );
     
    /* RR decoder */
    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [31:0] rr_imm;
    wire [4:0]  rr_rd;
    wire [31:0] rr_inst;
    wire rr_control_stall;

    rr_decoder rr_decoder_module (
        .clock    ( clock ),
        
        .inst     ( rr_inst ),
        .inst_out ( ir_pipe[0] ),

        .rs1      ( rs1 ),
        .rs2      ( rs2 ),
        .imm      ( rr_imm ),

        .pc_sel   ( pc_sel ),
        .a_sel    ( a_sel ),
        .b_sel    ( b_sel ),
        .rd       ( rr_rd ),
        .stall    ( rr_control_stall )
    );

    /* ALU decoder */
    wire [31:0] alu_imm;
    wire [3:0]  alu_op;
    wire [4:0]  alu_rd;
    wire alu_control_stall;

    alu_decoder alu_decoder_module (
        .clock    ( clock ),

        .inst     ( ir_pipe[0] ),
        .inst_out ( ir_pipe[1] ),

        .alu_op   ( alu_op ),
        
        .imm      ( alu_imm ),
        .rd       ( alu_rd ),
        .stall    ( alu_control_stall )
    );

    /* MEM decoder */
    wire [4:0] mem_rd;
    mem_decoder mem_decoder_module (
        .clock     ( clock ),

        .inst      ( ir_pipe[1] ),
        .inst_out  ( ir_pipe[2] ),

        .rw        ( mem_rw ),
        .store_sel ( store_sel ),
        .rd        ( mem_rd )
    );

    /* WB decoder */
    wire [4:0] wb_rd;

    wb_decoder wb_decoder_module (
        .clock    ( clock ),

        .inst     ( ir_pipe[2] ),

        .rd       ( wb_rd ),
        .load_sel ( load_sel ),
        .reg_we   ( reg_we ),
        .reg_sel  ( reg_sel )
    );

    /* Instantiate register bank */
    wire [31:0] reg_din;

    wire [31:0] rs1_val;
    wire [31:0] rs2_val;

    register_bank register_bank_module (
        .clock   ( clock ),

        .we      ( reg_we ),
        .ain     ( wb_rd ),
        .din     ( reg_din ),
        
        .rs1     ( rs1 ),
        .rs2     ( rs2 ),

        .rs1_val ( rs1_val ),
        .rs2_val ( rs2_val )
    );

    /* Instantiate ALU */
    wire [31:0] a;
    wire [31:0] b;

    alu alu_module (
        .clock  ( clock ),

        .alu_op ( alu_op ),
        .a      ( a ),
        .b      ( b ),

        .res    ( alu_res ),
        .cond   ( branch_sel )
    );

    assign branch = alu_imm + pc_pipe[1];

    /* a select mux */
    assign a = (a_sel == `A_PC)  ? pc_pipe[0] :
               (a_sel == `A_REG) ? rs1_val : 0;

    /* b select mux */
    assign b = (b_sel == `B_IMM) ? rr_imm : rs2_val;

    /* register select mux */
    assign reg_din = (reg_sel == `REG_PC_PLUS_4) ? pc_pipe[3] + 1 :
                     (reg_sel == `REG_RES)       ? r_pipe[1] : mem_din;

    /* branch select mux */
    assign branch_res = (branch_sel == `YES_BRANCH) ? branch : pc + 1;

    assign inst_aout = pc;

    assign control_stall = rr_control_stall || alu_control_stall;

    assign data_stall =
                (
                    inst_din[6:0] == `LUI ||
                    inst_din[6:0] == `AUIPC ||
                    inst_din[6:0] == `JAL
                ) ? 0 :
                (
                    inst_din[19:15] != `ZERO_REG && (
                    inst_din[19:15] == rr_rd ||
                    inst_din[19:15] == alu_rd ||
                    inst_din[19:15] == mem_rd)
                ) || (
                    inst_din[24:20] != `ZERO_REG && (
                    inst_din[24:20] == rr_rd ||
                    inst_din[24:20] == alu_rd ||
                    inst_din[24:20] == mem_rd)
                ) ? 1 : 0;

    assign stall = data_stall || control_stall;

    assign pc_on = stall ? 0 : clock;

    assign rr_inst = stall ? `NOP : inst_din;

    assign mem_aout = alu_res;
    assign mem_dout = d_pipe[1];

    always @(posedge clock) begin
        /* Pipeline */
        pc_pipe[0] <= pc;
        pc_pipe[1] <= pc_pipe[0];
        pc_pipe[2] <= pc_pipe[1];
        pc_pipe[3] <= pc_pipe[2];

        d_pipe[0]  <= rs2_val;
        d_pipe[1]  <= d_pipe[0];

        r_pipe[0]  <= alu_res;
        r_pipe[1]  <= r_pipe[0];
    end

endmodule

`endif
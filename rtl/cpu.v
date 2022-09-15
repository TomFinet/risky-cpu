`include "./rtl/codes.v"
`include "./rtl/if/pc.v"
`include "./rtl/register_bank.v"

`include "./rtl/rr/rr_decoder.v"
`include "./rtl/alu/alu_decoder.v"
`include "./rtl/mem/mem_decoder.v"
`include "./rtl/wb/wb_decoder.v"

`include "./rtl/alu/alu.v"


module cpu (
	input reset,
    input halt,
    input clock,

    output reg [31:0] inst_aout,
    input [31:0] inst_din,

    output reg mem_rw,
    output reg [31:0] mem_aout,
    output reg [31:0] mem_dout,
    input [31:0] mem_din,
);

    /* PC pipeline registers */
    reg [31:0] pc_pipe[3:0];

    /* IR pipeline registers */
    reg [31:0] ir_pipe[3:0];

    /* Data pipeline registers */
    reg [31:0] d_pipe[1:0];
    reg [31:0] a_pipe;
    reg [31:0] b_pipe;
    reg [31:0] r_pipe[1:0];

    /* Control signals */
    reg [1:0] pc_sel;
    reg pc_load;

    reg [1:0] a_sel;
    reg b_sel;

    reg [1:0] store_sel;
    reg [2:0] load_sel;
    reg [1:0] reg_sel;
    reg reg_we;

    reg [1:0] ir_sel;
    reg branch_sel;
    reg stall;
    
    /* Other signals */
    wire [31:0] branch_res;
    wire [31:0] branch;
    reg [31:0] jal;
    reg [31:0] jalr;

    /* program counter */    
    reg pc;

    pc pc (
        .clock  ( clock ),
        .reset  ( reset ),
        .load   ( pc_load ),

        .pc_sel ( pc_sel ),
        .jal    ( jal ),
        .jalr   ( jalr ),
        .branch ( branch_res ),

        .pc     ( pc )
    );
     
    /* RR decoder */
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [31:0] rr_imm;

    rr_decoder rr_decoder (
        .clock  ( clock ),
        
        .inst   ( ir_pipe[0] ),

        .rs1    ( rs1 ),
        .rs2    ( rs2 ),
        .imm    ( imm ),

        .pc_sel ( pc_sel ),
        .a_sel  ( a_sel ),
        .b_sel  ( b_sel ),
    );

    /* ALU decoder */
    reg [31:0] alu_imm;
    reg [31:0] alu_op;

    alu_decoder alu_decoder (
        .clock  ( clock ),

        .inst   ( ir_pipe[1] ),

        .imm    ( alu_imm ),

        .alu_op ( alu_op ),
    );

    /* MEM decoder */
    mem_decoder mem_decoder (
        .clock     ( clock ),

        .inst      ( ir_pipe[2] ),

        .rw        ( mem_rw ),
        .store_sel ( store_sel ),
    );

    /* WB decoder */
    wb_decoder wb_decoder (
        .clock    ( clock ),

        .inst     ( ir_pipe[3] ),

        .load_sel ( load_sel ),
        .reg_we   ( reg_we ),
        .reg_sel  ( reg_sel ),
    );

    /* Instantiate register bank */
    reg [4:0]  reg_ain;
    reg [31:0] reg_din;

    reg [31:0] rs1_val;
    reg [31:0] rs2_val;

    register_bank register_bank (
        .clock   ( clock ),

        .we      ( reg_we ),
        .ain     ( reg_ain ),
        .din     ( reg_din ),
        
        .rs1     ( rs1 ),
        .rs2     ( rs2 ),

        .rs1_val ( rs1_val ),
        .rs2_val ( rs2_val ),
    );

    /* Instantiate ALU */
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] alu_res;

    alu alu (
        .clock  ( clock ),
        .enable ( alu_op ),

        .alu_op ( alu_op ),
        .a      ( a_pipe ),
        .b      ( b_pipe ),

        .res    ( alu_res )
    );

    assign branch = alu_imm + pc_pipe[1];

    /* a select mux */
    always @(a_sel, pc_pipe[0], rs1_val) begin
        case (a_sel)
            A_PC:   a = pc_pipe[0];
            A_REG:  a = rs1_val;
            default a = 0;
        endcase
    end

    /* b select mux */
    always @(b_sel, rr_imm, rs2_val) begin
        case (b_sel)
            B_IMM: b = rr_imm;
            B_REG: b = rs2_val;
        endcase
    end

    /* b select mux */
    always @(reg_sel, pc_pipe[3], mem_din, r_pipe[1]) begin
        case (reg_sel)
            REG_PC_PLUS_4: reg_din = pc_pipe[3] + 4;
            REG_RES:       reg_din = r_pipe[1];
            REG_MEM:       reg_din = mem_din;
        endcase
    end

    /* branch select mux */
    always @(branch_sel, branch, pc) begin
        case (branch_sel)
            BRANCH:    branch_res = branch;
            NO_BRANCH: branch_res = pc + 4;
        endcase
    end

    always @(posedge clock) begin
        pc_pipe[0] <= pc;
        pc_pipe[1] <= pc_pipe[0];
        pc_pipe[2] <= pc_pipe[1];
        pc_pipe[3] <= pc_pipe[2];

        ir_pipe[0] <= inst_din;
        ir_pipe[1] <= ir_pipe[0];
        ir_pipe[2] <= ir_pipe[1];
        ir_pipe[3] <= ir_pipe[2];

        d_pipe[0]  <= rs2_val;
        d_pipe[1]  <= d_pipe[0];

        a_pipe     <= a;
        b_pipe     <= b;

        r_pipe[0]  <= alu_res;
        r_pipe[1]  <= r_pipe[0];  
    end


endmodule
`ifndef CPU
`define CPU

`include "./rtl/codes.v"
`include "./rtl/register_bank.v"
`include "./rtl/rr_control.v"
`include "./rtl/alu_control.v"
`include "./rtl/mem_control.v"
`include "./rtl/wb_control.v"
`include "./rtl/alu.v"
`include "./rtl/stall_unit.v"


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
    reg [31:0] pc;
    reg [31:0] pc_pipe[3:0];

    /* IR pipeline */
    wire [31:0] ir_pipe[2:0];

    /* Data pipeline registers */
    reg [31:0] a_pipe;
    reg [31:0] b_pipe;

    reg [31:0] d_pipe[1:0];
    reg [31:0] r_pipe[1:0];

    /* Control signals */
    wire [1:0] pc_sel;
    wire [1:0] rr_pc_sel;
    wire [1:0] alu_pc_sel;

    wire [1:0] a_sel;
    wire b_sel;

    wire [1:0] store_sel;
    wire [2:0] load_sel;
    wire [1:0] reg_sel;
    wire reg_we;

    wire branch_sel;
    wire stall;
    wire data_stall;
    wire control_stall;
    
    /* Other signals */
    wire [31:0] branch_res;
    wire [31:0] branch;

    wire [31:0] a;
    wire [31:0] b;

    wire        pc_on;
    wire [31:0] alu_res;

    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [31:0] rr_imm;
    wire [31:0] rr_inst;
    wire [4:0]  rr_rd;
    wire [6:0]  rr_opcode;

    wire [31:0] alu_imm;
    wire [3:0]  alu_op;
    wire [4:0]  alu_rd;
    wire [6:0]  alu_opcode;

    wire [4:0] mem_rd;
    wire [6:0] mem_opcode;

    wire [4:0] wb_rd;

    wire [31:0] reg_din;

    wire [31:0] rs1_val;
    wire [31:0] rs2_val;


    /* RR control */
    rr_control rr_control_m (
        .clock    ( clock ),
        .reset    ( reset ),
        
        .inst     ( rr_inst ),
        .inst_out ( ir_pipe[0] ),

        .rs1      ( rs1 ),
        .rs2      ( rs2 ),
        .imm      ( rr_imm ),

        .pc_sel   ( rr_pc_sel ),
        .a_sel    ( a_sel ),
        .b_sel    ( b_sel ),
        .rd       ( rr_rd ),
        .opcode   ( rr_opcode )
    );

    /* ALU control */
    alu_control alu_control_m (
        .clock    ( clock ),
        .reset    ( reset ),

        .inst     ( ir_pipe[0] ),
        .inst_out ( ir_pipe[1] ),

        .alu_op   ( alu_op ),

        .pc_sel   ( alu_pc_sel ),
        .imm      ( alu_imm ),
        .rd       ( alu_rd ),
        .opcode   ( alu_opcode )
    );

    /* MEM decoder */
    mem_control mem_control_m (
        .clock     ( clock ),
        .reset     ( reset ),

        .inst      ( ir_pipe[1] ),
        .inst_out  ( ir_pipe[2] ),

        .rw        ( mem_rw ),
        .store_sel ( store_sel ),
        .rd        ( mem_rd ),
        .opcode    ( mem_opcode )
    );

    /* WB decoder */
    wb_control wb_control_m (
        .clock    ( clock ),
        .reset    ( reset ),

        .inst     ( ir_pipe[2] ),
        
        .rd       ( wb_rd ),
        .load_sel ( load_sel ),
        .reg_we   ( reg_we ),
        .reg_sel  ( reg_sel )
    );

    /* Instantiate register bank */
    register_bank register_bank_m (
        .clock   ( clock ),
        .reset   ( reset ),

        .we      ( reg_we ),
        .ain     ( wb_rd ),
        .din     ( reg_din ),
        
        .rs1     ( rs1 ),
        .rs2     ( rs2 ),

        .rs1_val ( rs1_val ),
        .rs2_val ( rs2_val )
    );

    /* Instantiate ALU */
    alu alu_m (
        .alu_op ( alu_op ),
        .a      ( a_pipe ),
        .b      ( b_pipe ),

        .res    ( alu_res ),
        .cond   ( branch_sel )
    );

    /* Pipeline hazard logic */
    stall_unit stall_unit_m (
        .if_rs1        ( inst_din[19:15] ),
        .if_rs2        ( inst_din[24:20] ),
        .if_opcode     ( inst_din[6:0] ),

        .rr_opcode     ( rr_opcode ),
        .alu_opcode    ( alu_opcode ),
        .mem_opcode    ( mem_opcode ),

        .rr_rd         ( rr_rd ),
        .alu_rd        ( alu_rd ),
        .mem_rd        ( mem_rd ),

        .data_stall    ( data_stall ),
        .control_stall ( control_stall )
    );

    assign stall = data_stall || control_stall;

    assign pc_on = stall ? 0 : clock;

    /* a select mux */
    assign a = (a_sel == `A_PC)  ? pc_pipe[0] :
               (a_sel == `A_REG) ? rs1_val : 0;

    /* b select mux */
    assign b = (b_sel == `B_IMM) ? rr_imm : rs2_val;

    /* register select mux */
    assign reg_din = (reg_sel == `REG_PC_PLUS_4) ? pc_pipe[3] + 1 :
                     (reg_sel == `REG_RES)       ? r_pipe[1] : mem_din;

    /* branch select mux */
    assign branch = alu_imm + pc_pipe[1];
    assign branch_res = (branch_sel == `YES_BRANCH) ? branch : pc + 1;

    assign rr_inst = stall ? `NOP : inst_din;

    assign inst_aout = pc;
    assign mem_aout = r_pipe[0];
    assign mem_dout = d_pipe[1];

    assign pc_sel = (
                        alu_pc_sel == `PC_JUMP ||
                        alu_pc_sel == `PC_BRANCH
                    ) ? alu_pc_sel : rr_pc_sel;

    always @(posedge clock) begin
        if (reset) begin
            pc <= 0;
        end
        else begin
            if (!stall) begin
                case (pc_sel)
                    `PC_PLUS_1     : pc <= pc + 1;
                    `PC_BRANCH     : pc <= branch;
                    `PC_JUMP       : pc <= alu_res;
                    default        : pc <= pc + 1;
                endcase
            end

            /* Pipeline */
            pc_pipe[0] <= pc;
            pc_pipe[1] <= pc_pipe[0];
            pc_pipe[2] <= pc_pipe[1];
            pc_pipe[3] <= pc_pipe[2];

            a_pipe     <= a;
            b_pipe     <= b; 

            d_pipe[0]  <= rs2_val;
            d_pipe[1]  <= d_pipe[0];

            r_pipe[0]  <= alu_res;
            r_pipe[1]  <= r_pipe[0];
        end
    end

endmodule

`endif
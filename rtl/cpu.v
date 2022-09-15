`include "./rtl/lib/register.v"
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

    /* program counter */
    reg pc_load;
    reg [1:0] pc_sel;
    reg pc;

    pc pc (
        .clock  ( clock ),
        .reset  ( reset ),
        .load   ( pc_load ),

        .pc_sel ( pc_sel ),
        .jal    (  ),
        .jalr   (  ),
        .branch (  ),

        .pc     ( pc )
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
     
    /* RR decoder */
    rr_decoder rr_decoder (
        .clock  ( clock ),
        
        .inst   ( ir_pipe[0] ),

        .rs1    (  ),
        .rs2    (  ),
        .imm    (  ),

        .pc_sel ( pc_sel ),
        .a_sel  (  ),
        .b_sel  (  ),
    );

    /* ALU decoder */
    alu_decoder alu_decoder (
        .clock  ( clock ),

        .inst   ( ir_pipe[1] ),

        .imm    (  ),

        .alu_op (  ),
    );

    /* MEM decoder */
    mem_decoder mem_decoder (
        .clock     ( clock ),

        .inst      ( ir_pipe[2] ),

        .rw        (  ),
        .store_sel (  ),
    );

    /* WB decoder */
    wb_decoder wb_decoder (
        .clock    ( clock ),

        .inst     ( ir_pipe[3] ),

        .load_sel (  ),
        .reg_we   (  ),
        .reg_sel  (  ),
    );

    /* Instantiate register bank */
    reg reg_we;
    reg [4:0] reg_ain;
    reg [31:0] reg_din;

    reg [4:0] rs1;
    reg [4:0] rs2;

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
    reg [31:0] alu_res;

    alu alu (
        .clock  ( clock ),
        .enable ( alu_op ),

        .func   ( instr_func ),
        .a      ( rs_val ),
        .b      ( ra_val ),

        .res    ( alu_res )
    );


endmodule
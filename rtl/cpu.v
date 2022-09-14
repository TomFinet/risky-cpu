`include "./rtl/pc.v"
`include "./rtl/register_bank.v"
`include "./rtl/decoder.v"
`include "./rtl/alu.v"


module cpu (
	input reset,
    input halt,
    input clock,

    input reg [31:0] Din,

    output reg [31:0] A,
    output reg [31:0] Dout
);

    /* program counter */

    reg pc_reset;
    reg pc_enable;
    reg pc_out;

    pc pc (
        .clock  ( clock ),
        .reset  ( pc_reset ),
        .enable ( pc_enable ),

        .dout   ( pc_out )
    );

    /* address register */
    reg [31:0] addr_reg;

    /* instruction register */
    reg [31:0] instr_reg;

    /* instantiate decoder/control unit */
    reg decoder_enable;
    
    reg [2:0] instr_func;
    reg [11:0] instr_imm;
    reg [4:0] instr_rs;
    reg [4:0] instr_ra;
    reg [4:0] instr_rd;

    decoder decoder (
        .clock       ( clock ),
        .enable      ( decoder_enable ),

        .instruction ( instr_reg ),

        .func        ( instr_func ),
        .imm         ( instr_imm ),
        .rd          ( instr_rd ),
        .rs          ( instr_rs ),

        .reg_we      ( reg_we )
    );

    /* Instantiate register bank */
    reg reg_enable;

    reg reg_re;
    reg [31:0] reg_din;
    reg [4:0] reg_ain;

    reg [31:0] reg_dout;

    reg [31:0] rs_val;
    reg [31:0] ra_val;

    register_bank register_bank (
        .clock ( clock ),
        .enable ( reg_enable ),

        .we     ( reg_rw ),
        .din    ( reg_din ),
        .ain    ( reg_ain ),

        .rs     ( instr_rs ),
        .ra     ( instr_ra ),

        .dout   ( reg_dout ),

        .rs_val ( rs_val ),
        .ra_val ( ra_val )
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

    /* Reset */
    always @(posedge reset) begin
        pc_reset = 1;
        addr_reg = 0;
        instr_reg = 0;
    end

    /* Fetch */
    always @(posedge clock) begin
        addr_reg  = pc; // needs to be decided by a MUX when we add further instructions.
        A         = addr_reg;
        instr_reg = Din; // 
    end


endmodule
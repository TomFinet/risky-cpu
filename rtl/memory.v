`ifndef MEMORY
`define MEMORY

module memory (
    input clock,
    
    input [31:0] inst_ain, // for instruction reading
    output reg [31:0] inst_dout,

	input rw,
	input [31:0] ain,
	input [31:0] din,
	output reg [31:0] dout
);

// 1024 x 32-bit = memory
reg [31:0] mem[1023:0];

always @(posedge clock) begin
    inst_dout <= mem[inst_ain];

    if(rw) begin
        mem[ain] <= din;
    end
    else begin
        dout <= mem[ain];
    end
end

endmodule

`endif
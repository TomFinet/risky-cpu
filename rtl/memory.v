module memory (
    input clock,
	input reset,
    
    input [31:0] inst_ain, // for instruction reading
    output reg [31:0] inst_dout,

	input rw,
	input [31:0] ain,
	input [31:0] din,
	output reg [31:0] dout
);

// 1024 x 32-bit = memory
reg [31:0] mem[1023:0];

integer i;

always @(posedge clock) begin
    if(reset) begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] <= 0;
    end
    else begin
        inst_dout <= mem[inst_ain];

        if(rw) begin
            mem[ain] <= din;
        end
        else begin
            dout <= mem[ain];
        end
    end
end

endmodule
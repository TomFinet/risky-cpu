module memory(
	
    input clock,
	input enable,
	input reset,

	input rw,
	input [31:0] ain,
	input [31:0] din,

	output reg [31:0] dout
);

// 1024 x 32-bit = memory
reg [31:0] mem[1023:0];

integer i;

always @(posedge reset) begin
	if(reset) begin
    for (i = 0; i < 1024; i = i + 1)
        mem[i] = 0;
    end
end

always @(posedge clock) begin
    if(enable) begin
        if(rw) begin // write
            mem[ain] = din;
        end
        else begin // read
            dout = mem[ain];
        end
    end
end

endmodule
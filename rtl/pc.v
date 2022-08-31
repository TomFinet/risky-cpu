module pc (
    input clock,
    input reset,
    input enable,

    output reg [31:0] dout,
);

reg [31:0] pc;

always @(posedge reset) begin
    pc = 0;
end

always @(posedge clock && enable) begin
    dout = pc;
    pc = pc + 4;
end

endmodule
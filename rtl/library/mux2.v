module mux2 (
    input [31:0] a,
    input [31:0] b,
    input sel,

    output wire [31:0] out
);

assign out = sel ? a : b;

endmodule
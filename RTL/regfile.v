module regfile(
    input clk,
    input we,
    input [2:0] ra1, ra2, wa,
    input [15:0] wd,
    output [15:0] rd1, rd2
);
reg [15:0] R[0:7];

assign rd1 = R[ra1];
assign rd2 = R[ra2];

always @(posedge clk)
    if (we) R[wa] <= wd;

endmodule

`timescale 1ns/1ps

module tb_alu_pipe;

parameter N = 16;

reg clk = 0;
reg rst = 1;
reg [N-1:0] A, B;
reg [3:0] opcode;

wire [N-1:0] result;
wire Z, C, Nf, V;

// DUT
alu_pipe #(N) uut (
    .clk(clk),
    .rst(rst),
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .Z(Z),
    .C(C),
    .Nf(Nf),
    .V(V)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    // Reset
    #10 rst = 0;

    // ===== Basic Tests =====
    A=10; B=5; opcode=4'b0000; #10;   // ADD
    A=20; B=3; opcode=4'b0001; #10;   // SUB
    A=7;  B=2; opcode=4'b0010; #10;   // AND
    A=15; B=1; opcode=4'b0011; #10;   // OR
    A=9;  B=3; opcode=4'b0100; #10;   // XOR
    A=8;  B=0; opcode=4'b0101; #10;   // NOT

    // ===== Barrel Shifter Tests =====
    A = 16'hB38F; B = 3; opcode = 4'b0110; #10; // SHL by 3
    A = 16'hB38F; B = 2; opcode = 4'b0111; #10; // SHR by 2
    A = 16'hB38F; B = 2; opcode = 4'b1010; #10; // ASR by 2

    #50;
    $stop;
end

endmodule

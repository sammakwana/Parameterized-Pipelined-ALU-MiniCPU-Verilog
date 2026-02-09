module alu_pipe
#(parameter N = 16)
(
    input clk,
    input rst,
    input [N-1:0] A,
    input [N-1:0] B,
    input [3:0] opcode,
    output reg [N-1:0] result,
    output reg Z,
    output reg C,
    output reg Nf,
    output reg V
);

// ===== Opcodes =====
localparam ADD  = 4'b0000;
localparam SUB  = 4'b0001;
localparam ANDD = 4'b0010;
localparam ORR  = 4'b0011;
localparam XORR = 4'b0100;
localparam NOTT = 4'b0101;
localparam SHL  = 4'b0110;
localparam SHR  = 4'b0111;
localparam ASR  = 4'b1010;

// ===== Stage 1 : Input Registers =====
reg [N-1:0] A_r1, B_r1;
reg [3:0] opcode_r1;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        A_r1 <= 0;
        B_r1 <= 0;
        opcode_r1 <= 0;
    end else begin
        A_r1 <= A;
        B_r1 <= B;
        opcode_r1 <= opcode;
    end
end

// ===== Barrel Shifter =====
wire [N-1:0] shift_out;
reg [1:0] shift_sel;

barrel_shifter #(N) BS (
    .A(A_r1),
    .B(B_r1),
    .shift_op(shift_sel),
    .Y(shift_out)
);

// ===== Stage 2 : ALU Compute =====
reg [N-1:0] alu_mid;
reg carry_mid;
reg [N-1:0] A_r2, B_r2;
reg [3:0] opcode_r2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        alu_mid <= 0;
        carry_mid <= 0;
        A_r2 <= 0;
        B_r2 <= 0;
        opcode_r2 <= 0;
        shift_sel <= 2'b00;
    end else begin
        A_r2 <= A_r1;
        B_r2 <= B_r1;
        opcode_r2 <= opcode_r1;
        shift_sel <= 2'b00;

        case(opcode_r1)
            ADD: {carry_mid, alu_mid} <= A_r1 + B_r1;
            SUB: {carry_mid, alu_mid} <= A_r1 - B_r1;
            ANDD: alu_mid <= A_r1 & B_r1;
            ORR:  alu_mid <= A_r1 | B_r1;
            XORR: alu_mid <= A_r1 ^ B_r1;
            NOTT: alu_mid <= ~A_r1;

            SHL: begin shift_sel <= 2'b00; alu_mid <= shift_out; end
            SHR: begin shift_sel <= 2'b01; alu_mid <= shift_out; end
            ASR: begin shift_sel <= 2'b10; alu_mid <= shift_out; end

            default: alu_mid <= 0;
        endcase
    end
end

// ===== Stage 3 : Output Registers =====
always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
        Z <= 0;
        C <= 0;
        Nf <= 0;
        V <= 0;
    end else begin
        result <= alu_mid;
        Z <= (alu_mid == 0);
        C <= carry_mid;
        Nf <= alu_mid[N-1];

        V <= (opcode_r2 == ADD) ?
             ((A_r2[N-1] == B_r2[N-1]) && (alu_mid[N-1] != A_r2[N-1])) :
             (opcode_r2 == SUB) ?
             ((A_r2[N-1] != B_r2[N-1]) && (alu_mid[N-1] != A_r2[N-1])) :
             1'b0;
    end
end

endmodule

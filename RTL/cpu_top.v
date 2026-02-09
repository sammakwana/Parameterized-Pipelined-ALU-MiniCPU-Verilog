module cpu_top(
    input  wire clk,
    input  wire rst,

    // Debug outputs (to prevent optimization)
    output wire [15:0] debug_A,
    output wire [15:0] debug_B,
    output wire [15:0] debug_ALU,
    output wire [7:0]  debug_PC
);

parameter N = 16;

// ================= PROGRAM COUNTER =================
reg [7:0] PC;

always @(posedge clk or posedge rst) begin
    if (rst)
        PC <= 8'd0;
    else
        PC <= PC + 1'b1;
end

// ================= INSTRUCTION MEMORY =================
reg [15:0] IMEM [0:255];

initial begin
    IMEM[0] = 16'h0298;
    IMEM[1] = 16'h1850;
    IMEM[2] = 16'h2A60;
    IMEM[3] = 16'h3D60;
    IMEM[4] = 16'h4E50;
end

wire [15:0] instr;
assign instr = IMEM[PC];

// ================= DECODE =================
wire [3:0] opcode;
wire [2:0] rd, rs1, rs2;

assign opcode = instr[15:12];
assign rd     = instr[11:9];
assign rs1    = instr[8:6];
assign rs2    = instr[5:3];

// ================= REGISTER FILE =================
wire [N-1:0] A, B;
wire reg_write = 1'b1;
wire [15:0] alu_result;

regfile RF (
    .clk(clk),
    .we(reg_write),
    .ra1(rs1),
    .ra2(rs2),
    .wa(rd),
    .wd(alu_result),
    .rd1(A),
    .rd2(B)
);

// ================= BARREL SHIFTER =================
wire [15:0] shift_out;

barrel_shifter BS (
    .data_in(A),
    .shift_amt(B[3:0]),
    .dir(opcode[0]),
    .data_out(shift_out)
);

// ================= ALU =================
reg [15:0] alu_result_r;

always @(*) begin
    case (opcode)
        4'h0: alu_result_r = A + B;
        4'h1: alu_result_r = A - B;
        4'h2: alu_result_r = A & B;
        4'h3: alu_result_r = A | B;
        4'h4: alu_result_r = shift_out;
        default: alu_result_r = 16'h0000;
    endcase
end

assign alu_result = alu_result_r;

// ================= DEBUG OUTPUTS =================
assign debug_A   = A;
assign debug_B   = B;
assign debug_ALU = alu_result;
assign debug_PC  = PC;

endmodule

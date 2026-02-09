module alu_param
#(parameter N = 16)
(
    input  [N-1:0] A,
    input  [N-1:0] B,
    input  [3:0] opcode,
    output reg [N-1:0] result,
    output Z,
    output C,
    output Nf,
    output V
);

// Opcodes
localparam ADD  = 4'b0000;
localparam SUB  = 4'b0001;
localparam ANDD = 4'b0010;
localparam ORR  = 4'b0011;
localparam XORR = 4'b0100;
localparam NOTT = 4'b0101;
localparam SHL  = 4'b0110;
localparam SHR  = 4'b0111;
localparam MUL  = 4'b1000;
localparam CMP  = 4'b1001;
localparam ASR  = 4'b1010;   

// Barrel Shifter wires
wire [N-1:0] shift_out;
reg  [1:0] shift_sel;

// Barrel Shifter Instance
barrel_shifter #(N) bs (
    .A(A),
    .B(B),
    .shift_op(shift_sel),
    .Y(shift_out)
);

reg carry;

// ALU Logic
always @(*) begin
    carry = 0;
    shift_sel = 2'b00;

    case(opcode)

        ADD: {carry, result} = A + B;
        SUB: {carry, result} = A - B;
        ANDD: result = A & B;
        ORR:  result = A | B;
        XORR: result = A ^ B;
        NOTT: result = ~A;

        SHL: begin shift_sel = 2'b00; result = shift_out; end
        SHR: begin shift_sel = 2'b01; result = shift_out; end
        ASR: begin shift_sel = 2'b10; result = shift_out; end

        MUL: result = A * B;
        CMP: result = (A > B) ? 1 : 0;

        default: result = 0;
    endcase
end

// Flags
assign Z  = (result == 0);
assign C  = carry;
assign Nf = result[N-1];

assign V = (opcode == ADD) ?
           ((A[N-1] == B[N-1]) && (result[N-1] != A[N-1])) :
           (opcode == SUB) ?
           ((A[N-1] != B[N-1]) && (result[N-1] != A[N-1])) :
           1'b0;

endmodule
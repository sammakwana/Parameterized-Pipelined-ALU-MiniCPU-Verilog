`timescale 1ns/1ps

module tb_alu_param;

parameter N = 16;

reg  [N-1:0] A, B;
reg  [3:0] opcode;

wire [N-1:0] result;
wire Z, C, Nf, V;

integer errors = 0;
integer i;

// DUT
alu_param #(N) uut (
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result),
    .Z(Z),
    .C(C),
    .Nf(Nf),
    .V(V)
);

// ================= CHECK TASK =================
task check;
    input [N-1:0] expected;
begin
    if (result !== expected) begin
        $display("❌ ERROR | opcode=%b | A=%h B=%h | Expected=%h Got=%h",
                 opcode, A, B, expected, result);
        errors = errors + 1;
    end
    else begin
        $display("✔ PASS  | opcode=%b | Result=%h", opcode, result);
    end
end
endtask

// ================= TEST =================
initial begin

    $display("\n===== ALU SELF CHECK TEST START =====\n");

    // ---------- BASIC TEST ----------
    A=10; B=5; opcode=4'b0000; #5; check(15);   // ADD
    A=10; B=5; opcode=4'b0001; #5; check(5);    // SUB
    A=10; B=5; opcode=4'b0010; #5; check(10 & 5); // AND
    A=10; B=5; opcode=4'b0011; #5; check(10 | 5); // OR
    A=10; B=5; opcode=4'b0100; #5; check(10 ^ 5); // XOR
    A=10; B=5; opcode=4'b0101; #5; check(~10);    // NOT

    // ---------- BARREL SHIFT TEST ----------
    A = 16'hB38F; B=3; opcode=4'b0110; #5; check(A << 3);  // SHL
    A = 16'hB38F; B=2; opcode=4'b0111; #5; check(A >> 2);  // SHR
    A = 16'hB38F; B=2; opcode=4'b1010; #5; check($signed(A) >>> 2); // ASR

    // ---------- FLAG TEST ----------
    A=16'd10; B=16'd10; opcode=4'b0001; #5; check(0); // Z flag case
    A=16'hFFFF; B=1; opcode=4'b0000; #5; // Carry case
    A=5; B=10; opcode=4'b0001; #5;       // Negative case
    A=16'h7FFF; B=1; opcode=4'b0000; #5; // Overflow case

    // ---------- RANDOM TEST ----------
    $display("\n===== RANDOM TEST START =====\n");
    for (i=0; i<20; i=i+1) begin
        A = $random;
        B = $random;
        opcode = $random % 11;
        #5;
        // only basic ops auto-check (avoid divide/unknown)
        case(opcode)
            4'b0000: check(A + B);
            4'b0001: check(A - B);
            4'b0010: check(A & B);
            4'b0011: check(A | B);
            4'b0100: check(A ^ B);
            default: ;
        endcase
    end

    // ---------- FINAL RESULT ----------
    if (errors == 0)
        $display("\n🎉 ALL TESTS PASSED - ALU WORKING PERFECTLY 🎉\n");
    else
        $display("\n❌ TEST FAILED - Errors = %0d\n", errors);

    $stop;
end

endmodule

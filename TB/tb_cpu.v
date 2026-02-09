`timescale 1ns/1ps

module tb_cpu;

reg clk = 0;
reg rst = 1;

cpu_top DUT (
    .clk(clk),
    .rst(rst)
);

// CLOCK
always #5 clk = ~clk;

// RESET + RUN
initial begin
    #20 rst = 0;
    #2000 $finish;
end

endmodule

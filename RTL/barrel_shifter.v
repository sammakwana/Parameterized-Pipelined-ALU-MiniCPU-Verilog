module barrel_shifter(
    input  [15:0] data_in,
    input  [3:0]  shift_amt,
    input         dir,
    output [15:0] data_out
);

assign data_out = (dir == 1'b0) ? (data_in << shift_amt)
                                : (data_in >> shift_amt);

endmodule

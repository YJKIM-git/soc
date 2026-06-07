module add_xor (
    input   wire    [127:0]     in1,
    input   wire    [127:0]     in2,
    output  wire    [127:0]     xor_out
);
    
    assign xor_out = in1 ^ in2;
    
endmodule


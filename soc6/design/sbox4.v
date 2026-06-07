// 32-bit (4-byte) SubBytes block : the ONLY S-box resource in the core.
// Time-shared between the round SubBytes (4 lanes) and the key-expansion
// SubWord, so the whole AES core uses just 4 S-boxes instead of 20.
module sbox4 (
    input   wire    [31:0]  in,
    output  wire    [31:0]  out
);
    sbox s0 (.byte_in(in[31:24]), .sbox_out(out[31:24]));
    sbox s1 (.byte_in(in[23:16]), .sbox_out(out[23:16]));
    sbox s2 (.byte_in(in[15:8]),  .sbox_out(out[15:8]));
    sbox s3 (.byte_in(in[7:0]),   .sbox_out(out[7:0]));
endmodule

module mixcolumn(
    input   wire    [127:0]     state_in, 
    output  wire    [127:0]     state_out
);



assign state_out[127:120]   = mixcolumn2311 (state_in[127:120], state_in[119:112], state_in[111:104], state_in[103:96]);
assign state_out[119:112]   = mixcolumn2311 (state_in[119:112], state_in[111:104], state_in[103:96], state_in[127:120]);
assign state_out[111:104]   = mixcolumn2311 (state_in[111:104], state_in[103:96], state_in[127:120], state_in[119:112]);
assign state_out[103:96]    = mixcolumn2311 (state_in[103:96], state_in[127:120], state_in[119:112], state_in[111:104]);

assign state_out[95:88]     = mixcolumn2311 (state_in[95:88], state_in[87:80], state_in[79:72], state_in[71:64]);
assign state_out[87:80]     = mixcolumn2311 (state_in[87:80], state_in[79:72], state_in[71:64], state_in[95:88]);
assign state_out[79:72]     = mixcolumn2311 (state_in[79:72], state_in[71:64], state_in[95:88], state_in[87:80]);
assign state_out[71:64]     = mixcolumn2311 (state_in[71:64], state_in[95:88], state_in[87:80], state_in[79:72]);

assign state_out[63:56]     = mixcolumn2311 (state_in[63:56], state_in[55:48], state_in[47:40], state_in[39:32]);
assign state_out[55:48]     = mixcolumn2311 (state_in[55:48], state_in[47:40], state_in[39:32], state_in[63:56]);
assign state_out[47:40]     = mixcolumn2311 (state_in[47:40], state_in[39:32], state_in[63:56], state_in[55:48]);
assign state_out[39:32]     = mixcolumn2311 (state_in[39:32], state_in[63:56], state_in[55:48], state_in[47:40]);

assign state_out[31:24]     = mixcolumn2311 (state_in[31:24], state_in[23:16], state_in[15:8], state_in[7:0]);
assign state_out[23:16]     = mixcolumn2311 (state_in[23:16], state_in[15:8], state_in[7:0], state_in[31:24]);
assign state_out[15:8]      = mixcolumn2311 (state_in[15:8], state_in[7:0], state_in[31:24], state_in[23:16]);
assign state_out[7:0]       = mixcolumn2311 (state_in[7:0], state_in[31:24], state_in[23:16], state_in[15:8]);


function [7:0] mixcolumn2311;
input [7:0] i1, i2, i3, i4;
begin
    mixcolumn2311[7]=i1[6] ^ i2[6] ^ i2[7] ^ i3[7] ^ i4[7];
    mixcolumn2311[6]=i1[5] ^ i2[5] ^ i2[6] ^ i3[6] ^ i4[6];
    mixcolumn2311[5]=i1[4] ^ i2[4] ^ i2[5] ^ i3[5] ^ i4[5];
    mixcolumn2311[4]=i1[3] ^ i1[7] ^ i2[3] ^ i2[4] ^ i2[7] ^ i3[4] ^ i4[4];
    mixcolumn2311[3]=i1[2] ^ i1[7] ^ i2[2] ^ i2[3] ^ i2[7] ^ i3[3] ^ i4[3];
    mixcolumn2311[2]=i1[1] ^ i2[1] ^ i2[2] ^ i3[2] ^ i4[2];
    mixcolumn2311[1]=i1[0] ^ i1[7] ^ i2[0] ^ i2[1] ^ i2[7] ^ i3[1] ^ i4[1];
    mixcolumn2311[0]=i1[7] ^ i2[7] ^ i2[0] ^ i3[0] ^ i4[0];
end
endfunction

endmodule


module subbytes(
    input   wire    [127:0]     state_in,
    output  wire    [127:0]     state_out
);

     sbox u0( .byte_in(state_in[127:120]),.sbox_out(state_out[127:120]) );
     sbox u1( .byte_in(state_in[119:112]),.sbox_out(state_out[119:112]) );
     sbox u2( .byte_in(state_in[111:104]),.sbox_out(state_out[111:104]) );
     sbox u3( .byte_in(state_in[103:96]),.sbox_out(state_out[103:96]) );
     
     sbox u4( .byte_in(state_in[95:88]),.sbox_out(state_out[95:88]) );
     sbox u5( .byte_in(state_in[87:80]),.sbox_out(state_out[87:80]) );
     sbox u6( .byte_in(state_in[79:72]),.sbox_out(state_out[79:72]) );
     sbox u7( .byte_in(state_in[71:64]),.sbox_out(state_out[71:64]) );
     
     sbox u8( .byte_in(state_in[63:56]),.sbox_out(state_out[63:56]) );
     sbox u9( .byte_in(state_in[55:48]),.sbox_out(state_out[55:48]) );
     sbox u10(.byte_in(state_in[47:40]),.sbox_out(state_out[47:40]) );
     sbox u11(.byte_in(state_in[39:32]),.sbox_out(state_out[39:32]) );

     sbox u12(.byte_in(state_in[31:24]),.sbox_out(state_out[31:24]) );
     sbox u13(.byte_in(state_in[23:16]),.sbox_out(state_out[23:16]) );
     sbox u14(.byte_in(state_in[15:8]),.sbox_out(state_out[15:8]) );
     sbox u16(.byte_in(state_in[7:0]),.sbox_out(state_out[7:0]) );
	  
endmodule


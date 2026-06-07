// On-the-fly key expansion WITHOUT its own S-boxes.
// The SubWord (= SubBytes of RotWord(w3)) is computed by the shared sbox4
// block in the datapath and handed in via `subword`.
//
//   K_i = { w0^t , w0^t^w1 , w0^t^w1^w2 , w0^t^w1^w2^w3 }
//   where t = subword ^ Rcon(i)
module key_expand (
    input   wire    [127:0] key_in,     // K_{i-1}
    input   wire    [31:0]  subword,    // SubBytes(RotWord(w3)) from shared sbox4
    input   wire    [3:0]   rnd_idx,
    output  wire    [127:0] key_out      // K_i
);

wire [31:0] w0 = key_in[127:96];
wire [31:0] w1 = key_in[95:64];
wire [31:0] w2 = key_in[63:32];
wire [31:0] w3 = key_in[31:0];

wire [31:0] t   = subword ^ rcon_val(rnd_idx);
wire [31:0] nw0 = w0  ^ t;
wire [31:0] nw1 = nw0 ^ w1;
wire [31:0] nw2 = nw1 ^ w2;
wire [31:0] nw3 = nw2 ^ w3;

assign key_out = {nw0, nw1, nw2, nw3};

function [31:0] rcon_val;
input [3:0] idx;
case(idx)
 4'h1: rcon_val = 32'h01_00_00_00;
 4'h2: rcon_val = 32'h02_00_00_00;
 4'h3: rcon_val = 32'h04_00_00_00;
 4'h4: rcon_val = 32'h08_00_00_00;
 4'h5: rcon_val = 32'h10_00_00_00;
 4'h6: rcon_val = 32'h20_00_00_00;
 4'h7: rcon_val = 32'h40_00_00_00;
 4'h8: rcon_val = 32'h80_00_00_00;
 4'h9: rcon_val = 32'h1b_00_00_00;
 4'd10: rcon_val = 32'h36_00_00_00;
 default: rcon_val = 32'h00_00_00_00;
endcase
endfunction

endmodule

module aes_dp (
    input wire clk,
    input wire rst_n,

    input wire [3:0] rnd_idx,

    input wire         plaintext_en,
    input wire [127:0] plaintext_in,

    input wire         key_en,
    input wire [127:0] key_in,

    input wire ciphertext_en,
    input wire rndkey_en,

    input wire sb_mux_ctrl,
    input wire keygen_mux_ctrl,
    input wire skip_mux_ctrl,

    output wire [127:0] ciphertext_out
);

  wire [127:0] key_reg_o;
  wire [127:0] plain_reg_o;
  wire [127:0] add_xor1_o;
  wire [127:0] keygen_o;
  wire [127:0] mux_key_o;
  wire [127:0] rnd_key_reg_o;
  wire [127:0] mux_sb_o;
  wire [127:0] subbytes_o;
  wire [127:0] shiftrow_o;
  wire [127:0] mixcolumn_o;
  wire [127:0] mux_skip_o;
  wire [127:0] add_xor29_o;
  wire [127:0] state_reg_o;

  add_xor u_add_xor1 (
      .in1(plain_reg_o),
      .in2(key_reg_o),
      .xor_out(add_xor1_o)
  );

  mux2to1 u_mux2to1_sb (
      .in0 (ciphertext_out),
      .in1 (add_xor1_o),
      .ctrl(sb_mux_ctrl),
      .out (mux_sb_o)
  );

  mux2to1 u_mux2to1_keygen (
      .in0 (key_reg_o),
      .in1 (rnd_key_reg_o),
      .ctrl(keygen_mux_ctrl),
      .out (mux_key_o)
  );

  subbytes u_subbytes (
      .state_in (mux_sb_o),
      .state_out(subbytes_o)
  );

  shiftrow u_shiftrow (
      .state_in (subbytes_o),
      .state_out(shiftrow_o)
  );

  mixcolumn u_miscolumn (
      .state_in (shiftrow_o),
      .state_out(mixcolumn_o)
  );

  mux2to1 u_mux2to1_skip (
      .in0 (shiftrow_o),
      .in1 (mixcolumn_o),
      .ctrl(skip_mux_ctrl),
      .out (mux_skip_o)
  );

  add_xor u_add_xor29 (
      .in1(mux_skip_o),
      .in2(keygen_o),
      .xor_out(add_xor29_o)
  );

  dff_reg u_dff_reg_plain (
      .clk(clk),
      .rst_n(rst_n),
      .en(plaintext_en),
      .d_in(plaintext_in),
      .q_out(plain_reg_o)
  );

  dff_reg u_dff_reg_key (
      .clk(clk),
      .rst_n(rst_n),
      .en(key_en),
      .d_in(key_in),
      .q_out(key_reg_o)
  );

  dff_reg u_dff_reg_rndkey (
      .clk(clk),
      .rst_n(rst_n),
      .en(rndkey_en),
      .d_in(keygen_o),
      .q_out(rnd_key_reg_o)
  );

  dff_reg u1_dff_reg_cipher (
      .clk(clk),
      .rst_n(rst_n),
      .en(ciphertext_en),
      .d_in(add_xor29_o),
      .q_out(ciphertext_out)
  );

  key_gen u_key_gen (
      .rnd_idx(rnd_idx),
      .key(mux_key_o),
      .keyout(keygen_o)
  );

endmodule

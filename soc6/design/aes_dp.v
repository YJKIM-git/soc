// Folded AES datapath : 128-bit state register, but only 4 S-boxes (sbox4),
// time-shared across 5 sub-cycles per round.
//
//   scnt 0..3 : SubBytes one 32-bit lane of the state -> sub_reg
//   scnt 4    : SubWord of RotWord(w3) on the same 4 S-boxes -> key_expand
//               and ShiftRows/MixColumns/AddRoundKey latched into state.
//
// All sequential state (state_reg, key_reg, sub_reg) uses the same dff_reg
// instance style: a combinational next-value + an enabled register.
module aes_dp (
    input   wire                clk,
    input   wire                rst_n,

    input   wire    [127:0]     plaintext_in,
    input   wire    [127:0]     key_in,

    input   wire    [3:0]       rnd_idx,
    input   wire    [2:0]       scnt,
    input   wire                load_en,
    input   wire                sub_en,
    input   wire                round_en,
    input   wire                skip_mux_ctrl,

    output  wire    [127:0]     ciphertext_out
);

wire    [127:0] state_q;        // round state (also holds final ciphertext)
wire    [127:0] key_q;          // current round key K_{i-1}
wire    [127:0] sub_reg;        // SubBytes accumulator (dff_reg q_out)
reg     [127:0] sub_next;       // next value driven into sub_reg

// ---------------------------------------------------------------
// Shared 4-S-box block : input mux selects state lane or key RotWord
// ---------------------------------------------------------------
reg     [31:0]  sbox_in;
wire    [31:0]  sbox_out;

wire    [31:0]  w3      = key_q[31:0];
wire    [31:0]  rotword = {w3[23:16], w3[15:8], w3[7:0], w3[31:24]};

always @* begin
    case(scnt)
        3'd0:    sbox_in = state_q[127:96];
        3'd1:    sbox_in = state_q[95:64];
        3'd2:    sbox_in = state_q[63:32];
        3'd3:    sbox_in = state_q[31:0];
        3'd4:    sbox_in = rotword;            // key RotWord (SubWord)
        default: sbox_in = rotword;            // unused scnt 5..7 : keep defined
    endcase
end

sbox4 u_sbox4 (.in(sbox_in), .out(sbox_out));

// ---------------------------------------------------------------
// SubBytes accumulator next-value : write the lane addressed by scnt
// (0..3); every other lane holds. Registered by the dff_reg below
// (same style as state_reg / key_reg), enabled by sub_en.
// ---------------------------------------------------------------
always @* begin
    sub_next = sub_reg;                        // default : hold every lane
    case(scnt)
        3'd0:    sub_next[127:96] = sbox_out;
        3'd1:    sub_next[95:64]  = sbox_out;
        3'd2:    sub_next[63:32]  = sbox_out;
        3'd3:    sub_next[31:0]   = sbox_out;
        3'd4:    sub_next = sub_reg;            // key SubWord cycle : hold
        default: sub_next = sub_reg;            // unused scnt 5..7 : hold
    endcase
end

dff_reg #(.WIDTH(128)) u_sub_reg (
    .clk(clk), .rst_n(rst_n), .en(sub_en), .d_in(sub_next), .q_out(sub_reg)
);

// ---------------------------------------------------------------
// Round combinational path : ShiftRows -> (MixColumns | bypass) -> AddRoundKey
// (operates on the fully-substituted sub_reg at scnt == 4)
// ---------------------------------------------------------------
wire [127:0] sr_out, mc_out, mix_sel, round_key, round_out;

shiftrow  u_sr   (.state_in(sub_reg), .state_out(sr_out));
mixcolumn u_mc   (.state_in(sr_out),  .state_out(mc_out));
mux2to1   u_skip (.in0(sr_out), .in1(mc_out), .ctrl(skip_mux_ctrl), .out(mix_sel));

// Round key K_i : uses SubWord = sbox_out (valid at scnt == 4)
key_expand u_ke (
    .key_in     (key_q),
    .subword    (sbox_out),
    .rnd_idx    (rnd_idx),
    .key_out    (round_key)
);

add_xor u_ark (.in1(mix_sel), .in2(round_key), .xor_out(round_out));

// ---------------------------------------------------------------
// State register : initial AddRoundKey (PT ^ K0) on load, else round result
// ---------------------------------------------------------------
wire [127:0] init_state = plaintext_in ^ key_in;   // PT ^ K0
wire [127:0] state_din  = load_en ? init_state : round_out;
wire         state_en   = load_en | round_en;

dff_reg #(.WIDTH(128)) u_state (
    .clk(clk), .rst_n(rst_n), .en(state_en), .d_in(state_din), .q_out(state_q)
);

// ---------------------------------------------------------------
// Key register : K0 on load, generated K_i at end of each round
// ---------------------------------------------------------------
wire [127:0] key_din = load_en ? key_in : round_key;
wire         keyreg_en = load_en | round_en;

dff_reg #(.WIDTH(128)) u_key (
    .clk(clk), .rst_n(rst_n), .en(keyreg_en), .d_in(key_din), .q_out(key_q)
);

assign ciphertext_out = state_q;

endmodule

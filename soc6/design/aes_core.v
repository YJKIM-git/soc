// AES-128 encryption core (folded, 4 S-box version).
// Same top-level interface as the original 20-S-box core, so the existing
// testbench (tb_aes.v) drives it unmodified.
module aes_core (
    input   wire                clk,
    input   wire                rst_n,

    input   wire                aes_start,
    output  wire                aes_ready,
    output  wire                aes_valid,

    input   wire    [127:0]     aes_plaintext,
    input   wire    [127:0]     aes_key,
    output  wire    [127:0]     aes_ciphertext
);

wire    [3:0]   rnd_idx;
wire    [2:0]   scnt;
wire            load_en;
wire            sub_en;
wire            round_en;
wire            skip_mux_ctrl;

// Folded datapath (4 S-boxes)
aes_dp u_dp (
    .clk            (clk),
    .rst_n          (rst_n),

    .plaintext_in   (aes_plaintext),
    .key_in         (aes_key),

    .rnd_idx        (rnd_idx),
    .scnt           (scnt),
    .load_en        (load_en),
    .sub_en         (sub_en),
    .round_en       (round_en),
    .skip_mux_ctrl  (skip_mux_ctrl),

    .ciphertext_out (aes_ciphertext)
);

// Control FSM (drives the sub-cycle schedule)
aes_ctrl u_ctrl (
    .clk            (clk),
    .rst_n          (rst_n),

    .aes_start      (aes_start),
    .aes_ready      (aes_ready),
    .aes_valid      (aes_valid),

    .rnd_idx        (rnd_idx),
    .scnt           (scnt),
    .load_en        (load_en),
    .sub_en         (sub_en),
    .round_en       (round_en),
    .skip_mux_ctrl  (skip_mux_ctrl)
);

endmodule

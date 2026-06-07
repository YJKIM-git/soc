module aes_ctrl (
    input wire clk,
    input wire rst_n,

    input  wire aes_start,
    output reg  aes_ready,
    output reg  aes_valid,

    output reg [3:0] rnd_idx,

    output wire plaintext_en,
    output wire key_en,
    output wire ciphertext_en,
    output wire rndkey_en,

    output reg sb_mux_ctrl,
    output reg keygen_mux_ctrl,
    output reg skip_mux_ctrl
);

  localparam IDLE = 3'd0, RND_1 = 3'd1, RND_2TO9 = 3'd2, RND_10 = 3'd3, DONE = 3'd4;


  reg [2:0] cstate, nstate;
  wire aes_on;

  assign plaintext_en  = aes_start & aes_ready;
  assign key_en        = aes_start & aes_ready;
  assign aes_on        = (cstate == RND_1) | (cstate == RND_2TO9);
  assign ciphertext_en = aes_on || (cstate == RND_10);
  assign rndkey_en     = aes_on;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) rnd_idx <= 4'd0;

    else if (aes_start && aes_ready) rnd_idx <= 4'd1;

    else if (rnd_idx == 4'd10) rnd_idx <= 4'd0;

    else if (aes_on) rnd_idx <= rnd_idx + 4'd1;
  end


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) cstate <= IDLE;
    else cstate <= nstate;
  end


  always @* begin
    if (((cstate == IDLE) || (cstate == DONE)) && aes_start && aes_ready) nstate = RND_1;

    else if (cstate == RND_1) nstate = RND_2TO9;

    else if (cstate == RND_2TO9) begin
      if (rnd_idx == 4'd9) nstate = RND_10;
      else nstate = RND_2TO9;
    end else if (cstate == RND_10) nstate = DONE;

    else nstate = IDLE;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) aes_ready <= 1'b1;

    else if ((nstate == RND_1) || (nstate == RND_2TO9) || (nstate == RND_10)) aes_ready <= 1'b0;

    else if (nstate == DONE) aes_ready <= 1'b1;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) aes_valid <= 1'b0;

    else if ((nstate == RND_1) || (nstate == RND_2TO9) || (nstate == RND_10)) aes_valid <= 1'b0;

    else if (nstate == DONE) aes_valid <= 1'b1;
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) {sb_mux_ctrl, keygen_mux_ctrl, skip_mux_ctrl} <= {1'b0, 1'b0, 1'b0};

    else if (nstate == RND_1) {sb_mux_ctrl, keygen_mux_ctrl, skip_mux_ctrl} <= {1'b1, 1'b0, 1'b1};

    else if (nstate == RND_2TO9)
      {sb_mux_ctrl, keygen_mux_ctrl, skip_mux_ctrl} <= {1'b0, 1'b1, 1'b1};

    else if (nstate == RND_10) {sb_mux_ctrl, keygen_mux_ctrl, skip_mux_ctrl} <= {1'b0, 1'b1, 1'b0};

    else if (nstate == DONE) {sb_mux_ctrl, keygen_mux_ctrl, skip_mux_ctrl} <= {1'b0, 1'b0, 1'b0};
  end



endmodule

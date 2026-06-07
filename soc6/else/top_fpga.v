module top_fpga (
    input  wire clk,
    input  wire rst_n,
    input  wire btn_start,
    output wire ready,
    output wire valid,
    output wire out_led
);

  reg [127:0] aes_plaintext;
  reg [127:0] aes_key;

  initial begin
    aes_plaintext = 128'h00112233445566778899aabbccddeeff;
    aes_key       = 128'h000102030405060708090a0b0c0d0e0f;
  end

  wire [127:0] aes_ciphertext;

  aes_core u_core (
      .clk(clk),
      .rst_n(rst_n),
      .aes_start(btn_start),
      .aes_ready(ready),
      .aes_valid(valid),
      .aes_plaintext(aes_plaintext),
      .aes_key(aes_key),
      .aes_ciphertext(aes_ciphertext)
  );

  assign out_led = ^aes_ciphertext;

endmodule

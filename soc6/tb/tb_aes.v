`timescale 1ns / 10ps

module tb_aes;

parameter CLK_PERIOD = 10;

reg             clk       = 1'b0;
reg             rst_n     = 1'b0;
reg             aes_start = 1'b0;
reg     [127:0] plain_in  = 128'b0;
wire    [127:0] key_in    = 128'h2b7e151628aed2a6abf7158809cf4f3c;
wire            aes_valid;
wire            aes_ready;
wire    [127:0] cipher_out;

always #(CLK_PERIOD/2.0) clk = ~clk;

aes_core dut (
    .clk            (clk),
    .rst_n          (rst_n),
    .aes_start      (aes_start),
    .aes_valid      (aes_valid),
    .aes_ready      (aes_ready),
    .aes_plaintext  (plain_in),
    .aes_key        (key_in),
    .aes_ciphertext (cipher_out)
);

initial
begin
    $dumpfile("aes.vcd");
    $dumpvars(0, tb_aes);
end

task aes_run;
input [127:0] in;
input [127:0] check;
begin
    @(negedge clk);
    #10; aes_start = 1'b1; plain_in = in;
    #10; aes_start = 1'b0;

    wait(aes_valid);
    @(negedge clk);
    if(cipher_out == check)
        $display("Pass!");
    else
        $display("Fail! got=%032h expected=%032h", cipher_out, check);
end
endtask

initial
begin
    repeat (10) @(posedge clk);
    rst_n = 1'b1;

    #100;
    $display("1st Trial");
    aes_run(128'h6bc1bee22e409f96e93d7e117393172a, 128'h3ad77bb40d7a3660a89ecaf32466ef97);

    #100;
    $display("2nd Trial");
    aes_run(128'hae2d8a571e03ac9c9eb76fac45af8e51, 128'hf5d3d58503b9699de785895a96fdbaaf);

    #100;
    $display("3rd Trial");
    aes_run(128'h30c81c46a35ce411e5fbc1191a0a52ef, 128'h43b1cd7f598ece23881b00e3ed030688);

    #100;
    $display("4th Trial");
    aes_run(128'h45574841323032312b31343735303134, 128'h8f0401531efb5cd8f809ca1051b5bf9c);
    #1000;

    $finish;
end

endmodule

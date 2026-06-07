module dff_reg #(
    parameter WIDTH = 128
) (
    input  wire             clk,
    input  wire             rst_n,
    input  wire             en,
    input  wire [WIDTH-1:0] d_in,
    output reg  [WIDTH-1:0] q_out
);


  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) q_out <= {WIDTH{1'b0}};
    else if (en) q_out <= d_in;
  end

endmodule

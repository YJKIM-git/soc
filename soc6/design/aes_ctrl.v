module aes_ctrl (
    input wire clk,
    input wire rst_n,
    input  wire aes_start,
    output reg  aes_ready,
    output reg  aes_valid,
    output reg [3:0] rnd_idx,
    output reg [2:0] scnt,
    output wire load_en,
    output wire sub_en,
    output wire round_en,
    output wire skip_mux_ctrl
);

  localparam IDLE = 2'b00;
  localparam LOAD = 2'b01;
  localparam ROUND = 2'b10;
  localparam DONE = 2'b11;

  reg [1:0] cstate, nstate;

  always @(*) begin
    nstate = cstate;
    case (cstate)
      IDLE: if (aes_start) nstate = LOAD;
      LOAD: nstate = ROUND;
      ROUND: if (scnt == 3'd4 && rnd_idx == 4'd10) nstate = DONE;
      DONE: nstate = IDLE;
      default: nstate = IDLE;
    endcase
  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cstate    <= IDLE;
      scnt      <= 3'd0;
      rnd_idx   <= 4'd0;
      aes_ready <= 1'b1;
      aes_valid <= 1'b0;
    end else begin
      cstate <= nstate;

      case (cstate)
        IDLE: begin
          if (aes_start) begin
            rnd_idx   <= 4'd1;
            aes_ready <= 1'b0;
            aes_valid <= 1'b0;
          end
        end

        LOAD: begin
          scnt <= 3'd0;
        end

        ROUND: begin
          if (scnt == 3'd4) begin
            scnt <= 3'd0;
            if (rnd_idx == 4'd10) begin
              aes_valid <= 1'b1;
            end else begin
              rnd_idx <= rnd_idx + 1'b1;
            end
          end else begin
            scnt <= scnt + 1'b1;
          end
        end

        DONE: begin
          rnd_idx   <= 4'd0;
          aes_ready <= 1'b1;
        end

        default: begin
          scnt      <= 3'd0;
          rnd_idx   <= 4'd0;
          aes_ready <= 1'b1;
          aes_valid <= 1'b0;
        end
      endcase
    end
  end

  assign load_en       = (cstate == LOAD);
  assign sub_en        = (cstate == ROUND) && (scnt < 3'd4);
  assign round_en      = (cstate == ROUND) && (scnt == 3'd4);
  assign skip_mux_ctrl = (rnd_idx != 4'd10);

endmodule

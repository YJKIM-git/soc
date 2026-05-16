`timescale 1ns / 1ps
//`default_nettype none

module rw_sync_fsm (
    input  logic clk,
    input  logic rst,
    input  logic do_write,
    output logic exec,
    output logic rd_wr
);
  typedef enum logic [1:0] {
    IDLE,
    READ,
    WRITE,
    DONE
  } state_t;
  state_t cstate, nstate;

  always_ff @(posedge clk or posedge rst) begin : STATE_REG
    if (rst) begin
      cstate <= IDLE;
    end else begin
      cstate <= nstate;
    end
  end

  always_comb begin : NEXT_STATE_LOGIC
    nstate = cstate;
    unique case (cstate)
      IDLE: begin
        if (do_write) nstate = WRITE;
        else nstate = READ;
      end

      READ: begin
        if (!do_write) nstate = DONE;
      end

      WRITE: begin
        if (do_write) nstate = DONE;
      end

      DONE: begin
        nstate = IDLE;
      end

      default: begin
        nstate = IDLE;
      end
    endcase
  end

  always_comb begin : OUTPUT_LOGIC
    exec  = 1'b0;
    rd_wr = 1'b1;
    unique case (cstate)
      IDLE: ;

      READ: begin
        rd_wr = 1'b0;
      end

      WRITE: begin
        rd_wr = 1'b1;
      end

      DONE: begin
        exec = 1'b1;
      end

      default: ;
    endcase
  end

endmodule

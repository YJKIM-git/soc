`timescale 1ns / 1ps
//`default_nettype none

module tb_rw_sync_fsm;

  logic clk, rst, do_write, exec, rd_wr;

  rw_sync_fsm dut (
      .clk(clk),
      .rst(rst),
      .do_write(do_write),
      .exec(exec),
      .rd_wr(rd_wr)
  );

  int err_cnt, done_cnt;
  typedef enum logic [1:0] {
    IDLE,
    READ,
    WRITE,
    DONE
  } state_t;

  initial begin
    clk <= 1'b0;
    forever #5 clk <= ~clk;
  end

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, tb_rw_sync_fsm);
    $display("TEST START, %0d ns", $time);
  end

  initial begin
    reset_phase();
    run_phase();
    report_phase();
  end

  task automatic reset_phase();
    rst <= 1'b1;
    do_write <= 1'b0;
    repeat (2) @(posedge clk);
    rst <= 1'b0;
    repeat (1) @(posedge clk);
  endtask

  task automatic run_phase();
    //initialize counters
    done_cnt <= 0;
    err_cnt  <= 0;
    /**************************************/
    /*              READ_SEQ              */
    /**************************************/
    do_write <= 1'b0;       // init: IDLE
    repeat (2) @(posedge clk);
    // IDLE -> READ -> DONE
    /**************************************/

    /**************************************/
    /*             WRITE_SEQ              */
    /**************************************/
    do_write <= 1'b1;       // init: DONE
    repeat (3) @(posedge clk);
    // DONE -> IDLE -> WRITE -> DONE
    /**************************************/

    /**************************************/
    /*          BURST_READ_SEQ            */
    /**************************************/
    do_write <= 1'b0;       // init: DONE
    @(posedge clk);         // IDLE -> READ
    do_write <= 1'b1;
    repeat (4) @(posedge clk);
    do_write <= 1'b0;
    repeat (2) @(posedge clk);
    // DONE -> IDLE -> READ -> READ
    //  -> READ -> READ -> READ -> DONE
    /**************************************/

    /**************************************/
    /*         BURST_WRITE_SEQ            */
    /**************************************/
    do_write <= 1'b1;       // init: DONE
    @(posedge clk);         // IDLE -> WRITE
    do_write <= 1'b0;
    repeat (4) @(posedge clk);
    do_write <= 1'b1;
    repeat (2) @(posedge clk);
    // DONE -> IDLE -> WRITE -> WRITE
    //  -> WRITE -> WRITE -> WRITE -> DONE
    /**************************************/
    @(posedge clk);
  endtask


  task automatic report_phase();
    $display("========================================");
    if (err_cnt == 0) begin
      $display("TEST PASSED AND COMPLETED");
    end else begin
      $display("TEST FAILED: %0d ERRORS OCCURRED", err_cnt);
    end
    $display("========================================");
    $finish;
  endtask

  initial
    forever begin
      @(posedge clk)
      if (dut.cstate == DONE) begin
        case (done_cnt)
          0: $display("1. [FINISHED]        READ  SEQUENCE, %0d ns", $time);
          1: $display("2. [FINISHED]        WRITE SEQUENCE, %0d ns", $time);
          2: $display("3. [FINISHED] BURST  READ  SEQUENCE, %0d ns", $time);
          3: $display("4. [FINISHED] BURST  WRITE SEQUENCE, %0d ns", $time);
          default: ;
        endcase
        done_cnt++;
        wait (dut.cstate != DONE);
      end
    end

  property p_idle_to_write;
    @(posedge clk) disable iff (rst) (dut.cstate == IDLE && do_write) |=> (dut.cstate == WRITE);
  endproperty
  assert_idle_to_write :
  assert property (p_idle_to_write)
  else begin
    $error("[%0t] FSM ERROR: IDLE to WRITE transition failed.", $time);
    err_cnt++;  // Increment error counter
  end

  property p_idle_to_read;
    @(posedge clk) disable iff (rst) (dut.cstate == IDLE && !do_write) |=> (dut.cstate == READ);
  endproperty
  assert_idle_to_read :
  assert property (p_idle_to_read)
  else begin
    $error("[%0t] FSM ERROR: IDLE to READ transition failed.", $time);
    err_cnt++;
  end

  property p_read_to_done;
    @(posedge clk) disable iff (rst) (dut.cstate == READ && !do_write) |=> (dut.cstate == DONE);
  endproperty
  assert_read_to_done :
  assert property (p_read_to_done)
  else begin
    $error("[%0t] FSM ERROR: READ to DONE transition failed.", $time);
    err_cnt++;
  end

  property p_read_wait;
    @(posedge clk) disable iff (rst) (dut.cstate == READ && do_write) |=> (dut.cstate == READ);
  endproperty
  assert_read_wait :
  assert property (p_read_wait)
  else begin
    $error("[%0t] FSM ERROR: READ to READ transition failed.", $time);
    err_cnt++;
  end

  property p_write_to_done;
    @(posedge clk) disable iff (rst) (dut.cstate == WRITE && do_write) |=> (dut.cstate == DONE);
  endproperty
  assert_write_to_done :
  assert property (p_write_to_done)
  else begin
    $error("[%0t] FSM ERROR: WRITE to DONE transition failed.", $time);
    err_cnt++;
  end

  property p_write_wait;
    @(posedge clk) disable iff (rst) (dut.cstate == WRITE && !do_write) |=> (dut.cstate == WRITE);
  endproperty
  assert_write_wait :
  assert property (p_write_wait)
  else begin
    $error("[%0t] FSM ERROR: WRITE to WRITE transition failed.", $time);
    err_cnt++;
  end

  property p_done_to_idle;
    @(posedge clk) disable iff (rst) (dut.cstate == DONE) |=> (dut.cstate == IDLE);
  endproperty
  assert_done_to_idle :
  assert property (p_done_to_idle)
  else begin
    $error("[%0t] FSM ERROR: DONE to IDLE transition failed.", $time);
    err_cnt++;
  end

  property p_read;
    @(posedge clk) disable iff (rst) (dut.cstate == READ) |-> (exec == 1'b0 && rd_wr == 1'b0);
  endproperty
  assert_read :
  assert property (p_read)
  else begin
    $error("[%0t] FSM ERROR: READ state failed.", $time);
    err_cnt++;
  end

  property p_write;
    @(posedge clk) disable iff (rst) (dut.cstate == WRITE) |-> (exec == 1'b0 && rd_wr == 1'b1);
  endproperty
  assert_write :
  assert property (p_write)
  else begin
    $error("[%0t] FSM ERROR: WRITE state failed.", $time);
    err_cnt++;
  end

  property p_done;
    @(posedge clk) disable iff (rst) (dut.cstate == DONE) |-> (exec == 1'b1);
  endproperty
  assert_done :
  assert property (p_done)
  else begin
    $error("[%0t] FSM ERROR: DONE state failed.", $time);
    err_cnt++;
  end

endmodule

// --=========================================================================--
// Copyright (c) 2025-2026 DSAL, Hanyang University. All rights reserved
//                     DSAL Confidential Proprietary
//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from DSAL.
// -----------------------------------------------------------------------------
// FILE NAME       : hy_soc.v
// DEPARTMENT      : Digital System Architecture Lab.
// AUTHOR          : Ji-Hoon Kim
// AUTHOR'S EMAIL  : jhoonkim@hanyang.ac.kr
// -----------------------------------------------------------------------------
// hy_soc.v — HY-SoC Educational Lab3
//
// Cortex-M0 (DesignStart) + AHB-Lite Shared Bus + SRAM 64KB + LED + UART
//
// Memory map:
//   0x0000_0000 – 0x00FF_FFFF : s0 — ahb_sram (64 KB actual, 16 MB window)
//   0x5000_0000 – 0x50FF_FFFF : s1 — ahb_led
//   0x5100_0000 – 0x51FF_FFFF : s2 — ahb_uart
//   other                     : nomap → ahb_default_slv (ERROR, internal to bus)
//
// UART sim/synth mode:
//   Simulation  — `ifdef SIMULATION` sets SIM_MODE=1 (high-speed baud test mode)
//   Synthesis   — SIM_MODE=0 (real baud rate from BAUDDIV register)

module hy_soc (
  input  wire clk,       // system clock
  input  wire rst_n,     // async assert, sync deassert (active-low)
  // LED output
  output wire [3:0] led_o,
  // UART pins (directly to FPGA I/O in synthesis)
  output wire uart_tx_o,
  input  wire uart_rx_i
);

  // ---------------------------------------------------------------------------
  // AHB-Lite bus signals
  // ---------------------------------------------------------------------------
  wire [31:0] haddr;
  wire [31:0] hwdata;
  wire        hwrite;
  wire [1:0]  htrans;
  wire [2:0]  hburst;
  wire        hmastlock;
  wire [3:0]  hprot;
  wire [2:0]  hsize;
  wire [31:0] hrdata;
  wire        hresp;
  wire        hready;

  // Subordinate signals — SRAM
  wire        hsel_sram;
  wire [31:0] hrdata_sram;
  wire        hreadyout_sram;

  // Subordinate signals — LED
  wire        hsel_led;
  wire [31:0] hrdata_led;
  wire        hreadyout_led;

  // Subordinate signals — UART
  wire        hsel_uart;
  wire [31:0] hrdata_uart;
  wire        hreadyout_uart;

  // UART interrupt
  wire        uart_irq;
  wire [31:0] irq = {31'h0, uart_irq};  // IRQ[0] = UART

  // ---------------------------------------------------------------------------
  // Reset synchronizer: two independent async-assert / sync-deassert chains
  //   por_sync (ext reset only)        -> PORESETn, DBGRESETn
  //   sys_sync (ext reset + SYSRESETREQ) -> HRESETn
  // ---------------------------------------------------------------------------
  wire hresetn, poresetn, dbgresetn;

  cm0_rst_sync u_rst_sync (
    .clk            (clk),
    .rst_n          (rst_n),
    .sysresetreq_i  (1'b0),
    .poresetn_o     (poresetn),
    .dbgresetn_o    (dbgresetn),
    .hresetn_o      (hresetn)
  );

  // CDBGPWRUP self-ack
  wire cdbgpwrupreq;

  // ---------------------------------------------------------------------------
  // Cortex-M0 DesignStart
  // ---------------------------------------------------------------------------
  CORTEXM0INTEGRATION u_cm0 (
    // clocks & resets
    .FCLK           (clk),
    .SCLK           (clk),
    .HCLK           (clk),
    .DCLK           (clk),
    .PORESETn       (poresetn),
    .DBGRESETn      (dbgresetn),
    .HRESETn        (hresetn),
    .SWCLKTCK       (1'b0),
    .nTRST          (1'b1),

    // AHB-Lite manager port
    .HADDR          (haddr),
    .HBURST         (hburst),
    .HMASTLOCK      (hmastlock),
    .HPROT          (hprot),
    .HSIZE          (hsize),
    .HTRANS         (htrans),
    .HWDATA         (hwdata),
    .HWRITE         (hwrite),
    .HRDATA         (hrdata),
    .HREADY         (hready),
    .HRESP          (hresp),
    .HMASTER        (),

    // code sequentiality (unused)
    .CODENSEQ       (),
    .CODEHINTDE     (),
    .SPECHTRANS     (),

    // debug — SWD tied off
    .SWDITMS        (1'b0),
    .TDI            (1'b0),
    .SWDO           (),
    .SWDOEN         (),
    .TDO            (),
    .nTDOEN         (),
    .DBGRESTART     (1'b0),
    .DBGRESTARTED   (),
    .EDBGRQ         (1'b0),
    .HALTED         (),

    // interrupts
    .NMI            (1'b0),
    .IRQ            (irq),
    .TXEV           (),
    .RXEV           (1'b0),
    .LOCKUP         (),
    .SYSRESETREQ    (),
    // SysTick: 50 MHz → 10 ms = 500 000 - 1 = 0x07_A11F
    .STCALIB        ({1'b1, 1'b0, 24'h07A11F}),
    .STCLKEN        (1'b0),
    .IRQLATENCY     (8'h00),
    .ECOREVNUM      (28'h0),

    // power management — tied off
    .GATEHCLK       (),
    .SLEEPING       (),
    .SLEEPDEEP      (),
    .WAKEUP         (),
    .WICSENSE       (),
    .SLEEPHOLDREQn  (1'b1),
    .SLEEPHOLDACKn  (),
    .WICENREQ       (1'b0),
    .WICENACK       (),
    .CDBGPWRUPREQ   (cdbgpwrupreq),
    .CDBGPWRUPACK   (cdbgpwrupreq),  // self-ack

    // scan — tied off
    .SE             (1'b0),
    .RSTBYPASS      (1'b0)
  );

  // ---------------------------------------------------------------------------
  // On-chip Interconnect (SRAM + LED + UART + default slave)
  // ---------------------------------------------------------------------------
  ahb_interconnect u_interconnect (
    .hclk             (clk),
    .hrst_n           (hresetn),
    .haddr_i          (haddr),
    .htrans_i         (htrans),
    .hrdata_o         (hrdata),
    .hready_o         (hready),
    .hresp_o          (hresp),
    .hsel_sram_o      (hsel_sram),
    .hrdata_sram_i    (hrdata_sram),
    .hreadyout_sram_i (hreadyout_sram),
    .hsel_led_o       (hsel_led),
    .hrdata_led_i     (hrdata_led),
    .hreadyout_led_i  (hreadyout_led),
    .hsel_uart_o      (hsel_uart),
    .hrdata_uart_i    (hrdata_uart),
    .hreadyout_uart_i (hreadyout_uart)
  );

  // ---------------------------------------------------------------------------
  // SRAM 64 KB (MEMWIDTH=16 → 2^16 bytes)
  // ---------------------------------------------------------------------------
  ahb_sram #(.MEMWIDTH(16)) u_sram (
    .hsel      (hsel_sram),
    .clk       (clk),
    .rst_n     (hresetn),
    .hready    (hready),
    .haddr     (haddr),
    .htrans    (htrans),
    .hwrite    (hwrite),
    .hsize     (hsize),
    .hwdata    (hwdata),
    .hreadyout (hreadyout_sram),
    .hrdata    (hrdata_sram)
  );

  // ---------------------------------------------------------------------------
  // LED Controller
  // ---------------------------------------------------------------------------
  ahb_led u_led (
    .hclk       (clk),
    .hrst_n     (hresetn),
    .hsel_i     (hsel_led),
    .hready_i   (hready),
    .haddr_i    (haddr),
    .htrans_i   (htrans),
    .hwrite_i   (hwrite),
    .hwdata_i   (hwdata),
    .hreadyout_o(hreadyout_led),
    .hrdata_o   (hrdata_led),
    .led_o      (led_o)
  );

  // ---------------------------------------------------------------------------
  // UART
  // ---------------------------------------------------------------------------
  ahb_uart u_uart (
    .hclk       (clk),
    .hrst_n     (hresetn),
    .hsel_i     (hsel_uart),
    .hready_i   (hready),
    .haddr_i    (haddr),
    .htrans_i   (htrans),
    .hwrite_i   (hwrite),
    .hwdata_i   (hwdata),
    .hreadyout_o(hreadyout_uart),
    .hrdata_o   (hrdata_uart),
    .uart_rx_i  (uart_rx_i),
    .uart_tx_o  (uart_tx_o),
    .uart_irq_o (uart_irq),
    .baudtick_o ()
  );

endmodule

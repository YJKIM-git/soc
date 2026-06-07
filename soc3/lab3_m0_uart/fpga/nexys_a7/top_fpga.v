// top_fpga.v — Nexys A7-100T FPGA top wrapper for HY-SoC Lab3
//
// Board:  Digilent Nexys A7-100T (XC7A100T-1CSG324C)
// Clock:  100 MHz oscillator (pin E3) → MMCM → 50 MHz
// Reset:  CPU_RESETN (pin C12, active-low)
// LEDs:   LD0-LD3 (pins H17, K15, J13, N14)
// UART:   USB-UART — TX=D4, RX=C4 (directly on PL)

module top_fpga (
  input  wire       sysclk_100,    // 100 MHz oscillator
  input  wire       cpu_resetn,    // active-low reset button
  output wire [3:0] led,           // LD0-LD3
  output wire       uart_txd_in,   // FPGA → USB-UART chip (active naming from schematic)
  input  wire       uart_rxd_out   // USB-UART chip → FPGA
);

  wire clk_50m;
  wire mmcm_locked;
  wire mmcm_fb;

  MMCME2_BASE #(
    .CLKIN1_PERIOD  (10.000),
    .CLKFBOUT_MULT_F(10.000),
    .CLKOUT0_DIVIDE_F(20.000)
  ) u_mmcm (
    .CLKIN1    (sysclk_100),
    .CLKFBIN   (mmcm_fb),
    .CLKFBOUT  (mmcm_fb),
    .CLKOUT0   (clk_50m),
    .CLKOUT0B  (),
    .CLKOUT1   (),
    .CLKOUT1B  (),
    .CLKOUT2   (),
    .CLKOUT2B  (),
    .CLKOUT3   (),
    .CLKOUT3B  (),
    .CLKOUT4   (),
    .CLKOUT5   (),
    .CLKOUT6   (),
    .LOCKED    (mmcm_locked),
    .PWRDWN    (1'b0),
    .RST       (1'b0)
  );

  wire rst_n = mmcm_locked & cpu_resetn;

  wire [3:0] led_out;
  wire       uart_tx;

  hy_soc u_soc (
    .clk       (clk_50m),
    .rst_n     (rst_n),
    .led_o     (led_out),
    .uart_tx_o (uart_tx),
    .uart_rx_i (uart_rxd_out)
  );

  assign led         = led_out;
  assign uart_txd_in = uart_tx;

endmodule

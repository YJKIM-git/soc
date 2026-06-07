// top_fpga.v — Zybo Z7-20 FPGA top wrapper for HY-SoC Lab3
//
// Board:  Digilent Zybo Z7-20 (XC7Z020-1CLG400C)
// Clock:  125 MHz PL system clock (pin K17) → MMCM → 50 MHz
// Reset:  BTN0 (pin Y16, active-high) → inverted to active-low
// LEDs:   LD0-LD3 (pins M14, M15, G14, D18)
// UART:   Pmod JE — pin1 V12 (TX), pin2 W16 (RX)
//         Requires external Pmod UART module (e.g. Pmod USBUART)

module top_fpga (
  input  wire       sysclk_125,    // 125 MHz PL system clock
  input  wire       btn0,          // active-high push button (reset)
  output wire [3:0] led,           // LD0-LD3
  output wire       pmod_uart_tx,  // Pmod JE pin1 (FPGA TX → adapter RX)
  input  wire       pmod_uart_rx   // Pmod JE pin2 (adapter TX → FPGA RX)
);

  wire clk_50m;
  wire mmcm_locked;
  wire mmcm_fb;

  MMCME2_BASE #(
    .CLKIN1_PERIOD  (8.000),
    .CLKFBOUT_MULT_F(8.000),
    .CLKOUT0_DIVIDE_F(20.000)
  ) u_mmcm (
    .CLKIN1    (sysclk_125),
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

  wire rst_n = mmcm_locked & ~btn0;

  wire [3:0] led_out;
  wire       uart_tx;

  hy_soc u_soc (
    .clk       (clk_50m),
    .rst_n     (rst_n),
    .led_o     (led_out),
    .uart_tx_o (uart_tx),
    .uart_rx_i (pmod_uart_rx)
  );

  assign led          = led_out;
  assign pmod_uart_tx = uart_tx;

endmodule

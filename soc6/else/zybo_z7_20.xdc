#zybo z7-20
# System Clock 125MHz
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} [get_ports clk]

# Reset (Button 0)
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports rst_n]

# Start (Button 1)
set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports btn_start]

# Ready/Valid
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports ready]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports valid]

# [추가] 최적화 방지용 out_led 포트를 Zybo 보드의 LED 0번(M14 핀)에 할당
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports out_led]
set_units -time ns -capacitance pF

create_clock -name clk -period 20.0 [get_ports clk]

set_clock_uncertainty -setup 0.2 [get_clocks clk]
set_clock_uncertainty -hold 0.05 [get_clocks clk]

set_input_delay -max 2.0 -clock clk [all_inputs -no_clocks]
set_input_delay -min 0.2 -clock clk [all_inputs -no_clocks]

set_output_delay -max 2.0 -clock clk [all_outputs]
set_output_delay -min 0.2 -clock clk [all_outputs]

set_max_transition 0.5 [current_design]
set_max_fanout 30 [current_design]

set_false_path -from [get_ports rst_n]
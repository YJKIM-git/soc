# =============================================================================
# Professional Timing Analysis Script (OpenSTA)
# =============================================================================

# 1. Load Liberty (Standard Cell Library)
# Replace 'sky130_fd_sc_hd__tt_025C_1v80.lib' with your actual library file
read_liberty sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Read Design (Netlist)
read_verilog ../build/synth_netlist.v
link_design aes_core

# 3. Read Constraints
read_sdc sky130.sdc

# 4. Propagate Clocks
# In Post-Layout, we use set_propagated_clock
set_propagated_clock [all_clocks]

# 5. Timing Analysis & Reporting
# Check for unconstrained paths
check_setup -verbose

# Report the worst 10 setup paths
puts "=============================================\n"
puts "             SETUP VIOLATIONS                  "
puts "=============================================\n"
report_checks -path_delay max \
              -format full_clock_expanded \
              -fields {slew cap input_pin net} \
              -digits 4 \
              -group_path_count 1

# Report the worst 10 hold paths
puts "=============================================\n"
puts "             HOLD VIOLATIONS                  "
puts "=============================================\n"
report_checks -path_delay min \
              -format full_clock_expanded \
              -fields {slew cap input_pin net} \
              -digits 4 \
              -group_path_count 1

puts "=============================================\n"
puts "                 clock_skew                  "
puts "=============================================\n"
report_clock_skew -setup


puts "=============================================\n"
puts "                 WNS & TNS                     "
puts "=============================================\n"
report_wns
report_tns

puts "\n============================================="
puts "               POWER ANALYSIS                  "
puts "=============================================\n"
report_power

exit
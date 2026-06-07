# create_project.tcl — Vivado project for HY-SoC Lab3 on Nexys A7-100T
#
# Usage:
#   cd edu/lab3_m0_uart/fpga/nexys_a7
#   vivado -mode batch -source create_project.tcl

set proj_name  "lab3_fpga"
set proj_dir   [file normalize "$proj_name"]
set part       "xc7a100tcsg324-1"

set script_dir [file dirname [file normalize [info script]]]
set rtl_dir    [file normalize "$script_dir/../../rtl"]
set common_dir [file normalize "$script_dir/../../../../common"]
set arm_ip_dir [file normalize "/opt/arm_ip"]

create_project $proj_name $proj_dir -part $part -force
set_property target_language Verilog [current_project]

add_files -fileset sources_1 [list \
  "$script_dir/top_fpga.v"                                      \
  "$rtl_dir/hy_soc.v"                                       \
  "$rtl_dir/ahb_interconnect.v"                                  \
  "$rtl_dir/ahb_dcd.v"                                           \
  "$rtl_dir/ahb_slv_mux.v"                                      \
  "$common_dir/rst/cm0_rst_sync.v"                               \
  "$common_dir/ahb_bus/ahb_default_slv.v"                        \
  "$common_dir/ahb_sram/ahb_sram.v"                              \
  "$common_dir/led/ahb_led.v"                                    \
  "$common_dir/uart/ahb_uart.v"                                  \
  "$common_dir/uart/cmsdk_apb_uart.v"                            \
  "$arm_ip_dir/CortexM0-DS/CORTEXM0INTEGRATION.v"               \
  "$arm_ip_dir/CortexM0-DS/cortexm0ds_logic.v"                  \
]

add_files -fileset constrs_1 "$script_dir/nexys_a7.xdc"
set_property top top_fpga [current_fileset]

if {[file exists "$script_dir/../../sw/gcc/code.hex"]} {
  file copy -force "$script_dir/../../sw/gcc/code.hex" "$proj_dir/code.hex"
  puts "INFO: Copied code.hex (gcc) to project directory"
} elseif {[file exists "$script_dir/../../sw/arm/lab3.hex"]} {
  file copy -force "$script_dir/../../sw/arm/lab3.hex" "$proj_dir/code.hex"
  puts "INFO: Copied lab3.hex (arm) to project directory"
} else {
  puts "WARNING: No hex file found — build sw first"
}

set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY rebuilt [get_runs synth_1]

puts ""
puts "Project created: $proj_dir"
puts "Part: $part"
puts ""
puts "Next steps:"
puts "  1. Build SW:  cd ../../sw/gcc && make       (without SIMULATION flag)"
puts "  2. Copy hex:  cp ../../sw/gcc/code.hex $proj_dir/code.hex"
puts "  3. Open GUI:  vivado -mode gui $proj_dir/${proj_name}.xpr"
puts "  4. Run Synthesis → Implementation → Generate Bitstream"
puts ""

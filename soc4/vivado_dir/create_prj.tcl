# create_prj.tcl — Vivado project for rw_sync_fsm
#
# Usage:
#    vivado -mode batch -source create_prj.tcl
#    (or)GUI in Tcl Console: source create_prj.tcl

set proj_name  "rw_sync_fsm"
set part       "xc7z020clg400-1"

set script_dir [file dirname [file normalize [info script]]]
set proj_dir   "$script_dir/$proj_name"
set rtl_dir    "$script_dir/../rtl"

# ── 1. project creation ──────────────────────────────────────────
create_project $proj_name $proj_dir -part $part -force
set_property target_language Verilog [current_project]

# ── 2. RTL sources addition ─────────────────────────────────────────
if {[file exists "$rtl_dir/rw_sync_fsm.sv"]} {
    add_files -fileset sources_1 "$rtl_dir/rw_sync_fsm.sv"
    puts "INFO: Added RTL source: rw_sync_fsm.sv"
}

# ── 3. Simulation sources addition ──────────────────────────────────
if {[file exists "$rtl_dir/tb_rw_sync_fsm.sv"]} {
    add_files -fileset sim_1 "$rtl_dir/tb_rw_sync_fsm.sv"
    puts "INFO: Added Simulation source: tb_rw_sync_fsm.sv"
}

# ── 4. Constraints addition ──────────────────────────
if {[file exists "$rtl_dir/constraints.sdc"]} {
    add_files -fileset constrs_1 "$rtl_dir/constraints.sdc"
    puts "INFO: Added Constraints: constraints.sdc"
}

# ── 5. Compile order and top module setup ──────────────────────────
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property top rw_sync_fsm [current_fileset]
set_property top tb_rw_sync_fsm [get_filesets sim_1]

puts ""
puts "========================================================"
puts " Project created: $proj_dir"
puts " Part:            $part"
puts "========================================================"
puts "Next steps:"
puts "  1. Open GUI: vivado $proj_dir/${proj_name}.xpr"
puts "  2. Run Simulation or Synthesis"
puts "========================================================"
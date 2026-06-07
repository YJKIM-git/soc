set BASE_PATH ".."
set PDK_PATH "sky130_fd_sc_hd__tt_025C_1v80.lib"

yosys verilog_defaults -add -DSYNTH_ASIC
set flist [open "$BASE_PATH/filelist.f" r]
while {[gets $flist line] >= 0} {
    set line [string trim $line]
    if {$line eq "" || [string match "//*" $line] || [string match "#*" $line]} {
        continue
    }
    yosys read_verilog -sv "$BASE_PATH/$line"
}
close $flist

yosys hierarchy -check -top aes_core

yosys proc; yosys opt; yosys fsm; yosys opt; yosys memory; yosys opt; yosys techmap; yosys opt
yosys dfflibmap -liberty $PDK_PATH
yosys abc -liberty $PDK_PATH
yosys clean

yosys stat -liberty $PDK_PATH
yosys write_verilog ../build/synth_netlist.v
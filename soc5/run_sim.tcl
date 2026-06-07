launch_simulation
open_wave_config
run all
file mkdir results
file rename -force [glob -nocomplain *.vcd *.wdb] results/
close_sim

TOOL     ?= xsim
WORK_DIR  = work

dut      ?= aes
TOP_TB    = tb_$(dut)
f        ?= filelist.f

.PHONY: all run init_work iverilog xsim vsim clean help asic

all: clean run
gui_run: clean create_prj gui
run: $(TOOL)

# 1. Icarus Verilog
iverilog: init_work
	@iverilog -g2012 -o $(WORK_DIR)/sim.out -f $(f) tb/$(TOP_TB).v
	vvp $(WORK_DIR)/sim.out

# 2. Xilinx Xsim
xsim: 
	@xvlog -sv -f $(f) tb/$(TOP_TB).v -nolog
	@xelab -top $(TOP_TB) -snapshot $(dut)_snap -debug typical -timescale 1ns/10ps -nolog
	@xsim $(dut)_snap -R
	@mkdir -p results
	@mv xsim.log *.vcd *.wdb results
	@rm -rf xsim.dir *.jou *.pb

clean:
	@rm -rf xsim.dir *.jou *.pb *.log
	@rm -rf results/*.log results/*.vcd results/*.wdb
	@rm -rf build

help:
	@echo "Usage:"
	@echo "  make run               
	@echo "  make run TOOL=iverilog 
	@echo "  make run TOOL=vsim     
	@echo "  make run dut=XXX       
	@echo "  make clean             

create_prj:
	vivado -mode batch -source create_prj.tcl -nolog -nojournal

gui:
	vivado -nolog -nojournal ./aes128/aes128.xpr

asic:
	mkdir -p build
	cd synth && yosys synth.tcl > synth.log
	cd synth && sta sta.tcl > sta.log
	grep "Chip area for" synth/synth.log
	mv synth/synth.log synth/sta.log results
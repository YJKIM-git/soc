RTL_DIR := $(abspath rtl)
SIM_DIR := $(abspath cli_dir)
RES_DIR := $(abspath result)
VIVADO_DIR := $(abspath vivado_dir)

VSRCS := \
	$(RTL_DIR)/rw_sync_fsm.sv

TB_SRC := \
	$(RTL_DIR)/tb_rw_sync_fsm.sv

SIM ?= xsim
TOP_MODULE ?= tb_rw_sync_fsm

.PHONY: all sim clean help
all: clean sim create_vivado vivado

ifeq ($(SIM),xsim)
sim:
	mkdir -p $(SIM_DIR)
	cd $(SIM_DIR) && xvlog -sv $(VSRCS) $(TB_SRC)
	cd $(SIM_DIR) && xelab -debug typical $(TOP_MODULE) -s $(TOP_MODULE)_snapshot
	mkdir -p $(RES_DIR)
	cd $(SIM_DIR) && xsim $(TOP_MODULE)_snapshot --runall --log sim_run.log
	cp $(SIM_DIR)/sim_run.log $(SIM_DIR)/wave.fst $(RES_DIR)/ 2>/dev/null || true


create_vivado:
	cd $(VIVADO_DIR) && vivado -mode batch -source create_prj.tcl -nolog -nojournal

vivado:
	vivado -mode gui $(VIVADO_DIR)/rw_sync_fsm/rw_sync_fsm.xpr -nolog -nojournal

clean:
	rm -rf $(SIM_DIR)/*
	rm -rf $(VIVADO_DIR)/rw_sync_fsm
endif
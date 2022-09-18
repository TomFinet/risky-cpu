MODULE=machine
ASM=easy

MODULE_PATH=./rtl/$(MODULE).v
TESTBENCH_PATH=./sim/$(MODULE)_sim.cpp

.PHONY:sim
sim: waveform.vcd

.PHONY:verilate
verilate: .stamp.verilate

.PHONY:build
build: obj_dir/V$(MODULE)

.PHONY:waves
waves: machine_trace.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave machine_trace.vcd

waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE) +verilator+rand+reset+2


./obj_dir/V$(MODULE): .stamp.verilate
	@echo
	@echo "### BUILDING SIM ###"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)

.stamp.verilate: $(MODULE_PATH) $(TESTBENCH_PATH)
	@echo
	@echo "### VERILATING ###"
	verilator --trace --x-assign unique --x-initial unique -cc $(MODULE_PATH) --exe $(TESTBENCH_PATH)
	@touch .stamp.verilate

assemble:
	python asm/asm.py asm/tests/$(ASM).s > memory.list

.PHONY:lint
lint: $(MODULE).v
	verilator --lint-only $(MODULE_PATH)

.PHONY: clean
clean:
	rm -rf .stamp.*;
	rm -rf ./obj_dir
	rm -rf waveform.vcd

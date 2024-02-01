IP_DIR = ./ip
TEST_DIR = ./test
LOGS_DIR = ./logs
UTIL_DIR = ./util
SYNTH_OUTPUT_DIR= ./synth_out
VERILATOR = verilator

# add all the flags
VERILATOR_FLAGS = 
# --main generates the C++ wrapper that connects Verilog through the VPI, which we already wrote in sim_main.cpp
# --build uses Make to build the model
# --exe creates an executable
# --binary does all three above, so it doesn't make sense to use --binary with any of --main -- build or --exe
# we already wrote our own C++ wrapper, so we don't need --main, do --build and --exe
VERILATOR_FLAGS += --cc --exe --build
# show linting warnings
#VERILATOR_FLAGS += --Wall
# generate .vcd waveform
VERILATOR_FLAGS += --trace
# enable coverage check
#VERILATOR_FLAGS += --coverage
# choose top module
VERILATOR_FLAGS += --top-module top

VERILATOR_INPUT_FILES = top.v sim_main.cpp $(VERILOG_SRC_FILES) $(wildcard $(TEST_DIR)/*.cpp)
VERILOG_SRC_FILES = $(wildcard $(IP_DIR)/*.*) 

run_sim: 
	$(MAKE) build 
	@echo 
	@echo "-- RUN ------"
	@rm -rf logs
ifndef NO_TRACE
	@echo "run with trace enabled"
	obj_dir/Vtop +trace # + is syntax of the verilator cpp file
else
	@echo "run with trace disabled, no vcd will be generated"
	obj_dir/Vtop
endif
	@echo 
	@echo "-- DONE ------"
    
build: $(VERILATOR_INPUT_FILES)
	@echo
	@echo "-- VERILATE ------ verilog -> cpp & -- BUILD ----- build cpp -> executable"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT_FILES)

gtkwave:
	gtkwave --rcvar 'fontname_signals Monospace 13' --rcvar 'fontname_waves Monospace 13' $(LOGS_DIR)/top_dump.vcd $(UTIL_DIR)/gtkwave_signals_config.gtkw &

synth: $(VERILOG_SRC_FILES)
	@echo
	@echo "-- Run Sythesis with yosys ------"
	@rm -rf $(SYNTH_OUTPUT_DIR)
	@mkdir $(SYNTH_OUTPUT_DIR)
	yosys -p "read_verilog $(VERILOG_SRC_FILES); synth_ecp5 -json $(SYNTH_OUTPUT_DIR)/synth.json"
clean:
	rm -rf obj_dir *.log *.dmp *.vpd core $(LOGS_DIR) $(SYNTH_OUTPUT_DIR)

root_dir := $(PWD)
src_dir := ./src
inc_dir := ./include
sim_dir := ./sim

FSDB_DEF :=
    ifeq ($(FSDB),1)
    FSDB_DEF := +FSDB
    else ifeq ($(FSDB),2)
    FSDB_DEF := +FSDB_ALL
    endif

$(bld_dir):
    mkdir -p $(bld_dir)

# RTL simulation
rtl0: | $(bld_dir)
    cd $(bld_dir); \
    irun $(root_dir)/$(sim_dir)/top_tb.sv \
    +incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(inc_dir)+$(root_dir)/$(sim_dir) \
    +access+r \
    +nc64bit \

# Utilities
nWave: | $(bld_dir)
    cd $(bld_dir); \
    nWave top.fsdb &

superlint: | $(bld_dir)
    cd $(bld_dir); \
    jg -superlint ../script/superlint.tcl &

.PHONY: clean
clean:
	rm -rf $(bld_dir);

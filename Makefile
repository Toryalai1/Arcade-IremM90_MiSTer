QUARTUS_DIR = C:/intelFPGA_lite/17.0/quartus/bin64
PROJECT = Arcade-IremM90
CONFIG = Arcade-IremM90-Fast
MISTER = root@mister-dev
OUTDIR = output_files

RBF = $(OUTDIR)/$(CONFIG).rbf

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRCS = \
	$(call rwildcard,sys,*.v *.sv *.vhd *.vhdl *.qip *.sdc) \
	$(call rwildcard,rtl,*.v *.sv *.vhd *.vhdl *.qip *.sdc) \
	$(wildcard *.sdc *.v *.sv *.vhd *.vhdl *.qip)

all: run

$(RBF): $(SRCS)
	$(QUARTUS_DIR)/quartus_sh --flow compile $(PROJECT) -c $(CONFIG)

deploy.done: $(RBF)
	scp $(RBF) $(MISTER):/media/fat/_Arcade/cores/IremM90.rbf
	echo done > deploy.done

deploy: deploy.done

run: deploy.done 
	ssh $(MISTER) "echo load_core _Arcade/m90.mra > /dev/MiSTer_cmd"

.PHONY: all run deploy
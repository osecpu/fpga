SRCS=osecpu.v \
	alu.v ireg.v preg.v labeltable.v \
	led7seg.v datapath.v controller.v \
	mmu.v addrdec.v blockram.v
TOPMODULE=osecpu

DIR_QBIN=~/intelFPGA_lite/17.0/quartus/bin

default:
	$(DIR_QBIN)/quartus_map $(TOPMODULE)
	$(DIR_QBIN)/quartus_fit $(TOPMODULE)
	$(DIR_QBIN)/quartus_asm $(TOPMODULE)


i: $(SRCS) Makefile
	iverilog -Wall -s OSECPU -o $(TOPMODULE).out  $(SRCS)

vcd: $(SRCS) testbench.v Makefile
	iverilog -Wall -o testbench.out -s testbench $(SRCS) testbench.v
	vvp testbench.out

lspgm:
	$(DIR_QBIN)/quartus_pgm -l

install:
	$(DIR_QBIN)/quartus_pgm -c 1 -m jtag -o P\;output_files/$(TOPMODULE).sof@1

resetpgm:
	-killall jtagd
	sudo $(DIR_QBIN)/jtagd

clean:
	-rm -r db/ incremental_db/
	-rm *.rpt
	-rm *.jdi
	-rm *.summary
	-rm *.pin
	-rm *.out
	-rm *.sld
	-rm *.sof

log:
	-cat $(TOPMODULE).map.summary






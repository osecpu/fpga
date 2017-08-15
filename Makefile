COMMON_SRCS=osecpu.v \
		 alu.v ireg.v preg.v labeltable.v \
		 led7seg.v memory.v datapath.v controller.v mmu.v addrdec.v

TEST_SRCS=testbench.v $(COMMON_SRCS)
TOP_SRCS=top.v $(COMMON_SRCS)
TOPMODULE=osecpu

.PHONY: run test

DIR_QBIN=~/intelFPGA_lite/17.0/quartus/bin

default:
	$(DIR_QBIN)/quartus_map osecpu
	$(DIR_QBIN)/quartus_fit osecpu
	$(DIR_QBIN)/quartus_asm osecpu

testbench.out : $(TEST_SRCS) rom.hex Makefile
	iverilog -Wall -o $*.out -s testbench $(TEST_SRCS)

check:
	iverilog -Wall -o check.out -s check check.v
	vvp check.out

clean:
	-rm *.out
	-rm *.vcd

run:
	make testbench.vcd
	open testbench.vcd

testall:
	make test_addrdec

test:
	-rm testbench.vcd
	make testbench.vcd

vcd:
	make test
	open testbench.vcd

test_addrdec :
	make addrdec.vcd
test_mmu :
	make mmu.vcd

%.out : %.v Makefile
	iverilog -Wall -o $*.out -s testbench_$* $*.v

MMU_SRCS=mmu.v labeltable.v addrdec.v
mmu.out : $(MMU_SRCS) Makefile
	iverilog -Wall -o mmu.out -s testbench_mmu $(MMU_SRCS)

%.vcd : %.out Makefile
	vvp $*.out

reset_blaster :
	-killall jtagd
	sudo ~/intelFPGA_lite/17.0/quartus/bin/jtagd

install:
	$(DIR_QBIN)/quartus_pgm -c 1 -m jtag -o P\;$(TOPMODULE).sof@1

resetpgm:
	-killall jtagd
	sudo $(DIR_QBIN)/jtagd

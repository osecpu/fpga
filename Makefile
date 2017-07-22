COMMON_SRCS=osecpu.v \
		 alu.v ireg.v preg.v labeltable.v \
		 led7seg.v memory.v datapath.v controller.v

TEST_SRCS=testbench.v $(COMMON_SRCS)
TOP_SRCS=top.v $(COMMON_SRCS)


.PHONY: run test

testbench.out : $(TEST_SRCS) rom.hex Makefile
	iverilog -Wtimescale -o $*.out -s testbench $(TEST_SRCS)

check:
	iverilog -Wtimescale -o check.out -s check check.v
	vvp check.out

clean:
	-rm *.out
	-rm *.vcd

run:
	make testbench.vcd
	open testbench.vcd
	
test:
	-rm testbench.vcd
	make testbench.vcd

test_addrdec :
	make memctrl.vcd

%.out : %.v Makefile
	iverilog -o $*.out -s testbench_$* $*.v

%.vcd : %.out Makefile
	vvp $*.out

reset_blaster :
	-killall jtagd
	sudo ~/intelFPGA_lite/17.0/quartus/bin/jtagd

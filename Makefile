TOP_SRCS=top.v alu.v ireg.v led7seg.v memory.v

.PHONY: run

top.out : $(TOP_SRCS) rom.hex Makefile
	iverilog -o $*.out -s testbench_$* $(TOP_SRCS)

run:
	make top.vcd

%.out : %.v Makefile
	iverilog -o $*.out -s testbench_$* $*.v


%.vcd : %.out Makefile
	vvp $*.out
	open $*.vcd

reset_blaster :
	killall jtagd
	sudo ~/intelFPGA_lite/17.0/quartus/bin/jtagd

TOP_SRCS=top.v ireg.v led7seg.v memory.v

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



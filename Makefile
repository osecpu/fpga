TOP_SRCS=top.v ireg.v led7seg.v

top.out : $(TOP_SRCS) Makefile
	iverilog -o $*.out -s testbench_$* $(TOP_SRCS)

%.out : %.v Makefile
	iverilog -o $*.out -s testbench_$* $*.v


%.vcd : %.out Makefile
	vvp $*.out
	open $*.vcd



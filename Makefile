
%.out : %.v Makefile
	iverilog -o $*.out -s testbench $*.v


%.vcd : %.out Makefile
	vvp $*.out
	open $*.vcd



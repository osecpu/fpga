SRCS = testbench.v

testbench : $(SRCS) Makefile
	iverilog -o testbench $(SRCS)

test : testbench
	vvp testbench

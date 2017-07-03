TOP_SRCS=testbench.v osecpu.v \
		 alu.v ireg.v preg.v labeltable.v \
		 led7seg.v memory.v datapath.v controller.v

.PHONY: run test

top.out : $(TOP_SRCS) rom.hex Makefile
	iverilog -Wtimescale -o $*.out -s testbench $(TOP_SRCS)

clean:
	-rm *.out
	-rm *.vcd

run:
	make top.vcd
	open top.vcd
	
test:
	make top.vcd

%.out : %.v Makefile
	iverilog -o $*.out -s testbench_$* $*.v


%.vcd : %.out Makefile
	vvp $*.out

reset_blaster :
	killall jtagd
	sudo ~/intelFPGA_lite/17.0/quartus/bin/jtagd

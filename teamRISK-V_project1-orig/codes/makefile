all:CPU.out

CPU.out: CPU.v
	iverilog -o CPU.out *.v

run:
	vvp CPU.out
view:
	gtkwave CPU.vcd
clean: 
	del -f CPU.out

include Verilate.mk

regs:
	peakrdl regblock regs.rdl -o regblock/ --cpuif apb3-flat
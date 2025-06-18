include Verilate.mk

regs:
	peakrdl regblock regs.rdl -o regblock/ --cpuif apb3-flat

# UVM-SystemC targets with automatic path detection
uvm_systemc: 
	@echo "Configuring UVM-SystemC paths..."
	@bash scripts/configure_uvm_paths.sh
	@echo "Running UVM-SystemC simulation..."
	@fusesoc run --target=uvm_systemc_sim emin::router

# Legacy target for manual environment setup
uvm_systemc_manual:
	@echo "Running UVM-SystemC simulation with manual environment..."
	@echo "Make sure UVM_SYSTEMC_HOME and SYSTEMC_HOME are set if needed"
	fusesoc run --target=uvm_systemc_sim emin::router
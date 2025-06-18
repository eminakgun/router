# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build System and Commands

This project uses FuseSoC for RTL development and SystemC/SystemVerilog testbenches. Key commands:

```bash
# Setup environment
make                    # Create venv and install dependencies
make init              # Initialize FuseSoC library
source venv/bin/activate  # Activate virtual environment

# Build and simulate
make build             # Build default target using Verilator
make sim              # Run SystemVerilog simulation with coverage/tracing
make systemc_sim      # Run SystemC simulation

# Register generation
make regs             # Generate register RTL from SystemRDL (uses peakrdl)

# Cleanup
make clean            # Remove build artifacts
make distclean        # Clean everything including venv
```

## Architecture Overview

This is a **4-channel AXI Stream router** with APB configuration interface:

- **APB Interface**: Configuration and control via register map at regblock/router_regs.sv
- **AXI Stream Channels**: 4 data channels supporting Mux/Demux/Broadcast modes
- **Priority-Based Routing**: Dynamic channel priority assignment
- **Packet Format**: Custom 56-bit packets (Header|Source|Dest|Payload|CRC)

### Key Components

- `regs.rdl`: SystemRDL register definitions → generates regblock/ files
- `router.core`: FuseSoC core file defining build targets and filesets
- `tb/`: SystemC testbenches (router_tb.cpp, testbench_sc.cpp)
- `dv/apb-sc-uvm/`: APB agent submodule for SystemC UVM
- `regblock/`: Generated SystemVerilog register files

### Register Map (APB)

- 0x00: CHANNEL_ENABLE - Enable/disable 4 channels
- 0x04: MODE - Routing mode (Mux/Demux/Broadcast)  
- 0x08: PRIORITY - 2-bit priority per channel
- 0x0C: PACKET_COUNT - Per-channel packet counters (read-only)

### Build Targets

- `default`: Basic Verilator build with router_tb.cpp
- `sim`: Simulation with coverage, tracing, and assertions
- `systemc_sim`: SystemC mode with testbench_sc.cpp

The project is in Phase-1 development focusing on register DUT verilation and SystemC testbench integration.
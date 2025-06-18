# router

## Project Overview

This project implements a **router** that bridges an **APB configuration interface** and **AXI Stream data channels**. The router dynamically routes packets between multiple AXI Stream channels based on priorities and configurations set via the APB interface. The design is verified using **UVM testbenches in SystemC and SystemVerilog**, with a register interface generated using **PeakRDL**.

## Key Features

- **4-Channel AXI Stream Router**: Supports Mux, Demux, and Broadcast modes.
- **APB Configuration**: Configure channel priorities, enable/disable channels, and monitor packet counts.
- **Custom Packet Format**:  
  ```plaintext
  [Header (8b) | Source (4b) | Destination (4b) | Payload (32b) | CRC (8b)]
  ```
- **Priority-Based Routing**: Assign dynamic priorities to channels.
- **Register Interface**: Generated using **SystemRDL** and **PeakRDL**.
- **UVM Testbenches**: Implemented in both SystemC and SystemVerilog.

---

## Project Structure
```
.
├── rtl/                     # RTL code for the router DUT
│   ├── router.sv            # Router module (SystemVerilog)
│   └── router.cpp           # Router module (SystemC)
├── tb/                      # UVM testbenches
│   ├── uvm_sv/              # SystemVerilog testbench
│   └── uvm_sc/              # SystemC testbench
├── regs/                    # SystemRDL register definitions
│   └── router_regs.rdl      # Register map description
├── scripts/                 # Simulation and codegen scripts
│   ├── run_sim.sh           # Run simulations
│   └── generate_regs.py     # Generate RTL from PeakRDL
└── docs/                    # Documentation
    └── register_map.md      # Register map details
```

## Getting Started

### Prerequisites

- SystemC and SystemVerilog simulator (e.g., QuestaSim, VCS, or Xcelium).
- UVM library (for SystemVerilog and SystemC).
- Python 3.x and PeakRDL (`pip install peakrdl`).

### Build & Run

1. **Generate Register Interface**:

   ```bash
   peakrdl systemverilog regs/router_regs.rdl --output-dir rtl/regs
   ```

2. **Compile and Simulate**:

   ```bash
   # Basic SystemC testbench
   make systemc_sim
   
   # UVM SystemC testbench with APB agent (requires UVM-SystemC)
   source venv/bin/activate
   fusesoc run --target=uvm_systemc_sim emin::router
   
   # Legacy targets (for reference)
   # SystemVerilog: cd tb/uvm_sv && make compile && make run
   # SystemC: cd tb/uvm_sc && make compile && make run
   ```

## Register Map

| Address | Register Name    | Description                          |
|---------|------------------|--------------------------------------|
| 0x00    | `CHANNEL_ENABLE` | Enable/disable channels (4 bits).    |
| 0x04    | `MODE`           | Routing mode (Mux/Demux/Broadcast).  |
| 0x08    | `PRIORITY`       | Channel priorities (8 bits).         |
| 0x0C    | `PACKET_COUNT`   | Packet counts per channel (32 bits). |

---

## Custom Packet Format

```systemverilog
typedef struct packed {
    logic [7:0]  header;
    logic [3:0]  source;
    logic [3:0]  destination;
    logic [31:0] payload;
    logic [7:0]  crc;
} axi_stream_packet_t;
```

## Current Status

### Phase-1 Progress ✅
The project has successfully completed the initial phase of router verification infrastructure:

- **✅ UVM-SystemC Integration**: APB agent successfully compiled and integrated with UVM-SystemC framework
- **✅ Verilated DUT**: Router register block properly verilated and connected to SystemC testbench  
- **✅ Hello-World Test**: Basic APB sequence implemented that stimulates router registers:
  - CHANNEL_ENABLE (0x00) - Enable/disable 4 channels
  - MODE (0x04) - Routing mode configuration
  - PRIORITY (0x08) - Channel priority settings
  - PACKET_COUNT (0x0C) - Packet counter readback

### Available Build Targets
```bash
# Basic Verilator build
make build

# SystemC simulation  
make systemc_sim

# UVM SystemC testbench with APB agent
fusesoc run --target=uvm_systemc_sim emin::router
```

### Next Steps
- **Priority 1**: Fix APB virtual interface connection and agent configuration for full UVM sequence execution
- **Priority 2**: Generate RAL (Register Abstraction Layer) for enhanced register access  
- **Priority 3**: Implement comprehensive test sequences using RAL

## TODO

### Phase-1

- [X] Verilate register dut, use FuseSoC core files to verilate
- [X] Create top level testbench in SystemC which instantiates the verilated DUT
- [X] Include APB agent and compile top level SystemC testbench, use proper UVM architecture
- [X] Write a hello-world like app that runs a APB sequence to stimulate some registers
- [ ] **[HIGH PRIORITY]** Fix APB virtual interface connection and agent configuration for full UVM sequence execution
- [ ] Generate RAL for SystemC, use PeakRDL generated SV-UVM code to translate to UVM-SC
- [ ] Write first sequence to program the DUT and observe DUT outputs!
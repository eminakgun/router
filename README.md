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
   # SystemVerilog
   cd tb/uvm_sv
   make compile && make run

   # SystemC
   cd tb/uvm_sc
   make compile && make run
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

## TODO

### Phase-1

- [X] Verilate register dut, use FuseSoC core files to verilate
- [X] Create top level testbench in SystemC which instantiates the verilated DUT
- [ ] Include APB agent and compile top level testbench, i.e run a APB sequence
- [ ] Generate RAL for SystemC, use PeakRDL generated SV-UVM code to translate to UVM-SC
- [ ] Write first sequence to program the DUT and observe DUT outputs!

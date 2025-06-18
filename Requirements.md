# Router Project Requirements

## System Requirements

1. The system shall implement a router that bridges an APB configuration interface and AXI Stream data channels.
2. The router shall support 4 AXI Stream channels.
3. The router shall dynamically route packets between multiple AXI Stream channels.
4. The routing shall be based on priorities and configurations set via the APB interface.

## Functional Requirements

### Routing Capabilities

1. The router shall support Mux mode (many-to-one routing).
2. The router shall support Demux mode (one-to-many routing).
3. The router shall support Broadcast mode (one-to-all routing).
4. The router shall implement priority-based routing between channels.
5. The router shall allow dynamic assignment of priorities to channels.

### Packet Handling

1. The router shall support a custom packet format with the following fields:
   - Header (8 bits)
   - Source (4 bits)
   - Destination (4 bits)
   - Payload (32 bits)
   - CRC (8 bits)
2. The router shall maintain packet counts per channel.

## Interface Requirements

### APB Interface

1. The router shall provide an APB configuration interface.
2. The APB interface shall allow configuration of channel priorities.
3. The APB interface shall allow enabling/disabling of channels.
4. The APB interface shall provide access to packet count monitoring.

### AXI Stream Interface

1. The router shall implement 4 AXI Stream channels.
2. The AXI Stream channels shall conform to the AXI Stream protocol specification.

## Register Map Requirements

1. The router shall implement the following registers:
   - CHANNEL_ENABLE (Address 0x00): Enable/disable channels (4 bits)
   - MODE (Address 0x04): Routing mode selection (Mux/Demux/Broadcast)
   - PRIORITY (Address 0x08): Channel priorities (8 bits)
   - PACKET_COUNT (Address 0x0C): Packet counts per channel (32 bits)

## Implementation Requirements

1. The router shall be implemented in both SystemVerilog (router.sv) and SystemC (router.cpp).
2. The register interface shall be generated using SystemRDL and PeakRDL.

## Verification Requirements

1. The router shall be verified using UVM testbenches.
2. UVM testbenches shall be implemented in both SystemVerilog and SystemC.
3. The verification environment shall include:
   - APB agent for configuration interface testing
   - RAL (Register Abstraction Layer) for SystemC
   - Sequences to program the DUT and observe outputs

## Development Phase Requirements

### Phase-1
1. Verilate register DUT using FuseSoC core files.
2. Create top level testbench in SystemC which instantiates the verilated DUT.
3. Include APB agent and compile top level testbench (run an APB sequence).
4. Generate RAL for SystemC using PeakRDL generated SV-UVM code translated to UVM-SC.
5. Write first sequence to program the DUT and observe DUT outputs.

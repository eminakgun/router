#!/bin/bash
# run_uvm_systemc.sh - Run UVM-SystemC simulation with auto-detected paths

set -e

# Source the path detection
source "$(dirname "$0")/setup_uvm_paths.sh"

echo "=== Running UVM-SystemC Simulation ==="
echo "Using detected paths:"
echo "  UVM-SystemC Include: $UVM_SYSTEMC_INC"
echo "  UVM-SystemC Library: $UVM_SYSTEMC_LIB"  
echo "  SystemC Include: $SYSTEMC_INC_PATH"
echo "  SystemC Library: $SYSTEMC_LIB_PATH"
echo ""

# Create temporary core file with resolved paths
TEMP_CORE=$(mktemp router_resolved.core.XXXXXX)
trap "rm -f $TEMP_CORE" EXIT

# Generate the resolved core file by substituting environment variables
sed "s|\${UVM_SYSTEMC_INC:-/usr/local/uvm-systemc/include}|$UVM_SYSTEMC_INC|g; \
     s|\${SYSTEMC_INC_PATH:-/usr/local/include}|$SYSTEMC_INC_PATH|g; \
     s|\${SYSTEMC_LIB_PATH:-/usr/local/lib}|$SYSTEMC_LIB_PATH|g; \
     s|\${UVM_SYSTEMC_LIB:-/usr/local/uvm-systemc/lib}|$UVM_SYSTEMC_LIB|g" \
     router.core > "$TEMP_CORE"

echo "Generated resolved core file: $TEMP_CORE"

# Copy the resolved core file to the expected location
cp "$TEMP_CORE" router.core.resolved

# Run FuseSoC with the resolved configuration
echo "Running FuseSoC..."
fusesoc run --target=uvm_systemc_sim emin::router

echo "Simulation completed!"
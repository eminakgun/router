#!/bin/bash
# configure_uvm_paths.sh - Configure router.core with detected UVM-SystemC paths

set -e

# Get the script directory
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source the path detection
source "$SCRIPT_DIR/setup_uvm_paths.sh"

echo "=== Configuring UVM-SystemC Paths ==="
echo "Updating router.core with detected paths:"
echo "  UVM-SystemC Include: $UVM_SYSTEMC_INC"
echo "  UVM-SystemC Library: $UVM_SYSTEMC_LIB"  
echo "  SystemC Include: $SYSTEMC_INC_PATH"
echo "  SystemC Library: $SYSTEMC_LIB_PATH"
echo ""

# Create backup of original router.core
if [[ ! -f "$PROJECT_ROOT/router.core.backup" ]]; then
    echo "Creating backup: router.core.backup"
    cp "$PROJECT_ROOT/router.core" "$PROJECT_ROOT/router.core.backup"
fi

# Update router.core with resolved paths
sed -i.tmp \
    -e "s|\${UVM_SYSTEMC_INC:-[^}]*}|$UVM_SYSTEMC_INC|g" \
    -e "s|\${SYSTEMC_INC_PATH:-[^}]*}|$SYSTEMC_INC_PATH|g" \
    -e "s|\${SYSTEMC_LIB_PATH:-[^}]*}|$SYSTEMC_LIB_PATH|g" \
    -e "s|\${UVM_SYSTEMC_LIB:-[^}]*}|$UVM_SYSTEMC_LIB|g" \
    "$PROJECT_ROOT/router.core"

# Remove the temporary file
rm -f "$PROJECT_ROOT/router.core.tmp"

echo "✓ router.core updated successfully!"
echo ""
echo "Now you can run: fusesoc run --target=uvm_systemc_sim emin::router"
echo "To restore original: cp router.core.backup router.core"
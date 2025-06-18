#!/bin/bash
# setup_uvm_paths.sh - Detect SystemC and UVM-SystemC installation paths
# This script provides scalable path detection for different user environments

set -e

# Function to find library paths
find_library_path() {
    local lib_name="$1"
    local search_paths=(
        "/usr/local/lib"
        "/usr/lib/x86_64-linux-gnu" 
        "/usr/lib64"
        "/opt/systemc/lib"
        "/opt/homebrew/lib"
        "${HOME}/.local/lib"
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -f "${path}/${lib_name}" ]]; then
            echo "${path}"
            return 0
        fi
    done
    return 1
}

# Function to find include paths  
find_include_path() {
    local header_name="$1"
    local search_paths=(
        "/usr/local/include"
        "/usr/include"
        "/opt/systemc/include"
        "/opt/homebrew/include" 
        "${HOME}/.local/include"
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -f "${path}/${header_name}" ]] || [[ -d "${path}/${header_name}" ]]; then
            echo "${path}"
            return 0
        fi
    done
    return 1
}

# Function to find UVM-SystemC installation
find_uvm_systemc() {
    local search_paths=(
        "/usr/local/uvm-systemc"
        "/opt/uvm-systemc"
        "/usr/local"
        "${HOME}/.local/uvm-systemc"
        "${HOME}/uvm-systemc"
    )
    
    for path in "${search_paths[@]}"; do
        if [[ -f "${path}/lib/libuvm-systemc.so" ]] || [[ -f "${path}/lib/libuvm-systemc.a" ]]; then
            echo "${path}"
            return 0
        fi
    done
    return 1
}

echo "=== UVM-SystemC Path Detection ==="

# 1. Check environment variables first (highest priority)
if [[ -n "${UVM_SYSTEMC_HOME}" ]]; then
    echo "✓ Using UVM_SYSTEMC_HOME: ${UVM_SYSTEMC_HOME}"
    UVM_HOME="${UVM_SYSTEMC_HOME}"
elif [[ -n "${UVM_SYSTEMC_ROOT}" ]]; then
    echo "✓ Using UVM_SYSTEMC_ROOT: ${UVM_SYSTEMC_ROOT}" 
    UVM_HOME="${UVM_SYSTEMC_ROOT}"
else
    # Auto-detect UVM-SystemC installation
    echo "→ Auto-detecting UVM-SystemC installation..."
    UVM_HOME=$(find_uvm_systemc)
    if [[ -n "${UVM_HOME}" ]]; then
        echo "✓ Found UVM-SystemC at: ${UVM_HOME}"
    else
        echo "✗ UVM-SystemC not found in standard locations"
        echo "  Please set UVM_SYSTEMC_HOME environment variable"
        exit 1
    fi
fi

# 2. Check SystemC paths
if [[ -n "${SYSTEMC_HOME}" ]]; then
    echo "✓ Using SYSTEMC_HOME: ${SYSTEMC_HOME}"
    SYSTEMC_LIB="${SYSTEMC_HOME}/lib"
    SYSTEMC_INC="${SYSTEMC_HOME}/include"
else
    # Auto-detect SystemC
    echo "→ Auto-detecting SystemC installation..."
    SYSTEMC_LIB=$(find_library_path "libsystemc.so")
    SYSTEMC_INC=$(find_include_path "systemc")
    
    if [[ -n "${SYSTEMC_LIB}" && -n "${SYSTEMC_INC}" ]]; then
        echo "✓ Found SystemC lib: ${SYSTEMC_LIB}"
        echo "✓ Found SystemC include: ${SYSTEMC_INC}"
    else
        echo "✗ SystemC not found in standard locations"
        echo "  Please set SYSTEMC_HOME environment variable"
        exit 1
    fi
fi

# 3. Verify paths exist
echo "→ Verifying installation..."
if [[ ! -d "${UVM_HOME}/lib" ]]; then
    echo "✗ UVM-SystemC lib directory not found: ${UVM_HOME}/lib"
    exit 1
fi

if [[ ! -d "${UVM_HOME}/include" ]]; then
    echo "✗ UVM-SystemC include directory not found: ${UVM_HOME}/include"
    exit 1
fi

if [[ ! -d "${SYSTEMC_LIB}" ]]; then
    echo "✗ SystemC lib directory not found: ${SYSTEMC_LIB}"
    exit 1
fi

if [[ ! -d "${SYSTEMC_INC}" ]]; then
    echo "✗ SystemC include directory not found: ${SYSTEMC_INC}"
    exit 1
fi

# 4. Export results for use by build system
echo "→ Exporting paths..."
export UVM_SYSTEMC_LIB="${UVM_HOME}/lib"
export UVM_SYSTEMC_INC="${UVM_HOME}/include"
export SYSTEMC_LIB_PATH="${SYSTEMC_LIB}"
export SYSTEMC_INC_PATH="${SYSTEMC_INC}"

echo "✓ All paths verified successfully!"
echo ""
echo "Exported environment variables:"
echo "  UVM_SYSTEMC_LIB=${UVM_SYSTEMC_LIB}"
echo "  UVM_SYSTEMC_INC=${UVM_SYSTEMC_INC}" 
echo "  SYSTEMC_LIB_PATH=${SYSTEMC_LIB_PATH}"
echo "  SYSTEMC_INC_PATH=${SYSTEMC_INC_PATH}"
echo ""
echo "Usage: source scripts/setup_uvm_paths.sh && fusesoc run --target=uvm_systemc_sim emin::router"
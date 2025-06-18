# Configuration
VENV_DIR := venv
PYTHON := python3
PIP := pip3
FUSESOC := $(VENV_DIR)/bin/fusesoc

# Colors for terminal output
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
.PHONY: all
all: venv

# Create and setup virtual environment
$(VENV_DIR)/bin/activate:
	@echo "$(GREEN)Creating virtual environment...$(NC)"
	@$(PYTHON) -m venv $(VENV_DIR)
	@echo "$(GREEN)Upgrading pip...$(NC)"
	@$(VENV_DIR)/bin/pip install --upgrade pip
	@echo "$(GREEN)Installing requirements...$(NC)"
	@$(VENV_DIR)/bin/pip install -r requirements.txt
	@echo "$(GREEN)Virtual environment created successfully!$(NC)"

# Activate virtual environment
.PHONY: activate
activate: venv
	@echo "$(GREEN)To activate the virtual environment, run:$(NC)"
	@echo "source $(VENV_DIR)/bin/activate"

.PHONY: venv
venv: $(VENV_DIR)/bin/activate

# Initialize fusesoc library
.PHONY: init
init: venv
	@echo "$(GREEN)Initializing FuseSoC library...$(NC)"
	@. $(VENV_DIR)/bin/activate && fusesoc library add router .

# Build target
.PHONY: build
build: init
	@echo "$(GREEN)Building project...$(NC)"
	@. $(VENV_DIR)/bin/activate && fusesoc run --build --target=default router

# Run simulation
.PHONY: sim
sim: venv
	@echo "$(GREEN)Running simulation...$(NC)"
	@. $(VENV_DIR)/bin/activate && fusesoc run --target=sim router

# Run SystemC simulation
.PHONY: systemc_sim
systemc_sim: init
	@echo "$(GREEN)Running SystemC simulation...$(NC)"
	@. $(VENV_DIR)/bin/activate && fusesoc run --target=systemc_sim router

# Clean build artifacts
.PHONY: clean
clean:
	@echo "$(RED)Cleaning build artifacts...$(NC)"
	@rm -rf build/
	@rm -rf fusesoc_libraries/
	@rm -f fusesoc.conf

# Clean everything including virtual environment
.PHONY: distclean
distclean: clean
	@echo "$(RED)Removing virtual environment...$(NC)"
	@rm -rf $(VENV_DIR)

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make          - Create virtual environment and install dependencies"
	@echo "  make init     - Initialize FuseSoC library"
	@echo "  make build    - Build the project"
	@echo "  make sim      - Run simulation"
	@echo "  make clean    - Remove build artifacts"
	@echo "  make distclean- Remove build artifacts and virtual environment"
	@echo "  make help     - Show this help message"
# FIFO Verification Project

## Overview

This project implements a parameterized synchronous FIFO (First-In-First-Out) module in SystemVerilog along with a comprehensive UVM (Universal Verification Methodology) testbench for verification. The project demonstrates industry-standard verification practices and serves as a learning platform for SystemVerilog design and UVM verification.

## Features

- **Parameterized FIFO Design:** Configurable data width and depth  
- **Synchronous Operation:** Single clock domain design  
- **Standard FIFO Interface:** Write enable, read enable, data ports, and status flags  
- **Comprehensive UVM Testbench:** Complete verification environment with sequences, drivers, monitors, and scoreboard  
- **Multiple Test Scenarios:** Random operations, fill/empty tests, and boundary condition testing  

## File Structure
fifo_verification/
├── rtl/
│ └── fifo.sv # Synthesizable FIFO module
├── tb/
│ ├── fifo_env.sv # UVM environment
│ ├── fifo_driver.sv # UVM driver for stimulus generation
│ ├── fifo_monitor.sv # UVM monitor for signal observation
│ ├── fifo_scoreboard.sv # UVM scoreboard for checking
│ ├── fifo_sequence.sv # UVM sequences and transaction class
│ └── fifo_test.sv # UVM test classes and testbench top
├── sim/
│ └── run.do # ModelSim/Questa simulation script
└── README.md # This file

## FIFO Module Specifications

- **Default Parameters:** 8-bit data width, 16-entry depth  
- **Ports:**  
  - `clk`: Clock input  
  - `rst_n`: Active-low reset  
  - `wr_en`: Write enable  
  - `rd_en`: Read enable  
  - `data_in[7:0]`: Input data  
  - `data_out[7:0]`: Output data  
  - `full`: FIFO full flag  
  - `empty`: FIFO empty flag  

## UVM Testbench Components

- **Transaction Class (`fifo_transaction`):**  
  Encapsulates all FIFO interface signals with randomization constraints for realistic stimulus  

- **Sequences:**  
  - Random Sequence: Generates randomized read/write operations  
  - Fill Sequence: Tests FIFO full condition  
  - Empty Sequence: Tests FIFO empty condition  

- **Driver (`fifo_driver`):**  
  Drives stimulus to the FIFO interface and handles timing and protocol requirements  

- **Monitor (`fifo_monitor`):**  
  Observes FIFO interface signals and broadcasts transactions to the scoreboard  

- **Scoreboard (`fifo_scoreboard`):**  
  Implements reference model, checks data integrity and status flags, and provides comprehensive test reporting  

- **Environment (`fifo_env`):**  
  Instantiates and connects all verification components and manages overall verification flow  

- **Tests:**  
  - Base Test: Foundation for all test cases  
  - Random Test: Basic randomized operations  
  - Comprehensive Test: Multiple test scenarios in sequence  

## How to Run

### Prerequisites

- ModelSim/Questa Sim or compatible SystemVerilog simulator  
- UVM library support  

### Simulation Steps

1. Navigate to the simulation directory:

   ```bash
   cd sim/

2. Run the simulation using the provided script
bash
vsim -do run.do

3. Alternatively, compile and run manually:

# Compile RTL
```bash
vlog -sv +incdir+../tb ../rtl/fifo.sv

# Compile testbench
```bash
vlog -sv +incdir+../tb +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv ../tb/fifo_test.sv

# Run simulation
vsim -c fifo_tb_top +UVM_TESTNAME=fifo_comprehensive_test
run -all

# Expected Output
- Transaction logging with detailed FIFO operations
- Scoreboard reports showing write/read counts
- Pass/fail status with error summary
- Waveform file (fifo_waves.vcd) for debugging

# Test Scenarios
- Random Operations: Mixed read/write operations with randomized data
- Fill Test: Continuously write until FIFO is full, verify full flag
- Empty Test: Continuously read until FIFO is empty, verify empty flag
- Boundary Conditions: Test simultaneous read/write operations
- Data Integrity: Verify FIFO ordering (first-in, first-out)


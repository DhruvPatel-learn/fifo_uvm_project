# FIFO Verification Project

## Overview

This project implements a parameterized synchronous FIFO (First-In-First-Out) module in SystemVerilog along with a comprehensive UVM (Universal Verification Methodology) testbench for verification. The project demonstrates industry-standard verification practices and serves as a learning platform for SystemVerilog design and UVM verification.

## Features

- **Parameterized FIFO Design**: Configurable data width and depth
- **Synchronous Operation**: Single clock domain design
- **Standard FIFO Interface**: Write enable, read enable, data ports, and status flags
- **Comprehensive UVM Testbench**: Complete verification environment with sequences, drivers, monitors, and scoreboard
- **Multiple Test Scenarios**: Random operations, fill/empty tests, and boundary condition testing

## File Structure

```
fifo_verification/
│
├── rtl/
│   └── fifo.sv                     # Synthesizable FIFO module
│
├── tb/
│   ├── fifo_env.sv                 # UVM environment
│   ├── fifo_driver.sv              # UVM driver for stimulus generation
│   ├── fifo_monitor.sv             # UVM monitor for signal observation
│   ├── fifo_scoreboard.sv          # UVM scoreboard for checking
│   ├── fifo_sequence.sv            # UVM sequences and transaction class
│   └── fifo_test.sv                # UVM test classes and testbench top
│
├── sim/
│   └── run.do                      # ModelSim/Questa simulation script
│
└── README.md                       # This file
```

### File Descriptions

| Directory | File | Description |
|-----------|------|-------------|
| `rtl/` | `fifo.sv` | Parameterized synchronous FIFO RTL module |
| `tb/` | `fifo_env.sv` | UVM environment containing all verification components |
| `tb/` | `fifo_driver.sv` | UVM driver for generating stimulus to DUT |
| `tb/` | `fifo_monitor.sv` | UVM monitor for observing DUT interface signals |
| `tb/` | `fifo_scoreboard.sv` | UVM scoreboard for checking and reporting results |
| `tb/` | `fifo_sequence.sv` | UVM sequences and transaction definitions |
| `tb/` | `fifo_test.sv` | UVM test classes and testbench top module |
| `sim/` | `run.do` | ModelSim/Questa simulation automation script |
| `/` | `README.md` | Project documentation and usage instructions |

## FIFO Module Specifications

- **Default Parameters**: 8-bit data width, 16-entry depth
- **Ports**:
  - `clk`: Clock input
  - `rst_n`: Active-low reset
  - `wr_en`: Write enable
  - `rd_en`: Read enable
  - `data_in[7:0]`: Input data
  - `data_out[7:0]`: Output data
  - `full`: FIFO full flag
  - `empty`: FIFO empty flag

## UVM Testbench Components

### Transaction Class (`fifo_transaction`)
- Encapsulates all FIFO interface signals
- Includes randomization constraints for realistic stimulus

### Sequences
- **Random Sequence**: Generates randomized read/write operations
- **Fill Sequence**: Tests FIFO full condition
- **Empty Sequence**: Tests FIFO empty condition

### Driver (`fifo_driver`)
- Drives stimulus to the FIFO interface
- Handles timing and protocol requirements

### Monitor (`fifo_monitor`)
- Observes FIFO interface signals
- Broadcasts transactions to scoreboard

### Scoreboard (`fifo_scoreboard`)
- Implements reference model
- Checks data integrity and status flags
- Provides comprehensive test reporting

### Environment (`fifo_env`)
- Instantiates and connects all verification components
- Manages the overall verification flow

### Tests
- **Base Test**: Foundation for all test cases
- **Random Test**: Basic randomized operations
- **Comprehensive Test**: Multiple test scenarios in sequence

## How to Run

### Prerequisites
- ModelSim/Questa Sim or compatible SystemVerilog simulator
- UVM library support

### Simulation Steps

1. **Navigate to simulation directory**:
   ```bash
   cd sim/
   ```

2. **Run the simulation**:
   ```bash
   vsim -do run.do
   ```

3. **Alternative manual compilation**:
   ```bash
   # Compile RTL
   vlog -sv +incdir+../tb ../rtl/fifo.sv
   
   # Compile testbench
   vlog -sv +incdir+../tb +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv ../tb/fifo_test.sv
   
   # Run simulation
   vsim -c fifo_tb_top +UVM_TESTNAME=fifo_comprehensive_test
   run -all
   ```

### Expected Output
- Transaction logging with detailed FIFO operations
- Scoreboard reports showing write/read counts
- Pass/fail status with error summary
- Waveform file (`fifo_waves.vcd`) for debugging

## Test Scenarios

1. **Random Operations**: Mixed read/write operations with randomized data
2. **Fill Test**: Continuously write until FIFO is full, verify full flag
3. **Empty Test**: Continuously read until FIFO is empty, verify empty flag
4. **Boundary Conditions**: Test simultaneous read/write operations
5. **Data Integrity**: Verify FIFO ordering (first-in, first-out)

## Customization

### FIFO Parameters
To modify FIFO specifications, edit the parameters in `rtl/fifo.sv`:
```systemverilog
parameter int DATA_WIDTH = 8,    // Change data width
parameter int DEPTH = 16,        // Change FIFO depth
```

### Test Configuration
Modify test behavior in `tb/fifo_test.sv`:
```systemverilog
seq.num_transactions = 200;     // Adjust number of operations
```

### Sequence Constraints
Customize operation probabilities in `tb/fifo_sequence.sv`:
```systemverilog
constraint c_operations {
    wr_en dist {1 := 7, 0 := 3};  // 70% write probability
    rd_en dist {1 := 5, 0 := 5};  // 50% read probability
}
```

## Debugging Tips

1. **Enable Verbose Logging**:
   ```bash
   +UVM_VERBOSITY=UVM_HIGH
   ```

2. **View Waveforms**:
   ```bash
   gtkwave fifo_waves.vcd
   ```

3. **Check Scoreboard Output**:
   - Look for "SCOREBOARD SUMMARY" in simulation log
   - Verify write/read counts match expectations
   - Check for any error messages

## Learning Objectives

This project helps understand:

- **SystemVerilog RTL Design**: Parameterized modules, always blocks, memory inference
- **UVM Methodology**: Component hierarchy, phases, analysis ports
- **Verification Planning**: Test scenarios, coverage, checking strategies
- **Interface Design**: Timing, protocols, status signaling
- **Debug Techniques**: Waveform analysis, logging, error tracking

## Common Issues and Solutions

### Compilation Errors
- Ensure UVM library path is correctly set
- Check file inclusion order in testbench
- Verify SystemVerilog syntax compatibility

### Simulation Hangs
- Check reset timing and polarity
- Verify clock generation
- Ensure proper phase objection handling

### Data Mismatches
- Review FIFO pointer logic
- Check timing of read/write operations
- Verify scoreboard reference model

## Extensions and Improvements

Possible enhancements for advanced learning:

1. **Coverage Collection**: Add functional and code coverage
2. **Assertion-Based Verification**: Implement SVA properties
3. **Clock Domain Crossing**: Add asynchronous FIFO variant
4. **Protocol Compliance**: Add AXI-Stream or Avalon interfaces
5. **Performance Analysis**: Add throughput and latency measurements
6. **Constrained Random**: More sophisticated sequence constraints
7. **Register Model**: UVM register layer for configuration

## References

- **UVM User Guide**: Accellera UVM 1.2 Class Reference
- **SystemVerilog LRM**: IEEE Std 1800-2017
- **Verification Methodology**: "Writing Testbenches using SystemVerilog" by Janick Bergeron

## Contact Information

For questions, suggestions, or contributions: Dhruv.Patel@unb.ca
- Create issues in the project repository
- Review code comments for implementation details
- Extend test scenarios for additional learning

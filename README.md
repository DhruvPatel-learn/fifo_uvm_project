# SystemVerilog FIFO with UVM Verification

This repository contains a SystemVerilog FIFO module along with a UVM testbench developed as a self-driven learning project to practice RTL design and verification methodologies.

## Project Overview

- Parameterized FIFO buffer designed in SystemVerilog
- Full UVM testbench including driver, monitor, scoreboard, and sequences
- Test scenarios cover normal operation and edge cases like underflow, overflow, and reset
- Functional coverage implemented to ensure verification completeness

## How to Run

The simulation can be run using any standard SystemVerilog simulator supporting UVM (e.g., QuestaSim, VCS, ModelSim). Use the provided simulator script in the `sim` folder to compile and run.

## File Structure

- `rtl/fifo.sv`: FIFO RTL module  
- `tb/`: UVM testbench components and test definitions  
- `sim/run.do`: Simulation script for compiling and running tests

## Contact

For questions or suggestions, please reach out Dhruv.Patel@unb.ca



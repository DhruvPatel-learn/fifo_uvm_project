# ==============================================================================
# File: sim/run.do
# Description: ModelSim/Questa simulation script for FIFO verification
# ==============================================================================

# Create work library
if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# Set UVM home directory (modify path as needed)
# Uncomment and modify the following line based on your UVM installation
# set UVM_HOME "/path/to/uvm"

# Compile RTL files
echo "Compiling RTL files..."
vlog -sv +incdir+../tb \
     ../rtl/fifo.sv

# Compile UVM package and testbench files
echo "Compiling UVM testbench..."
vlog -sv +incdir+../tb \
     +incdir+$UVM_HOME/src \
     $UVM_HOME/src/uvm_pkg.sv \
     ../tb/fifo_test.sv

# Check for compilation errors
if {[llength [vlog -list]] == 0} {
    echo "ERROR: Compilation failed!"
    quit -f
}

# Load design
echo "Loading design..."
vsim -t ps \
     -voptargs=+acc \
     +UVM_TESTNAME=fifo_comprehensive_test \
     +UVM_VERBOSITY=UVM_MEDIUM \
     fifo_tb_top

# Add waves to waveform viewer
echo "Adding signals to waveform..."
add wave -divider "Clock and Reset"
add wave /fifo_tb_top/clk
add wave /fifo_tb_top/rst_n

add wave -divider "FIFO Interface"
add wave /fifo_tb_top/dut_if/wr_en
add wave /fifo_tb_top/dut_if/rd_en
add wave -hex /fifo_tb_top/dut_if/data_in
add wave -hex /fifo_tb_top/dut_if/data_out
add wave /fifo_tb_top/dut_if/full
add wave /fifo_tb_top/dut_if/empty

add wave -divider "FIFO Internal"
add wave -unsigned /fifo_tb_top/dut/wr_ptr
add wave -unsigned /fifo_tb_top/dut/rd_ptr
add wave -unsigned /fifo_tb_top/dut/count
add wave -hex /fifo_tb_top/dut/mem

# Configure waveform display
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0

# Run simulation
echo "Starting simulation..."
run -all

# Zoom to fit waveform
wave zoom full

echo ""
echo "=== Simulation Summary ==="
echo "Check the transcript for test results and scoreboard summary."
echo "Use 'wave zoom full' to view complete waveform."
echo "Waveform file 'fifo_waves.vcd' has been generated."
echo ""

# Keep ModelSim open for waveform analysis
# Uncomment the following line to automatically quit after simulation
# quit -sim

// ==============================================================================
// File: tb/fifo_test.sv
// Description: UVM Test classes and testbench top module
// ==============================================================================

// Interface definition
interface fifo_if (
    input logic clk,
    input logic rst_n
);
    logic        wr_en;
    logic        rd_en;
    logic [7:0]  data_in;
    logic [7:0]  data_out;
    logic        full;
    logic        empty;
endinterface

// Base test class
class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    fifo_env m_env;

    function new(string name = "fifo_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_env = fifo_env::type_id::create("m_env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass

// Random test
class fifo_random_test extends fifo_base_test;
    `uvm_component_utils(fifo_random_test)

    function new(string name = "fifo_random_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_random_sequence seq;
        
        phase.raise_objection(this);
        
        seq = fifo_random_sequence::type_id::create("seq");
        seq.num_transactions = 200;
        seq.start(m_env.m_driver.sequencer);
        
        #1000; // Additional delay
        
        phase.drop_objection(this);
    endtask

endclass

// Comprehensive test
class fifo_comprehensive_test extends fifo_base_test;
    `uvm_component_utils(fifo_comprehensive_test)

    function new(string name = "fifo_comprehensive_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fifo_fill_sequence   fill_seq;
        fifo_empty_sequence  empty_seq;
        fifo_random_sequence random_seq;
        
        phase.raise_objection(this);
        
        `uvm_info("FIFO_TEST", "Starting comprehensive test...", UVM_LOW)
        
        // Fill FIFO test
        `uvm_info("FIFO_TEST", "Running fill sequence...", UVM_LOW)
        fill_seq = fifo_fill_sequence::type_id::create("fill_seq");
        fill_seq.start(m_env.m_driver.sequencer);
        
        #100;
        
        // Empty FIFO test
        `uvm_info("FIFO_TEST", "Running empty sequence...", UVM_LOW)
        empty_seq = fifo_empty_sequence::type_id::create("empty_seq");
        empty_seq.start(m_env.m_driver.sequencer);
        
        #100;
        
        // Random operations test
        `uvm_info("FIFO_TEST", "Running random sequence...", UVM_LOW)
        random_seq = fifo_random_sequence::type_id::create("random_seq");
        random_seq.num_transactions = 300;
        random_seq.start(m_env.m_driver.sequencer);
        
        #1000;
        
        `uvm_info("FIFO_TEST", "Comprehensive test completed", UVM_LOW)
        phase.drop_objection(this);
    endtask

endclass

// Testbench top module
module fifo_tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // Include all verification files
    `include "fifo_sequence.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"
    `include "fifo_scoreboard.sv"
    `include "fifo_env.sv"

    // Clock and reset generation
    logic clk = 0;
    logic rst_n = 0;
    
    always #5 clk = ~clk; // 100MHz clock
    
    initial begin
        rst_n = 0;
        #50;
        rst_n = 1;
    end

    // Interface instantiation
    fifo_if dut_if(.clk(clk), .rst_n(rst_n));

    // DUT instantiation
    fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16)
    ) dut (
        .clk(dut_if.clk),
        .rst_n(dut_if.rst_n),
        .wr_en(dut_if.wr_en),
        .rd_en(dut_if.rd_en),
        .data_in(dut_if.data_in),
        .data_out(dut_if.data_out),
        .full(dut_if.full),
        .empty(dut_if.empty)
    );

    // Test execution
    initial begin
        // Set interface in config database
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", dut_if);
        
        // Run test
        run_test("fifo_comprehensive_test");
    end

    // Waveform dump
    initial begin
        $dumpfile("fifo_waves.vcd");
        $dumpvars(0, fifo_tb_top);
    end

    // Timeout
    initial begin
        #100000;
        `uvm_fatal("FIFO_TB", "Test timeout!")
    end

endmodule

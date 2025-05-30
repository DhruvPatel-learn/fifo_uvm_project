// ==============================================================================
// File: tb/fifo_scoreboard.sv
// Description: UVM Scoreboard for FIFO verification
// ==============================================================================

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // Analysis export for receiving transactions
    uvm_analysis_export #(fifo_transaction) analysis_export;
    
    // Internal FIFO model
    logic [7:0] expected_fifo[$];
    int write_count;
    int read_count;
    int error_count;

    function new(string name = "fifo_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
        write_count = 0;
        read_count = 0;
        error_count = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void write(fifo_transaction trans);
        check_transaction(trans);
    endfunction

    function void check_transaction(fifo_transaction trans);
        logic expected_full, expected_empty;
        logic [7:0] expected_data_out;
        
        // Update expected FIFO state based on transaction
        if (trans.wr_en && !trans.full) begin
            expected_fifo.push_back(trans.data_in);
            write_count++;
            `uvm_info("FIFO_SB", $sformatf("Write: data=0x%h, fifo_size=%0d", trans.data_in, expected_fifo.size()), UVM_MEDIUM)
        end
        
        if (trans.rd_en && !trans.empty && expected_fifo.size() > 0) begin
            expected_data_out = expected_fifo.pop_front();
            read_count++;
            `uvm_info("FIFO_SB", $sformatf("Read: expected_data=0x%h, actual_data=0x%h, fifo_size=%0d", 
                     expected_data_out, trans.data_out, expected_fifo.size()), UVM_MEDIUM)
            
            // Check data integrity
            if (expected_data_out !== trans.data_out) begin
                `uvm_error("FIFO_SB", $sformatf("Data mismatch! Expected: 0x%h, Actual: 0x%h", 
                          expected_data_out, trans.data_out))
                error_count++;
            end
        end
        
        // Check status flags
        expected_full = (expected_fifo.size() >= 16); // Assuming DEPTH=16
        expected_empty = (expected_fifo.size() == 0);
        
        if (trans.full !== expected_full) begin
            `uvm_error("FIFO_SB", $sformatf("Full flag mismatch! Expected: %b, Actual: %b, FIFO size: %0d", 
                      expected_full, trans.full, expected_fifo.size()))
            error_count++;
        end
        
        if (trans.empty !== expected_empty) begin
            `uvm_error("FIFO_SB", $sformatf("Empty flag mismatch! Expected: %b, Actual: %b, FIFO size: %0d", 
                      expected_empty, trans.empty, expected_fifo.size()))
            error_count++;
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("FIFO_SB", "=== SCOREBOARD SUMMARY ===", UVM_LOW)
        `uvm_info("FIFO_SB", $sformatf("Total Writes: %0d", write_count), UVM_LOW)
        `uvm_info("FIFO_SB", $sformatf("Total Reads: %0d", read_count), UVM_LOW)
        `uvm_info("FIFO_SB", $sformatf("Total Errors: %0d", error_count), UVM_LOW)
        
        if (error_count == 0) begin
            `uvm_info("FIFO_SB", "*** TEST PASSED ***", UVM_LOW)
        end else begin
            `uvm_error("FIFO_SB", "*** TEST FAILED ***")
        end
    endfunction

endclass

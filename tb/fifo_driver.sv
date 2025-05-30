// ==============================================================================
// File: tb/fifo_driver.sv
// Description: UVM Driver for FIFO verification
// ==============================================================================

class fifo_driver extends uvm_driver #(fifo_transaction);
    `uvm_component_utils(fifo_driver)

    // Virtual interface handle
    virtual fifo_if vif;

    function new(string name = "fifo_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get virtual interface from config database
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("FIFO_DRIVER", "Virtual interface not found in config database")
        end
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction trans;
        
        // Initialize signals
        vif.wr_en   <= 0;
        vif.rd_en   <= 0;
        vif.data_in <= 0;
        
        // Wait for reset deassertion
        wait(vif.rst_n);
        @(posedge vif.clk);
        
        forever begin
            // Get next transaction from sequencer
            seq_item_port.get_next_item(trans);
            
            // Drive transaction
            drive_transaction(trans);
            
            // Signal completion
            seq_item_port.item_done();
        end
    endtask

    task drive_transaction(fifo_transaction trans);
        @(posedge vif.clk);
        
        // Drive signals based on transaction
        vif.wr_en   <= trans.wr_en;
        vif.rd_en   <= trans.rd_en;
        vif.data_in <= trans.data_in;
        
        `uvm_info("FIFO_DRIVER", 
                  $sformatf("Driving: wr_en=%b, rd_en=%b, data_in=%h", 
                           trans.wr_en, trans.rd_en, trans.data_in), UVM_HIGH)
        
        // Hold for one clock cycle
        @(posedge vif.clk);
        
        // Clear control signals
        vif.wr_en <= 0;
        vif.rd_en <= 0;
    endtask

endclass

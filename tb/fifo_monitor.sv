// ==============================================================================
// File: tb/fifo_monitor.sv
// Description: UVM Monitor for FIFO verification
// ==============================================================================

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    // Virtual interface handle
    virtual fifo_if vif;
    
    // Analysis port for broadcasting transactions
    uvm_analysis_port #(fifo_transaction) mon_analysis_port;

    function new(string name = "fifo_monitor", uvm_component parent = null);
        super.new(name, parent);
        mon_analysis_port = new("mon_analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Get virtual interface from config database
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("FIFO_MONITOR", "Virtual interface not found in config database")
        end
    endfunction

    task run_phase(uvm_phase phase);
        fifo_transaction trans;
        
        // Wait for reset deassertion
        wait(vif.rst_n);
        
        forever begin
            @(posedge vif.clk);
            
            // Create new transaction
            trans = fifo_transaction::type_id::create("trans");
            
            // Sample interface signals
            sample_transaction(trans);
            
            // Send transaction to analysis port
            mon_analysis_port.write(trans);
        end
    endtask

    task sample_transaction(fifo_transaction trans);
        trans.wr_en    = vif.wr_en;
        trans.rd_en    = vif.rd_en;
        trans.data_in  = vif.data_in;
        trans.data_out = vif.data_out;
        trans.full     = vif.full;
        trans.empty    = vif.empty;
        
        `uvm_info("FIFO_MONITOR", 
                  $sformatf("Monitored: wr_en=%b, rd_en=%b, data_in=%h, data_out=%h, full=%b, empty=%b", 
                           trans.wr_en, trans.rd_en, trans.data_in, trans.data_out, trans.full, trans.empty), 
                  UVM_HIGH)
    endtask

endclass

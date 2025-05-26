// ==============================================================================
// File: tb/fifo_env.sv
// Description: UVM Environment for FIFO verification
// ==============================================================================

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    // Environment components
    fifo_driver     m_driver;
    fifo_monitor    m_monitor;
    fifo_scoreboard m_scoreboard;
    
    // Analysis port connection
    uvm_analysis_port #(fifo_transaction) mon_analysis_port;

    function new(string name = "fifo_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create components
        m_driver     = fifo_driver::type_id::create("m_driver", this);
        m_monitor    = fifo_monitor::type_id::create("m_monitor", this);
        m_scoreboard = fifo_scoreboard::type_id::create("m_scoreboard", this);
        
        `uvm_info("FIFO_ENV", "Build phase completed", UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect monitor to scoreboard
        m_monitor.mon_analysis_port.connect(m_scoreboard.analysis_export);
        
        `uvm_info("FIFO_ENV", "Connect phase completed", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("FIFO_ENV", "Run phase started", UVM_LOW)
    endtask

endclass

// ==============================================================================
// File: tb/fifo_sequence.sv
// Description: UVM Sequences for FIFO verification
// ==============================================================================

// Base transaction class
class fifo_transaction extends uvm_sequence_item;
    `uvm_object_utils(fifo_transaction)

    // Transaction fields
    rand bit        wr_en;
    rand bit        rd_en;
    rand bit [7:0]  data_in;
    bit [7:0]       data_out;
    bit             full;
    bit             empty;

    // Constraints
    constraint c_operations {
        wr_en dist {1 := 7, 0 := 3};  // 70% write probability
        rd_en dist {1 := 5, 0 := 5};  // 50% read probability
    }

    function new(string name = "fifo_transaction");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field_int("wr_en",    wr_en,    1);
        printer.print_field_int("rd_en",    rd_en,    1);
        printer.print_field_int("data_in",  data_in,  8);
        printer.print_field_int("data_out", data_out, 8);
        printer.print_field_int("full",     full,     1);
        printer.print_field_int("empty",    empty,    1);
    endfunction

endclass

// Base sequence class
class fifo_base_sequence extends uvm_sequence #(fifo_transaction);
    `uvm_object_utils(fifo_base_sequence)

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

endclass

// Basic random sequence
class fifo_random_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_random_sequence)

    int num_transactions = 100;

    function new(string name = "fifo_random_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction trans;
        
        repeat(num_transactions) begin
            trans = fifo_transaction::type_id::create("trans");
            start_item(trans);
            if (!trans.randomize()) begin
                `uvm_error("FIFO_SEQ", "Randomization failed")
            end
            finish_item(trans);
        end
    endtask

endclass

// Fill FIFO sequence
class fifo_fill_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_fill_sequence)

    function new(string name = "fifo_fill_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction trans;
        
        // Fill the FIFO
        repeat(20) begin  // More than FIFO depth to test full condition
            trans = fifo_transaction::type_id::create("trans");
            start_item(trans);
            trans.wr_en = 1;
            trans.rd_en = 0;
            if (!trans.randomize() with {wr_en == 1; rd_en == 0;}) begin
                `uvm_error("FIFO_SEQ", "Randomization failed")
            end
            finish_item(trans);
        end
    endtask

endclass

// Empty FIFO sequence
class fifo_empty_sequence extends fifo_base_sequence;
    `uvm_object_utils(fifo_empty_sequence)

    function new(string name = "fifo_empty_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_transaction trans;
        
        // Empty the FIFO
        repeat(20) begin  // More than FIFO depth to test empty condition
            trans = fifo_transaction::type_id::create("trans");
            start_item(trans);
            if (!trans.randomize() with {wr_en == 0; rd_en == 1;}) begin
                `uvm_error("FIFO_SEQ", "Randomization failed")
            end
            finish_item(trans);
        end
    endtask

endclass

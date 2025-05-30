// ==============================================================================
// File: rtl/fifo.sv
// Description: Parameterized synchronous FIFO module
// ==============================================================================

module fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 16,
    parameter int ADDR_WIDTH = $clog2(DEPTH)
) (
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    wr_en,
    input  logic                    rd_en,
    input  logic [DATA_WIDTH-1:0]   data_in,
    output logic [DATA_WIDTH-1:0]   data_out,
    output logic                    full,
    output logic                    empty
);

    // Internal signals
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [ADDR_WIDTH:0]   wr_ptr;
    logic [ADDR_WIDTH:0]   rd_ptr;
    logic [ADDR_WIDTH:0]   count;

    // Pointer management
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
            count  <= '0;
        end else begin
            // Write operation
            if (wr_en && !full) begin
                wr_ptr <= wr_ptr + 1;
                count  <= count + 1;
            end
            
            // Read operation
            if (rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1;
                count  <= count - 1;
            end
            
            // Simultaneous read and write
            if (wr_en && rd_en && !full && !empty) begin
                count <= count; // Count remains same
            end
        end
    end

    // Memory write
    always_ff @(posedge clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
        end
    end

    // Memory read
    assign data_out = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // Status flags
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule

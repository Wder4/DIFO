module LIFO #(
    parameter DATA_BITS  = 32,
    parameter LIFO_DEPTH = 4,
    parameter TOP_BITS   = 3
)(
    input                        clk, rst,
    input                        enb_i,
    input                        clr_i, 
    input                        push_i, pop_i,
    input        [DATA_BITS-1:0] datain_i,
    output logic [DATA_BITS-1:0] dataout_o,
    output logic                 full_o,
    output logic                 empty_o
);

    integer i;
    logic [DATA_BITS-1:0] mem [LIFO_DEPTH-1:0];
    logic [TOP_BITS -1:0] top;
    
    assign empty_o = ~|top;
    assign full_o  = top == LIFO_DEPTH; 
    assign dataout_o = pop_i && ~empty_o ? mem[top] : {(DATA_BITS){1'bx}};

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < LIFO_DEPTH; i++)
                mem[i] <= {(DATA_BITS){1'b0}};
        end
        else if (clr_i) begin
            for (i = 0; i < LIFO_DEPTH; i++)
                mem[i] <= {(DATA_BITS){1'b0}};
        end
        else if (enb_i && push_i && ~full_o) begin
            mem[top] <= datain_i;
        end
    end
    // top
    always_ff @(posedge clk or posedge rst) begin
        if (rst)                  top <= {(TOP_BITS){1'b0}};
        else if (clr_i)           top <= {(TOP_BITS){1'b0}};
        else if (enb_i && push_i) top <= top + {{TOP_BITS-1}{1'b0}, 1'b1};
        else if (enb_i && pop_i)  top <= top - {{TOP_BITS-1}{1'b0}, 1'b1};
    end

endmodule

module receiver (
    input clk,
    input rstn,
    output ready,
    output [6:0] data_out,
    output parity_ok_n,
    input serial_in
);

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin

        end else begin
            
        end
    end
    

endmodule
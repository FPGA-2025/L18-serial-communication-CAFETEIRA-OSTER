module transmitter (
    input clk,
    input rstn,
    input start,
    input [6:0] data_in,
    output reg serial_out
);

    localparam S0 = 2'b00, S1 = 2'b01;
    reg [1:0] state;
    reg [2:0] n;
    reg paridade; 

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            serial_out = 1'b1;
            state = S0;
            n = 0;
            paridade = 0;
        end else begin
            case(state)
                S0: begin
                    serial_out <= 1;
                    n = 0;
                    if (start) begin
                        paridade = ^data_in;
                        state = S1;
                        serial_out <= 0; //att
                    end
                end
                S1: begin
                    if (n < 7) begin
                        serial_out <= data_in[n];//att
                        n = n + 1;
                    end else begin
                        serial_out <= paridade;//att
                        state = S0;
                    end
                end
                default: state = S0;
            endcase
        end
    end
endmodule
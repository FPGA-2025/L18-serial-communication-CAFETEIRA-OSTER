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
            serial_out <= 1'b1;
            state <= S0;
        end else begin
            paridade <= ^data_in[6:0];
            if (start) begin
                serial_out <= 0;
                state <= S1;
            end else begin
                case(state)
                    S0: begin
                        serial_out = 1;
                        n = 0;
                    end
                    S1: begin
                        // Verifica se o LSB é 1
                        if (n < 7) begin
                            if (data_in[n] == 1'b1) begin
                                serial_out = 1;           
                            end else begin
                                serial_out = 0;
                            end
                            n = n + 1;
                        end else begin
                            if (paridade) begin
                                serial_out = 1;
                            end else begin
                                serial_out = 0;
                            end
                            state = S0;
                        end
                    end
                    default: state <= S0;
                endcase
            end
        end
    end
endmodule
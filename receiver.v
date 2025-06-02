module receiver (
    input clk,
    input rstn,
    output wire ready,
    output wire [6:0] data_out,
    output wire parity_ok_n,
    input serial_in
);

    assign parity_ok_n = parity_ok_n_reg;
    assign data_out = receptor;
    assign ready = ready_reg;

    localparam S0 = 2'b00, S1 = 2'b01; 

    reg [1:0] state;
    reg [6:0] receptor;
    reg [2:0] n;
    reg paridade;
    reg parity_ok_n_reg;
    reg ready_reg;


    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            receptor[6:0] = 7'b0000000;
            state = S0;
            n = 0;
        end else begin
            case(state) 
                S0: begin
                    if (!serial_in) begin
                        state = S1;
                    end
                end
                S1: begin
                    if (n < 7) begin
                        if (serial_in) begin
                            receptor[6:0] = (receptor[6:0] << 1) | 1'b1;
                            n = n + 1;
                        end else begin
                            receptor[6:0] = receptor[6:0] << 1 | 1'b0;
                            n = n + 1;
                        end
                    end else begin
                        ready_reg = 1;
                        paridade = ^receptor[6:0];
                        if (paridade == serial_in) begin
                            parity_ok_n_reg = 0;
                        end else begin
                            parity_ok_n_reg = 1;
                        end
                        state = S0;
                    end
                end
                default: state = S0;
            endcase
        end
    end
endmodule
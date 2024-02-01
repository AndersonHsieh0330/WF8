`default_nettype none
`timescale 1ps/1ps
module pipline_register #(
    parameter WIDTH = 1
) (
    input  wire             clk, 
    input  wire             reset,
    input  wire [WIDTH-1:0] in,
    output reg  [WIDTH-1:0] out
); 

always @(posedge clk) begin
    if (reset) begin
        out <= {WIDTH{1'b0}};
    end else begin
        out <= in;
    end
end

endmodule
`default_nettype none
`timescale 1ps/1ps
// instruction memory
module imemory (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] addr_in,
    output reg  [7:0] data_out
);
(* ram_style = "block"*) reg [7:0] mem [`LINE_COUNT-1:0];

initial begin
    $readmemb(`MEM_PATH, mem);
end

always @(posedge clk) begin
    if (reset) begin
        data_out <= 8'b0;
    end else begin
        data_out <= mem[addr_in];
    end
end
endmodule
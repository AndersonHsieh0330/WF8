`default_nettype none
`timescale 1ps/1ps
// data memory, single port memory
module dmemory (
    input  wire       clk,
    input  wire       reset,
    input  wire       write_en, // if not writing we're reading
    input  wire [7:0] addr_in,
    input  wire [7:0] data_in,
    input  wire [7:0] memory_mapped_io_addr_in,
    output wire [7:0] memory_mapped_io_data_out,
    output reg  [7:0] data_out
);
(* ram_style = "block"*) reg [7:0] mem [255:`LINE_COUNT];

always @(posedge clk) begin
    if (reset) begin
        data_out <= 8'b0;
    end else if (write_en) begin
        mem[addr_in] <= data_in;
    end else begin
        data_out <= mem[addr_in];
    end
end
endmodule
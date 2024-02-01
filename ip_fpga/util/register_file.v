`default_nettype none
`timescale 1ps/1ps
module register_file (
    // need at most 1 read and 1 write port, ISA spec
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] write_data_in,
    input  wire [2:0] write_addr_in, // write to this address
    input  wire       write_en,
    input  wire [2:0] read_addr_in,  // read value at this address
    output wire [7:0] reg_b_out,     // note that reg_acc can be reg_b as well
    output wire [7:0] reg_acc_out
);

reg [7:0] registers [7:0];

assign reg_b_out = registers[read_addr_in];
assign reg_acc_out = registers[7];

// note there we do not have a dedicated register for value 0
// cuz 8 registers is already not a lot and we need the extra register
// plus we won't need to reset the register that often due to the accumulator design
integer i;
always @(posedge clk) begin
    if (reset) begin
        for (i = 0 ; i < 8 ; i = i + 1) begin
            registers[i] <= 8'b0;
        end
    end else begin
        if (write_en) begin
            registers[write_addr_in] <= write_data_in;
        end
    end
end

endmodule
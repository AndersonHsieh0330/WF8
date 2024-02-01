// Register Read Write Select
`default_nettype none
module reg_rw_sel (
    input  wire [2:0] reg_b_addr,
    input  wire       reg_b_read_en,
    input  wire       reg_b_write_en,
    output wire [7:0] x_read_en,
    output wire [7:0] x_write_en
);

assign x_write_en = (8'b00000001 & {7'b0000000, reg_b_write_en}) << reg_b_addr;
assign x_read_en = (8'b00000001 & {7'b0000000, reg_b_read_en}) << reg_b_addr;

endmodule

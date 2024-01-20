// Register Read Write Select
`default_nettype none
module reg_rw_sel (
    input  wire [2:0] reg_b_addr,
    input  wire       reg_b_read_en,
    input  wire       reg_b_write_en,
    output wire [7:0] read_en,
    output wire [7:0] write_en
);

assign write_en = (8'b00000001 & reg_b_write_en) << reg_b_addr;
assign read_en = (8'b00000001 & reg_b_read_en) << reg_b_addr;

endmodule

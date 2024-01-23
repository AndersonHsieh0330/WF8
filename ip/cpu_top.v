`default_nettype none
module cput_top (
    input wire clk,
    input wire rst
);

/*
* wire names are prefixed by whatever module generates the signal
*/
wire [7:0] cpu_bus;

register_top register_insts (
    .clk(clk),
    .rst(rst),
    .cpu_bus(cpu_bus),
    .write_en(),
    .read_en(),
    .reg_acc_in(),
    .reg_acc_out()
);

wire [7:0] alu_a_in;
wire [7:0] alu_b_in;
wire [7:0] pc;
wire [7:0] reg_acc;
wire [7:0] imm;

assign alu_a_in = alu_a_sel ? pc : reg_acc;
assign alu_b_in = alu_b_sel ? cpu_bus : imm;
alu alu_inst (
    .a(alu_a_in),
    .b(alu_b_in),
    .alu_mode(),
    .c(),
    .alu_flags()
);

wire [7:0]                 opcode;
wire [`ALU_MODE_COUNT-1:0] control_alu_mode;
wire                       control_reg_b_write_en
wire                       control_alu_a_sel;
wire                       control_alu_b_sel;
wire                       control_mem_write_en;

control control_inst (
    .opcode(ram_insn[7:4]),
    .alu_mode(control_alu_mode),
    .reg_b_write_en(control_reg_b_write_en),
    .alu_a_sel(control_alu_a_sel),  
    .alu_b_sel(control_alu_b_sel),  
    .mem_write_en(control_mem_write_en)
);

wire [7:0] insn;
wire [3:0] decode_imm_out;
wire [2:0] decode_reg_b

insn_decoder decode_inst (
    .insn(ram_insn),
    .imm_out(decode_imm_out),
    .reg_bl(decode_reg_b)
);

wire [7:0] reg_xxx_read_en;
wire [7:0] reg_xxx_write_en;
reg_rw_sel reg_rw_sel_inst (
	.reg_b_addr(decode_reg_b),
	.reg_b_read_en(control_),
	.reg_b_write_en(control_reg_b_write_en),
	.read_en(reg_xxx_read_en),
	.write_en(reg_xxx_write_en)
);

wire [7:0] ram_insn;
wire [7:0] ram_out;
ram ram_inst (
    .clk(clk),
    .rst(rst),
    .addr_in_port_1(pc), 
    .addr_in_port_2(cpu_bus),
    .data_in_port_1(cpu_bus),
    .write_en(control_mem_write_en),
    .data_out_port_1(ram_insn),
    .data_out_port_2(ram_out),
);

endmodule

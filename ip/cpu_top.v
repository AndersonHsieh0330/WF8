`default_nettype none
module cput_top (
    input wire clk,
    input wire rst
);

/*
* wire names are prefixed by whatever module generates the signal
*/
wire [7:0] cpu_bus;
wire [7:0] reg_acc;

wire [7:0] pc;
wire [7:0] pc_in;

wire [7:0] alu_a;
wire [7:0] alu_b;
wire [7:0] alu_c;

wire [`BC_FLAG_COUNT-1:0] bc_flags;

wire [`ALU_MODE_COUNT-1:0] control_alu_mode;
wire                       control_reg_b_write_en
wire                       control_reg_b_read_en
wire                       control_alu_a_sel;
wire                       control_alu_b_sel;
wire                       control_mem_write_en;

wire [3:0] decode_imm_out;
wire [2:0] decode_reg_b

wire [7:0] reg_x_read_en;
wire [7:0] reg_x_write_en;

wire [7:0] ram_insn;
wire [7:0] ram_out;

wire [7:0] reg_rw_sel_x_read_en;
wire [7:0] reg_rw_sel_x_write_en;

register_top register_insts (
    .clk(clk),
    .rst(rst),
    .cpu_bus(cpu_bus),
    .x_write_en(reg_rw_sel_x_write_en),
    .x_read_en(reg_rw_sel_x_read_en),
    .reg_acc_in(alu_c),
    .reg_acc_out(reg_acc)
);
 
// +1 pc adder + pc_sel mux
assign pc_in = bd_pc_sel ? cpu_bus : pc + 1;

register_no_r_w_en pc_inst (
	.clk(clk),
	.rst(rst),
	.reg_in(pc_in),
	.reg_out(pc)
);

assign alu_a = alu_a_sel ? pc : reg_acc;
assign alu_b = alu_b_sel ? decode_imm_out : cpu_bus;
alu alu_inst (
    .a(alu_a),
    .b(alu_b),
    .alu_mode(control_alu_mode),
    .c(alu_c)
);

branch_compare (
	.a(reg_acc),
	.b(cpu_bus), // reg_b
	.bc_flags(bc_flags)
);

wire bd_pc_sel;
branch_decision (
	.opcode(ram_insn[7:3]),
	.bc_flags(bc_flags),
	.pc_sel(bd_pc_sel)
);

control control_inst (
    .opcode(ram_insn[7:4]),
    .alu_mode(control_alu_mode),
    .reg_b_write_en(control_reg_b_write_en),
	.reg_b_read_en(control_reg_b_read_en),
    .alu_a_sel(control_alu_a_sel),  
    .alu_b_sel(control_alu_b_sel),  
    .mem_write_en(control_mem_write_en)
);

insn_decoder decode_inst (
    .insn(ram_insn),
    .imm_out(decode_imm_out),
    .reg_bl(decode_reg_b)
);

reg_rw_sel reg_rw_sel_inst (
	.reg_b_addr(decode_reg_b),
	.reg_b_read_en(control_),
	.reg_b_write_en(control_reg_b_write_en),
	.read_en(reg_x_read_en),
	.write_en(reg_x_write_en)
);

ram ram_inst (
    .clk(clk),
    .rst(rst),
    .addr_in_port_1(pc), 
    .addr_in_port_2(cpu_bus),
    .data_in_port_1(cpu_bus),
    .write_en(control_mem_write_en),
    .data_out_port_1(ram_insn),
    .data_out_port_2(ram_out)
);

reg_rw_sel reg_rw_sel_inst (
	.reg_b_addr(decode_reg_b),
	.reg_b_read_en(control_reg_b_read_en),
	.reg_b_write_en(control_reg_b_write_en),
	.x_read_en(reg_rw_sel_x_read_en),
	.x_write_en(reg_rw_sel_x_write_en)
);

endmodule

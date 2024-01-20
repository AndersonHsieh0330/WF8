`default_nettype none
module cput_top (
    input wire clk,
    input wire reset
);

/*
* wire names are prefixed by whatever module generates the signal
*/
wire [7:0] cpu_bus;

register_top register_insts (
    .clk(clk),
    .reset(reset),
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
    .opcode(),
    .alu_mode(control_alu_mode),
    .reg_b_write_en(control_reg_b_write_en),
    .alu_a_sel(control_alu_a_sel),  
    .alu_b_sel(control_alu_b_sel),  
    .mem_write_en(control_mem_write_en)
);

wire [7:0] insn,
wire [7:0] decode_imm_out,
wire [7:0] decode_reg_out 

insn_decoder decode_inst (
    .insn(),
    .imm_out(decode_imm_out),
    .reg_out(decode_reg_out)
);

wire [7:0] insn;
ram ram_inst (
    .clk(clk),
    .reset(reset),
    .addr_in_port_1(), 
    .addr_in_port_2(),
    .data_in_port_1(cpu_bus),
    .write_en(control_mem_write_en),
    .data_out_port_1(insn),
    .data_out_port_2(),

);
wire data_out_port_2,
wire data_out_port_1,

endmodule

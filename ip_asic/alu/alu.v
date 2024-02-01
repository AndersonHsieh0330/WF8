`include "/ip/util/params.vh"
`default_nettype none
`timescale 1ps/1ps
module alu 
#(
	parameter BIT_COUNT = 8
)
(
	input  wire [BIT_COUNT-1:0] 	  a, // reg_acc or PC
	input  wire [BIT_COUNT-1:0] 	  b, // reg x0 ~ x6 or immediate value
	input  wire [`ALU_MODE_COUNT-1:0] alu_mode,
	output wire [BIT_COUNT-1:0] 	  c
);
wire [3:0] imm;
assign imm = b[3:0];

//--- add, addi
wire [BIT_COUNT-1:0] adder_input;
wire [BIT_COUNT-1:0] adder_output;
wire 				 adder_cout;
adder adder_inst(
	.a(a),
	.b(b), 
	.sum(adder_output),
	.cout(adder_cout) // temporary
);

//--- sh, shi
wire [BIT_COUNT-1:0] shifter_output;
shifter shifter_inst (
	.shift_in(a),
	.shift_amount(b),
	.shift_out(shifter_output)
);

//--- not
wire [BIT_COUNT-1:0] isa_not_result;
assign isa_not_result = ~a;

//--- and
wire [BIT_COUNT-1:0] isa_and_result;
assign isa_and_result = a & b;

//--- or
wire [BIT_COUNT-1:0] isa_or_result;
assign isa_or_result = a | b;

//--- output enable based on insn enable
assign c = 
	(adder_output & {8{alu_mode[`ALU_MODE_ADD]}}) 	  |
	(shifter_output & {8{alu_mode[`ALU_MODE_SHIFT]}}) |
	(isa_not_result & {8{alu_mode[`ALU_MODE_NOT]}})	  |
	(isa_and_result & {8{alu_mode[`ALU_MODE_AND]}})	  |
	(isa_or_result & {8{alu_mode[`ALU_MODE_OR]}})	  |							   |
	(a & {8{alu_mode[`ALU_MODE_BYPASS_A]}})			  |
	(b & {8{alu_mode[`ALU_MODE_BYPASS_B]}});

endmodule


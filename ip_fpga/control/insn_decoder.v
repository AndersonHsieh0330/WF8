`default_nettype none
`timescale 1ps/1ps
/*
	this module is responsible for generating register address 
	and corresponding immediate value from the 8 bit instruction
*/
module insn_decoder 
(
	input  wire [7:0] insn,
	output wire [3:0] imm_out, // the immidiate value from insns
	output wire [2:0] reg_out // the register specified in insns
);

wire [3:0] opcode;
wire 	   utility_bit;

assign opcode 	   = insn[7:4];
assign utility_bit = insn[3];
assign reg_out 	   = insn[2:0];
assign imm_out 	   = insn[7]&insn[6]&(insn[5]|insn[4]) ? 2 : {imm_out, reg_out};

endmodule

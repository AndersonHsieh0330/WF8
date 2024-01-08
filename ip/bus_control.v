`default_nettype none
`include "param.vh"
module bus_control 
(
	input  wire		clk,
	input  wire [2:0] reg_num, // encoded, from instruction decoder.
	input  wire [`ISA_INSN_COUNT-1:0] insn_en, // from insn decoder

	//--- for program counter register
	output reg reg_pc_write_en,
	output reg reg_pc_read_en,

	//--- for register 0 ~ 8
	output reg [7:0] reg_out_en,  
	output reg [7:0] reg_write_en,

	//--- for RAM
	output reg ram_out_en,
	output reg ram_en, // this goes to port 1 of RAM, HIGH when we want RAM to take in address specified at address in port
		
	//--- control signals
	output reg insn_done // when current clk cycle is the last cycle of current executing insn, this signal goes HIGH
);

reg is_second_cycle; // HIGH when current clk cycle is the second clk cycle of an insn 

always @(posedge clk) begin
	
	// defaults
	reg_pc_write_en <= 1'b0;
	reg_pc_read_en <= 1'b0;
	reg_out_en <= 8'b0;
	reg_write_en <= 8'b0;
	
	insn_done <= 1'b0;
	counter <= 2'b0;

	// 1 cycle insns
	if (insn_en[`ISA_ADD] |
		insturction_en[`ISA_SH]  |
		insturction_en[`ISA_AND] |
		insn_en[`ISA_OR]  |
		insn_en[`ISA_XOR] |
		insn_en[`]) begin
		reg_out_en[reg_num] <= 1'b1;
		reg_write_en[0] <= 1'b1;
		insn_done <= 1'b1;
	end	

	if (insn_en[`ISA_CPY]) begin
		reg_out_en[0] <= 1'b1;
		reg_write_en[reg_num] <= 1'b1;
		insn_done <= 1'b1;
	end

	if (insn_en[`ISA_CPYPC]) begin
		reg_pc_read_en <= 1'b1;
		reg_write_en[reg_num] <= 1'b1;
		insn_done <= 1'b1;
	end

	if (insn_en[`ISA_ADDI] | 
		insn_en[`ISA_SHI]  | 
		insn_en[`ISA_NOT]  |
	) begin
		reg_write_en[0] <= 1'b1;
		insn_done <= 1'b1;
	end

	// 2 cycle instructiosn
	if (is_second_cycle) begin
		if (insn_en[`ISA_LB]) begin
			reg_write_en[reg_num] <= 1'b1;
			ram_out_en <= 1'b1;
			is_second_cycle <= 1'b0;
		end
	end else begin
		if (insn_en[`ISA_LB]) begin
			reg_out_en[0] <= 1'b1;
			ram_en <= 1'b1; // register the address at input address port
			is_second_cycle <= 1'b1;
		end
	end

end

endmodule

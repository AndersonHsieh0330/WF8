`include "/ip/util/params.vh"
`default_nettype none
`timescale 1ps/1ps
module control (
    input  wire [4:0]                 opcode,
    output reg  [`ALU_MODE_COUNT-1:0] alu_mode,
    output wire                       reg_b_write_en, // only if reg_b needs to occupy cpu_bus
    output wire                       reg_b_read_en, // only if reg_b needs to occupy cpu_bus
    output wire                       alu_a_sel,   // LOW for accumulator, HIGH for PC 
    output wire                       alu_b_sel,   // LOW for reg x0 ~ x6, HIGH for immediate value
    output wire                       mem_write_en,
    output wire                       mem_out_en
);

always @(*) begin
    case(opcode[4:1]) 
        4'b000? : alu_mode = `ALU_MODE_ADD;
        4'b001? : alu_mode = `ALU_MODE_SHIFT;
        4'b0100 : alu_mode = `ALU_MODE_NOT;
        4'b0101 : alu_mode = `ALU_MODE_AND;
        4'b0110 : alu_mode = `ALU_MODE_OR;
        4'b0111 : alu_mode = `ALU_MODE_XOR;
        4'b10?? : alu_mode = `ALU_MODE_BYPASS_A; /* cpy, cpypc, lb, sb, jmpadr */
		4'b1011 : alu_mode = `ALU_MODE_BYPASS_B; /* jmpadr */
        default : alu_mode = `ALU_MODE_ADD; 	 /* jmpi, blt, bge, beq, bneq */
    endcase
end

// add, addi, sh, shi, not, and, or, xor, cpy, cpypc, lb
assign reg_b_write_en = ~opcode[4] | (opcode[4] & ~opcode[3] & ~opcode[2]);

// all instructions except addi, shi and jmpi
assign reg_b_read_en = ~((~opcode[4] & ~opcode[3] & opcode[1]) | opcode[4:1] == 4'b1100);

// jmpi, blt, bge, beq, bneq, and cpypc
assign alu_a_sel = (opcode[4] & opcode[3]) | (opcode == 5'b10001); 

// jmpi, blt, bge, beq, bneq, addi and shi
assign alu_b_sel = (opcode[4] & opcode[3]) | (~opcode[4] & ~opcode[3] & opcode[1]);

// sb
assign mem_write_en = opcode[4:1] == 4'b1010;

// lb
assign mem_out_en = opcode[4:1] == 4'b1001;

endmodule

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
    output wire                       pc_bus_en,   // only pc needs to occupy cpu_bus
    output wire                       mem_write_en
);

always @(*) begin
    case(opcode[4:1]) 
        4'b000? : alu_mode = `ALU_MODE_ADD;
        4'b001? : alu_mode = `ALU_MODE_SHIFT;
        4'b0100 : alu_mode = `ALU_MODE_NOT;
        4'b0101 : alu_mode = `ALU_MODE_AND;
        4'b0110 : alu_mode = `ALU_MODE_OR;
        4'b0111 : alu_mode = `ALU_MODE_ADD; // jump/branch instructions uses add mode since branch compare is isolated
        4'b10?? : begin
            /* cpy, cpypc, lb, sb, jmpadr */
            alu_mode = `ALU_MODE_BYPASS_A;
        end
        default : begin
            /* jmpi, blt, bge, beq, bneq */
            alu_mode = `ALU_MODE_ADD;
        end
    endcase
end

// add, addi, sh, shi, not, and, or, xor, cpy, cpypc, lb
assign reg_b_write_en = ~opcode[4] | (opcode[4] & ~opcode[3] & ~opcode[2]);

// add, sh, and, or, xor, cpy, sb, jmpadr
assign reg_b_read_en = 

// jmpi, blt, bge, beq, bneq, and cpypc
assign alu_a_sel = (opcode[4] & opcode[3]) | (opcode == 5'b10001); 

// jmpi, blt, bge, beq, bneq, addi and shi
assign alu_b_sel = (opcode[4] & opcode[3]) | (~opcode[4] & ~opcode[3] & opcode[1]);

// sb
assign mem_write_en = opcode[4:1] == 4'b1010;

endmodule

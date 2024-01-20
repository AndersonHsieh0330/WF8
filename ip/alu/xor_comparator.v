`default_nettype none
`timescale 1ps/1ps
module xor_comparator
#(
	parameter BIT_COUNT = 8
)
(
	input  wire [BIT_COUNT-1:0] a,
	input  wire [BIT_COUNT-1:0] b,
	output wire [BIT_COUNT-1:0] xor_result,
	output wire                 equal,
	output wire                 a_larger
);

wire [BIT_COUNT-1:0] a_larger_1b;
wire [BIT_COUNT-1:0] equal_1b;

generate
	for (genvar gi = 0 ; gi < BIT_COUNT ; gi = gi + 1) begin
		xor_comparator_1b xor_comparator_1b_inst (
			.a(a[gi]),
			.b(b[gi]),
			.last_equal(gi==(BIT_COUNT-1)?1'b1:equal_1b[gi+1]),
			.equal(equal_1b[gi]),
			.last_a_larger(gi==(BIT_COUNT-1)?1'b0:a_larger_1b[gi+1]),
			.a_larger(a_larger_1b[gi]),
			.xor_result(xor_result[gi])
		);
	end
endgenerate
endmodule

module xor_comparator_1b
(
	input  wire a,
	input  wire b,
	input  wire last_equal, // from higher bit 
	input  wire last_a_larger, // from higher bit 
	output wire equal,
	output wire a_larger,
	output wire xor_result
);

assign xor_result = a ^ b;
assign equal = ~xor_result & last_equal;
assign a_larger = (last_equal & a & xor_result) | last_a_larger;

endmodule
//--- this is just a gate level full adder for fun
module full_adder_0_bit 
(
	input  a,
	input  b,
	input  cin,
	output sum,
	output cout
);

wire a_xor_b = a ^ b;
wire a_and_b = a & b;

assign sum = a_xor_b ^ cin;
assign cout = a_and_b | (cin & a_xor_b);

endmodule

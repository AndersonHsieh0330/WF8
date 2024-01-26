`default_nettype none
`timescale 1ps/1ps
/*
* use behavior module because I want vivado compiler to use dsp block
* instead of LUTs
*/
module adder #(
	BIT_COUNT = 8
)
(
	input  wire [BIT_COUNT-1:0] a,
	input  wire [BIT_COUNT-1:0] b,
	output wire [BIT_COUNT-1:0] sum,
	output wire cout
);

wire [BIT_COUNT:0] result;

assign result = a + b;
assign {cout, sum} = result;

endmodule

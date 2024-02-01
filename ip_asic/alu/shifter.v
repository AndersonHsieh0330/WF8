`default_nettype none
//-- TODO: see if we need overflow/underflow detection
module shifter 
#(
	parameter BIT_COUNT = 8
)
(
	input  wire [BIT_COUNT-1:0] shift_in,
	input  wire [BIT_COUNT-1:0] shift_amount, // 2s complement
	output wire [BIT_COUNT-1:0] shift_out
);

assign shift_out = shift_amount[BIT_COUNT-1] ? shift_in >> ((~shift_amount)+1) : shift_in << shift_amount;

endmodule

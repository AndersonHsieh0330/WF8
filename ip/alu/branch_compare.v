`include "/ip/util/params.vh"
`default_nettype none
module branch_compare (
    input  wire a,
    input  wire b,
    output wire [BC_FLAG_COUNT-1:0] bc_flags
);

//--- xor, branch flags
wire [BIT_COUNT-1:0] xor_comparator_out;
wire				 comp_a_larger;

assign bc_flags[`BC_FLAG_GT] = ~comp_a_larger;
xor_comparator comparator_inst (
	.a(a), 
	.b(b), 
	.xor_result(xor_comparator_out),
	.equal(bc_flags[`BC_FLAG_EQ]),
	.a_larger(comp_a_larger) // note that a is reg_acc, so inversed
);

endmodule

module register_top (
	input 	    clk,
	input       reset,
	inout [7:0] cpu_bus,
	input [7:0] write_en,
	input [7:0] read_en,
	input [7:0] reg_acc_in,
	input [7:0] reg_acc_out
);

wire reg_acc;

assign reg_acc_out = reg_acc;

generate
	for (genvar i = 0 ; i < 7 ; i = i + 1) begin
		register reg_inst (
			.clk(clk),
			.write_en(write_en[i]),
			.read_en(read_en[i]),
			.reg_in(cpu_bus),
			.reg_out(cpu_bus)
		);
	end

	register reg_acc (
		.clk(clk),
		.write_en(write_en[7]),
		.read_en(read_en[7]),
		.reg_in(reg_acc_in),
		.reg_out(cpu_bus)
	);
endgenerate
endmodule

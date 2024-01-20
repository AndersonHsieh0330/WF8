`default_nettype none
module register_top (
	input  wire 	  clk,
	input  wire       reset,
	inout  wire [7:0] cpu_bus,
	input  wire [7:0] write_en,
	input  wire [7:0] read_en,
	input  wire [7:0] reg_acc_in,
	output wire [7:0] reg_acc_out
);

generate
	for (genvar i = 0 ; i < 7 ; i = i + 1) begin
		register reg_inst (
			.clk(clk),
            .reset(reset),
			.write_en(write_en[i]),
			.read_en(read_en[i]),
			.reg_in(cpu_bus),
			.reg_out(cpu_bus)
		);
	end

	register_bypass_out reg_acc (
		.clk(clk),
        .reset(reset),
		.write_en(write_en[7]),
		.read_en(read_en[7]),
		.reg_in(reg_acc_in),
		.reg_out(cpu_bus),
        .bypass_out(reg_acc_out)
	);
endgenerate
endmodule

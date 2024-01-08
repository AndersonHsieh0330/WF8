// these modules are only used for ASIC version of this core
module register
#(
	parameter BIT_COUNT = 8
) (
	input clk,
	input write_en,
	input out_en,
	input [BIT_COUNT-1:0] reg_in,
	input [BIT_COUNT-1:0] reg_out
);

reg [BIT_COUNT-1:0] reg_val;

assign reg_out = out_en ? reg_val : {BIT_COUNT{1'bz}};

always @(posedge clk) begin
	if (write_en) begin
		reg_val <= reg_in;
	end
end

endmodule

module register_no_enable
#(
	parameter BIT_COUNT = 8
)
(
	input clk,
	input [BIT_COUNT-1:0] reg_in,
	input reg [BIT_COUNT-1;0] reg_out
);


always @(posedge clk) begin
	reg_out <= reg_in;
end

endmodule

module clk_gate (
	input clk,
	input en,
	output g_clk
);

reg latch_out;

always @(*) begin
	if (~clk) begin
		latch_out <= en;
	end 
end

assign g_clk = latch_out & clk;
endmodule

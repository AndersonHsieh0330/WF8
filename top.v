`default_nettype none
module top (
	input  wire 	  clk,
	input  wire 	  rst,

	output wire [7:0] io_bus_addr,
	output wire [7:0] io_bus_dout
);

parameter BIT_COUNT = 32;

initial begin
    if ($test$plusargs("trace") != 0) begin
        // use $display to print anything you want
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/top_dump.vcd");
        $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);
end

cpu_top cpu_inst (
	.clk(clk),
	.rst(rst),
	.io_bus_addr(io_bus_addr),
	.io_bus_dout(io_bus_dout)
);

endmodule

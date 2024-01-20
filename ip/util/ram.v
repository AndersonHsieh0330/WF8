`default_nettype none
/*
*	2 read ports 1 write port
*/
module ram #(
	parameter WORD_LINE = 256, // address are 8 bits
	parameter BIT_LINE = 8     // byte addressable, 8^7 = 256
) (
	input  wire 			   clk,
	input  wire 			   reset,
	
	input  wire [7:0] 	   	   addr_in_port_1, 
	input  wire [7:0] 	   	   addr_in_port_2,
	input  wire [BIT_LINE-1:0] data_in_port_1,
	input  wire 		       write_en,
	
	output reg  [BIT_LINE-1:0] data_out_port_1,
	output reg  [BIT_LINE-1:0] data_out_port_2,
);

reg [BIT_LINE-1:0] memory [WORD_LINE-1:0];

`ifdef SIM
initial begin
	$readmemb("ram_8_256.data", memory, 0, 256);
end
`endif

always @(posedge clk) begin 
	if (reset) begin
		data_out_port_1 <= 8'b0;
		data_out_port_1 <= 8'b0;
	end else if (write_en) begin
		data_out_port_1 <= memory[addr_in_port_1];
		data_out_port_2 <= 8'b0;
		memory[addr_in_port_2] <= data_in_port_2;
	end else begin
		data_out_port_1 <= memory[addr_in_port_1];
		data_out_port_2 <= memory[addr_in_port_2];
	end
end

endmodule

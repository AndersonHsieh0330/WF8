`default_nettype none
module register
#(
	parameter BIT_COUNT = 8
) (
	input 		           clk,
    input                  rst,
	input 		           write_en,
	input 		           read_en,
	input  [BIT_COUNT-1:0] reg_in,
	output [BIT_COUNT-1:0] reg_out
);

reg [BIT_COUNT-1:0] reg_val;

assign reg_out = read_en ? reg_val : {BIT_COUNT{1'bz}};

always @(posedge clk) begin
    if (rst) begin
        reg_val <= {BIT_COUNT{1'bz}}
    end else if (write_en) begin
		reg_val <= reg_in;
	end
end

endmodule

module register_bypass_out
#(
	parameter BIT_COUNT = 8
) (
	input 		           clk,
    input                  rst,
	input 		           write_en,
	input 		           read_en,
	input  [BIT_COUNT-1:0] reg_in,
	output [BIT_COUNT-1:0] reg_out
	output [BIT_COUNT-1:0] bypass_out
);

reg [BIT_COUNT-1:0] reg_val;

assign reg_out = read_en ? reg_val : {BIT_COUNT{1'bz}};
assign bypass_out = reg_val;

always @(posedge clk) begin
    if (rst) begin
        reg_val <= {BIT_COUNT{1'bz}}
    end else if (write_en) begin
		reg_val <= reg_in;
	end else begin
		reg_val <= reg_val;
	end
end

endmodule

module register_bypass_out_no_w_en
#(
	parameter BIT_COUNT = 8
) (
	input  wire		            clk,
    input  wire                 rst,
	input  wire 				read_en,
	input  wire [BIT_COUNT-1:0] reg_in,
	output wire [BIT_COUNT-1:0] reg_out,
	output wire [BIT_COUNT-1:0] bypass_out
);

reg [BIT_COUNT-1:0] reg_val;

assign bypass_out = reg_val;
assign reg_out = read_en ? reg_val : {BIT_COUNT{1'bz}};

always @(posedge clk) begin
    if (rst) begin
        reg_val  <= {BIT_COUNT{1'b0}}
	end else begin
		reg_out <= reg_in;
	end
end

endmodule

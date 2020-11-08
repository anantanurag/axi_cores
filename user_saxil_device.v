module user_saxil_device (
	input wire user_saxil_clk,
	input wire user_saxil_rst_n,  // Asynchronous reset active low
	output reg user_port_arready,
	input wire user_port_arvalid,
	output reg user_port_rvalid,
	output reg [31:0] user_port_rdata,
	output reg [1:0] user_port_rresp,
	input wire [31:0] user_port_araddr
);

	always @(~user_saxil_rst_n) begin
		user_port_arready <= 1'b0;
		user_port_rvalid <= 1'b0;
		user_port_rdata <= 1'b0;
		user_port_rresp <= 1'b0;
	end

	always @(posedge(user_saxil_clk) && user_saxil_rst_n) begin
		// Accepts all addresses
		// Returns Random Data for any address
		user_port_arready <= 1'b1;
		user_port_rdata <= $random;
		user_port_rvalid <= 1'b1;
		user_port_rresp <= 2'b00;
	end

endmodule
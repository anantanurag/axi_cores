module saxil_read_top (
	input wire saxil_read_top_clk,
	input wire saxil_read_top_rst_n,
	input wire saxil_read_arvalid,
	output wire saxil_read_arready,
	input wire [31:0] saxil_read_araddr,
	input wire [2:0] saxil_read_arprot,
	output wire saxil_read_rvalid,
	input wire saxil_read_rready,
	output wire [31:0] saxil_read_rdata,
	output wire [1:0] saxil_read_rresp
);


	wire intercon_arready;
	wire intercon_arvalid;
	wire intercon_rvalid;
	wire [31:0] intercon_rdata;
	wire [1:0] intercon_rresp;
	wire [31:0] intercon_araddr;

	axi_lite_slave_read axil_s_rd(
		.S_AXIL_ACLK(saxil_read_top_clk),
		.S_AXIL_ARESETn(saxil_read_top_rst_n),
		.S_AXIL_ARVALID(saxil_read_arvalid),
		.S_AXIL_ARREADY(saxil_read_arready),
		.S_AXIL_ARADDR(saxil_read_araddr),
		.S_AXIL_ARPROT(saxil_read_arprot),
		.S_AXIL_RVALID(saxil_read_rvalid),
		.S_AXIL_RREADY(saxil_read_rready),
		.S_AXIL_RDATA(saxil_read_rdata),
		.S_AXIL_RRESP(saxil_read_rresp),
		.user_port_arready(intercon_arready),
		.user_port_arvalid(intercon_arvalid),
		.user_port_rvalid(intercon_rvalid),
		.user_port_rdata(intercon_rdata),
		.user_port_rresp(intercon_rresp),
		.user_port_araddr(intercon_araddr)
	);
	user_saxil_device u_s_dev(
		.user_saxil_clk(saxil_read_top_clk),
		.user_saxil_rst_n(saxil_read_top_rst_n),
		.user_port_arready(intercon_arready),
		.user_port_arvalid(intercon_arvalid),
		.user_port_rvalid(intercon_rvalid),
		.user_port_rdata(intercon_rdata),
		.user_port_rresp(intercon_rresp),
		.user_port_araddr(intercon_araddr)
	);

endmodule
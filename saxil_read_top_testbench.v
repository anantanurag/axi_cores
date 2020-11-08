`timescale 1ns/100ps

module saxil_read_top_testbench (
);

	reg tb_saxil_read_top_clk;
	reg tb_saxil_read_top_rst_n;
	reg tb_saxil_read_arvalid;
	wire tb_saxil_read_arready;
	reg [31:0] tb_saxil_read_araddr;
	reg [2:0] tb_saxil_read_arprot;
	wire tb_saxil_read_rvalid;
	reg tb_saxil_read_rready;
	wire [31:0] tb_saxil_read_rdata;
	wire [1:0] tb_saxil_read_rresp;


	saxil_read_top srt_dut(
		.saxil_read_top_clk(tb_saxil_read_top_clk),
		.saxil_read_top_rst_n(tb_saxil_read_top_rst_n),
		.saxil_read_arvalid(tb_saxil_read_arvalid),
		.saxil_read_arready(tb_saxil_read_arready),
		.saxil_read_araddr(tb_saxil_read_araddr),
		.saxil_read_arprot(tb_saxil_read_arprot),
		.saxil_read_rvalid(tb_saxil_read_rvalid),
		.saxil_read_rready(tb_saxil_read_rready),
		.saxil_read_rdata(tb_saxil_read_rdata),
		.saxil_read_rresp(tb_saxil_read_rresp)
	);

	initial begin
		$monitor("TIME = %3d; tb_saxil_read_top_clk = %h ; tb_saxil_read_top_rst_n = %h ; tb_saxil_read_arvalid = %h; tb_saxil_read_arready = %h; tb_saxil_read_araddr = %h; tb_saxil_read_arprot = %h; tb_saxil_read_rvalid = %h; tb_saxil_read_rready = %h; tb_saxil_read_rdata = %h; tb_saxil_read_rresp = %h;",
			$time,
			tb_saxil_read_top_clk,
			tb_saxil_read_top_rst_n,
			tb_saxil_read_arvalid,
			tb_saxil_read_arready,
			tb_saxil_read_araddr,
			tb_saxil_read_arprot,
			tb_saxil_read_rvalid,
			tb_saxil_read_rready,
			tb_saxil_read_rdata,
			tb_saxil_read_rresp
			); 
	end

	initial begin
		tb_saxil_read_top_clk = 0;
		forever begin
			#10 tb_saxil_read_top_clk = ~tb_saxil_read_top_clk;
		end
	end

	initial begin
		tb_saxil_read_top_rst_n = 1;
		#5 tb_saxil_read_top_rst_n = 0;
		#15 tb_saxil_read_top_rst_n = 1;
	end

	initial begin
		//1st TX
		tb_saxil_read_arvalid = 1'b1;
		tb_saxil_read_araddr = 32'hFFFF_FFFF;
		tb_saxil_read_arprot = 3'h0;
		tb_saxil_read_rready = 1'b1;

		#30;
		tb_saxil_read_arvalid = 1'b0;
		tb_saxil_read_rready = 1'b0;

		#30;
		//2nd TX
		tb_saxil_read_arvalid = 1'b1;
		tb_saxil_read_araddr = 32'hF0F0_F0F0;
		tb_saxil_read_arprot = 3'h0;
		tb_saxil_read_rready = 1'b1;

		#30;
		tb_saxil_read_arvalid = 1'b0;
		tb_saxil_read_rready = 1'b0;

		#30;
/*
		//3rd TX
		tb_saxil_read_arvalid = $random;
		tb_saxil_read_araddr = $random;
		tb_saxil_read_arprot = $random;
		tb_saxil_read_rready = $random;

		#30;
		tb_saxil_read_arvalid = 1'b0;
		tb_saxil_read_rready = 1'b0;

		#30;
		//4th TX
		tb_saxil_read_arvalid = $random;
		tb_saxil_read_araddr = $random;
		tb_saxil_read_arprot = $random;
		tb_saxil_read_rready = $random;

		#30;
		tb_saxil_read_arvalid = 1'b0;
		tb_saxil_read_rready = 1'b0;

		#30;
		//5th TX
		tb_saxil_read_arvalid = $random;
		tb_saxil_read_araddr = $random;
		tb_saxil_read_arprot = $random;
		tb_saxil_read_rready = $random;
		*/

		$finish;


	end


endmodule
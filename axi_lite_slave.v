/**

AXI Lite Signals

Global - 
			ACLK
			ARESETn

Write address channel - 
			AWVALID
			AWREADY
			AWADDR
			AWPROT

Write data channel - 
			WVALID
			WREADY
			WDATA
			WSTRB

Write Response channel - 
			BVALID
			BREADY
			BRESP

Read address channel - 
			ARVALID
			ARREADY
			ARADDR
			ARPROT

Read data channel - 
			RVALID
			RREADY
			RDATA
			RRESP

**/

module axi_lite_slave_read (
	input  S_AXIL_ACLK,    // Clock
	input  S_AXIL_ARESETn, // Negedge Reset
	
	//Read Address Channel Signals
	input  S_AXIL_ARVALID,
	output S_AXIL_ARREADY,
	input S_AXIL_ARADDR,
	input S_AXIL_APROT,

	//Read Data Channel Signals
	output S_AXIL_RVALID,
	input S_AXIL_RREADY,
	output S_AXIL_RDATA,
	output S_AXIL_RRESP,
);

endmodule
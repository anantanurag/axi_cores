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
	input wire S_AXIL_ACLK,    // Clock
	input wire S_AXIL_ARESETn, // Negedge Reset
	
	//Read Address Channel Signals
	input wire S_AXIL_ARVALID,
	output reg S_AXIL_ARREADY,
	input wire [31:0] S_AXIL_ARADDR,
	input wire [2:0] S_AXIL_ARPROT,

	//Read Data Channel Signals
	output reg S_AXIL_RVALID,
	input wire S_AXIL_RREADY,
	output reg [31:0] S_AXIL_RDATA,
	output reg [1:0] S_AXIL_RRESP,

	// User Port Signals Start
	input wire user_port_arready,
	output reg user_port_arvalid,
	input wire user_port_rvalid,
	input wire [31:0] user_port_rdata,
	input wire [1:0] user_port_rresp,
	output reg [31:0] user_port_araddr
	// User Port Signals End
);

/*	// Interface Signals Begin
	wire S_AXIL_ACLK;
	wire S_AXIL_ARESETn;

	wire S_AXIL_ARVALID;
	reg S_AXIL_ARREADY;
	wire [31:0] S_AXIL_ARADDR;
	wire [2:0] S_AXIL_ARPROT;
	reg S_AXIL_RVALID;
	wire S_AXIL_RREADY;
	reg [31:0] S_AXIL_RDATA;
	reg [1:0] S_AXIL_RRESP;
	// Interface Signals End


	// Signals going to Functional Block to drive Relevant Data Start
	wire user_port_arready;
	reg user_port_arvalid; // Maybe slave needs to do this Slave can wait for ARVALID before asserting ARREADY
	wire user_port_rvalid;
	wire [31:0] user_port_rdata;
	wire user_port_rresp;
	reg [31:0] user_port_araddr;
	// Signals going to Functional Block to drive Relevant Data End
*/
	// FSM Signals Start
	reg [3:0] fsm_saxil_current_state;
	reg [3:0] fsm_saxil_next_state;
	// FSM Signals End

	localparam 	FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION = 4'd0,
				FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS = 4'd1,
				FSM_SAXIL_RD_WAIT_FOR_ARREADY_ASSERTION = 4'd2,
				FSM_SAXIL_RD_PROCURE_DATA_FROM_DEVICE = 4'd3,
				FSM_SAXIL_RD_WAIT_FOR_RREADY_ASSERTION = 4'd4,
				FSM_SAXIL_RD_SEND_DATA_TO_BUS = 4'd5;



	initial begin
		//All Output Signals equal to zero
		S_AXIL_ARREADY = 1'b0;
		S_AXIL_RVALID = 1'b0;
		S_AXIL_RDATA = 32'b0;
		S_AXIL_RRESP = 2'b0;

		// FSM States Initialized
		fsm_saxil_current_state = 4'b0;
		fsm_saxil_next_state = 4'b0;
	end


	always @ (~S_AXIL_ARESETn) begin
		// ***** ASYNCHRONOUS ***** 
		// At Reset, make all output signals 0
		S_AXIL_ARREADY = 1'b0;
		S_AXIL_RVALID = 1'b0;
		S_AXIL_RDATA = 32'b0;
		S_AXIL_RRESP = 2'b0;
	end

	// Actual Logic starts here 
	/** Finite State Machine
	States - 
		0. FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION - no action or after tx complete
		1. FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS - arvalid is 1
		2. FSM_SAXIL_RD_WAIT_FOR_ARREADY_ASSERTION - wait state for user device to be ready to accept addr
		3. FSM_SAXIL_RD_PROCURE_DATA_FROM_DEVICE - addr is accepted and arready is 1
		4. FSM_SAXIL_RD_WAIT_FOR_RREADY_ASSERTION - wait till master asserts rready
		5. FSM_SAXIL_RD_SEND_DATA_TO_BUS - rvalid is 1

**/

always @ (posedge(S_AXIL_ACLK) && S_AXIL_ARESETn) begin
	case (fsm_saxil_current_state)
		FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION : 
		begin	
			if (S_AXIL_ARVALID) begin
				//user_port_araddr <= S_AXIL_ARADDR;
				fsm_saxil_next_state <= FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS;
			end else begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION;
			end
		end
		FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS :
		begin 
			if (S_AXIL_RREADY) begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_ARREADY_ASSERTION;
			end else begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS;
			end
		end
		FSM_SAXIL_RD_WAIT_FOR_ARREADY_ASSERTION :
		begin
			if (S_AXIL_ARREADY) begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_PROCURE_DATA_FROM_DEVICE;
			end else begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_ARREADY_ASSERTION;
			end
		end
		FSM_SAXIL_RD_PROCURE_DATA_FROM_DEVICE :
		begin
			fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_RREADY_ASSERTION;
		end
		FSM_SAXIL_RD_WAIT_FOR_RREADY_ASSERTION :
		begin
			if (S_AXIL_RREADY) begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_SEND_DATA_TO_BUS;
			end else begin
				fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_RREADY_ASSERTION;
			end
		end
		FSM_SAXIL_RD_SEND_DATA_TO_BUS :
		begin
			fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION;
		end
		default : 
		begin
			fsm_saxil_next_state <= FSM_SAXIL_RD_WAIT_FOR_ARVALID_ASSERTION;
		end
	endcase

end

always @(*) begin
	case (fsm_saxil_current_state)
		FSM_SAXIL_RD_ACCEPT_ADDRESS_FROM_BUS :
		begin
			user_port_araddr <= S_AXIL_ARADDR;
		end
		FSM_SAXIL_RD_SEND_DATA_TO_BUS :
		begin
			S_AXIL_RDATA <= user_port_rdata;
		end
		default : /* DO NOTHING */;
	endcase

end


endmodule
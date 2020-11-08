# axi_cores
My implementation of AXI and AXI-lite Cores


8 November 2020

ZipCPU makes some great points on using formal verfication such and eventually going on to write an efficient AXI Core. AXI is challenging, so I will start with AXI-lite. I will start with a slave AXI-lite module. I still need to read the specifications. I am not sure how this project will turn out. If I cling on to ZIPCPU's blog articles, I should sufficiently help me walk down this path for AXI-lite atleast. Once I have a decent AXI-lite core, I shall attempt the AXI core.

I realized that just as master and slave cores can be split into separate modules, even read and write can be split. That makes the first task of writing a SLAVE READ module a much less daunting task.

I have written the relevant port list of the module, now i need to revise the Verilog concepts such as reg and wire and which type of signal is which. Initial begin statements, Finite State Machines seem to be less challenging compared to port types.

I am having some difficulty in not assuming where is this AXIL Slave Reader being used. I am not sure whether a generic reader can be placed. Afterall, what data will it return when asked for data from any address. What is the valid address range. I cannot help but think that this AXIL Slave Reader must be put on the exterior of another more functionally active module that is doing something for useful than simply interacting with an interconnect.

Lets just start with this assumtion for the sake of moving ahead. This AXI Slave Reader is an interface for a Register Bank or Register File. Maybe these registers are mapped into an SRAM, who knows what is the standard way, or even one of the ways to implement this. If I proceed with this then I will have to initialize and fill some values in this memory. For now let me proceed with something like RDATA = urandom() and move ahead.

The more i sit on the idea, I feel that even this urandom function should not be a part of the AXIL Slave Reader module, but in a separate module. 

Now that I have reached that stage where I need to code FSM's I really feel the need to revisit the steps that I learnt in college to code FSM in verilog. They were very fluent and made writing complex FSMs like a trip to the adjacent room.

I recalled roughly how to write FSMs and just to remark, at lowest I could think of 3 states in this design, but after accounting for wait states, I am up to 6 states. This increase in states was a result of carefully reading the "Read Transaction Dependencies" of the AXI specification

Tried compiling the design, the first set of errors clarified the reg vs wire problem. Inputs must not be reg, thats for sure.

Next issue is packed vs unpacked arrays, iverilog says that if I want to use unpacked arrays, I should switch to SystemVerilog

After resolving the errors related to vectored vs scaler, duplicate declaration inside module and outside, now one last piece of silly error, I need to give each FSM state a valid binary value. After one single Google search, I found that I require to use localparam. And then my file is compilation error free.

I wrote a basic user_saxil_device.v file for implementing the device module on top of which the axi slave reader sits. Nothing complex so far, just returns a random rdata value for any address. Obviously I will either need to modify this file for slave writer or create a new device solely for write.

Now I need to write a top module to connect SAXIL and SAXIL_DEVICE.

The top module connecting SAXIL and Slave Read Device is compile error free.

Now I need to write a test bench for saxil_read_top.v

I forgot to add logic for ARPROT, but is it the slave's responsibility to deal with security? I think some other mediator is required to handle PROT signals. I am just going to leave PROT alone for now.

Written a testbench for the saxil_read_top module.

The test bench has compiled but on running vvp, the terminal simply hanged without giving any response. Even Ctrl-C did not work, I had to kill the terminal.

Maybe because I forgot to add the monitor signals, there wasn't any response.

Yes, the issue was definitely the missing monitor signal. I just need to remove $time from the monitor statement and prints should be controlled unlike with $time.

Still non-terminating simulation. I think I need to add timescale.

I forgot to add $finish.

VVP is simulating nicely now, but rdata is 0 throughout. Now I need to start debugging.

Apart from a small error where I was resetting on negative level, any other issue seems hard to debug without a waveform viewer.

In Waveform viewer, it is obvious that device is generating data but the AXIL Slave is not zeroing it somehow. Current state of the FSM is in unknown state. I should initialize it.

So FSM is moving like this - 0 -> 1 -> 0, why?

ARREADY, RVALID, RDATA - all outputs of device are always 0. I think I forgot to connect ARREADY and RVALID between SAXIL and Device. Something fishy going on here. I am connecting RDATA between SAXIL and Device inside SAXIL Module but leaving ARREADY and RVALID to be connected by a wrapper module. I forgot that connecting wires between Device and SAXIL and assigning values to output ports of SAXIL are 2 different things.

Trying to understand how to connect the signals between SAXIL and Device, either Synchronously or Asynchronously. I would like it to be synchronous but how to do it?

I think that all signals coming in and out of the device should be connected synchronously without any additional logic. Currently some additional logic has been applied to RDATA, maybe I will try to simplify it later.

RVALID and ARREADY are crossing the device boundary onto the SAXIL, but FSM is not proceeding as expected. I think I forgot to add the code to assign current_state <= next_state. I should have revised the tutorial instead of guessing.

It should be simple to debug. Let me take a look at this again tomorrow, or whenever I feel like debugging this.




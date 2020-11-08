# axi_cores
My implementation of AXI and AXI-lite Cores


8 November 2020
ZipCPU makes some great points on using formal verfication such and eventually going on to write an efficient AXI Core. AXI is challenging, so I will start with AXI-lite. I will start with a slave AXI-lite module. I still need to read the specifications. I am not sure how this project will turn out. If I cling on to ZIPCPU's blog articles, I should sufficiently help me walk down this path for AXI-lite atleast. Once I have a decent AXI-lite core, I shall attempt the AXI core.

I realized that just as master and slave cores can be split into separate modules, even read and write can be split. That makes the first task of writing a SLAVE READ module a much less daunting task.

I have written the relevant port list of the module, now i need to revise the Verilog concepts such as reg and wire and which type of signal is which. Initial begin statements, Finite State Machines seem to be less challenging compared to port types.
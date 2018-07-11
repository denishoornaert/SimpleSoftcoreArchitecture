# Simple Softcore Architecture

This project consists in the implementation is a single core load/store CPU architecture that aims to be eventually ran on an FPGA.

The architecture is neither designed to be a RISC or CISC architecture. In fact, all the functionalities enabled by the architecture will be arbitrarily decided.
The main objective of  this project is to test my knowledge of *hardware description languages* (here VHDL), CPU architecture and --- eventually --- compilers.

Therefore, as suggested above, the road map is composed of several steps :
 - the design of a simple --- but sound --- CPU architecture
   - data forwarding
   - branch prediction
   - ...
  
 - creation of an assembly language induced by the ISA (i.e. compiler `asm` to `bitstraem`)
 - enabling of basic input/output management (keyboard input and display output)
 - implementation of internal interruptions and an ISR
 - implementation of an RTC (could be used to enable the utilization of timers)
 - physical implementation on a specific board (yet to be determined)
 - creation of high-level language (c-like)
 - a simple OS

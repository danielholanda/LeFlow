# Legup Patch - Creating I/O ports (alpha version - Use at your own risk!)

Vivado HLS provides a comprehensive set of interfacing options for IP integration in the Vivado logic synthesis flow. LegUp, on the other hand, uses a relatively limited memory-mapped approach. This patch provides a modification of LegUp’s source code to allow the creation of I/O ports. This patch is specially useful for LeFlow, since this will allow performing realistic ML tests and interfacing with external hardware.

## How it works

To resemble the format used by Vivado HLS, the implemented LegUp feature supports adding a TCL directive to convert a global variable into an I/O port.  Multiple concurrent port writes are allowed by both Vivado HLS and this LegUp implementation. The variables are then synthesized into I/O ports (input-only if no values are assigned to
it; output-only if no assignments are made from it). The following code shows a sample LeFlow_config.tcl in which the use wants to map the variable in the IR "my_variable" to an input or output port.
```
set_project StratixIV DE4-530 Tiger_DDR2
set_interface_port my_variable
```

## Contributing

The current patch only allows creating I/O ports for single variables. Ideally, arrays should be supported. It is conceivable that this code can be easily modified to support that. If you decide implementing this, please consider contributing to the LeFlow repository.

## Applying this patch

We modified the following files:
- llvm/lib/Target/Verilog/Allocation.cpp
- llvm/lib/Target/Verilog/GenerateRTL.cpp
- llvm/lib/Target/Verilog/LegupConfig.cpp
- llvm/lib/Target/Verilog/LegupConfig.h
- llvm/lib/Target/Verilog/LegupTcl.cpp
- llvm/lib/Target/Verilog/RTL.h

To use this patch, simply copy the files to the right location at your local LegUp installationg and compile it. 
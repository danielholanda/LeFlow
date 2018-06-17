// Copyright (C) 1991-2013 Altera Corporation
// This simulation model contains highly confidential and
// proprietary information of Altera and is being provided
// in accordance with and subject to the protections of the
// applicable Altera Program License Subscription Agreement
// which governs its use and disclosure. Your use of Altera
// Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions,
// and any output files any of the foregoing (including device
// programming or simulation files), and any associated
// documentation or information are expressly subject to the
// terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of simulating designs for
// use exclusively in logic devices manufactured by Altera and sold
// by Altera or its authorized distributors. Please refer to the
// applicable agreement for further details. Altera products and
// services are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
// Altera assumes no responsibility or liability arising out of the
// application or use of this simulation model.
// Quartus II 13.0.1 Build 232 06/12/2013

module cyclonev_hps_interface_hps2fpga
#(
	parameter dummy	= 32
)(
   input  wire [1:0]  port_size_config,
   input  wire [1:0]  clk,
   output wire [11:0] awid,
   output wire [29:0] awaddr,
   output wire [3:0]  awlen,
   output wire [2:0]  awsize,
   output wire [1:0]  awburst,
   output wire [1:0]  awlock,
   output wire [3:0]  awcache,
   output wire [2:0]  awprot,
   output wire [1:0]  awvalid,
   input  wire [1:0]  awready,
   output wire [11:0] wid,
   output wire [dummy - 1:0] wdata,
   output wire [7:0]  wstrb,
   output wire        wlast,
   output wire        wvalid,
   input  wire        wready,
   input  wire [11:0] bid,
   input  wire [1:0]  bresp,
   input  wire        bvalid,
   output wire        bready,
   output wire [11:0] arid,
   output wire [29:0] araddr,
   output wire [3:0]  arlen,
   output wire [2:0]  arsize,
   output wire [1:0]  arburst,
   output wire [1:0]  arlock,
   output wire [3:0]  arcache,
   output wire [2:0]  arprot,
   output wire        arvalid,
   input  wire        arready,
   input  wire [11:0] rid,
   input  wire [dummy - 1:0] rdata,
   input  wire [1:0]  rresp,
   input  wire        rlast,
   input  wire        rvalid,
   output wire        rready
);
   
	initial begin
		$display("dummy value - %0d", dummy);
	end


endmodule 

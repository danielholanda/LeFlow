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
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_8g_pcs_aggregate_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_8g_pcs_aggregate
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter xaui_sm_operation = "en_xaui_sm",	//Valid values: dis_xaui_sm|en_xaui_sm|en_xaui_legacy_sm
	parameter dskw_sm_operation = "dskw_xaui_sm",	//Valid values: dskw_xaui_sm|dskw_srio_sm
	parameter data_agg_bonding = "agg_disable",	//Valid values: agg_disable|x4_cmu1|x4_cmu2|x4_cmu3|x4_lc1|x4_lc2|x4_lc3|x2_cmu1|x2_lc1
	parameter prot_mode_tx = "pipe_g1_tx",	//Valid values: pipe_g1_tx|pipe_g2_tx|cpri_tx|cpri_rx_tx_tx|gige_tx|xaui_tx|srio_2p1_tx|test_tx|basic_tx|disabled_prot_mode_tx
	parameter pcs_dw_datapath = "sw_data_path",	//Valid values: sw_data_path|dw_data_path
	parameter dskw_control = "dskw_write_control",	//Valid values: dskw_write_control|dskw_read_control
	parameter refclkdig_sel = "dis_refclk_dig_sel",	//Valid values: dis_refclk_dig_sel|en_refclk_dig_sel
	parameter agg_pwdn = "dis_agg_pwdn",	//Valid values: dis_agg_pwdn|en_agg_pwdn
	parameter [ 3:0 ] dskw_mnumber_data = 4'b100,	//Valid values: 4
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 1:0 ] aligndetsyncbotch2,
	input [ 1:0 ] aligndetsyncch0,
	input [ 1:0 ] aligndetsyncch1,
	input [ 1:0 ] aligndetsyncch2,
	input [ 1:0 ] aligndetsynctopch0,
	input [ 1:0 ] aligndetsynctopch1,
	input [ 0:0 ] alignstatussyncbotch2,
	input [ 0:0 ] alignstatussyncch0,
	input [ 0:0 ] alignstatussyncch1,
	input [ 0:0 ] alignstatussyncch2,
	input [ 0:0 ] alignstatussynctopch0,
	input [ 0:0 ] alignstatussynctopch1,
	input [ 1:0 ] cgcomprddinbotch2,
	input [ 1:0 ] cgcomprddinch0,
	input [ 1:0 ] cgcomprddinch1,
	input [ 1:0 ] cgcomprddinch2,
	input [ 1:0 ] cgcomprddintopch0,
	input [ 1:0 ] cgcomprddintopch1,
	input [ 1:0 ] cgcompwrinbotch2,
	input [ 1:0 ] cgcompwrinch0,
	input [ 1:0 ] cgcompwrinch1,
	input [ 1:0 ] cgcompwrinch2,
	input [ 1:0 ] cgcompwrintopch0,
	input [ 1:0 ] cgcompwrintopch1,
	input [ 0:0 ] decctlbotch2,
	input [ 0:0 ] decctlch0,
	input [ 0:0 ] decctlch1,
	input [ 0:0 ] decctlch2,
	input [ 0:0 ] decctltopch0,
	input [ 0:0 ] decctltopch1,
	input [ 7:0 ] decdatabotch2,
	input [ 7:0 ] decdatach0,
	input [ 7:0 ] decdatach1,
	input [ 7:0 ] decdatach2,
	input [ 7:0 ] decdatatopch0,
	input [ 7:0 ] decdatatopch1,
	input [ 0:0 ] decdatavalidbotch2,
	input [ 0:0 ] decdatavalidch0,
	input [ 0:0 ] decdatavalidch1,
	input [ 0:0 ] decdatavalidch2,
	input [ 0:0 ] decdatavalidtopch0,
	input [ 0:0 ] decdatavalidtopch1,
	input [ 0:0 ] dedicatedaggscaninch1,
	input [ 0:0 ] delcondmetinbotch2,
	input [ 0:0 ] delcondmetinch0,
	input [ 0:0 ] delcondmetinch1,
	input [ 0:0 ] delcondmetinch2,
	input [ 0:0 ] delcondmetintopch0,
	input [ 0:0 ] delcondmetintopch1,
	input [ 63:0 ] dprioagg,
	input [ 0:0 ] fifoovrinbotch2,
	input [ 0:0 ] fifoovrinch0,
	input [ 0:0 ] fifoovrinch1,
	input [ 0:0 ] fifoovrinch2,
	input [ 0:0 ] fifoovrintopch0,
	input [ 0:0 ] fifoovrintopch1,
	input [ 0:0 ] fifordinbotch2,
	input [ 0:0 ] fifordinch0,
	input [ 0:0 ] fifordinch1,
	input [ 0:0 ] fifordinch2,
	input [ 0:0 ] fifordintopch0,
	input [ 0:0 ] fifordintopch1,
	input [ 0:0 ] insertincompleteinbotch2,
	input [ 0:0 ] insertincompleteinch0,
	input [ 0:0 ] insertincompleteinch1,
	input [ 0:0 ] insertincompleteinch2,
	input [ 0:0 ] insertincompleteintopch0,
	input [ 0:0 ] insertincompleteintopch1,
	input [ 0:0 ] latencycompinbotch2,
	input [ 0:0 ] latencycompinch0,
	input [ 0:0 ] latencycompinch1,
	input [ 0:0 ] latencycompinch2,
	input [ 0:0 ] latencycompintopch0,
	input [ 0:0 ] latencycompintopch1,
	input [ 0:0 ] rcvdclkch0,
	input [ 0:0 ] rcvdclkch1,
	input [ 1:0 ] rdalignbotch2,
	input [ 1:0 ] rdalignch0,
	input [ 1:0 ] rdalignch1,
	input [ 1:0 ] rdalignch2,
	input [ 1:0 ] rdaligntopch0,
	input [ 1:0 ] rdaligntopch1,
	input [ 0:0 ] rdenablesyncbotch2,
	input [ 0:0 ] rdenablesyncch0,
	input [ 0:0 ] rdenablesyncch1,
	input [ 0:0 ] rdenablesyncch2,
	input [ 0:0 ] rdenablesynctopch0,
	input [ 0:0 ] rdenablesynctopch1,
	input [ 0:0 ] refclkdig,
	input [ 1:0 ] runningdispbotch2,
	input [ 1:0 ] runningdispch0,
	input [ 1:0 ] runningdispch1,
	input [ 1:0 ] runningdispch2,
	input [ 1:0 ] runningdisptopch0,
	input [ 1:0 ] runningdisptopch1,
	input [ 0:0 ] rxpcsrstn,
	input [ 0:0 ] scanmoden,
	input [ 0:0 ] scanshiftn,
	input [ 0:0 ] syncstatusbotch2,
	input [ 0:0 ] syncstatusch0,
	input [ 0:0 ] syncstatusch1,
	input [ 0:0 ] syncstatusch2,
	input [ 0:0 ] syncstatustopch0,
	input [ 0:0 ] syncstatustopch1,
	input [ 0:0 ] txctltcbotch2,
	input [ 0:0 ] txctltcch0,
	input [ 0:0 ] txctltcch1,
	input [ 0:0 ] txctltcch2,
	input [ 0:0 ] txctltctopch0,
	input [ 0:0 ] txctltctopch1,
	input [ 7:0 ] txdatatcbotch2,
	input [ 7:0 ] txdatatcch0,
	input [ 7:0 ] txdatatcch1,
	input [ 7:0 ] txdatatcch2,
	input [ 7:0 ] txdatatctopch0,
	input [ 7:0 ] txdatatctopch1,
	input [ 0:0 ] txpcsrstn,
	input [ 0:0 ] txpmaclk,
	output [ 15:0 ] aggtestbusch0,
	output [ 15:0 ] aggtestbusch1,
	output [ 15:0 ] aggtestbusch2,
	output [ 0:0 ] alignstatusbotch2,
	output [ 0:0 ] alignstatusch0,
	output [ 0:0 ] alignstatusch1,
	output [ 0:0 ] alignstatusch2,
	output [ 0:0 ] alignstatussync0botch2,
	output [ 0:0 ] alignstatussync0ch0,
	output [ 0:0 ] alignstatussync0ch1,
	output [ 0:0 ] alignstatussync0ch2,
	output [ 0:0 ] alignstatussync0topch0,
	output [ 0:0 ] alignstatussync0topch1,
	output [ 0:0 ] alignstatustopch0,
	output [ 0:0 ] alignstatustopch1,
	output [ 0:0 ] cgcomprddallbotch2,
	output [ 0:0 ] cgcomprddallch0,
	output [ 0:0 ] cgcomprddallch1,
	output [ 0:0 ] cgcomprddallch2,
	output [ 0:0 ] cgcomprddalltopch0,
	output [ 0:0 ] cgcomprddalltopch1,
	output [ 0:0 ] cgcompwrallbotch2,
	output [ 0:0 ] cgcompwrallch0,
	output [ 0:0 ] cgcompwrallch1,
	output [ 0:0 ] cgcompwrallch2,
	output [ 0:0 ] cgcompwralltopch0,
	output [ 0:0 ] cgcompwralltopch1,
	output [ 0:0 ] dedicatedaggscanoutch0tieoff,
	output [ 0:0 ] dedicatedaggscanoutch1,
	output [ 0:0 ] dedicatedaggscanoutch2tieoff,
	output [ 0:0 ] delcondmet0botch2,
	output [ 0:0 ] delcondmet0ch0,
	output [ 0:0 ] delcondmet0ch1,
	output [ 0:0 ] delcondmet0ch2,
	output [ 0:0 ] delcondmet0topch0,
	output [ 0:0 ] delcondmet0topch1,
	output [ 0:0 ] endskwqdbotch2,
	output [ 0:0 ] endskwqdch0,
	output [ 0:0 ] endskwqdch1,
	output [ 0:0 ] endskwqdch2,
	output [ 0:0 ] endskwqdtopch0,
	output [ 0:0 ] endskwqdtopch1,
	output [ 0:0 ] endskwrdptrsbotch2,
	output [ 0:0 ] endskwrdptrsch0,
	output [ 0:0 ] endskwrdptrsch1,
	output [ 0:0 ] endskwrdptrsch2,
	output [ 0:0 ] endskwrdptrstopch0,
	output [ 0:0 ] endskwrdptrstopch1,
	output [ 0:0 ] fifoovr0botch2,
	output [ 0:0 ] fifoovr0ch0,
	output [ 0:0 ] fifoovr0ch1,
	output [ 0:0 ] fifoovr0ch2,
	output [ 0:0 ] fifoovr0topch0,
	output [ 0:0 ] fifoovr0topch1,
	output [ 0:0 ] fifordoutcomp0botch2,
	output [ 0:0 ] fifordoutcomp0ch0,
	output [ 0:0 ] fifordoutcomp0ch1,
	output [ 0:0 ] fifordoutcomp0ch2,
	output [ 0:0 ] fifordoutcomp0topch0,
	output [ 0:0 ] fifordoutcomp0topch1,
	output [ 0:0 ] fiforstrdqdbotch2,
	output [ 0:0 ] fiforstrdqdch0,
	output [ 0:0 ] fiforstrdqdch1,
	output [ 0:0 ] fiforstrdqdch2,
	output [ 0:0 ] fiforstrdqdtopch0,
	output [ 0:0 ] fiforstrdqdtopch1,
	output [ 0:0 ] insertincomplete0botch2,
	output [ 0:0 ] insertincomplete0ch0,
	output [ 0:0 ] insertincomplete0ch1,
	output [ 0:0 ] insertincomplete0ch2,
	output [ 0:0 ] insertincomplete0topch0,
	output [ 0:0 ] insertincomplete0topch1,
	output [ 0:0 ] latencycomp0botch2,
	output [ 0:0 ] latencycomp0ch0,
	output [ 0:0 ] latencycomp0ch1,
	output [ 0:0 ] latencycomp0ch2,
	output [ 0:0 ] latencycomp0topch0,
	output [ 0:0 ] latencycomp0topch1,
	output [ 0:0 ] rcvdclkout,
	output [ 0:0 ] rcvdclkoutbot,
	output [ 0:0 ] rcvdclkouttop,
	output [ 0:0 ] rxctlrsbotch2,
	output [ 0:0 ] rxctlrsch0,
	output [ 0:0 ] rxctlrsch1,
	output [ 0:0 ] rxctlrsch2,
	output [ 0:0 ] rxctlrstopch0,
	output [ 0:0 ] rxctlrstopch1,
	output [ 7:0 ] rxdatarsbotch2,
	output [ 7:0 ] rxdatarsch0,
	output [ 7:0 ] rxdatarsch1,
	output [ 7:0 ] rxdatarsch2,
	output [ 7:0 ] rxdatarstopch0,
	output [ 7:0 ] rxdatarstopch1,
	output [ 0:0 ] txctltsbotch2,
	output [ 0:0 ] txctltsch0,
	output [ 0:0 ] txctltsch1,
	output [ 0:0 ] txctltsch2,
	output [ 0:0 ] txctltstopch0,
	output [ 0:0 ] txctltstopch1,
	output [ 7:0 ] txdatatsbotch2,
	output [ 7:0 ] txdatatsch0,
	output [ 7:0 ] txdatatsch1,
	output [ 7:0 ] txdatatsch2,
	output [ 7:0 ] txdatatstopch0,
	output [ 7:0 ] txdatatstopch1); 

	cyclonev_hssi_8g_pcs_aggregate_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.xaui_sm_operation(xaui_sm_operation),
		.dskw_sm_operation(dskw_sm_operation),
		.data_agg_bonding(data_agg_bonding),
		.prot_mode_tx(prot_mode_tx),
		.pcs_dw_datapath(pcs_dw_datapath),
		.dskw_control(dskw_control),
		.refclkdig_sel(refclkdig_sel),
		.agg_pwdn(agg_pwdn),
		.dskw_mnumber_data(dskw_mnumber_data),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_pcs_aggregate_encrypted_inst	(
		.aligndetsyncbotch2(aligndetsyncbotch2),
		.aligndetsyncch0(aligndetsyncch0),
		.aligndetsyncch1(aligndetsyncch1),
		.aligndetsyncch2(aligndetsyncch2),
		.aligndetsynctopch0(aligndetsynctopch0),
		.aligndetsynctopch1(aligndetsynctopch1),
		.alignstatussyncbotch2(alignstatussyncbotch2),
		.alignstatussyncch0(alignstatussyncch0),
		.alignstatussyncch1(alignstatussyncch1),
		.alignstatussyncch2(alignstatussyncch2),
		.alignstatussynctopch0(alignstatussynctopch0),
		.alignstatussynctopch1(alignstatussynctopch1),
		.cgcomprddinbotch2(cgcomprddinbotch2),
		.cgcomprddinch0(cgcomprddinch0),
		.cgcomprddinch1(cgcomprddinch1),
		.cgcomprddinch2(cgcomprddinch2),
		.cgcomprddintopch0(cgcomprddintopch0),
		.cgcomprddintopch1(cgcomprddintopch1),
		.cgcompwrinbotch2(cgcompwrinbotch2),
		.cgcompwrinch0(cgcompwrinch0),
		.cgcompwrinch1(cgcompwrinch1),
		.cgcompwrinch2(cgcompwrinch2),
		.cgcompwrintopch0(cgcompwrintopch0),
		.cgcompwrintopch1(cgcompwrintopch1),
		.decctlbotch2(decctlbotch2),
		.decctlch0(decctlch0),
		.decctlch1(decctlch1),
		.decctlch2(decctlch2),
		.decctltopch0(decctltopch0),
		.decctltopch1(decctltopch1),
		.decdatabotch2(decdatabotch2),
		.decdatach0(decdatach0),
		.decdatach1(decdatach1),
		.decdatach2(decdatach2),
		.decdatatopch0(decdatatopch0),
		.decdatatopch1(decdatatopch1),
		.decdatavalidbotch2(decdatavalidbotch2),
		.decdatavalidch0(decdatavalidch0),
		.decdatavalidch1(decdatavalidch1),
		.decdatavalidch2(decdatavalidch2),
		.decdatavalidtopch0(decdatavalidtopch0),
		.decdatavalidtopch1(decdatavalidtopch1),
		.dedicatedaggscaninch1(dedicatedaggscaninch1),
		.delcondmetinbotch2(delcondmetinbotch2),
		.delcondmetinch0(delcondmetinch0),
		.delcondmetinch1(delcondmetinch1),
		.delcondmetinch2(delcondmetinch2),
		.delcondmetintopch0(delcondmetintopch0),
		.delcondmetintopch1(delcondmetintopch1),
		.dprioagg(dprioagg),
		.fifoovrinbotch2(fifoovrinbotch2),
		.fifoovrinch0(fifoovrinch0),
		.fifoovrinch1(fifoovrinch1),
		.fifoovrinch2(fifoovrinch2),
		.fifoovrintopch0(fifoovrintopch0),
		.fifoovrintopch1(fifoovrintopch1),
		.fifordinbotch2(fifordinbotch2),
		.fifordinch0(fifordinch0),
		.fifordinch1(fifordinch1),
		.fifordinch2(fifordinch2),
		.fifordintopch0(fifordintopch0),
		.fifordintopch1(fifordintopch1),
		.insertincompleteinbotch2(insertincompleteinbotch2),
		.insertincompleteinch0(insertincompleteinch0),
		.insertincompleteinch1(insertincompleteinch1),
		.insertincompleteinch2(insertincompleteinch2),
		.insertincompleteintopch0(insertincompleteintopch0),
		.insertincompleteintopch1(insertincompleteintopch1),
		.latencycompinbotch2(latencycompinbotch2),
		.latencycompinch0(latencycompinch0),
		.latencycompinch1(latencycompinch1),
		.latencycompinch2(latencycompinch2),
		.latencycompintopch0(latencycompintopch0),
		.latencycompintopch1(latencycompintopch1),
		.rcvdclkch0(rcvdclkch0),
		.rcvdclkch1(rcvdclkch1),
		.rdalignbotch2(rdalignbotch2),
		.rdalignch0(rdalignch0),
		.rdalignch1(rdalignch1),
		.rdalignch2(rdalignch2),
		.rdaligntopch0(rdaligntopch0),
		.rdaligntopch1(rdaligntopch1),
		.rdenablesyncbotch2(rdenablesyncbotch2),
		.rdenablesyncch0(rdenablesyncch0),
		.rdenablesyncch1(rdenablesyncch1),
		.rdenablesyncch2(rdenablesyncch2),
		.rdenablesynctopch0(rdenablesynctopch0),
		.rdenablesynctopch1(rdenablesynctopch1),
		.refclkdig(refclkdig),
		.runningdispbotch2(runningdispbotch2),
		.runningdispch0(runningdispch0),
		.runningdispch1(runningdispch1),
		.runningdispch2(runningdispch2),
		.runningdisptopch0(runningdisptopch0),
		.runningdisptopch1(runningdisptopch1),
		.rxpcsrstn(rxpcsrstn),
		.scanmoden(scanmoden),
		.scanshiftn(scanshiftn),
		.syncstatusbotch2(syncstatusbotch2),
		.syncstatusch0(syncstatusch0),
		.syncstatusch1(syncstatusch1),
		.syncstatusch2(syncstatusch2),
		.syncstatustopch0(syncstatustopch0),
		.syncstatustopch1(syncstatustopch1),
		.txctltcbotch2(txctltcbotch2),
		.txctltcch0(txctltcch0),
		.txctltcch1(txctltcch1),
		.txctltcch2(txctltcch2),
		.txctltctopch0(txctltctopch0),
		.txctltctopch1(txctltctopch1),
		.txdatatcbotch2(txdatatcbotch2),
		.txdatatcch0(txdatatcch0),
		.txdatatcch1(txdatatcch1),
		.txdatatcch2(txdatatcch2),
		.txdatatctopch0(txdatatctopch0),
		.txdatatctopch1(txdatatctopch1),
		.txpcsrstn(txpcsrstn),
		.txpmaclk(txpmaclk),
		.aggtestbusch0(aggtestbusch0),
		.aggtestbusch1(aggtestbusch1),
		.aggtestbusch2(aggtestbusch2),
		.alignstatusbotch2(alignstatusbotch2),
		.alignstatusch0(alignstatusch0),
		.alignstatusch1(alignstatusch1),
		.alignstatusch2(alignstatusch2),
		.alignstatussync0botch2(alignstatussync0botch2),
		.alignstatussync0ch0(alignstatussync0ch0),
		.alignstatussync0ch1(alignstatussync0ch1),
		.alignstatussync0ch2(alignstatussync0ch2),
		.alignstatussync0topch0(alignstatussync0topch0),
		.alignstatussync0topch1(alignstatussync0topch1),
		.alignstatustopch0(alignstatustopch0),
		.alignstatustopch1(alignstatustopch1),
		.cgcomprddallbotch2(cgcomprddallbotch2),
		.cgcomprddallch0(cgcomprddallch0),
		.cgcomprddallch1(cgcomprddallch1),
		.cgcomprddallch2(cgcomprddallch2),
		.cgcomprddalltopch0(cgcomprddalltopch0),
		.cgcomprddalltopch1(cgcomprddalltopch1),
		.cgcompwrallbotch2(cgcompwrallbotch2),
		.cgcompwrallch0(cgcompwrallch0),
		.cgcompwrallch1(cgcompwrallch1),
		.cgcompwrallch2(cgcompwrallch2),
		.cgcompwralltopch0(cgcompwralltopch0),
		.cgcompwralltopch1(cgcompwralltopch1),
		.dedicatedaggscanoutch0tieoff(dedicatedaggscanoutch0tieoff),
		.dedicatedaggscanoutch1(dedicatedaggscanoutch1),
		.dedicatedaggscanoutch2tieoff(dedicatedaggscanoutch2tieoff),
		.delcondmet0botch2(delcondmet0botch2),
		.delcondmet0ch0(delcondmet0ch0),
		.delcondmet0ch1(delcondmet0ch1),
		.delcondmet0ch2(delcondmet0ch2),
		.delcondmet0topch0(delcondmet0topch0),
		.delcondmet0topch1(delcondmet0topch1),
		.endskwqdbotch2(endskwqdbotch2),
		.endskwqdch0(endskwqdch0),
		.endskwqdch1(endskwqdch1),
		.endskwqdch2(endskwqdch2),
		.endskwqdtopch0(endskwqdtopch0),
		.endskwqdtopch1(endskwqdtopch1),
		.endskwrdptrsbotch2(endskwrdptrsbotch2),
		.endskwrdptrsch0(endskwrdptrsch0),
		.endskwrdptrsch1(endskwrdptrsch1),
		.endskwrdptrsch2(endskwrdptrsch2),
		.endskwrdptrstopch0(endskwrdptrstopch0),
		.endskwrdptrstopch1(endskwrdptrstopch1),
		.fifoovr0botch2(fifoovr0botch2),
		.fifoovr0ch0(fifoovr0ch0),
		.fifoovr0ch1(fifoovr0ch1),
		.fifoovr0ch2(fifoovr0ch2),
		.fifoovr0topch0(fifoovr0topch0),
		.fifoovr0topch1(fifoovr0topch1),
		.fifordoutcomp0botch2(fifordoutcomp0botch2),
		.fifordoutcomp0ch0(fifordoutcomp0ch0),
		.fifordoutcomp0ch1(fifordoutcomp0ch1),
		.fifordoutcomp0ch2(fifordoutcomp0ch2),
		.fifordoutcomp0topch0(fifordoutcomp0topch0),
		.fifordoutcomp0topch1(fifordoutcomp0topch1),
		.fiforstrdqdbotch2(fiforstrdqdbotch2),
		.fiforstrdqdch0(fiforstrdqdch0),
		.fiforstrdqdch1(fiforstrdqdch1),
		.fiforstrdqdch2(fiforstrdqdch2),
		.fiforstrdqdtopch0(fiforstrdqdtopch0),
		.fiforstrdqdtopch1(fiforstrdqdtopch1),
		.insertincomplete0botch2(insertincomplete0botch2),
		.insertincomplete0ch0(insertincomplete0ch0),
		.insertincomplete0ch1(insertincomplete0ch1),
		.insertincomplete0ch2(insertincomplete0ch2),
		.insertincomplete0topch0(insertincomplete0topch0),
		.insertincomplete0topch1(insertincomplete0topch1),
		.latencycomp0botch2(latencycomp0botch2),
		.latencycomp0ch0(latencycomp0ch0),
		.latencycomp0ch1(latencycomp0ch1),
		.latencycomp0ch2(latencycomp0ch2),
		.latencycomp0topch0(latencycomp0topch0),
		.latencycomp0topch1(latencycomp0topch1),
		.rcvdclkout(rcvdclkout),
		.rcvdclkoutbot(rcvdclkoutbot),
		.rcvdclkouttop(rcvdclkouttop),
		.rxctlrsbotch2(rxctlrsbotch2),
		.rxctlrsch0(rxctlrsch0),
		.rxctlrsch1(rxctlrsch1),
		.rxctlrsch2(rxctlrsch2),
		.rxctlrstopch0(rxctlrstopch0),
		.rxctlrstopch1(rxctlrstopch1),
		.rxdatarsbotch2(rxdatarsbotch2),
		.rxdatarsch0(rxdatarsch0),
		.rxdatarsch1(rxdatarsch1),
		.rxdatarsch2(rxdatarsch2),
		.rxdatarstopch0(rxdatarstopch0),
		.rxdatarstopch1(rxdatarstopch1),
		.txctltsbotch2(txctltsbotch2),
		.txctltsch0(txctltsch0),
		.txctltsch1(txctltsch1),
		.txctltsch2(txctltsch2),
		.txctltstopch0(txctltstopch0),
		.txctltstopch1(txctltstopch1),
		.txdatatsbotch2(txdatatsbotch2),
		.txdatatsch0(txdatatsch0),
		.txdatatsch1(txdatatsch1),
		.txdatatsch2(txdatatsch2),
		.txdatatstopch0(txdatatstopch0),
		.txdatatstopch1(txdatatstopch1)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_8g_rx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_8g_rx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "gige",	//Valid values: pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter tx_rx_parallel_loopback = "dis_plpbk",	//Valid values: dis_plpbk|en_plpbk
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter polarity_inversion = "dis_pol_inv",	//Valid values: dis_pol_inv|en_pol_inv
	parameter wa_pd = "wa_pd_10",	//Valid values: dont_care_wa_pd_0|dont_care_wa_pd_1|wa_pd_7|wa_pd_10|wa_pd_20|wa_pd_40|wa_pd_8_sw|wa_pd_8_dw|wa_pd_16_sw|wa_pd_16_dw|wa_pd_32|wa_pd_fixed_7_k28p5|wa_pd_fixed_10_k28p5|wa_pd_fixed_16_a1a2_sw|wa_pd_fixed_16_a1a2_dw|wa_pd_fixed_32_a1a1a2a2|prbs15_fixed_wa_pd_16_sw|prbs15_fixed_wa_pd_16_dw|prbs15_fixed_wa_pd_20_dw|prbs31_fixed_wa_pd_16_sw|prbs31_fixed_wa_pd_16_dw|prbs31_fixed_wa_pd_10_sw|prbs31_fixed_wa_pd_40_dw|prbs8_fixed_wa|prbs10_fixed_wa|prbs7_fixed_wa_pd_16_sw|prbs7_fixed_wa_pd_16_dw|prbs7_fixed_wa_pd_20_dw|prbs23_fixed_wa_pd_16_sw|prbs23_fixed_wa_pd_32_dw|prbs23_fixed_wa_pd_40_dw
	parameter [ 39:0 ] wa_pd_data = 40'b0,	//Valid values: 40
	parameter wa_boundary_lock_ctrl = "bit_slip",	//Valid values: bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
	parameter wa_pld_controlled = "dis_pld_ctrl",	//Valid values: dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw
	parameter wa_sync_sm_ctrl = "gige_sync_sm",	//Valid values: gige_sync_sm|pipe_sync_sm|xaui_sync_sm|srio1p3_sync_sm|srio2p1_sync_sm|sw_basic_sync_sm|dw_basic_sync_sm|fibre_channel_sync_sm
	parameter [ 7:0 ] wa_rknumber_data = 8'b0,	//Valid values: 8
	parameter [ 5:0 ] wa_renumber_data = 6'b0,	//Valid values: 6
	parameter [ 7:0 ] wa_rgnumber_data = 8'b0,	//Valid values: 8
	parameter [ 1:0 ] wa_rosnumber_data = 2'b0,	//Valid values: 2
	parameter wa_kchar = "dis_kchar",	//Valid values: dis_kchar|en_kchar
	parameter wa_det_latency_sync_status_beh = "assert_sync_status_non_imm",	//Valid values: assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
	parameter wa_clk_slip_spacing = "min_clk_slip_spacing",	//Valid values: min_clk_slip_spacing|user_programmable_clk_slip_spacing
	parameter [ 9:0 ] wa_clk_slip_spacing_data = 10'b10000,	//Valid values: 10
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter [ 9:0 ] deskew_pattern = 10'b1101101000,	//Valid values: 10
	parameter deskew_prog_pattern_only = "en_deskew_prog_pat_only",	//Valid values: dis_deskew_prog_pat_only|en_deskew_prog_pat_only
	parameter rate_match = "dis_rm",	//Valid values: dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
	parameter eightb_tenb_decoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter err_flags_sel = "err_flags_wa",	//Valid values: err_flags_wa|err_flags_8b10b
	parameter polinv_8b10b_dec = "dis_polinv_8b10b_dec",	//Valid values: dis_polinv_8b10b_dec|en_polinv_8b10b_dec
	parameter eightbtenb_decoder_output_sel = "data_8b10b_decoder",	//Valid values: data_8b10b_decoder|data_xaui_sm
	parameter invalid_code_flag_only = "dis_invalid_code_only",	//Valid values: dis_invalid_code_only|en_invalid_code_only
	parameter auto_error_replacement = "dis_err_replace",	//Valid values: dis_err_replace|en_err_replace
	parameter pad_or_edb_error_replace = "replace_edb",	//Valid values: replace_edb|replace_pad|replace_edb_dynamic
	parameter byte_deserializer = "dis_bds",	//Valid values: dis_bds|en_bds_by_2|en_bds_by_2_det
	parameter byte_order = "dis_bo",	//Valid values: dis_bo|en_pcs_ctrl_eight_bit_bo|en_pcs_ctrl_nine_bit_bo|en_pcs_ctrl_ten_bit_bo|en_pld_ctrl_eight_bit_bo|en_pld_ctrl_nine_bit_bo|en_pld_ctrl_ten_bit_bo
	parameter re_bo_on_wa = "dis_re_bo_on_wa",	//Valid values: dis_re_bo_on_wa|en_re_bo_on_wa
	parameter [ 19:0 ] bo_pattern = 20'b0,	//Valid values: 20
	parameter [ 9:0 ] bo_pad = 10'b0,	//Valid values: 10
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter prbs_ver = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter [ 7:0 ] cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_ver = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter cdr_ctrl = "dis_cdr_ctrl",	//Valid values: dis_cdr_ctrl|en_cdr_ctrl|en_cdr_ctrl_w_cid
	parameter cdr_ctrl_rxvalid_mask = "dis_rxvalid_mask",	//Valid values: dis_rxvalid_mask|en_rxvalid_mask
	parameter [ 7:0 ] wait_cnt = 8'b0,	//Valid values: 8
	parameter [ 9:0 ] mask_cnt = 10'h3ff,	//Valid values: 10
	parameter eidle_entry_sd = "dis_eidle_sd",	//Valid values: dis_eidle_sd|en_eidle_sd
	parameter eidle_entry_eios = "dis_eidle_eios",	//Valid values: dis_eidle_eios|en_eidle_eios
	parameter eidle_entry_iei = "dis_eidle_iei",	//Valid values: dis_eidle_iei|en_eidle_iei
	parameter rx_rcvd_clk = "rcvd_clk_rcvd_clk",	//Valid values: rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
	parameter rx_clk1 = "rcvd_clk_clk1",	//Valid values: rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|rcvd_clk_agg_top_or_bottom_clk1
	parameter rx_clk2 = "rcvd_clk_clk2",	//Valid values: rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2
	parameter rx_rd_clk = "pld_rx_clk",	//Valid values: pld_rx_clk|rx_clk
	parameter dw_one_or_two_symbol_bo = "donot_care_one_two_bo",	//Valid values: donot_care_one_two_bo|one_symbol_bo|two_symbol_bo_eight_bit|two_symbol_bo_nine_bit|two_symbol_bo_ten_bit
	parameter comp_fifo_rst_pld_ctrl = "dis_comp_fifo_rst_pld_ctrl",	//Valid values: dis_comp_fifo_rst_pld_ctrl|en_comp_fifo_rst_pld_ctrl
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter test_bus_sel = "prbs_bist_testbus",	//Valid values: prbs_bist_testbus|tx_testbus|tx_ctrl_plane_testbus|wa_testbus|deskew_testbus|rm_testbus|rx_ctrl_testbus|pcie_ctrl_testbus|rx_ctrl_plane_testbus|agg_testbus
	parameter [ 12:0 ] wa_rvnumber_data = 13'b0,	//Valid values: 13
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter prbs_ver_clr_flag = "dis_prbs_clr_flag",	//Valid values: dis_prbs_clr_flag|en_prbs_clr_flag
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter [ 17:0 ] pma_done_count = 18'b0,	//Valid values: 18
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter bist_ver_clr_flag = "dis_bist_clr_flag",	//Valid values: dis_bist_clr_flag|en_bist_clr_flag
	parameter wa_disp_err_flag = "dis_disp_err_flag",	//Valid values: dis_disp_err_flag|en_disp_err_flag
	parameter runlength_check = "en_runlength_sw",	//Valid values: dis_runlength|en_runlength_sw|en_runlength_dw
	parameter [ 5:0 ] runlength_val = 6'b0,	//Valid values: 6
	parameter force_signal_detect = "en_force_signal_detect",	//Valid values: en_force_signal_detect|dis_force_signal_detect
	parameter deskew = "dis_deskew",	//Valid values: dis_deskew|en_srio_v2p1|en_xaui
	parameter rx_wr_clk = "rx_clk2_div_1_2_4",	//Valid values: rx_clk2_div_1_2_4|txfifo_rd_clk
	parameter rx_clk_free_running = "en_rx_clk_free_run",	//Valid values: dis_rx_clk_free_run|en_rx_clk_free_run
	parameter rx_pcs_urst = "en_rx_pcs_urst",	//Valid values: dis_rx_pcs_urst|en_rx_pcs_urst
	parameter pipe_if_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx
	parameter pc_fifo_rst_pld_ctrl = "dis_pc_fifo_rst_pld_ctrl",	//Valid values: dis_pc_fifo_rst_pld_ctrl|en_pc_fifo_rst_pld_ctrl
	parameter ibm_invalid_code = "dis_ibm_invalid_code",	//Valid values: dis_ibm_invalid_code|en_ibm_invalid_code
	parameter channel_number = 0,	//Valid values: 0..65
	parameter rx_refclk = "dis_refclk_sel",	//Valid values: dis_refclk_sel|en_refclk_sel
	parameter clock_gate_dw_rm_wr = "dis_dw_rm_wrclk_gating",	//Valid values: dis_dw_rm_wrclk_gating|en_dw_rm_wrclk_gating
	parameter clock_gate_bds_dec_asn = "dis_bds_dec_asn_clk_gating",	//Valid values: dis_bds_dec_asn_clk_gating|en_bds_dec_asn_clk_gating
	parameter fixed_pat_det = "dis_fixed_patdet",	//Valid values: dis_fixed_patdet|en_fixed_patdet
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_cdr_eidle = "dis_cdr_eidle_clk_gating",	//Valid values: dis_cdr_eidle_clk_gating|en_cdr_eidle_clk_gating
	parameter [ 19:0 ] clkcmp_pattern_p = 20'b0,	//Valid values: 20
	parameter [ 19:0 ] clkcmp_pattern_n = 20'b0,	//Valid values: 20
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter clock_gate_pc_rdclk = "dis_pc_rdclk_gating",	//Valid values: dis_pc_rdclk_gating|en_pc_rdclk_gating
	parameter wa_pd_polarity = "dis_pd_both_pol",	//Valid values: dis_pd_both_pol|en_pd_both_pol|dont_care_both_pol
	parameter clock_gate_dskw_rd = "dis_dskw_rdclk_gating",	//Valid values: dis_dskw_rdclk_gating|en_dskw_rdclk_gating
	parameter clock_gate_byteorder = "dis_byteorder_clk_gating",	//Valid values: dis_byteorder_clk_gating|en_byteorder_clk_gating
	parameter clock_gate_dw_pc_wrclk = "dis_dw_pc_wrclk_gating",	//Valid values: dis_dw_pc_wrclk_gating|en_dw_pc_wrclk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter clock_gate_sw_wa = "dis_sw_wa_clk_gating",	//Valid values: dis_sw_wa_clk_gating|en_sw_wa_clk_gating
	parameter clock_gate_dw_dskw_wr = "dis_dw_dskw_wrclk_gating",	//Valid values: dis_dw_dskw_wrclk_gating|en_dw_dskw_wrclk_gating
	parameter clock_gate_sw_pc_wrclk = "dis_sw_pc_wrclk_gating",	//Valid values: dis_sw_pc_wrclk_gating|en_sw_pc_wrclk_gating
	parameter clock_gate_sw_rm_rd = "dis_sw_rm_rdclk_gating",	//Valid values: dis_sw_rm_rdclk_gating|en_sw_rm_rdclk_gating
	parameter clock_gate_sw_rm_wr = "dis_sw_rm_wrclk_gating",	//Valid values: dis_sw_rm_wrclk_gating|en_sw_rm_wrclk_gating
	parameter auto_speed_nego = "dis_asn",	//Valid values: dis_asn|en_asn_g2_freq_scal
	parameter [ 3:0 ] fixed_pat_num = 4'b1111,	//Valid values: 4
	parameter clock_gate_sw_dskw_wr = "dis_sw_dskw_wrclk_gating",	//Valid values: dis_sw_dskw_wrclk_gating|en_sw_dskw_wrclk_gating
	parameter clock_gate_dw_rm_rd = "dis_dw_rm_rdclk_gating",	//Valid values: dis_dw_rm_rdclk_gating|en_dw_rm_rdclk_gating
	parameter clock_gate_dw_wa = "dis_dw_wa_clk_gating",	//Valid values: dis_dw_wa_clk_gating|en_dw_wa_clk_gating
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] a1a2size,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] alignstatus,
	input [ 0:0 ] alignstatussync0,
	input [ 0:0 ] alignstatussync0toporbot,
	input [ 0:0 ] alignstatustoporbot,
	input [ 0:0 ] bitreversalenable,
	input [ 0:0 ] bitslip,
	input [ 0:0 ] bytereversalenable,
	input [ 0:0 ] byteorder,
	input [ 0:0 ] cgcomprddall,
	input [ 0:0 ] cgcomprddalltoporbot,
	input [ 0:0 ] cgcompwrall,
	input [ 0:0 ] cgcompwralltoporbot,
	input [ 0:0 ] rmfifouserrst,
	input [ 0:0 ] configselinchnldown,
	input [ 0:0 ] configselinchnlup,
	input [ 0:0 ] delcondmet0,
	input [ 0:0 ] delcondmet0toporbot,
	input [ 0:0 ] dynclkswitchn,
	input [ 2:0 ] eidleinfersel,
	input [ 0:0 ] endskwqd,
	input [ 0:0 ] endskwqdtoporbot,
	input [ 0:0 ] endskwrdptrs,
	input [ 0:0 ] endskwrdptrstoporbot,
	input [ 0:0 ] enablecommadetect,
	input [ 0:0 ] fifoovr0,
	input [ 0:0 ] fifoovr0toporbot,
	input [ 0:0 ] rmfifordincomp0,
	input [ 0:0 ] fifordincomp0toporbot,
	input [ 0:0 ] fiforstrdqd,
	input [ 0:0 ] fiforstrdqdtoporbot,
	input [ 0:0 ] gen2ngen1,
	input [ 0:0 ] hrdrst,
	input [ 0:0 ] insertincomplete0,
	input [ 0:0 ] insertincomplete0toporbot,
	input [ 0:0 ] latencycomp0,
	input [ 0:0 ] latencycomp0toporbot,
	input [ 0:0 ] phfifouserrst,
	input [ 0:0 ] phystatusinternal,
	input [ 0:0 ] phystatuspcsgen3,
	input [ 0:0 ] pipeloopbk,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] pldrxclk,
	input [ 0:0 ] polinvrx,
	input [ 0:0 ] prbscidenable,
	input [ 19:0 ] datain,
	input [ 0:0 ] rateswitchcontrol,
	input [ 0:0 ] rcvdclkagg,
	input [ 0:0 ] rcvdclkaggtoporbot,
	input [ 0:0 ] rcvdclkpma,
	input [ 0:0 ] rdenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] rmfiforeadenable,
	input [ 0:0 ] pcfifordenable,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] refclkdig2,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 0:0 ] resetppmcntrsinchnldown,
	input [ 0:0 ] resetppmcntrsinchnlup,
	input [ 0:0 ] ctrlfromaggblock,
	input [ 0:0 ] rxcontrolrstoporbot,
	input [ 7:0 ] datafrinaggblock,
	input [ 7:0 ] rxdatarstoporbot,
	input [ 1:0 ] rxdivsyncinchnldown,
	input [ 1:0 ] rxdivsyncinchnlup,
	input [ 1:0 ] rxsynchdrpcsgen3,
	input [ 1:0 ] rxweinchnldown,
	input [ 1:0 ] rxweinchnlup,
	input [ 2:0 ] rxstatusinternal,
	input [ 0:0 ] rxpcsrst,
	input [ 0:0 ] rxvalidinternal,
	input [ 0:0 ] scanmode,
	input [ 0:0 ] sigdetfrompma,
	input [ 0:0 ] speedchangeinchnldown,
	input [ 0:0 ] speedchangeinchnlup,
	input [ 0:0 ] syncsmen,
	input [ 19:0 ] txctrlplanetestbus,
	input [ 1:0 ] txdivsync,
	input [ 0:0 ] txpmaclk,
	input [ 19:0 ] txtestbus,
	input [ 19:0 ] parallelloopback,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] pxfifowrdisable,
	input [ 0:0 ] rmfifowriteenable,
	output [ 3:0 ] a1a2k1k2flag,
	output [ 0:0 ] aggrxpcsrst,
	output [ 1:0 ] aligndetsync,
	output [ 0:0 ] alignstatuspld,
	output [ 0:0 ] alignstatussync,
	output [ 0:0 ] rmfifopartialfull,
	output [ 0:0 ] rmfifopartialempty,
	output [ 0:0 ] bistdone,
	output [ 0:0 ] bisterr,
	output [ 0:0 ] byteordflag,
	output [ 1:0 ] cgcomprddout,
	output [ 1:0 ] cgcompwrout,
	output [ 19:0 ] channeltestbusout,
	output [ 0:0 ] configseloutchnldown,
	output [ 0:0 ] configseloutchnlup,
	output [ 0:0 ] decoderctrl,
	output [ 7:0 ] decoderdata,
	output [ 0:0 ] decoderdatavalid,
	output [ 0:0 ] delcondmetout,
	output [ 0:0 ] disablepcfifobyteserdes,
	output [ 0:0 ] earlyeios,
	output [ 0:0 ] eidleexit,
	output [ 0:0 ] rmfifoempty,
	output [ 0:0 ] pcfifoempty,
	output [ 1:0 ] errctrl,
	output [ 15:0 ] errdata,
	output [ 0:0 ] fifoovrout,
	output [ 0:0 ] fifordoutcomp,
	output [ 0:0 ] rmfifofull,
	output [ 0:0 ] pcfifofull,
	output [ 0:0 ] insertincompleteout,
	output [ 0:0 ] latencycompout,
	output [ 0:0 ] ltr,
	output [ 0:0 ] pcieswitch,
	output [ 0:0 ] phystatus,
	output [ 63:0 ] pipedata,
	output [ 0:0 ] prbsdone,
	output [ 0:0 ] prbserrlt,
	output [ 1:0 ] rdalign,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] resetpcptrs,
	output [ 0:0 ] resetpcptrsinchnldownpipe,
	output [ 0:0 ] resetpcptrsinchnluppipe,
	output [ 0:0 ] resetpcptrsoutchnldown,
	output [ 0:0 ] resetpcptrsoutchnlup,
	output [ 0:0 ] resetppmcntrsoutchnldown,
	output [ 0:0 ] resetppmcntrsoutchnlup,
	output [ 0:0 ] resetppmcntrspcspma,
	output [ 19:0 ] parallelrevloopback,
	output [ 0:0 ] runlengthviolation,
	output [ 0:0 ] rlvlt,
	output [ 1:0 ] runningdisparity,
	output [ 3:0 ] rxblkstart,
	output [ 0:0 ] clocktopld,
	output [ 0:0 ] rxclkslip,
	output [ 3:0 ] rxdatavalid,
	output [ 1:0 ] rxdivsyncoutchnldown,
	output [ 1:0 ] rxdivsyncoutchnlup,
	output [ 0:0 ] rxpipeclk,
	output [ 0:0 ] rxpipesoftreset,
	output [ 1:0 ] rxsynchdr,
	output [ 1:0 ] rxweoutchnldown,
	output [ 1:0 ] rxweoutchnlup,
	output [ 63:0 ] dataout,
	output [ 0:0 ] eidledetected,
	output [ 2:0 ] rxstatus,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] selftestdone,
	output [ 0:0 ] selftesterr,
	output [ 0:0 ] signaldetectout,
	output [ 0:0 ] speedchange,
	output [ 0:0 ] speedchangeinchnldownpipe,
	output [ 0:0 ] speedchangeinchnluppipe,
	output [ 0:0 ] speedchangeoutchnldown,
	output [ 0:0 ] speedchangeoutchnlup,
	output [ 0:0 ] syncstatus,
	output [ 4:0 ] wordalignboundary,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_8g_rx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.tx_rx_parallel_loopback(tx_rx_parallel_loopback),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.polarity_inversion(polarity_inversion),
		.wa_pd(wa_pd),
		.wa_pd_data(wa_pd_data),
		.wa_boundary_lock_ctrl(wa_boundary_lock_ctrl),
		.wa_pld_controlled(wa_pld_controlled),
		.wa_sync_sm_ctrl(wa_sync_sm_ctrl),
		.wa_rknumber_data(wa_rknumber_data),
		.wa_renumber_data(wa_renumber_data),
		.wa_rgnumber_data(wa_rgnumber_data),
		.wa_rosnumber_data(wa_rosnumber_data),
		.wa_kchar(wa_kchar),
		.wa_det_latency_sync_status_beh(wa_det_latency_sync_status_beh),
		.wa_clk_slip_spacing(wa_clk_slip_spacing),
		.wa_clk_slip_spacing_data(wa_clk_slip_spacing_data),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.deskew_pattern(deskew_pattern),
		.deskew_prog_pattern_only(deskew_prog_pattern_only),
		.rate_match(rate_match),
		.eightb_tenb_decoder(eightb_tenb_decoder),
		.err_flags_sel(err_flags_sel),
		.polinv_8b10b_dec(polinv_8b10b_dec),
		.eightbtenb_decoder_output_sel(eightbtenb_decoder_output_sel),
		.invalid_code_flag_only(invalid_code_flag_only),
		.auto_error_replacement(auto_error_replacement),
		.pad_or_edb_error_replace(pad_or_edb_error_replace),
		.byte_deserializer(byte_deserializer),
		.byte_order(byte_order),
		.re_bo_on_wa(re_bo_on_wa),
		.bo_pattern(bo_pattern),
		.bo_pad(bo_pad),
		.phase_compensation_fifo(phase_compensation_fifo),
		.prbs_ver(prbs_ver),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_ver(bist_ver),
		.cdr_ctrl(cdr_ctrl),
		.cdr_ctrl_rxvalid_mask(cdr_ctrl_rxvalid_mask),
		.wait_cnt(wait_cnt),
		.mask_cnt(mask_cnt),
		.eidle_entry_sd(eidle_entry_sd),
		.eidle_entry_eios(eidle_entry_eios),
		.eidle_entry_iei(eidle_entry_iei),
		.rx_rcvd_clk(rx_rcvd_clk),
		.rx_clk1(rx_clk1),
		.rx_clk2(rx_clk2),
		.rx_rd_clk(rx_rd_clk),
		.dw_one_or_two_symbol_bo(dw_one_or_two_symbol_bo),
		.comp_fifo_rst_pld_ctrl(comp_fifo_rst_pld_ctrl),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.agg_block_sel(agg_block_sel),
		.test_bus_sel(test_bus_sel),
		.wa_rvnumber_data(wa_rvnumber_data),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.prbs_ver_clr_flag(prbs_ver_clr_flag),
		.hip_mode(hip_mode),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.pma_done_count(pma_done_count),
		.test_mode(test_mode),
		.bist_ver_clr_flag(bist_ver_clr_flag),
		.wa_disp_err_flag(wa_disp_err_flag),
		.runlength_check(runlength_check),
		.runlength_val(runlength_val),
		.force_signal_detect(force_signal_detect),
		.deskew(deskew),
		.rx_wr_clk(rx_wr_clk),
		.rx_clk_free_running(rx_clk_free_running),
		.rx_pcs_urst(rx_pcs_urst),
		.pipe_if_enable(pipe_if_enable),
		.pc_fifo_rst_pld_ctrl(pc_fifo_rst_pld_ctrl),
		.ibm_invalid_code(ibm_invalid_code),
		.channel_number(channel_number),
		.rx_refclk(rx_refclk),
		.clock_gate_dw_rm_wr(clock_gate_dw_rm_wr),
		.clock_gate_bds_dec_asn(clock_gate_bds_dec_asn),
		.fixed_pat_det(fixed_pat_det),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_cdr_eidle(clock_gate_cdr_eidle),
		.clkcmp_pattern_p(clkcmp_pattern_p),
		.clkcmp_pattern_n(clkcmp_pattern_n),
		.clock_gate_prbs(clock_gate_prbs),
		.clock_gate_pc_rdclk(clock_gate_pc_rdclk),
		.wa_pd_polarity(wa_pd_polarity),
		.clock_gate_dskw_rd(clock_gate_dskw_rd),
		.clock_gate_byteorder(clock_gate_byteorder),
		.clock_gate_dw_pc_wrclk(clock_gate_dw_pc_wrclk),
		.sup_mode(sup_mode),
		.clock_gate_sw_wa(clock_gate_sw_wa),
		.clock_gate_dw_dskw_wr(clock_gate_dw_dskw_wr),
		.clock_gate_sw_pc_wrclk(clock_gate_sw_pc_wrclk),
		.clock_gate_sw_rm_rd(clock_gate_sw_rm_rd),
		.clock_gate_sw_rm_wr(clock_gate_sw_rm_wr),
		.auto_speed_nego(auto_speed_nego),
		.fixed_pat_num(fixed_pat_num),
		.clock_gate_sw_dskw_wr(clock_gate_sw_dskw_wr),
		.clock_gate_dw_rm_rd(clock_gate_dw_rm_rd),
		.clock_gate_dw_wa(clock_gate_dw_wa),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_rx_pcs_encrypted_inst	(
		.a1a2size(a1a2size),
		.aggtestbus(aggtestbus),
		.alignstatus(alignstatus),
		.alignstatussync0(alignstatussync0),
		.alignstatussync0toporbot(alignstatussync0toporbot),
		.alignstatustoporbot(alignstatustoporbot),
		.bitreversalenable(bitreversalenable),
		.bitslip(bitslip),
		.bytereversalenable(bytereversalenable),
		.byteorder(byteorder),
		.cgcomprddall(cgcomprddall),
		.cgcomprddalltoporbot(cgcomprddalltoporbot),
		.cgcompwrall(cgcompwrall),
		.cgcompwralltoporbot(cgcompwralltoporbot),
		.rmfifouserrst(rmfifouserrst),
		.configselinchnldown(configselinchnldown),
		.configselinchnlup(configselinchnlup),
		.delcondmet0(delcondmet0),
		.delcondmet0toporbot(delcondmet0toporbot),
		.dynclkswitchn(dynclkswitchn),
		.eidleinfersel(eidleinfersel),
		.endskwqd(endskwqd),
		.endskwqdtoporbot(endskwqdtoporbot),
		.endskwrdptrs(endskwrdptrs),
		.endskwrdptrstoporbot(endskwrdptrstoporbot),
		.enablecommadetect(enablecommadetect),
		.fifoovr0(fifoovr0),
		.fifoovr0toporbot(fifoovr0toporbot),
		.rmfifordincomp0(rmfifordincomp0),
		.fifordincomp0toporbot(fifordincomp0toporbot),
		.fiforstrdqd(fiforstrdqd),
		.fiforstrdqdtoporbot(fiforstrdqdtoporbot),
		.gen2ngen1(gen2ngen1),
		.hrdrst(hrdrst),
		.insertincomplete0(insertincomplete0),
		.insertincomplete0toporbot(insertincomplete0toporbot),
		.latencycomp0(latencycomp0),
		.latencycomp0toporbot(latencycomp0toporbot),
		.phfifouserrst(phfifouserrst),
		.phystatusinternal(phystatusinternal),
		.phystatuspcsgen3(phystatuspcsgen3),
		.pipeloopbk(pipeloopbk),
		.pldltr(pldltr),
		.pldrxclk(pldrxclk),
		.polinvrx(polinvrx),
		.prbscidenable(prbscidenable),
		.datain(datain),
		.rateswitchcontrol(rateswitchcontrol),
		.rcvdclkagg(rcvdclkagg),
		.rcvdclkaggtoporbot(rcvdclkaggtoporbot),
		.rcvdclkpma(rcvdclkpma),
		.rdenableinchnldown(rdenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.rmfiforeadenable(rmfiforeadenable),
		.pcfifordenable(pcfifordenable),
		.refclkdig(refclkdig),
		.refclkdig2(refclkdig2),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.resetppmcntrsinchnldown(resetppmcntrsinchnldown),
		.resetppmcntrsinchnlup(resetppmcntrsinchnlup),
		.ctrlfromaggblock(ctrlfromaggblock),
		.rxcontrolrstoporbot(rxcontrolrstoporbot),
		.datafrinaggblock(datafrinaggblock),
		.rxdatarstoporbot(rxdatarstoporbot),
		.rxdivsyncinchnldown(rxdivsyncinchnldown),
		.rxdivsyncinchnlup(rxdivsyncinchnlup),
		.rxsynchdrpcsgen3(rxsynchdrpcsgen3),
		.rxweinchnldown(rxweinchnldown),
		.rxweinchnlup(rxweinchnlup),
		.rxstatusinternal(rxstatusinternal),
		.rxpcsrst(rxpcsrst),
		.rxvalidinternal(rxvalidinternal),
		.scanmode(scanmode),
		.sigdetfrompma(sigdetfrompma),
		.speedchangeinchnldown(speedchangeinchnldown),
		.speedchangeinchnlup(speedchangeinchnlup),
		.syncsmen(syncsmen),
		.txctrlplanetestbus(txctrlplanetestbus),
		.txdivsync(txdivsync),
		.txpmaclk(txpmaclk),
		.txtestbus(txtestbus),
		.parallelloopback(parallelloopback),
		.wrenableinchnldown(wrenableinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.pxfifowrdisable(pxfifowrdisable),
		.rmfifowriteenable(rmfifowriteenable),
		.a1a2k1k2flag(a1a2k1k2flag),
		.aggrxpcsrst(aggrxpcsrst),
		.aligndetsync(aligndetsync),
		.alignstatuspld(alignstatuspld),
		.alignstatussync(alignstatussync),
		.rmfifopartialfull(rmfifopartialfull),
		.rmfifopartialempty(rmfifopartialempty),
		.bistdone(bistdone),
		.bisterr(bisterr),
		.byteordflag(byteordflag),
		.cgcomprddout(cgcomprddout),
		.cgcompwrout(cgcompwrout),
		.channeltestbusout(channeltestbusout),
		.configseloutchnldown(configseloutchnldown),
		.configseloutchnlup(configseloutchnlup),
		.decoderctrl(decoderctrl),
		.decoderdata(decoderdata),
		.decoderdatavalid(decoderdatavalid),
		.delcondmetout(delcondmetout),
		.disablepcfifobyteserdes(disablepcfifobyteserdes),
		.earlyeios(earlyeios),
		.eidleexit(eidleexit),
		.rmfifoempty(rmfifoempty),
		.pcfifoempty(pcfifoempty),
		.errctrl(errctrl),
		.errdata(errdata),
		.fifoovrout(fifoovrout),
		.fifordoutcomp(fifordoutcomp),
		.rmfifofull(rmfifofull),
		.pcfifofull(pcfifofull),
		.insertincompleteout(insertincompleteout),
		.latencycompout(latencycompout),
		.ltr(ltr),
		.pcieswitch(pcieswitch),
		.phystatus(phystatus),
		.pipedata(pipedata),
		.prbsdone(prbsdone),
		.prbserrlt(prbserrlt),
		.rdalign(rdalign),
		.rdenableoutchnldown(rdenableoutchnldown),
		.rdenableoutchnlup(rdenableoutchnlup),
		.resetpcptrs(resetpcptrs),
		.resetpcptrsinchnldownpipe(resetpcptrsinchnldownpipe),
		.resetpcptrsinchnluppipe(resetpcptrsinchnluppipe),
		.resetpcptrsoutchnldown(resetpcptrsoutchnldown),
		.resetpcptrsoutchnlup(resetpcptrsoutchnlup),
		.resetppmcntrsoutchnldown(resetppmcntrsoutchnldown),
		.resetppmcntrsoutchnlup(resetppmcntrsoutchnlup),
		.resetppmcntrspcspma(resetppmcntrspcspma),
		.parallelrevloopback(parallelrevloopback),
		.runlengthviolation(runlengthviolation),
		.rlvlt(rlvlt),
		.runningdisparity(runningdisparity),
		.rxblkstart(rxblkstart),
		.clocktopld(clocktopld),
		.rxclkslip(rxclkslip),
		.rxdatavalid(rxdatavalid),
		.rxdivsyncoutchnldown(rxdivsyncoutchnldown),
		.rxdivsyncoutchnlup(rxdivsyncoutchnlup),
		.rxpipeclk(rxpipeclk),
		.rxpipesoftreset(rxpipesoftreset),
		.rxsynchdr(rxsynchdr),
		.rxweoutchnldown(rxweoutchnldown),
		.rxweoutchnlup(rxweoutchnlup),
		.dataout(dataout),
		.eidledetected(eidledetected),
		.rxstatus(rxstatus),
		.rxvalid(rxvalid),
		.selftestdone(selftestdone),
		.selftesterr(selftesterr),
		.signaldetectout(signaldetectout),
		.speedchange(speedchange),
		.speedchangeinchnldownpipe(speedchangeinchnldownpipe),
		.speedchangeinchnluppipe(speedchangeinchnluppipe),
		.speedchangeoutchnldown(speedchangeoutchnldown),
		.speedchangeoutchnlup(speedchangeoutchnlup),
		.syncstatus(syncstatus),
		.wordalignboundary(wordalignboundary),
		.wrenableoutchnldown(wrenableoutchnldown),
		.wrenableoutchnlup(wrenableoutchnlup),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_8g_tx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_8g_tx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "basic",	//Valid values: pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter tx_compliance_controlled_disparity = "dis_txcompliance",	//Valid values: dis_txcompliance|en_txcompliance_pipe2p0
	parameter force_kchar = "dis_force_kchar",	//Valid values: dis_force_kchar|en_force_kchar
	parameter force_echar = "dis_force_echar",	//Valid values: dis_force_echar|en_force_echar
	parameter byte_serializer = "dis_bs",	//Valid values: dis_bs|en_bs_by_2
	parameter data_selection_8b10b_encoder_input = "normal_data_path",	//Valid values: normal_data_path|xaui_sm|gige_idle_conversion
	parameter eightb_tenb_disp_ctrl = "dis_disp_ctrl",	//Valid values: dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
	parameter eightb_tenb_encoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter prbs_gen = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter [ 7:0 ] cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_gen = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter polarity_inversion = "dis_polinv",	//Valid values: dis_polinv|enable_polinv
	parameter tx_bitslip = "dis_tx_bitslip",	//Valid values: dis_tx_bitslip|en_tx_bitslip
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter revloop_back_rm = "dis_rev_loopback_rx_rm",	//Valid values: dis_rev_loopback_rx_rm|en_rev_loopback_rx_rm
	parameter phfifo_write_clk_sel = "pld_tx_clk",	//Valid values: pld_tx_clk|tx_clk
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter refclk_b_clk_sel = "tx_pma_clock",	//Valid values: tx_pma_clock|refclk_dig
	parameter auto_speed_nego_gen2 = "dis_asn_g2",	//Valid values: dis_asn_g2|en_asn_g2_freq_scal
	parameter txpcs_urst = "en_txpcs_urst",	//Valid values: dis_txpcs_urst|en_txpcs_urst
	parameter clock_gate_dw_fifowr = "dis_dw_fifowr_clk_gating",	//Valid values: dis_dw_fifowr_clk_gating|en_dw_fifowr_clk_gating
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter txclk_freerun = "dis_freerun_tx",	//Valid values: dis_freerun_tx|en_freerun_tx
	parameter clock_gate_bs_enc = "dis_bs_enc_clk_gating",	//Valid values: dis_bs_enc_clk_gating|en_bs_enc_clk_gating
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_fiford = "dis_fiford_clk_gating",	//Valid values: dis_fiford_clk_gating|en_fiford_clk_gating
	parameter pcfifo_urst = "dis_pcfifourst",	//Valid values: dis_pcfifourst|en_pcfifourst
	parameter clock_gate_sw_fifowr = "dis_sw_fifowr_clk_gating",	//Valid values: dis_sw_fifowr_clk_gating|en_sw_fifowr_clk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter dynamic_clk_switch = "dis_dyn_clk_switch",	//Valid values: dis_dyn_clk_switch|en_dyn_clk_switch
	parameter channel_number = 0,	//Valid values: 0..65
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] dispcbyte,
	input [ 2:0 ] elecidleinfersel,
	input [ 1:0 ] fifoselectinchnldown,
	input [ 1:0 ] fifoselectinchnlup,
	input [ 0:0 ] rateswitch,
	input [ 0:0 ] hrdrst,
	input [ 0:0 ] pipetxdeemph,
	input [ 2:0 ] pipetxmargin,
	input [ 0:0 ] phfiforeset,
	input [ 0:0 ] coreclk,
	input [ 0:0 ] polinvrxin,
	input [ 0:0 ] invpol,
	input [ 1:0 ] powerdn,
	input [ 0:0 ] prbscidenable,
	input [ 0:0 ] rdenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] phfiforddisable,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] resetpcptrs,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 19:0 ] revparallellpbkdata,
	input [ 0:0 ] enrevparallellpbk,
	input [ 0:0 ] pipeenrevparallellpbkin,
	input [ 0:0 ] rxpolarityin,
	input [ 0:0 ] scanmode,
	input [ 3:0 ] txblkstart,
	input [ 4:0 ] bitslipboundaryselect,
	input [ 0:0 ] xgmctrl,
	input [ 0:0 ] xgmctrltoporbottom,
	input [ 7:0 ] xgmdatain,
	input [ 7:0 ] xgmdataintoporbottom,
	input [ 3:0 ] txdatavalid,
	input [ 1:0 ] txdivsyncinchnldown,
	input [ 1:0 ] txdivsyncinchnlup,
	input [ 1:0 ] txsynchdr,
	input [ 43:0 ] datain,
	input [ 0:0 ] detectrxloopin,
	input [ 0:0 ] txpmalocalclk,
	input [ 0:0 ] pipetxswing,
	input [ 0:0 ] txpcsreset,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] phfifowrenable,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] dynclkswitchn,
	output [ 0:0 ] phfifounderflow,
	output [ 1:0 ] fifoselectoutchnldown,
	output [ 1:0 ] fifoselectoutchnlup,
	output [ 0:0 ] phfifooverflow,
	output [ 2:0 ] grayelecidleinferselout,
	output [ 0:0 ] phfifotxdeemph,
	output [ 2:0 ] phfifotxmargin,
	output [ 0:0 ] phfifotxswing,
	output [ 0:0 ] polinvrxout,
	output [ 1:0 ] pipepowerdownout,
	output [ 19:0 ] dataout,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] rdenablesync,
	output [ 0:0 ] refclkb,
	output [ 0:0 ] refclkbreset,
	output [ 0:0 ] pipeenrevparallellpbkout,
	output [ 0:0 ] rxpolarityout,
	output [ 3:0 ] txblkstartout,
	output [ 0:0 ] clkout,
	output [ 0:0 ] xgmctrlenable,
	output [ 19:0 ] txctrlplanetestbus,
	output [ 31:0 ] txdataouttogen3,
	output [ 7:0 ] xgmdataout,
	output [ 3:0 ] txdatavalidouttogen3,
	output [ 3:0 ] txdatakouttogen3,
	output [ 1:0 ] txdivsync,
	output [ 1:0 ] txdivsyncoutchnldown,
	output [ 1:0 ] txdivsyncoutchnlup,
	output [ 0:0 ] txpipeclk,
	output [ 0:0 ] txpipeelectidle,
	output [ 0:0 ] txpipesoftreset,
	output [ 1:0 ] txsynchdrout,
	output [ 19:0 ] txtestbus,
	output [ 0:0 ] txcomplianceout,
	output [ 0:0 ] detectrxloopout,
	output [ 0:0 ] txelecidleout,
	output [ 19:0 ] parallelfdbkout,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_8g_tx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.phase_compensation_fifo(phase_compensation_fifo),
		.tx_compliance_controlled_disparity(tx_compliance_controlled_disparity),
		.force_kchar(force_kchar),
		.force_echar(force_echar),
		.byte_serializer(byte_serializer),
		.data_selection_8b10b_encoder_input(data_selection_8b10b_encoder_input),
		.eightb_tenb_disp_ctrl(eightb_tenb_disp_ctrl),
		.eightb_tenb_encoder(eightb_tenb_encoder),
		.prbs_gen(prbs_gen),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_gen(bist_gen),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.polarity_inversion(polarity_inversion),
		.tx_bitslip(tx_bitslip),
		.agg_block_sel(agg_block_sel),
		.revloop_back_rm(revloop_back_rm),
		.phfifo_write_clk_sel(phfifo_write_clk_sel),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.test_mode(test_mode),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.refclk_b_clk_sel(refclk_b_clk_sel),
		.auto_speed_nego_gen2(auto_speed_nego_gen2),
		.txpcs_urst(txpcs_urst),
		.clock_gate_dw_fifowr(clock_gate_dw_fifowr),
		.clock_gate_prbs(clock_gate_prbs),
		.txclk_freerun(txclk_freerun),
		.clock_gate_bs_enc(clock_gate_bs_enc),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_fiford(clock_gate_fiford),
		.pcfifo_urst(pcfifo_urst),
		.clock_gate_sw_fifowr(clock_gate_sw_fifowr),
		.sup_mode(sup_mode),
		.dynamic_clk_switch(dynamic_clk_switch),
		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_tx_pcs_encrypted_inst	(
		.dispcbyte(dispcbyte),
		.elecidleinfersel(elecidleinfersel),
		.fifoselectinchnldown(fifoselectinchnldown),
		.fifoselectinchnlup(fifoselectinchnlup),
		.rateswitch(rateswitch),
		.hrdrst(hrdrst),
		.pipetxdeemph(pipetxdeemph),
		.pipetxmargin(pipetxmargin),
		.phfiforeset(phfiforeset),
		.coreclk(coreclk),
		.polinvrxin(polinvrxin),
		.invpol(invpol),
		.powerdn(powerdn),
		.prbscidenable(prbscidenable),
		.rdenableinchnldown(rdenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.phfiforddisable(phfiforddisable),
		.refclkdig(refclkdig),
		.resetpcptrs(resetpcptrs),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.revparallellpbkdata(revparallellpbkdata),
		.enrevparallellpbk(enrevparallellpbk),
		.pipeenrevparallellpbkin(pipeenrevparallellpbkin),
		.rxpolarityin(rxpolarityin),
		.scanmode(scanmode),
		.txblkstart(txblkstart),
		.bitslipboundaryselect(bitslipboundaryselect),
		.xgmctrl(xgmctrl),
		.xgmctrltoporbottom(xgmctrltoporbottom),
		.xgmdatain(xgmdatain),
		.xgmdataintoporbottom(xgmdataintoporbottom),
		.txdatavalid(txdatavalid),
		.txdivsyncinchnldown(txdivsyncinchnldown),
		.txdivsyncinchnlup(txdivsyncinchnlup),
		.txsynchdr(txsynchdr),
		.datain(datain),
		.detectrxloopin(detectrxloopin),
		.txpmalocalclk(txpmalocalclk),
		.pipetxswing(pipetxswing),
		.txpcsreset(txpcsreset),
		.wrenableinchnldown(wrenableinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.phfifowrenable(phfifowrenable),
		.aggtxpcsrst(aggtxpcsrst),
		.dynclkswitchn(dynclkswitchn),
		.phfifounderflow(phfifounderflow),
		.fifoselectoutchnldown(fifoselectoutchnldown),
		.fifoselectoutchnlup(fifoselectoutchnlup),
		.phfifooverflow(phfifooverflow),
		.grayelecidleinferselout(grayelecidleinferselout),
		.phfifotxdeemph(phfifotxdeemph),
		.phfifotxmargin(phfifotxmargin),
		.phfifotxswing(phfifotxswing),
		.polinvrxout(polinvrxout),
		.pipepowerdownout(pipepowerdownout),
		.dataout(dataout),
		.rdenableoutchnldown(rdenableoutchnldown),
		.rdenableoutchnlup(rdenableoutchnlup),
		.rdenablesync(rdenablesync),
		.refclkb(refclkb),
		.refclkbreset(refclkbreset),
		.pipeenrevparallellpbkout(pipeenrevparallellpbkout),
		.rxpolarityout(rxpolarityout),
		.txblkstartout(txblkstartout),
		.clkout(clkout),
		.xgmctrlenable(xgmctrlenable),
		.txctrlplanetestbus(txctrlplanetestbus),
		.txdataouttogen3(txdataouttogen3),
		.xgmdataout(xgmdataout),
		.txdatavalidouttogen3(txdatavalidouttogen3),
		.txdatakouttogen3(txdatakouttogen3),
		.txdivsync(txdivsync),
		.txdivsyncoutchnldown(txdivsyncoutchnldown),
		.txdivsyncoutchnlup(txdivsyncoutchnlup),
		.txpipeclk(txpipeclk),
		.txpipeelectidle(txpipeelectidle),
		.txpipesoftreset(txpipesoftreset),
		.txsynchdrout(txsynchdrout),
		.txtestbus(txtestbus),
		.txcomplianceout(txcomplianceout),
		.detectrxloopout(detectrxloopout),
		.txelecidleout(txelecidleout),
		.parallelfdbkout(parallelfdbkout),
		.wrenableoutchnldown(wrenableoutchnldown),
		.wrenableoutchnlup(wrenableoutchnlup),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_common_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_common_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "disabled_prot_mode",	//Valid values: disabled_prot_mode|pipe_g1|pipe_g2|other_protocols
	parameter force_freqdet = "force_freqdet_dis",	//Valid values: force_freqdet_dis|force1_freqdet_en|force0_freqdet_en
	parameter ppmsel = "ppmsel_default",	//Valid values: ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
	parameter ppm_cnt_rst = "ppm_cnt_rst_dis",	//Valid values: ppm_cnt_rst_dis|ppm_cnt_rst_en
	parameter auto_speed_ena = "dis_auto_speed_ena",	//Valid values: dis_auto_speed_ena|en_auto_speed_ena
	parameter ppm_gen1_2_cnt = "cnt_32k",	//Valid values: cnt_32k|cnt_64k
	parameter ppm_post_eidle_delay = "cnt_200_cycles",	//Valid values: cnt_200_cycles|cnt_400_cycles
	parameter func_mode = "disable",	//Valid values: disable|hrdrstctrl_cmu|eightg_only_pld|eightg_only_hip|pma_direct
	parameter pma_if_dft_val = "dft_0",	//Valid values: dft_0
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs
	parameter ppm_deassert_early = "deassert_early_dis",	//Valid values: deassert_early_dis|deassert_early_en
	parameter pipe_if_g3pcs = "pipe_if_8gpcs",	//Valid values: pipe_if_8gpcs
	parameter pma_if_dft_en = "dft_dis",	//Valid values: dft_dis
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] aggalignstatus,
	input [ 0:0 ] aggalignstatussync0,
	input [ 0:0 ] aggalignstatussync0toporbot,
	input [ 0:0 ] aggalignstatustoporbot,
	input [ 0:0 ] aggcgcomprddall,
	input [ 0:0 ] aggcgcomprddalltoporbot,
	input [ 0:0 ] aggcgcompwrall,
	input [ 0:0 ] aggcgcompwralltoporbot,
	input [ 0:0 ] aggdelcondmet0,
	input [ 0:0 ] aggdelcondmet0toporbot,
	input [ 0:0 ] aggendskwqd,
	input [ 0:0 ] aggendskwqdtoporbot,
	input [ 0:0 ] aggendskwrdptrs,
	input [ 0:0 ] aggendskwrdptrstoporbot,
	input [ 0:0 ] aggfifoovr0,
	input [ 0:0 ] aggfifoovr0toporbot,
	input [ 0:0 ] aggfifordincomp0,
	input [ 0:0 ] aggfifordincomp0toporbot,
	input [ 0:0 ] aggfiforstrdqd,
	input [ 0:0 ] aggfiforstrdqdtoporbot,
	input [ 0:0 ] agginsertincomplete0,
	input [ 0:0 ] agginsertincomplete0toporbot,
	input [ 0:0 ] agglatencycomp0,
	input [ 0:0 ] agglatencycomp0toporbot,
	input [ 0:0 ] aggrcvdclkagg,
	input [ 0:0 ] aggrcvdclkaggtoporbot,
	input [ 0:0 ] aggrxcontrolrs,
	input [ 0:0 ] aggrxcontrolrstoporbot,
	input [ 7:0 ] aggrxdatars,
	input [ 7:0 ] aggrxdatarstoporbot,
	input [ 0:0 ] aggtestsotopldin,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] aggtxctlts,
	input [ 0:0 ] aggtxctltstoporbot,
	input [ 7:0 ] aggtxdatats,
	input [ 7:0 ] aggtxdatatstoporbot,
	input [ 0:0 ] hardreset,
	input [ 0:0 ] pcs8gearlyeios,
	input [ 0:0 ] pcs8geidleexit,
	input [ 0:0 ] pcs8gltrpma,
	input [ 0:0 ] pcs8gpcieswitch,
	input [ 17:0 ] pcs8gpmacurrentcoeff,
	input [ 0:0 ] pcs8gtxelecidle,
	input [ 0:0 ] pcs8gtxdetectrx,
	input [ 1:0 ] pcsaggaligndetsync,
	input [ 0:0 ] pcsaggalignstatussync,
	input [ 1:0 ] pcsaggcgcomprddout,
	input [ 1:0 ] pcsaggcgcompwrout,
	input [ 0:0 ] pcsaggdecctl,
	input [ 7:0 ] pcsaggdecdata,
	input [ 0:0 ] pcsaggdecdatavalid,
	input [ 0:0 ] pcsaggdelcondmetout,
	input [ 0:0 ] pcsaggfifoovrout,
	input [ 0:0 ] pcsaggfifordoutcomp,
	input [ 0:0 ] pcsagginsertincompleteout,
	input [ 0:0 ] pcsagglatencycompout,
	input [ 1:0 ] pcsaggrdalign,
	input [ 0:0 ] pcsaggrdenablesync,
	input [ 0:0 ] pcsaggrefclkdig,
	input [ 1:0 ] pcsaggrunningdisp,
	input [ 0:0 ] pcsaggrxpcsrst,
	input [ 0:0 ] pcsaggscanmoden,
	input [ 0:0 ] pcsaggscanshiftn,
	input [ 0:0 ] pcsaggsyncstatus,
	input [ 0:0 ] pcsaggtxctltc,
	input [ 7:0 ] pcsaggtxdatatc,
	input [ 0:0 ] pcsaggtxpcsrst,
	input [ 0:0 ] pcsrefclkdig,
	input [ 0:0 ] pcsscanmoden,
	input [ 0:0 ] pcsscanshiftn,
	input [ 0:0 ] pldnfrzdrv,
	input [ 0:0 ] pldpartialreconfig,
	input [ 0:0 ] pldtestsitoaggin,
	input [ 0:0 ] clklow,
	input [ 0:0 ] fref,
	input [ 0:0 ] pmahclk,
	input [ 1:0 ] pmapcieswdone,
	input [ 0:0 ] pmarxdetectvalid,
	input [ 0:0 ] pmarxfound,
	input [ 0:0 ] pmarxpmarstb,
	input [ 0:0 ] resetppmcntrs,
	output [ 1:0 ] aggaligndetsync,
	output [ 0:0 ] aggalignstatussync,
	output [ 1:0 ] aggcgcomprddout,
	output [ 1:0 ] aggcgcompwrout,
	output [ 0:0 ] aggdecctl,
	output [ 7:0 ] aggdecdata,
	output [ 0:0 ] aggdecdatavalid,
	output [ 0:0 ] aggdelcondmetout,
	output [ 0:0 ] aggfifoovrout,
	output [ 0:0 ] aggfifordoutcomp,
	output [ 0:0 ] agginsertincompleteout,
	output [ 0:0 ] agglatencycompout,
	output [ 1:0 ] aggrdalign,
	output [ 0:0 ] aggrdenablesync,
	output [ 0:0 ] aggrefclkdig,
	output [ 1:0 ] aggrunningdisp,
	output [ 0:0 ] aggrxpcsrst,
	output [ 0:0 ] aggscanmoden,
	output [ 0:0 ] aggscanshiftn,
	output [ 0:0 ] aggsyncstatus,
	output [ 0:0 ] aggtestsotopldout,
	output [ 0:0 ] aggtxctltc,
	output [ 7:0 ] aggtxdatatc,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] pcs8ggen2ngen1,
	output [ 0:0 ] pcs8gpmarxfound,
	output [ 0:0 ] pcs8gpowerstatetransitiondone,
	output [ 0:0 ] pcs8grxdetectvalid,
	output [ 0:0 ] pcsaggalignstatus,
	output [ 0:0 ] pcsaggalignstatussync0,
	output [ 0:0 ] pcsaggalignstatussync0toporbot,
	output [ 0:0 ] pcsaggalignstatustoporbot,
	output [ 0:0 ] pcsaggcgcomprddall,
	output [ 0:0 ] pcsaggcgcomprddalltoporbot,
	output [ 0:0 ] pcsaggcgcompwrall,
	output [ 0:0 ] pcsaggcgcompwralltoporbot,
	output [ 0:0 ] pcsaggdelcondmet0,
	output [ 0:0 ] pcsaggdelcondmet0toporbot,
	output [ 0:0 ] pcsaggendskwqd,
	output [ 0:0 ] pcsaggendskwqdtoporbot,
	output [ 0:0 ] pcsaggendskwrdptrs,
	output [ 0:0 ] pcsaggendskwrdptrstoporbot,
	output [ 0:0 ] pcsaggfifoovr0,
	output [ 0:0 ] pcsaggfifoovr0toporbot,
	output [ 0:0 ] pcsaggfifordincomp0,
	output [ 0:0 ] pcsaggfifordincomp0toporbot,
	output [ 0:0 ] pcsaggfiforstrdqd,
	output [ 0:0 ] pcsaggfiforstrdqdtoporbot,
	output [ 0:0 ] pcsagginsertincomplete0,
	output [ 0:0 ] pcsagginsertincomplete0toporbot,
	output [ 0:0 ] pcsagglatencycomp0,
	output [ 0:0 ] pcsagglatencycomp0toporbot,
	output [ 0:0 ] pcsaggrcvdclkagg,
	output [ 0:0 ] pcsaggrcvdclkaggtoporbot,
	output [ 0:0 ] pcsaggrxcontrolrs,
	output [ 0:0 ] pcsaggrxcontrolrstoporbot,
	output [ 7:0 ] pcsaggrxdatars,
	output [ 7:0 ] pcsaggrxdatarstoporbot,
	output [ 15:0 ] pcsaggtestbus,
	output [ 0:0 ] pcsaggtxctlts,
	output [ 0:0 ] pcsaggtxctltstoporbot,
	output [ 7:0 ] pcsaggtxdatats,
	output [ 7:0 ] pcsaggtxdatatstoporbot,
	output [ 0:0 ] pldhclkout,
	output [ 0:0 ] pldtestsitoaggout,
	output [ 0:0 ] pmaclklowout,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmafrefout,
	output [ 9:0 ] pmaiftestbus,
	output [ 0:0 ] pmaltr,
	output [ 0:0 ] pmanfrzdrv,
	output [ 0:0 ] pmapartialreconfig,
	output [ 1:0 ] pmapcieswitch,
	output [ 0:0 ] freqlock,
	output [ 0:0 ] pmatxelecidle,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] asynchdatain,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_common_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.force_freqdet(force_freqdet),
		.ppmsel(ppmsel),
		.ppm_cnt_rst(ppm_cnt_rst),
		.auto_speed_ena(auto_speed_ena),
		.ppm_gen1_2_cnt(ppm_gen1_2_cnt),
		.ppm_post_eidle_delay(ppm_post_eidle_delay),
		.func_mode(func_mode),
		.pma_if_dft_val(pma_if_dft_val),
		.sup_mode(sup_mode),
		.selectpcs(selectpcs),
		.ppm_deassert_early(ppm_deassert_early),
		.pipe_if_g3pcs(pipe_if_g3pcs),
		.pma_if_dft_en(pma_if_dft_en),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_common_pcs_pma_interface_encrypted_inst	(
		.aggalignstatus(aggalignstatus),
		.aggalignstatussync0(aggalignstatussync0),
		.aggalignstatussync0toporbot(aggalignstatussync0toporbot),
		.aggalignstatustoporbot(aggalignstatustoporbot),
		.aggcgcomprddall(aggcgcomprddall),
		.aggcgcomprddalltoporbot(aggcgcomprddalltoporbot),
		.aggcgcompwrall(aggcgcompwrall),
		.aggcgcompwralltoporbot(aggcgcompwralltoporbot),
		.aggdelcondmet0(aggdelcondmet0),
		.aggdelcondmet0toporbot(aggdelcondmet0toporbot),
		.aggendskwqd(aggendskwqd),
		.aggendskwqdtoporbot(aggendskwqdtoporbot),
		.aggendskwrdptrs(aggendskwrdptrs),
		.aggendskwrdptrstoporbot(aggendskwrdptrstoporbot),
		.aggfifoovr0(aggfifoovr0),
		.aggfifoovr0toporbot(aggfifoovr0toporbot),
		.aggfifordincomp0(aggfifordincomp0),
		.aggfifordincomp0toporbot(aggfifordincomp0toporbot),
		.aggfiforstrdqd(aggfiforstrdqd),
		.aggfiforstrdqdtoporbot(aggfiforstrdqdtoporbot),
		.agginsertincomplete0(agginsertincomplete0),
		.agginsertincomplete0toporbot(agginsertincomplete0toporbot),
		.agglatencycomp0(agglatencycomp0),
		.agglatencycomp0toporbot(agglatencycomp0toporbot),
		.aggrcvdclkagg(aggrcvdclkagg),
		.aggrcvdclkaggtoporbot(aggrcvdclkaggtoporbot),
		.aggrxcontrolrs(aggrxcontrolrs),
		.aggrxcontrolrstoporbot(aggrxcontrolrstoporbot),
		.aggrxdatars(aggrxdatars),
		.aggrxdatarstoporbot(aggrxdatarstoporbot),
		.aggtestsotopldin(aggtestsotopldin),
		.aggtestbus(aggtestbus),
		.aggtxctlts(aggtxctlts),
		.aggtxctltstoporbot(aggtxctltstoporbot),
		.aggtxdatats(aggtxdatats),
		.aggtxdatatstoporbot(aggtxdatatstoporbot),
		.hardreset(hardreset),
		.pcs8gearlyeios(pcs8gearlyeios),
		.pcs8geidleexit(pcs8geidleexit),
		.pcs8gltrpma(pcs8gltrpma),
		.pcs8gpcieswitch(pcs8gpcieswitch),
		.pcs8gpmacurrentcoeff(pcs8gpmacurrentcoeff),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxdetectrx(pcs8gtxdetectrx),
		.pcsaggaligndetsync(pcsaggaligndetsync),
		.pcsaggalignstatussync(pcsaggalignstatussync),
		.pcsaggcgcomprddout(pcsaggcgcomprddout),
		.pcsaggcgcompwrout(pcsaggcgcompwrout),
		.pcsaggdecctl(pcsaggdecctl),
		.pcsaggdecdata(pcsaggdecdata),
		.pcsaggdecdatavalid(pcsaggdecdatavalid),
		.pcsaggdelcondmetout(pcsaggdelcondmetout),
		.pcsaggfifoovrout(pcsaggfifoovrout),
		.pcsaggfifordoutcomp(pcsaggfifordoutcomp),
		.pcsagginsertincompleteout(pcsagginsertincompleteout),
		.pcsagglatencycompout(pcsagglatencycompout),
		.pcsaggrdalign(pcsaggrdalign),
		.pcsaggrdenablesync(pcsaggrdenablesync),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.pcsaggrunningdisp(pcsaggrunningdisp),
		.pcsaggrxpcsrst(pcsaggrxpcsrst),
		.pcsaggscanmoden(pcsaggscanmoden),
		.pcsaggscanshiftn(pcsaggscanshiftn),
		.pcsaggsyncstatus(pcsaggsyncstatus),
		.pcsaggtxctltc(pcsaggtxctltc),
		.pcsaggtxdatatc(pcsaggtxdatatc),
		.pcsaggtxpcsrst(pcsaggtxpcsrst),
		.pcsrefclkdig(pcsrefclkdig),
		.pcsscanmoden(pcsscanmoden),
		.pcsscanshiftn(pcsscanshiftn),
		.pldnfrzdrv(pldnfrzdrv),
		.pldpartialreconfig(pldpartialreconfig),
		.pldtestsitoaggin(pldtestsitoaggin),
		.clklow(clklow),
		.fref(fref),
		.pmahclk(pmahclk),
		.pmapcieswdone(pmapcieswdone),
		.pmarxdetectvalid(pmarxdetectvalid),
		.pmarxfound(pmarxfound),
		.pmarxpmarstb(pmarxpmarstb),
		.resetppmcntrs(resetppmcntrs),
		.aggaligndetsync(aggaligndetsync),
		.aggalignstatussync(aggalignstatussync),
		.aggcgcomprddout(aggcgcomprddout),
		.aggcgcompwrout(aggcgcompwrout),
		.aggdecctl(aggdecctl),
		.aggdecdata(aggdecdata),
		.aggdecdatavalid(aggdecdatavalid),
		.aggdelcondmetout(aggdelcondmetout),
		.aggfifoovrout(aggfifoovrout),
		.aggfifordoutcomp(aggfifordoutcomp),
		.agginsertincompleteout(agginsertincompleteout),
		.agglatencycompout(agglatencycompout),
		.aggrdalign(aggrdalign),
		.aggrdenablesync(aggrdenablesync),
		.aggrefclkdig(aggrefclkdig),
		.aggrunningdisp(aggrunningdisp),
		.aggrxpcsrst(aggrxpcsrst),
		.aggscanmoden(aggscanmoden),
		.aggscanshiftn(aggscanshiftn),
		.aggsyncstatus(aggsyncstatus),
		.aggtestsotopldout(aggtestsotopldout),
		.aggtxctltc(aggtxctltc),
		.aggtxdatatc(aggtxdatatc),
		.aggtxpcsrst(aggtxpcsrst),
		.pcs8ggen2ngen1(pcs8ggen2ngen1),
		.pcs8gpmarxfound(pcs8gpmarxfound),
		.pcs8gpowerstatetransitiondone(pcs8gpowerstatetransitiondone),
		.pcs8grxdetectvalid(pcs8grxdetectvalid),
		.pcsaggalignstatus(pcsaggalignstatus),
		.pcsaggalignstatussync0(pcsaggalignstatussync0),
		.pcsaggalignstatussync0toporbot(pcsaggalignstatussync0toporbot),
		.pcsaggalignstatustoporbot(pcsaggalignstatustoporbot),
		.pcsaggcgcomprddall(pcsaggcgcomprddall),
		.pcsaggcgcomprddalltoporbot(pcsaggcgcomprddalltoporbot),
		.pcsaggcgcompwrall(pcsaggcgcompwrall),
		.pcsaggcgcompwralltoporbot(pcsaggcgcompwralltoporbot),
		.pcsaggdelcondmet0(pcsaggdelcondmet0),
		.pcsaggdelcondmet0toporbot(pcsaggdelcondmet0toporbot),
		.pcsaggendskwqd(pcsaggendskwqd),
		.pcsaggendskwqdtoporbot(pcsaggendskwqdtoporbot),
		.pcsaggendskwrdptrs(pcsaggendskwrdptrs),
		.pcsaggendskwrdptrstoporbot(pcsaggendskwrdptrstoporbot),
		.pcsaggfifoovr0(pcsaggfifoovr0),
		.pcsaggfifoovr0toporbot(pcsaggfifoovr0toporbot),
		.pcsaggfifordincomp0(pcsaggfifordincomp0),
		.pcsaggfifordincomp0toporbot(pcsaggfifordincomp0toporbot),
		.pcsaggfiforstrdqd(pcsaggfiforstrdqd),
		.pcsaggfiforstrdqdtoporbot(pcsaggfiforstrdqdtoporbot),
		.pcsagginsertincomplete0(pcsagginsertincomplete0),
		.pcsagginsertincomplete0toporbot(pcsagginsertincomplete0toporbot),
		.pcsagglatencycomp0(pcsagglatencycomp0),
		.pcsagglatencycomp0toporbot(pcsagglatencycomp0toporbot),
		.pcsaggrcvdclkagg(pcsaggrcvdclkagg),
		.pcsaggrcvdclkaggtoporbot(pcsaggrcvdclkaggtoporbot),
		.pcsaggrxcontrolrs(pcsaggrxcontrolrs),
		.pcsaggrxcontrolrstoporbot(pcsaggrxcontrolrstoporbot),
		.pcsaggrxdatars(pcsaggrxdatars),
		.pcsaggrxdatarstoporbot(pcsaggrxdatarstoporbot),
		.pcsaggtestbus(pcsaggtestbus),
		.pcsaggtxctlts(pcsaggtxctlts),
		.pcsaggtxctltstoporbot(pcsaggtxctltstoporbot),
		.pcsaggtxdatats(pcsaggtxdatats),
		.pcsaggtxdatatstoporbot(pcsaggtxdatatstoporbot),
		.pldhclkout(pldhclkout),
		.pldtestsitoaggout(pldtestsitoaggout),
		.pmaclklowout(pmaclklowout),
		.pmacurrentcoeff(pmacurrentcoeff),
		.pmaearlyeios(pmaearlyeios),
		.pmafrefout(pmafrefout),
		.pmaiftestbus(pmaiftestbus),
		.pmaltr(pmaltr),
		.pmanfrzdrv(pmanfrzdrv),
		.pmapartialreconfig(pmapartialreconfig),
		.pmapcieswitch(pmapcieswitch),
		.freqlock(freqlock),
		.pmatxelecidle(pmatxelecidle),
		.pmatxdetectrx(pmatxdetectrx),
		.asynchdatain(asynchdatain),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_common_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_common_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter hip_enable = "hip_disable",	//Valid values: hip_disable|hip_enable
	parameter hrdrstctrl_en_cfgusr = "hrst_dis_cfgusr",	//Valid values: hrst_dis_cfgusr|hrst_en_cfgusr
	parameter pld_side_reserved_source10 = "pld_res10",	//Valid values: pld_res10|hip_res10
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter pld_side_reserved_source0 = "pld_res0",	//Valid values: pld_res0|hip_res0
	parameter pld_side_reserved_source1 = "pld_res1",	//Valid values: pld_res1|hip_res1
	parameter pld_side_reserved_source2 = "pld_res2",	//Valid values: pld_res2|hip_res2
	parameter pld_side_reserved_source3 = "pld_res3",	//Valid values: pld_res3|hip_res3
	parameter pld_side_reserved_source4 = "pld_res4",	//Valid values: pld_res4|hip_res4
	parameter pld_side_reserved_source5 = "pld_res5",	//Valid values: pld_res5|hip_res5
	parameter pld_side_reserved_source6 = "pld_res6",	//Valid values: pld_res6|hip_res6
	parameter pld_side_reserved_source7 = "pld_res7",	//Valid values: pld_res7|hip_res7
	parameter pld_side_reserved_source8 = "pld_res8",	//Valid values: pld_res8|hip_res8
	parameter pld_side_reserved_source9 = "pld_res9",	//Valid values: pld_res9|hip_res9
	parameter hrdrstctrl_en_cfg = "hrst_dis_cfg",	//Valid values: hrst_dis_cfg|hrst_en_cfg
	parameter testbus_sel = "eight_g_pcs",	//Valid values: eight_g_pcs|pma_if
	parameter usrmode_sel4rst = "usermode",	//Valid values: usermode|last_frz
	parameter pld_side_reserved_source11 = "pld_res11",	//Valid values: pld_res11|hip_res11
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 37:0 ] emsipcomin,
	input [ 19:0 ] pcs8gchnltestbusout,
	input [ 0:0 ] pcs8gphystatus,
	input [ 2:0 ] pcs8gpldextraout,
	input [ 0:0 ] pcs8grxelecidle,
	input [ 2:0 ] pcs8grxstatus,
	input [ 0:0 ] pcs8grxvalid,
	input [ 5:0 ] pcs8gtestso,
	input [ 0:0 ] pcsaggtestso,
	input [ 0:0 ] pcspmaiftestso,
	input [ 9:0 ] pcspmaiftestbusout,
	input [ 1:0 ] pld8gpowerdown,
	input [ 0:0 ] pld8gprbsciden,
	input [ 0:0 ] pld8grefclkdig,
	input [ 0:0 ] pld8grefclkdig2,
	input [ 0:0 ] pld8grxpolarity,
	input [ 0:0 ] pld8gtxdeemph,
	input [ 0:0 ] pld8gtxdetectrxloopback,
	input [ 0:0 ] pld8gtxelecidle,
	input [ 2:0 ] pld8gtxmargin,
	input [ 0:0 ] pld8gtxswing,
	input [ 0:0 ] pldaggrefclkdig,
	input [ 2:0 ] pldeidleinfersel,
	input [ 0:0 ] pldhclkin,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] pldpartialreconfigin,
	input [ 0:0 ] pldpcspmaifrefclkdig,
	input [ 0:0 ] pldrate,
	input [ 11:0 ] pldreservedin,
	input [ 0:0 ] pldscanmoden,
	input [ 0:0 ] pldscanshiftn,
	input [ 0:0 ] pmaclklow,
	input [ 0:0 ] pmafref,
	output [ 2:0 ] emsipcomclkout,
	output [ 26:0 ] emsipcomout,
	output [ 0:0 ] emsipenablediocsrrdydly,
	output [ 2:0 ] pcs8geidleinfersel,
	output [ 0:0 ] pcs8ghardreset,
	output [ 0:0 ] pcs8gltr,
	output [ 3:0 ] pcs8gpldextrain,
	output [ 1:0 ] pcs8gpowerdown,
	output [ 0:0 ] pcs8gprbsciden,
	output [ 0:0 ] pcs8grate,
	output [ 0:0 ] pcs8grefclkdig,
	output [ 0:0 ] pcs8grefclkdig2,
	output [ 0:0 ] pcs8grxpolarity,
	output [ 0:0 ] pcs8gscanmoden,
	output [ 0:0 ] pcs8gscanshift,
	output [ 5:0 ] pcs8gtestsi,
	output [ 0:0 ] pcs8gtxdeemph,
	output [ 0:0 ] pcs8gtxdetectrxloopback,
	output [ 0:0 ] pcs8gtxelecidle,
	output [ 2:0 ] pcs8gtxmargin,
	output [ 0:0 ] pcs8gtxswing,
	output [ 0:0 ] pcsaggrefclkdig,
	output [ 0:0 ] pcsaggscanmoden,
	output [ 0:0 ] pcsaggscanshift,
	output [ 0:0 ] pcsaggtestsi,
	output [ 0:0 ] pcspcspmaifrefclkdig,
	output [ 0:0 ] pcspcspmaifscanmoden,
	output [ 0:0 ] pcspcspmaifscanshiftn,
	output [ 0:0 ] pcspmaifhardreset,
	output [ 0:0 ] pcspmaiftestsi,
	output [ 0:0 ] pld8gphystatus,
	output [ 0:0 ] pld8grxelecidle,
	output [ 2:0 ] pld8grxstatus,
	output [ 0:0 ] pld8grxvalid,
	output [ 0:0 ] pldclklow,
	output [ 0:0 ] pldfref,
	output [ 0:0 ] pldnfrzdrv,
	output [ 0:0 ] pldpartialreconfigout,
	output [ 10:0 ] pldreservedout,
	output [ 19:0 ] pldtestdata,
	output [ 0:0 ] rstsel,
	output [ 0:0 ] usrrstsel,
	output [ 0:0 ] asynchdatain,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_common_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.hip_enable(hip_enable),
		.hrdrstctrl_en_cfgusr(hrdrstctrl_en_cfgusr),
		.pld_side_reserved_source10(pld_side_reserved_source10),
		.pld_side_data_source(pld_side_data_source),
		.pld_side_reserved_source0(pld_side_reserved_source0),
		.pld_side_reserved_source1(pld_side_reserved_source1),
		.pld_side_reserved_source2(pld_side_reserved_source2),
		.pld_side_reserved_source3(pld_side_reserved_source3),
		.pld_side_reserved_source4(pld_side_reserved_source4),
		.pld_side_reserved_source5(pld_side_reserved_source5),
		.pld_side_reserved_source6(pld_side_reserved_source6),
		.pld_side_reserved_source7(pld_side_reserved_source7),
		.pld_side_reserved_source8(pld_side_reserved_source8),
		.pld_side_reserved_source9(pld_side_reserved_source9),
		.hrdrstctrl_en_cfg(hrdrstctrl_en_cfg),
		.testbus_sel(testbus_sel),
		.usrmode_sel4rst(usrmode_sel4rst),
		.pld_side_reserved_source11(pld_side_reserved_source11),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_common_pld_pcs_interface_encrypted_inst	(
		.emsipcomin(emsipcomin),
		.pcs8gchnltestbusout(pcs8gchnltestbusout),
		.pcs8gphystatus(pcs8gphystatus),
		.pcs8gpldextraout(pcs8gpldextraout),
		.pcs8grxelecidle(pcs8grxelecidle),
		.pcs8grxstatus(pcs8grxstatus),
		.pcs8grxvalid(pcs8grxvalid),
		.pcs8gtestso(pcs8gtestso),
		.pcsaggtestso(pcsaggtestso),
		.pcspmaiftestso(pcspmaiftestso),
		.pcspmaiftestbusout(pcspmaiftestbusout),
		.pld8gpowerdown(pld8gpowerdown),
		.pld8gprbsciden(pld8gprbsciden),
		.pld8grefclkdig(pld8grefclkdig),
		.pld8grefclkdig2(pld8grefclkdig2),
		.pld8grxpolarity(pld8grxpolarity),
		.pld8gtxdeemph(pld8gtxdeemph),
		.pld8gtxdetectrxloopback(pld8gtxdetectrxloopback),
		.pld8gtxelecidle(pld8gtxelecidle),
		.pld8gtxmargin(pld8gtxmargin),
		.pld8gtxswing(pld8gtxswing),
		.pldaggrefclkdig(pldaggrefclkdig),
		.pldeidleinfersel(pldeidleinfersel),
		.pldhclkin(pldhclkin),
		.pldltr(pldltr),
		.pldpartialreconfigin(pldpartialreconfigin),
		.pldpcspmaifrefclkdig(pldpcspmaifrefclkdig),
		.pldrate(pldrate),
		.pldreservedin(pldreservedin),
		.pldscanmoden(pldscanmoden),
		.pldscanshiftn(pldscanshiftn),
		.pmaclklow(pmaclklow),
		.pmafref(pmafref),
		.emsipcomclkout(emsipcomclkout),
		.emsipcomout(emsipcomout),
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.pcs8geidleinfersel(pcs8geidleinfersel),
		.pcs8ghardreset(pcs8ghardreset),
		.pcs8gltr(pcs8gltr),
		.pcs8gpldextrain(pcs8gpldextrain),
		.pcs8gpowerdown(pcs8gpowerdown),
		.pcs8gprbsciden(pcs8gprbsciden),
		.pcs8grate(pcs8grate),
		.pcs8grefclkdig(pcs8grefclkdig),
		.pcs8grefclkdig2(pcs8grefclkdig2),
		.pcs8grxpolarity(pcs8grxpolarity),
		.pcs8gscanmoden(pcs8gscanmoden),
		.pcs8gscanshift(pcs8gscanshift),
		.pcs8gtestsi(pcs8gtestsi),
		.pcs8gtxdeemph(pcs8gtxdeemph),
		.pcs8gtxdetectrxloopback(pcs8gtxdetectrxloopback),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxmargin(pcs8gtxmargin),
		.pcs8gtxswing(pcs8gtxswing),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.pcsaggscanmoden(pcsaggscanmoden),
		.pcsaggscanshift(pcsaggscanshift),
		.pcsaggtestsi(pcsaggtestsi),
		.pcspcspmaifrefclkdig(pcspcspmaifrefclkdig),
		.pcspcspmaifscanmoden(pcspcspmaifscanmoden),
		.pcspcspmaifscanshiftn(pcspcspmaifscanshiftn),
		.pcspmaifhardreset(pcspmaifhardreset),
		.pcspmaiftestsi(pcspmaiftestsi),
		.pld8gphystatus(pld8gphystatus),
		.pld8grxelecidle(pld8grxelecidle),
		.pld8grxstatus(pld8grxstatus),
		.pld8grxvalid(pld8grxvalid),
		.pldclklow(pldclklow),
		.pldfref(pldfref),
		.pldnfrzdrv(pldnfrzdrv),
		.pldpartialreconfigout(pldpartialreconfigout),
		.pldreservedout(pldreservedout),
		.pldtestdata(pldtestdata),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.asynchdatain(asynchdatain),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pipe_gen1_2_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pipe_gen1_2
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "pipe_g1",	//Valid values: pipe_g1|pipe_g2|srio_2p1|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter tx_pipe_enable = "dis_pipe_tx",	//Valid values: dis_pipe_tx|en_pipe_tx
	parameter rx_pipe_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx
	parameter pipe_byte_de_serializer_en = "dont_care_bds",	//Valid values: dis_bds|en_bds_by_2|dont_care_bds
	parameter txswing = "dis_txswing",	//Valid values: dis_txswing|en_txswing
	parameter rxdetect_bypass = "dis_rxdetect_bypass",	//Valid values: dis_rxdetect_bypass|en_rxdetect_bypass
	parameter error_replace_pad = "replace_edb",	//Valid values: replace_edb|replace_pad
	parameter ind_error_reporting = "dis_ind_error_reporting",	//Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter phystatus_rst_toggle = "dis_phystatus_rst_toggle",	//Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter elecidle_delay = "elec_idle_delay",	//Valid values: elec_idle_delay
	parameter [ 2:0 ] elec_idle_delay_val = 3'b0,	//Valid values: 3
	parameter phy_status_delay = "phystatus_delay",	//Valid values: phystatus_delay
	parameter [ 2:0 ] phystatus_delay_val = 3'b0,	//Valid values: 3
	parameter [ 5:0 ] rvod_sel_d_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_b_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_c_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_c_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_settings = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_a_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_d_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_settings = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_b_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_e_val = 6'b0,	//Valid values: 6
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter [ 5:0 ] rvod_sel_e_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_a_val = 6'b0,	//Valid values: 6
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] pcieswitch,
	input [ 0:0 ] piperxclk,
	input [ 0:0 ] pipetxclk,
	input [ 0:0 ] polinvrx,
	input [ 0:0 ] powerstatetransitiondone,
	input [ 0:0 ] powerstatetransitiondoneena,
	input [ 1:0 ] powerdown,
	input [ 0:0 ] refclkb,
	input [ 0:0 ] refclkbreset,
	input [ 0:0 ] revloopbkpcsgen3,
	input [ 0:0 ] revloopback,
	input [ 0:0 ] rxdetectvalid,
	input [ 0:0 ] rxfound,
	input [ 0:0 ] rxpipereset,
	input [ 63:0 ] rxd,
	input [ 0:0 ] rxelectricalidle,
	input [ 0:0 ] rxpolarity,
	input [ 0:0 ] sigdetni,
	input [ 0:0 ] speedchange,
	input [ 0:0 ] speedchangechnldown,
	input [ 0:0 ] speedchangechnlup,
	input [ 0:0 ] txelecidlecomp,
	input [ 0:0 ] txpipereset,
	input [ 43:0 ] txdch,
	input [ 0:0 ] txdeemph,
	input [ 0:0 ] txdetectrxloopback,
	input [ 0:0 ] txelecidlein,
	input [ 2:0 ] txmargin,
	input [ 0:0 ] txswingport,
	output [ 17:0 ] currentcoeff,
	output [ 0:0 ] phystatus,
	output [ 0:0 ] polinvrxint,
	output [ 0:0 ] revloopbk,
	output [ 63:0 ] rxdch,
	output [ 0:0 ] rxelecidle,
	output [ 0:0 ] rxelectricalidleout,
	output [ 2:0 ] rxstatus,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] speedchangeout,
	output [ 0:0 ] txelecidleout,
	output [ 43:0 ] txd,
	output [ 0:0 ] txdetectrx,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pipe_gen1_2_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.tx_pipe_enable(tx_pipe_enable),
		.rx_pipe_enable(rx_pipe_enable),
		.pipe_byte_de_serializer_en(pipe_byte_de_serializer_en),
		.txswing(txswing),
		.rxdetect_bypass(rxdetect_bypass),
		.error_replace_pad(error_replace_pad),
		.ind_error_reporting(ind_error_reporting),
		.phystatus_rst_toggle(phystatus_rst_toggle),
		.elecidle_delay(elecidle_delay),
		.elec_idle_delay_val(elec_idle_delay_val),
		.phy_status_delay(phy_status_delay),
		.phystatus_delay_val(phystatus_delay_val),
		.rvod_sel_d_val(rvod_sel_d_val),
		.rpre_emph_b_val(rpre_emph_b_val),
		.rvod_sel_c_val(rvod_sel_c_val),
		.rpre_emph_c_val(rpre_emph_c_val),
		.rpre_emph_settings(rpre_emph_settings),
		.rvod_sel_a_val(rvod_sel_a_val),
		.rpre_emph_d_val(rpre_emph_d_val),
		.rvod_sel_settings(rvod_sel_settings),
		.rvod_sel_b_val(rvod_sel_b_val),
		.rpre_emph_e_val(rpre_emph_e_val),
		.sup_mode(sup_mode),
		.rvod_sel_e_val(rvod_sel_e_val),
		.rpre_emph_a_val(rpre_emph_a_val),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_pipe_gen1_2_encrypted_inst	(
		.pcieswitch(pcieswitch),
		.piperxclk(piperxclk),
		.pipetxclk(pipetxclk),
		.polinvrx(polinvrx),
		.powerstatetransitiondone(powerstatetransitiondone),
		.powerstatetransitiondoneena(powerstatetransitiondoneena),
		.powerdown(powerdown),
		.refclkb(refclkb),
		.refclkbreset(refclkbreset),
		.revloopbkpcsgen3(revloopbkpcsgen3),
		.revloopback(revloopback),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.rxpipereset(rxpipereset),
		.rxd(rxd),
		.rxelectricalidle(rxelectricalidle),
		.rxpolarity(rxpolarity),
		.sigdetni(sigdetni),
		.speedchange(speedchange),
		.speedchangechnldown(speedchangechnldown),
		.speedchangechnlup(speedchangechnlup),
		.txelecidlecomp(txelecidlecomp),
		.txpipereset(txpipereset),
		.txdch(txdch),
		.txdeemph(txdeemph),
		.txdetectrxloopback(txdetectrxloopback),
		.txelecidlein(txelecidlein),
		.txmargin(txmargin),
		.txswingport(txswingport),
		.currentcoeff(currentcoeff),
		.phystatus(phystatus),
		.polinvrxint(polinvrxint),
		.revloopbk(revloopbk),
		.rxdch(rxdch),
		.rxelecidle(rxelecidle),
		.rxelectricalidleout(rxelectricalidleout),
		.rxstatus(rxstatus),
		.rxvalid(rxvalid),
		.speedchangeout(speedchangeout),
		.txelecidleout(txelecidleout),
		.txd(txd),
		.txdetectrx(txdetectrx),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_aux_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_aux
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter cal_clk_sel = "pm_aux_iqclk_cal_clk_sel_cal_clk",	//Valid values: pm_aux_iqclk_cal_clk_sel_cal_clk|pm_aux_iqclk_cal_clk_sel_iqclk0|pm_aux_iqclk_cal_clk_sel_iqclk1|pm_aux_iqclk_cal_clk_sel_iqclk2|pm_aux_iqclk_cal_clk_sel_iqclk3|pm_aux_iqclk_cal_clk_sel_iqclk4|pm_aux_iqclk_cal_clk_sel_iqclk5
	parameter cal_result_status = "pm_aux_result_status_tx",	//Valid values: pm_aux_result_status_tx|pm_aux_result_status_rx
	parameter continuous_calibration = "false",	//Valid values: false|true
	parameter pm_aux_cal_clk_test_sel = "false",	//Valid values: false|true
	parameter rx_cal_override_value = 0,	//Valid values: 0..31
	parameter rx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter rx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter test_counter_enable = "false",	//Valid values: false|true
	parameter tx_cal_override_value = 0,	//Valid values: 0..31
	parameter tx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter tx_imp = "cal_imp_48_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	inout [ 0:0 ] atb0out,
	inout [ 0:0 ] atb1out,
	input [ 0:0 ] calclk,
	input [ 0:0 ] calpdb,
	input [ 5:0 ] refiqclk,
	input [ 0:0 ] testcntl,
	output [ 0:0 ] nonusertoio,
	output [ 4:0 ] zrxtx50); 

	cyclonev_hssi_pma_aux_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.cal_clk_sel(cal_clk_sel),
		.cal_result_status(cal_result_status),
		.continuous_calibration(continuous_calibration),
		.pm_aux_cal_clk_test_sel(pm_aux_cal_clk_test_sel),
		.rx_cal_override_value(rx_cal_override_value),
		.rx_cal_override_value_enable(rx_cal_override_value_enable),
		.rx_imp(rx_imp),
		.test_counter_enable(test_counter_enable),
		.tx_cal_override_value(tx_cal_override_value),
		.tx_cal_override_value_enable(tx_cal_override_value_enable),
		.tx_imp(tx_imp),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_pma_aux_encrypted_inst	(
		.atb0out(atb0out),
		.atb1out(atb1out),
		.calclk(calclk),
		.calpdb(calpdb),
		.refiqclk(refiqclk),
		.testcntl(testcntl),
		.nonusertoio(nonusertoio),
		.zrxtx50(zrxtx50)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_int_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_int
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..255
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter cvp_mode = "cvp_mode_off",	//Valid values: cvp_mode_off|cvp_mode_on
	parameter early_eios_sel = "pcs_early_eios",	//Valid values: pcs_early_eios|core_early_eios
	parameter ffclk_enable = "ffclk_off",	//Valid values: ffclk_off|ffclk_on
	parameter iqtxrxclk_a_sel = "tristage_outa",	//Valid values: iqtxrxclk_a_pma_rx_clk|iqtxrxclk_a_pcs_rx_clk|iqtxrxclk_a_pma_tx_clk|iqtxrxclk_a_pcs_tx_clk|tristage_outa
	parameter iqtxrxclk_b_sel = "tristage_outb",	//Valid values: iqtxrxclk_b_pma_rx_clk|iqtxrxclk_b_pcs_rx_clk|iqtxrxclk_b_pma_tx_clk|iqtxrxclk_b_pcs_tx_clk|tristage_outb
	parameter ltr_sel = "pcs_ltr",	//Valid values: pcs_ltr|core_ltr
	parameter pcie_switch_sel = "pcs_pcie_switch_sw",	//Valid values: pcs_pcie_switch_sw|core_pcie_switch_sw
	parameter pclk_0_clk_sel = "pclk_0_power_down",	//Valid values: pclk_0_pma_rx_clk|pclk_0_pcs_rx_clk|pclk_0_pma_tx_clk|pclk_0_pcs_tx_clk|pclk_0_power_down
	parameter pclk_1_clk_sel = "pclk_1_power_down",	//Valid values: pclk_1_pma_rx_clk|pclk_1_pcs_rx_clk|pclk_1_pma_tx_clk|pclk_1_pcs_tx_clk|pclk_1_power_down
	parameter tx_elec_idle_sel = "pcs_tx_elec_idle",	//Valid values: pcs_tx_elec_idle|core_tx_elec_idle
	parameter txdetectrx_sel = "pcs_txdetectrx"	//Valid values: pcs_txdetectrx|core_txdetectrx
)
(
//input and output port declaration
	input [ 0:0 ] bslip,
	input [ 0:0 ] ccrurstb,
	input [ 0:0 ] cearlyeios,
	input [ 0:0 ] clkdivrxi,
	input [ 0:0 ] clkdivtxi,
	input [ 0:0 ] clklowi,
	input [ 0:0 ] cltd,
	input [ 0:0 ] cltr,
	input [ 0:0 ] cpcieswitch,
	input [ 0:0 ] crslpbk,
	input [ 0:0 ] ctxdetectrx,
	input [ 0:0 ] ctxelecidle,
	input [ 0:0 ] ctxpmarstb,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] frefi,
	input [ 0:0 ] hclkpcsi,
	input [ 11:0 ] icoeff,
	input [ 0:0 ] ltr,
	input [ 0:0 ] pcieswdonei,
	input [ 0:0 ] pcieswitch,
	input [ 0:0 ] pcsrxclkout,
	input [ 0:0 ] pcstxclkout,
	input [ 0:0 ] pfdmodelocki,
	input [ 0:0 ] pldclk,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] rxdetclk,
	input [ 0:0 ] rxdetectvalidi,
	input [ 0:0 ] rxfoundi,
	input [ 0:0 ] rxplllocki,
	input [ 0:0 ] rxpmarstb,
	input [ 0:0 ] sdi,
	input [ 7:0 ] testbusi,
	input [ 3:0 ] testsel,
	input [ 0:0 ] txdetectrx,
	input [ 0:0 ] txelecidle,
	output [ 0:0 ] bslipo,
	output [ 0:0 ] clklow,
	output [ 0:0 ] cpcieswdone,
	output [ 1:0 ] cpclk,
	output [ 0:0 ] cpfdmodelock,
	output [ 0:0 ] crurstbo,
	output [ 0:0 ] crxdetectvalid,
	output [ 0:0 ] crxfound,
	output [ 0:0 ] crxplllock,
	output [ 0:0 ] csd,
	output [ 0:0 ] earlyeioso,
	output [ 0:0 ] fref,
	output [ 0:0 ] hclkpcs,
	output [ 11:0 ] icoeffo,
	output [ 0:0 ] iqtxrxclka,
	output [ 0:0 ] iqtxrxclkb,
	output [ 0:0 ] ltdo,
	output [ 0:0 ] ltro,
	output [ 0:0 ] pcieswdone,
	output [ 0:0 ] pcieswitcho,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] pldclko,
	output [ 0:0 ] ppmlocko,
	output [ 0:0 ] rxdetclko,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] rxpmarstbo,
	output [ 0:0 ] sd,
	output [ 0:0 ] slpbko,
	output [ 7:0 ] testbus,
	output [ 3:0 ] testselo,
	output [ 0:0 ] txdetectrxo,
	output [ 0:0 ] txelecidleo,
	output [ 0:0 ] txpmarstbo,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_int_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.cvp_mode(cvp_mode),
		.early_eios_sel(early_eios_sel),
		.ffclk_enable(ffclk_enable),
		.iqtxrxclk_a_sel(iqtxrxclk_a_sel),
		.iqtxrxclk_b_sel(iqtxrxclk_b_sel),
		.ltr_sel(ltr_sel),
		.pcie_switch_sel(pcie_switch_sel),
		.pclk_0_clk_sel(pclk_0_clk_sel),
		.pclk_1_clk_sel(pclk_1_clk_sel),
		.tx_elec_idle_sel(tx_elec_idle_sel),
		.txdetectrx_sel(txdetectrx_sel)

	)
	cyclonev_hssi_pma_int_encrypted_inst	(
		.bslip(bslip),
		.ccrurstb(ccrurstb),
		.cearlyeios(cearlyeios),
		.clkdivrxi(clkdivrxi),
		.clkdivtxi(clkdivtxi),
		.clklowi(clklowi),
		.cltd(cltd),
		.cltr(cltr),
		.cpcieswitch(cpcieswitch),
		.crslpbk(crslpbk),
		.ctxdetectrx(ctxdetectrx),
		.ctxelecidle(ctxelecidle),
		.ctxpmarstb(ctxpmarstb),
		.earlyeios(earlyeios),
		.frefi(frefi),
		.hclkpcsi(hclkpcsi),
		.icoeff(icoeff),
		.ltr(ltr),
		.pcieswdonei(pcieswdonei),
		.pcieswitch(pcieswitch),
		.pcsrxclkout(pcsrxclkout),
		.pcstxclkout(pcstxclkout),
		.pfdmodelocki(pfdmodelocki),
		.pldclk(pldclk),
		.ppmlock(ppmlock),
		.rxdetclk(rxdetclk),
		.rxdetectvalidi(rxdetectvalidi),
		.rxfoundi(rxfoundi),
		.rxplllocki(rxplllocki),
		.rxpmarstb(rxpmarstb),
		.sdi(sdi),
		.testbusi(testbusi),
		.testsel(testsel),
		.txdetectrx(txdetectrx),
		.txelecidle(txelecidle),
		.bslipo(bslipo),
		.clklow(clklow),
		.cpcieswdone(cpcieswdone),
		.cpclk(cpclk),
		.cpfdmodelock(cpfdmodelock),
		.crurstbo(crurstbo),
		.crxdetectvalid(crxdetectvalid),
		.crxfound(crxfound),
		.crxplllock(crxplllock),
		.csd(csd),
		.earlyeioso(earlyeioso),
		.fref(fref),
		.hclkpcs(hclkpcs),
		.icoeffo(icoeffo),
		.iqtxrxclka(iqtxrxclka),
		.iqtxrxclkb(iqtxrxclkb),
		.ltdo(ltdo),
		.ltro(ltro),
		.pcieswdone(pcieswdone),
		.pcieswitcho(pcieswitcho),
		.pfdmodelock(pfdmodelock),
		.pldclko(pldclko),
		.ppmlocko(ppmlocko),
		.rxdetclko(rxdetclko),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.rxplllock(rxplllock),
		.rxpmarstbo(rxpmarstbo),
		.sd(sd),
		.slpbko(slpbko),
		.testbus(testbus),
		.testselo(testselo),
		.txdetectrxo(txdetectrxo),
		.txelecidleo(txelecidleo),
		.txpmarstbo(txpmarstbo),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_rx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_rx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter cdrclk_to_cgb = "cdrclk_2cgb_dis",	//Valid values: cdrclk_2cgb_dis|cdrclk_2cgb_en
	parameter channel_number = 0,	//Valid values: 0..65
	parameter diagnostic_loopback = "diag_lpbk_off",	//Valid values: diag_lpbk_on|diag_lpbk_off
	parameter pdb_sd = "false",	//Valid values: false|true
	parameter rx_dc_gain = 0,	//Valid values: 0..1
	parameter sd_off = 1,	//Valid values: 0..29
	parameter sd_on = 1,	//Valid values: 0..16
	parameter sd_threshold = 3,	//Valid values: 0..7
	parameter term_sel = "100 ohms",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vcm_current_add = "vcm_current_1",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vcm_sel = "vtt_0p80v",	//Valid values: vtt_0p80v|vtt_0p75v|vtt_0p70v|vtt_0p65v|vtt_0p60v|vtt_0p55v|vtt_0p50v|vtt_0p35v|vtt_pup_weak|vtt_pdn_weak|tristate1|vtt_pdn_strong|vtt_pup_strong|tristate2|tristate3|tristate4
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter rx_sel_half_bw = "full_bw",	//Valid values: full_bw|half_bw
	parameter rx_acgain_a = "aref_volt_0",	//Valid values: aref_volt_0|aref_volt_0p5|aref_volt_0p75|aref_volt_1p0
	parameter rx_acgain_v = "vref_volt_1p0",	//Valid values: vref_volt_1p0|vref_volt_0p75|vref_volt_0p5|vref_volt_0
	parameter ct_equalizer_setting = 0,
// NOTE: This parameter was added by hand to deal with the recent addition of
// this parameter to the atom.  It does not require simulation support but
// needs to be here to prevent issues when handling the postfit netlist.
	parameter reverse_loopback = "reverse_lpbk_cdr"	//Valid values: reverse_lpbk_cdr|reverse_lpbk_rx
)
(
//input and output port declaration
	input [ 0:0 ] ck0sigdet,
	input [ 0:0 ] datain,
	input [ 0:0 ] hardoccalen,
	input [ 0:0 ] lpbkp,
	input [ 0:0 ] rstn,
	input [ 0:0 ] slpbk,
	output [ 0:0 ] dataout,
	input [ 0:0 ] nonuserfrompmaux,
	output [ 0:0 ] rdlpbkp,
	output [ 0:0 ] sd,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_rx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.cdrclk_to_cgb(cdrclk_to_cgb),
		.channel_number(channel_number),
		.diagnostic_loopback(diagnostic_loopback),
		.pdb_sd(pdb_sd),
		.rx_dc_gain(rx_dc_gain),
		.sd_off(sd_off),
		.sd_on(sd_on),
		.sd_threshold(sd_threshold),
		.term_sel(term_sel),
		.vcm_current_add(vcm_current_add),
		.vcm_sel(vcm_sel),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.rx_sel_half_bw(rx_sel_half_bw),
		.rx_acgain_a(rx_acgain_a),
		.rx_acgain_v(rx_acgain_v)

	)
	cyclonev_hssi_pma_rx_buf_encrypted_inst	(
		.ck0sigdet(ck0sigdet),
		.datain(datain),
		.hardoccalen(hardoccalen),
		.lpbkp(lpbkp),
		.rstn(rstn),
		.slpbk(slpbk),
		.dataout(dataout),
		.nonuserfrompmaux(nonuserfrompmaux),
		.rdlpbkp(rdlpbkp),
		.sd(sd),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_rx_deser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_rx_deser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter enable_bit_slip = "true",	//Valid values: false|true
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter sdclk_enable = "false",	//Valid values: false|true
	parameter vco_bypass = "vco_bypass_normal",	//Valid values: vco_bypass_normal|vco_bypass_normal_dont_care|clklow_to_clkdivrx|fref_to_clkdivrx
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter pma_direct = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 0:0 ] bslip,
	input [ 0:0 ] clk270b,
	input [ 0:0 ] clk90b,
	input [ 0:0 ] deven,
	input [ 0:0 ] dodd,
	input [ 0:0 ] pciesw,
	input [ 0:0 ] rstn,
	output [ 0:0 ] clkdivrx,
	output [ 0:0 ] clkdivrxrx,
	output [ 79:0 ] dout,
	output [ 0:0 ] pciel,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_rx_deser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.channel_number(channel_number),
		.clk_forward_only_mode(clk_forward_only_mode),
		.enable_bit_slip(enable_bit_slip),
		.mode(mode),
		.sdclk_enable(sdclk_enable),
		.vco_bypass(vco_bypass),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.pma_direct(pma_direct)

	)
	cyclonev_hssi_pma_rx_deser_encrypted_inst	(
		.bslip(bslip),
		.clk270b(clk270b),
		.clk90b(clk90b),
		.deven(deven),
		.dodd(dodd),
		.pciesw(pciesw),
		.rstn(rstn),
		.clkdivrx(clkdivrx),
		.clkdivrxrx(clkdivrxrx),
		.dout(dout),
		.pciel(pciel),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_tx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_tx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..65
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter common_mode_driver_sel = "volt_0p65v",	//Valid values: volt_0p80v|volt_0p75v|volt_0p70v|volt_0p65v|volt_0p60v|volt_0p55v|volt_0p50v|volt_0p35v|pull_up|pull_dn|tristated1|grounded|pull_up_to_vccela|tristated2|tristated3|tristated4
	parameter driver_resolution_ctrl = "disabled",	//Valid values: offset_main|offset_po1|conbination1|disabled
	parameter fir_coeff_ctrl_sel = "ram_ctl",	//Valid values: ram_ctl|dynamic_ctl
	parameter local_ib_ctl = "ib_29ohm",	//Valid values: ib_49ohm|ib_29ohm|ib_42ohm|ib_22ohm
	parameter lst = "atb_disabled",	//Valid values: atb_disabled|atb_0|atb_1|atb_2|atb_3|atb_4|atb_5|atb_6|atb_7|atb_8|atb_9|atb_10|atb_11|atb_12|atb_13|atb_14
	parameter pre_emp_switching_ctrl_1st_post_tap = 0,	//Valid values: 0..31
	parameter rx_det = 0,	//Valid values: 0..15
	parameter rx_det_pdb = "false",	//Valid values: false|true
	parameter slew_rate_ctrl = 5,	//Valid values: 1..5
	parameter swing_boost = "not_boost",	//Valid values: boost|not_boost
	parameter term_sel = "100 ohms",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vcm_current_addl = "vcm_current_1",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vod_boost = "not_boost",	//Valid values: boost|not_boost
	parameter vod_switching_ctrl_main_tap = 10,	//Valid values: 0..63
	parameter local_ib_en = "no_local_ib",	//Valid values: no_local_ib|local_ib
	parameter cml_en = "no_cml",	//Valid values: no_cml|cml
	parameter tx_powerdown = "normal_tx_on"		// Valid values: normal_tx_on|power_down_tx
	
)
(
//input and output port declaration
	input [ 0:0 ] avgvon,
	input [ 0:0 ] avgvop,
	input [ 0:0 ] datain,
	input [ 11:0 ] icoeff,
	input [ 0:0 ] rxdetclk,
	input [ 0:0 ] txdetrx,
	input [ 0:0 ] txelecidl,
	input [ 0:0 ] vrlpbkn,
	input [ 0:0 ] vrlpbkn1t,
	input [ 0:0 ] vrlpbkp,
	input [ 0:0 ] vrlpbkp1t,
	output [ 0:0 ] compass,
	output [ 0:0 ] dataout,
	output [ 1:0 ] detecton,
	output [ 0:0 ] fixedclkout,
	input [ 0:0 ] nonuserfrompmaux,
	output [ 0:0 ] probepass,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_tx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.common_mode_driver_sel(common_mode_driver_sel),
		.driver_resolution_ctrl(driver_resolution_ctrl),
		.fir_coeff_ctrl_sel(fir_coeff_ctrl_sel),
		.local_ib_ctl(local_ib_ctl),
		.lst(lst),
		.pre_emp_switching_ctrl_1st_post_tap(pre_emp_switching_ctrl_1st_post_tap),
		.rx_det(rx_det),
		.rx_det_pdb(rx_det_pdb),
		.slew_rate_ctrl(slew_rate_ctrl),
		.swing_boost(swing_boost),
		.term_sel(term_sel),
		.vcm_current_addl(vcm_current_addl),
		.vod_boost(vod_boost),
		.vod_switching_ctrl_main_tap(vod_switching_ctrl_main_tap),
		.local_ib_en(local_ib_en),
		.cml_en(cml_en)

	)
	cyclonev_hssi_pma_tx_buf_encrypted_inst	(
		.avgvon(avgvon),
		.avgvop(avgvop),
		.datain(datain),
		.icoeff(icoeff),
		.rxdetclk(rxdetclk),
		.txdetrx(txdetrx),
		.txelecidl(txelecidl),
		.vrlpbkn(vrlpbkn),
		.vrlpbkn1t(vrlpbkn1t),
		.vrlpbkp(vrlpbkp),
		.vrlpbkp1t(vrlpbkp1t),
		.compass(compass),
		.dataout(dataout),
		.detecton(detecton),
		.fixedclkout(fixedclkout),
		.nonuserfrompmaux(nonuserfrompmaux),
		.probepass(probepass),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_tx_cgb_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_tx_cgb
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter reserved_transmit_channel = "false",	//Valid values: false|true; this is for declaring dummy channels for AV Degradation issue only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter cgb_iqclk_sel = "tristate",	//Valid values: cgb_x1_n_div|rx_output|tristate
	parameter cgb_sync = "normal",	//Valid values: sync_rst|normal
	parameter channel_number = 0,	//Valid values: 0..255
	parameter clk_mute = "disable_clockmute",	//Valid values: disable_clockmute|enable_clock_mute|enable_clock_mute_master_channel
	parameter data_rate = "",	//Valid values: 
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter reset_scheme = "counter_reset_disable",	//Valid values: counter_reset_disable|counter_reset_enable
	parameter tx_mux_power_down = "normal",	//Valid values: power_down|normal
	parameter x1_clock_source_sel = "x1_clk_unused",	//Valid values: up_segmented|down_segmented|ffpll|ch1_txpll_t|ch1_txpll_b|same_ch_txpll|hfclk_xn_up|hfclk_ch1_x6_dn|hfclk_xn_dn|hfclk_ch1_x6_up|x1_clk_unused
	parameter x1_div_m_sel = 1,	//Valid values: 1|2|4|8
	parameter xn_clock_source_sel = "cgb_x1_m_div",	//Valid values: xn_up|ch1_x6_dn|xn_dn|ch1_x6_up|cgb_x1_m_div|cgb_xn_unused
	parameter pcie_rst = "normal_reset",	//Valid values: normal_reset|pcie_reset
	parameter fref_vco_bypass = "normal_operation",	//Valid values: normal_operation|fref_bypass
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter x1_clock0_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock1_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock2_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock3_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock4_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock5_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock6_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock7_logical_to_physical_mapping = "x1_clk_unused"	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
)
(
//input and output port declaration
	input [ 0:0 ] clkbcdr1b,
	input [ 0:0 ] clkbcdr1t,
	input [ 0:0 ] clkbcdrloc,
	input [ 0:0 ] clkbdnseg,
	input [ 0:0 ] clkbffpll,
	input [ 0:0 ] clkbupseg,
	input [ 0:0 ] clkcdr1b,
	input [ 0:0 ] clkcdr1t,
	input [ 0:0 ] clkcdrloc,
	input [ 0:0 ] clkdnseg,
	input [ 0:0 ] clkffpll,
	input [ 0:0 ] clkupseg,
	input [ 0:0 ] cpulsex6dn,
	input [ 0:0 ] cpulsex6up,
	input [ 0:0 ] cpulsexndn,
	input [ 0:0 ] cpulsexnup,
	input [ 0:0 ] hfclknx6dn,
	input [ 0:0 ] hfclknx6up,
	input [ 0:0 ] hfclknxndn,
	input [ 0:0 ] hfclknxnup,
	input [ 0:0 ] hfclkpx6dn,
	input [ 0:0 ] hfclkpx6up,
	input [ 0:0 ] hfclkpxndn,
	input [ 0:0 ] hfclkpxnup,
	input [ 0:0 ] lfclknx6dn,
	input [ 0:0 ] lfclknx6up,
	input [ 0:0 ] lfclknxndn,
	input [ 0:0 ] lfclknxnup,
	input [ 0:0 ] lfclkpx6dn,
	input [ 0:0 ] lfclkpx6up,
	input [ 0:0 ] lfclkpxndn,
	input [ 0:0 ] lfclkpxnup,
	input [ 0:0 ] pciesw,
	input [ 0:0 ] pclkx6dn,
	input [ 0:0 ] pclkx6up,
	input [ 0:0 ] pclkxndn,
	input [ 0:0 ] pclkxnup,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxclk,
	output [ 0:0 ] cpulse,
	output [ 0:0 ] cpulseout,
	output [ 0:0 ] hfclkn,
	output [ 0:0 ] hfclknout,
	output [ 0:0 ] hfclkp,
	output [ 0:0 ] hfclkpout,
	output [ 0:0 ] lfclkn,
	output [ 0:0 ] lfclknout,
	output [ 0:0 ] lfclkp,
	output [ 0:0 ] lfclkpout,
	output [ 0:0 ] pcieswdone,
	output [ 0:0 ] pciesyncp,
	output [ 2:0 ] pclk,
	output [ 0:0 ] pclkout,
	output [ 0:0 ] rxiqclk,
	input [ 0:0 ] fref,
	input [ 0:0 ] pcsrstn,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_tx_cgb_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.cgb_iqclk_sel(cgb_iqclk_sel),
		.cgb_sync(cgb_sync),
		.channel_number(channel_number),
		.clk_mute(clk_mute),
		.data_rate(data_rate),
		.mode(mode),
		.reset_scheme(reset_scheme),
		.tx_mux_power_down(tx_mux_power_down),
		.x1_clock_source_sel(x1_clock_source_sel),
		.x1_div_m_sel(x1_div_m_sel),
		.xn_clock_source_sel(xn_clock_source_sel),
		.pcie_rst(pcie_rst),
		.fref_vco_bypass(fref_vco_bypass),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.x1_clock0_logical_to_physical_mapping(x1_clock0_logical_to_physical_mapping),
		.x1_clock1_logical_to_physical_mapping(x1_clock1_logical_to_physical_mapping),
		.x1_clock2_logical_to_physical_mapping(x1_clock2_logical_to_physical_mapping),
		.x1_clock3_logical_to_physical_mapping(x1_clock3_logical_to_physical_mapping),
		.x1_clock4_logical_to_physical_mapping(x1_clock4_logical_to_physical_mapping),
		.x1_clock5_logical_to_physical_mapping(x1_clock5_logical_to_physical_mapping),
		.x1_clock6_logical_to_physical_mapping(x1_clock6_logical_to_physical_mapping),
		.x1_clock7_logical_to_physical_mapping(x1_clock7_logical_to_physical_mapping)

	)
	cyclonev_hssi_pma_tx_cgb_encrypted_inst	(
		.clkbcdr1b(clkbcdr1b),
		.clkbcdr1t(clkbcdr1t),
		.clkbcdrloc(clkbcdrloc),
		.clkbdnseg(clkbdnseg),
		.clkbffpll(clkbffpll),
		.clkbupseg(clkbupseg),
		.clkcdr1b(clkcdr1b),
		.clkcdr1t(clkcdr1t),
		.clkcdrloc(clkcdrloc),
		.clkdnseg(clkdnseg),
		.clkffpll(clkffpll),
		.clkupseg(clkupseg),
		.cpulsex6dn(cpulsex6dn),
		.cpulsex6up(cpulsex6up),
		.cpulsexndn(cpulsexndn),
		.cpulsexnup(cpulsexnup),
		.hfclknx6dn(hfclknx6dn),
		.hfclknx6up(hfclknx6up),
		.hfclknxndn(hfclknxndn),
		.hfclknxnup(hfclknxnup),
		.hfclkpx6dn(hfclkpx6dn),
		.hfclkpx6up(hfclkpx6up),
		.hfclkpxndn(hfclkpxndn),
		.hfclkpxnup(hfclkpxnup),
		.lfclknx6dn(lfclknx6dn),
		.lfclknx6up(lfclknx6up),
		.lfclknxndn(lfclknxndn),
		.lfclknxnup(lfclknxnup),
		.lfclkpx6dn(lfclkpx6dn),
		.lfclkpx6up(lfclkpx6up),
		.lfclkpxndn(lfclkpxndn),
		.lfclkpxnup(lfclkpxnup),
		.pciesw(pciesw),
		.pclkx6dn(pclkx6dn),
		.pclkx6up(pclkx6up),
		.pclkxndn(pclkxndn),
		.pclkxnup(pclkxnup),
		.rstn(rstn),
		.rxclk(rxclk),
		.cpulse(cpulse),
		.cpulseout(cpulseout),
		.hfclkn(hfclkn),
		.hfclknout(hfclknout),
		.hfclkp(hfclkp),
		.hfclkpout(hfclkpout),
		.lfclkn(lfclkn),
		.lfclknout(lfclknout),
		.lfclkp(lfclkp),
		.lfclkpout(lfclkpout),
		.pcieswdone(pcieswdone),
		.pciesyncp(pciesyncp),
		.pclk(pclk),
		.pclkout(pclkout),
		.rxiqclk(rxiqclk),
		.fref(fref),
		.pcsrstn(pcsrstn),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_pma_tx_ser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_pma_tx_ser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_divtx_deskew = 0,	//Valid values: 0..15
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter [ 0:0 ] forced_data_mode = 1'b0,	//Valid values: 1
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter post_tap_1_en = "false",	//Valid values: false|true
	parameter ser_loopback = "false",	//Valid values: false|true
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter pma_direct = "false",	//Valid values: false|true
	parameter duty_cycle_tune = "duty_cycle3"	//Valid values: duty_cycle0|duty_cycle1|duty_cycle2|duty_cycle3|duty_cycle4|duty_cycle5|duty_cycle6|duty_cycle7
)
(
//input and output port declaration
	input [ 0:0 ] cpulse,
	input [ 79:0 ] datain,
	input [ 0:0 ] hfclk,
	input [ 0:0 ] hfclkn,
	input [ 0:0 ] lfclk,
	input [ 0:0 ] lfclkn,
	input [ 2:0 ] pclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] slpbk,
	output [ 0:0 ] clkdivtx,
	output [ 0:0 ] dataout,
	output [ 0:0 ] lbvop,
	output [ 0:0 ] preenout,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] avgvon,
	output [ 0:0 ] avgvop); 

	cyclonev_hssi_pma_tx_ser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.channel_number(channel_number),
		.clk_divtx_deskew(clk_divtx_deskew),
		.clk_forward_only_mode(clk_forward_only_mode),
		.forced_data_mode(forced_data_mode),
		.mode(mode),
		.post_tap_1_en(post_tap_1_en),
		.ser_loopback(ser_loopback),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.pma_direct(pma_direct),
		.duty_cycle_tune(duty_cycle_tune)

	)
	cyclonev_hssi_pma_tx_ser_encrypted_inst	(
		.cpulse(cpulse),
		.datain(datain),
		.hfclk(hfclk),
		.hfclkn(hfclkn),
		.lfclk(lfclk),
		.lfclkn(lfclkn),
		.pclk(pclk),
		.rstn(rstn),
		.slpbk(slpbk),
		.clkdivtx(clkdivtx),
		.dataout(dataout),
		.lbvop(lbvop),
		.preenout(preenout),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.avgvon(avgvon),
		.avgvop(avgvop)
	);


endmodule
`timescale 1 ps/1 ps

module    cyclonev_hssi_pma_cdr_refclk_select_mux    (
    calclk,
	refclklc,  //not supported
	occalen,  //not supported
    ffplloutbot,
    ffpllouttop,
    pldclk,
    refiqclk0,
    refiqclk1,
    refiqclk10,
    refiqclk2,
    refiqclk3,
    refiqclk4,
    refiqclk5,
    refiqclk6,
    refiqclk7,
    refiqclk8,
    refiqclk9,
    rxiqclk0,
    rxiqclk1,
    rxiqclk10,
    rxiqclk2,
    rxiqclk3,
    rxiqclk4,
    rxiqclk5,
    rxiqclk6,
    rxiqclk7,
    rxiqclk8,
    rxiqclk9,
    avmmclk,
    avmmrstn,
    avmmwrite,
    avmmread,
    avmmbyteen,
    avmmaddress,
    avmmwritedata,
    avmmreaddata,
    blockselect,
    clkout);

    parameter    lpm_type    =    "cyclonev_hssi_pma_cdr_refclk_select_mux";
    parameter    channel_number    =    0;
      // the mux_type parameter is used for dynamic reconfiguration
   // support. It specifies whethter this mux should listen to the
   // DPRIO memory space for the CDR REF CLK mux or for the LC REF CLK
   // mux
parameter mux_type = "cdr_refclk_select_mux"; // cdr_refclk_select_mux|lc_refclk_select_mux

parameter    refclk_select    =    "ref_iqclk0";
parameter    reference_clock_frequency    =    "0 ps";
parameter    avmm_group_channel_index = 0;
parameter    use_default_base_address = "true";
parameter    user_base_address = 0;

parameter inclk0_logical_to_physical_mapping = "";
parameter inclk1_logical_to_physical_mapping = "";
parameter inclk2_logical_to_physical_mapping = "";
parameter inclk3_logical_to_physical_mapping = "";
parameter inclk4_logical_to_physical_mapping = "";
parameter inclk5_logical_to_physical_mapping = "";
parameter inclk6_logical_to_physical_mapping = "";
parameter inclk7_logical_to_physical_mapping = "";
parameter inclk8_logical_to_physical_mapping = "";
parameter inclk9_logical_to_physical_mapping = "";
parameter inclk10_logical_to_physical_mapping = "";
parameter inclk11_logical_to_physical_mapping = "";
parameter inclk12_logical_to_physical_mapping = "";
parameter inclk13_logical_to_physical_mapping = "";
parameter inclk14_logical_to_physical_mapping = "";
parameter inclk15_logical_to_physical_mapping = "";
parameter inclk16_logical_to_physical_mapping = "";
parameter inclk17_logical_to_physical_mapping = "";
parameter inclk18_logical_to_physical_mapping = "";
parameter inclk19_logical_to_physical_mapping = "";
parameter inclk20_logical_to_physical_mapping = "";
parameter inclk21_logical_to_physical_mapping = "";
parameter inclk22_logical_to_physical_mapping = "";
parameter inclk23_logical_to_physical_mapping = "";
parameter inclk24_logical_to_physical_mapping = "";
parameter inclk25_logical_to_physical_mapping = "";
   



    input         calclk;
	input         refclklc;  //not supported
	input         occalen;  //not supported
    input         ffplloutbot;
    input         ffpllouttop;
    input         pldclk;
    input         refiqclk0;
    input         refiqclk1;
    input         refiqclk10;
    input         refiqclk2;
    input         refiqclk3;
    input         refiqclk4;
    input         refiqclk5;
    input         refiqclk6;
    input         refiqclk7;
    input         refiqclk8;
    input         refiqclk9;
    input         rxiqclk0;
    input         rxiqclk1;
    input         rxiqclk10;
    input         rxiqclk2;
    input         rxiqclk3;
    input         rxiqclk4;
    input         rxiqclk5;
    input         rxiqclk6;
    input         rxiqclk7;
    input         rxiqclk8;
    input         rxiqclk9;
    input         avmmclk;
    input         avmmrstn;
    input         avmmwrite;
    input         avmmread;
    input  [ 1:0] avmmbyteen;
    input  [10:0] avmmaddress;
    input  [15:0] avmmwritedata;
    output [15:0] avmmreaddata;
    output        blockselect;
    output        clkout;

    cyclonev_hssi_pma_cdr_refclk_select_mux_encrypted  
    #(
    .lpm_type(lpm_type),
    .channel_number(channel_number),
    .refclk_select(refclk_select),
    .reference_clock_frequency(reference_clock_frequency),
    .avmm_group_channel_index(avmm_group_channel_index),
    .use_default_base_address(use_default_base_address),
    .user_base_address(user_base_address),
    .inclk0_logical_to_physical_mapping(inclk0_logical_to_physical_mapping),
    .inclk1_logical_to_physical_mapping(inclk1_logical_to_physical_mapping),
    .inclk2_logical_to_physical_mapping(inclk2_logical_to_physical_mapping),
    .inclk3_logical_to_physical_mapping(inclk3_logical_to_physical_mapping),
    .inclk4_logical_to_physical_mapping(inclk4_logical_to_physical_mapping),
    .inclk5_logical_to_physical_mapping(inclk5_logical_to_physical_mapping),
    .inclk6_logical_to_physical_mapping(inclk6_logical_to_physical_mapping),
    .inclk7_logical_to_physical_mapping(inclk7_logical_to_physical_mapping),
    .inclk8_logical_to_physical_mapping(inclk8_logical_to_physical_mapping),
    .inclk9_logical_to_physical_mapping(inclk9_logical_to_physical_mapping),
    .inclk10_logical_to_physical_mapping(inclk10_logical_to_physical_mapping),
    .inclk11_logical_to_physical_mapping(inclk11_logical_to_physical_mapping),
    .inclk12_logical_to_physical_mapping(inclk12_logical_to_physical_mapping),
    .inclk13_logical_to_physical_mapping(inclk13_logical_to_physical_mapping)
    ) inst (
        .calclk(calclk),
		.refclklc(refclklc),
		.occalen(occalen),
        .ffplloutbot(ffplloutbot),
        .ffpllouttop(ffpllouttop),
        .pldclk(pldclk),
        .refiqclk0(refiqclk0),
        .refiqclk1(refiqclk1),
        .refiqclk10(refiqclk10),
        .refiqclk2(refiqclk2),
        .refiqclk3(refiqclk3),
        .refiqclk4(refiqclk4),
        .refiqclk5(refiqclk5),
        .refiqclk6(refiqclk6),
        .refiqclk7(refiqclk7),
        .refiqclk8(refiqclk8),
        .refiqclk9(refiqclk9),
        .rxiqclk0(rxiqclk0),
        .rxiqclk1(rxiqclk1),
        .rxiqclk10(rxiqclk10),
        .rxiqclk2(rxiqclk2),
        .rxiqclk3(rxiqclk3),
        .rxiqclk4(rxiqclk4),
        .rxiqclk5(rxiqclk5),
        .rxiqclk6(rxiqclk6),
        .rxiqclk7(rxiqclk7),
        .rxiqclk8(rxiqclk8),
        .rxiqclk9(rxiqclk9),
		.avmmclk(avmmclk),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clkout(clkout) );
    
   // need to add assignment for the rest of the parameter assignments
   

endmodule //cyclonev_hssi_pma_cdr_refclk_select_mux

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_rx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_rx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter clkslip_sel = "pld",	//Valid values: pld|slip_eight_g_pcs
	parameter prot_mode = "other_protocols",	//Valid values: other_protocols|cpri_8g
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] pcs8grxclkiqout,
	input [ 0:0 ] pcs8grxclkslip,
	input [ 0:0 ] pldrxclkslip,
	input [ 0:0 ] pldrxpmarstb,
	input [ 4:0 ] pmareservedin,
	input [ 79:0 ] datainfrompma,
	input [ 0:0 ] pmarxpllphaselockin,
	input [ 0:0 ] clockinfrompma,
	input [ 0:0 ] pmasigdet,
	output [ 19:0 ] dataoutto8gpcs,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 0:0 ] pcs8gsigdetni,
	output [ 4:0 ] pmareservedout,
	output [ 0:0 ] pmarxclkout,
	output [ 0:0 ] pmarxpllphaselockout,
	output [ 0:0 ] pmarxclkslip,
	output [ 0:0 ] pmarxpmarstb,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_rx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.clkslip_sel(clkslip_sel),
		.prot_mode(prot_mode),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_rx_pcs_pma_interface_encrypted_inst	(
		.pcs8grxclkiqout(pcs8grxclkiqout),
		.pcs8grxclkslip(pcs8grxclkslip),
		.pldrxclkslip(pldrxclkslip),
		.pldrxpmarstb(pldrxpmarstb),
		.pmareservedin(pmareservedin),
		.datainfrompma(datainfrompma),
		.pmarxpllphaselockin(pmarxpllphaselockin),
		.clockinfrompma(clockinfrompma),
		.pmasigdet(pmasigdet),
		.dataoutto8gpcs(dataoutto8gpcs),
		.clockoutto8gpcs(clockoutto8gpcs),
		.pcs8gsigdetni(pcs8gsigdetni),
		.pmareservedout(pmareservedout),
		.pmarxclkout(pmarxclkout),
		.pmarxpllphaselockout(pmarxpllphaselockout),
		.pmarxclkslip(pmarxclkslip),
		.pmarxpmarstb(pmarxpmarstb),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_rx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_rx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter pcs_side_block_sel = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] emsipenablediocsrrdydly,
	input [ 12:0 ] emsiprxspecialin,
	input [ 3:0 ] pcs8ga1a2k1k2flag,
	input [ 0:0 ] pcs8galignstatus,
	input [ 0:0 ] pcs8gbistdone,
	input [ 0:0 ] pcs8gbisterr,
	input [ 0:0 ] pcs8gbyteordflag,
	input [ 0:0 ] pcs8gemptyrmf,
	input [ 0:0 ] pcs8gemptyrx,
	input [ 0:0 ] pcs8gfullrmf,
	input [ 0:0 ] pcs8gfullrx,
	input [ 0:0 ] pcs8grlvlt,
	input [ 0:0 ] clockinfrom8gpcs,
	input [ 3:0 ] pcs8grxdatavalid,
	input [ 63:0 ] datainfrom8gpcs,
	input [ 0:0 ] pcs8gsignaldetectout,
	input [ 4:0 ] pcs8gwaboundary,
	input [ 0:0 ] pld8ga1a2size,
	input [ 0:0 ] pld8gbitlocreven,
	input [ 0:0 ] pld8gbitslip,
	input [ 0:0 ] pld8gbytereven,
	input [ 0:0 ] pld8gbytordpld,
	input [ 0:0 ] pld8gcmpfifourstn,
	input [ 0:0 ] pld8gencdt,
	input [ 0:0 ] pld8gphfifourstrxn,
	input [ 0:0 ] pld8gpldrxclk,
	input [ 0:0 ] pld8gpolinvrx,
	input [ 0:0 ] pld8grdenablermf,
	input [ 0:0 ] pld8grdenablerx,
	input [ 0:0 ] pld8grxurstpcsn,
	input [ 0:0 ] pld8gwrdisablerx,
	input [ 0:0 ] pld8gwrenablermf,
	input [ 0:0 ] pldrxclkslipin,
	input [ 0:0 ] pldrxpmarstbin,
	input [ 0:0 ] pld8gsyncsmeninput,
	input [ 0:0 ] pmarxplllock,
	input [ 0:0 ] rstsel,
	input [ 0:0 ] usrrstsel,
	output [ 128:0 ] emsiprxout,
	output [ 15:0 ] emsiprxspecialout,
	output [ 0:0 ] pcs8ga1a2size,
	output [ 0:0 ] pcs8gbitlocreven,
	output [ 0:0 ] pcs8gbitslip,
	output [ 0:0 ] pcs8gbytereven,
	output [ 0:0 ] pcs8gbytordpld,
	output [ 0:0 ] pcs8gcmpfifourst,
	output [ 0:0 ] pcs8gencdt,
	output [ 0:0 ] pcs8gphfifourstrx,
	output [ 0:0 ] pcs8gpldrxclk,
	output [ 0:0 ] pcs8gpolinvrx,
	output [ 0:0 ] pcs8grdenablermf,
	output [ 0:0 ] pcs8grdenablerx,
	output [ 0:0 ] pcs8grxurstpcs,
	output [ 0:0 ] pcs8gsyncsmenoutput,
	output [ 0:0 ] pcs8gwrdisablerx,
	output [ 0:0 ] pcs8gwrenablermf,
	output [ 3:0 ] pld8ga1a2k1k2flag,
	output [ 0:0 ] pld8galignstatus,
	output [ 0:0 ] pld8gbistdone,
	output [ 0:0 ] pld8gbisterr,
	output [ 0:0 ] pld8gbyteordflag,
	output [ 0:0 ] pld8gemptyrmf,
	output [ 0:0 ] pld8gemptyrx,
	output [ 0:0 ] pld8gfullrmf,
	output [ 0:0 ] pld8gfullrx,
	output [ 0:0 ] pld8grlvlt,
	output [ 0:0 ] pld8grxclkout,
	output [ 3:0 ] pld8grxdatavalid,
	output [ 0:0 ] pld8gsignaldetectout,
	output [ 4:0 ] pld8gwaboundary,
	output [ 0:0 ] pldrxclkslipout,
	output [ 63:0 ] dataouttopld,
	output [ 0:0 ] pldrxpmarstbout,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_rx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_8g_0ppm(is_8g_0ppm),
		.pcs_side_block_sel(pcs_side_block_sel),
		.pld_side_data_source(pld_side_data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_rx_pld_pcs_interface_encrypted_inst	(
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.emsiprxspecialin(emsiprxspecialin),
		.pcs8ga1a2k1k2flag(pcs8ga1a2k1k2flag),
		.pcs8galignstatus(pcs8galignstatus),
		.pcs8gbistdone(pcs8gbistdone),
		.pcs8gbisterr(pcs8gbisterr),
		.pcs8gbyteordflag(pcs8gbyteordflag),
		.pcs8gemptyrmf(pcs8gemptyrmf),
		.pcs8gemptyrx(pcs8gemptyrx),
		.pcs8gfullrmf(pcs8gfullrmf),
		.pcs8gfullrx(pcs8gfullrx),
		.pcs8grlvlt(pcs8grlvlt),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pcs8grxdatavalid(pcs8grxdatavalid),
		.datainfrom8gpcs(datainfrom8gpcs),
		.pcs8gsignaldetectout(pcs8gsignaldetectout),
		.pcs8gwaboundary(pcs8gwaboundary),
		.pld8ga1a2size(pld8ga1a2size),
		.pld8gbitlocreven(pld8gbitlocreven),
		.pld8gbitslip(pld8gbitslip),
		.pld8gbytereven(pld8gbytereven),
		.pld8gbytordpld(pld8gbytordpld),
		.pld8gcmpfifourstn(pld8gcmpfifourstn),
		.pld8gencdt(pld8gencdt),
		.pld8gphfifourstrxn(pld8gphfifourstrxn),
		.pld8gpldrxclk(pld8gpldrxclk),
		.pld8gpolinvrx(pld8gpolinvrx),
		.pld8grdenablermf(pld8grdenablermf),
		.pld8grdenablerx(pld8grdenablerx),
		.pld8grxurstpcsn(pld8grxurstpcsn),
		.pld8gwrdisablerx(pld8gwrdisablerx),
		.pld8gwrenablermf(pld8gwrenablermf),
		.pldrxclkslipin(pldrxclkslipin),
		.pldrxpmarstbin(pldrxpmarstbin),
		.pld8gsyncsmeninput(pld8gsyncsmeninput),
		.pmarxplllock(pmarxplllock),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.emsiprxout(emsiprxout),
		.emsiprxspecialout(emsiprxspecialout),
		.pcs8ga1a2size(pcs8ga1a2size),
		.pcs8gbitlocreven(pcs8gbitlocreven),
		.pcs8gbitslip(pcs8gbitslip),
		.pcs8gbytereven(pcs8gbytereven),
		.pcs8gbytordpld(pcs8gbytordpld),
		.pcs8gcmpfifourst(pcs8gcmpfifourst),
		.pcs8gencdt(pcs8gencdt),
		.pcs8gphfifourstrx(pcs8gphfifourstrx),
		.pcs8gpldrxclk(pcs8gpldrxclk),
		.pcs8gpolinvrx(pcs8gpolinvrx),
		.pcs8grdenablermf(pcs8grdenablermf),
		.pcs8grdenablerx(pcs8grdenablerx),
		.pcs8grxurstpcs(pcs8grxurstpcs),
		.pcs8gsyncsmenoutput(pcs8gsyncsmenoutput),
		.pcs8gwrdisablerx(pcs8gwrdisablerx),
		.pcs8gwrenablermf(pcs8gwrenablermf),
		.pld8ga1a2k1k2flag(pld8ga1a2k1k2flag),
		.pld8galignstatus(pld8galignstatus),
		.pld8gbistdone(pld8gbistdone),
		.pld8gbisterr(pld8gbisterr),
		.pld8gbyteordflag(pld8gbyteordflag),
		.pld8gemptyrmf(pld8gemptyrmf),
		.pld8gemptyrx(pld8gemptyrx),
		.pld8gfullrmf(pld8gfullrmf),
		.pld8gfullrx(pld8gfullrx),
		.pld8grlvlt(pld8grlvlt),
		.pld8grxclkout(pld8grxclkout),
		.pld8grxdatavalid(pld8grxdatavalid),
		.pld8gsignaldetectout(pld8gsignaldetectout),
		.pld8gwaboundary(pld8gwaboundary),
		.pldrxclkslipout(pldrxclkslipout),
		.dataouttopld(dataouttopld),
		.pldrxpmarstbout(pldrxpmarstbout),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_tx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_tx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 19:0 ] datainfrom8gpcs,
	input [ 0:0 ] pcs8gtxclkiqout,
	input [ 0:0 ] pmarxfreqtxcmuplllockin,
	input [ 0:0 ] clockinfrompma,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 0:0 ] pmarxfreqtxcmuplllockout,
	output [ 0:0 ] pmatxclkout,
	output [ 79:0 ] dataouttopma,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_tx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_tx_pcs_pma_interface_encrypted_inst	(
		.datainfrom8gpcs(datainfrom8gpcs),
		.pcs8gtxclkiqout(pcs8gtxclkiqout),
		.pmarxfreqtxcmuplllockin(pmarxfreqtxcmuplllockin),
		.clockinfrompma(clockinfrompma),
		.clockoutto8gpcs(clockoutto8gpcs),
		.pmarxfreqtxcmuplllockout(pmarxfreqtxcmuplllockout),
		.pmatxclkout(pmatxclkout),
		.dataouttopma(dataouttopma),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_hssi_tx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_tx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] emsipenablediocsrrdydly,
	input [ 103:0 ] emsiptxin,
	input [ 12:0 ] emsiptxspecialin,
	input [ 0:0 ] pcs8gemptytx,
	input [ 0:0 ] pcs8gfulltx,
	input [ 0:0 ] clockinfrom8gpcs,
	input [ 0:0 ] pld8gphfifoursttxn,
	input [ 0:0 ] pld8gpldtxclk,
	input [ 0:0 ] pld8gpolinvtx,
	input [ 0:0 ] pld8grddisabletx,
	input [ 0:0 ] pld8grevloopbk,
	input [ 4:0 ] pld8gtxboundarysel,
	input [ 3:0 ] pld8gtxdatavalid,
	input [ 0:0 ] pld8gtxurstpcsn,
	input [ 0:0 ] pld8gwrenabletx,
	input [ 43:0 ] datainfrompld,
	input [ 0:0 ] pmatxcmuplllock,
	input [ 0:0 ] rstsel,
	input [ 0:0 ] usrrstsel,
	output [ 2:0 ] emsippcstxclkout,
	output [ 15:0 ] emsiptxspecialout,
	output [ 0:0 ] pcs8gphfifoursttx,
	output [ 0:0 ] pcs8gpldtxclk,
	output [ 0:0 ] pcs8gpolinvtx,
	output [ 0:0 ] pcs8grddisabletx,
	output [ 0:0 ] pcs8grevloopbk,
	output [ 4:0 ] pcs8gtxboundarysel,
	output [ 3:0 ] pcs8gtxdatavalid,
	output [ 43:0 ] dataoutto8gpcs,
	output [ 0:0 ] pcs8gtxurstpcs,
	output [ 0:0 ] pcs8gwrenabletx,
	output [ 0:0 ] pld8gemptytx,
	output [ 0:0 ] pld8gfulltx,
	output [ 0:0 ] pld8gtxclkout,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_tx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_8g_0ppm(is_8g_0ppm),
		.pld_side_data_source(pld_side_data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_tx_pld_pcs_interface_encrypted_inst	(
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.emsiptxin(emsiptxin),
		.emsiptxspecialin(emsiptxspecialin),
		.pcs8gemptytx(pcs8gemptytx),
		.pcs8gfulltx(pcs8gfulltx),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pld8gphfifoursttxn(pld8gphfifoursttxn),
		.pld8gpldtxclk(pld8gpldtxclk),
		.pld8gpolinvtx(pld8gpolinvtx),
		.pld8grddisabletx(pld8grddisabletx),
		.pld8grevloopbk(pld8grevloopbk),
		.pld8gtxboundarysel(pld8gtxboundarysel),
		.pld8gtxdatavalid(pld8gtxdatavalid),
		.pld8gtxurstpcsn(pld8gtxurstpcsn),
		.pld8gwrenabletx(pld8gwrenabletx),
		.datainfrompld(datainfrompld),
		.pmatxcmuplllock(pmatxcmuplllock),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.emsippcstxclkout(emsippcstxclkout),
		.emsiptxspecialout(emsiptxspecialout),
		.pcs8gphfifoursttx(pcs8gphfifoursttx),
		.pcs8gpldtxclk(pcs8gpldtxclk),
		.pcs8gpolinvtx(pcs8gpolinvtx),
		.pcs8grddisabletx(pcs8grddisabletx),
		.pcs8grevloopbk(pcs8grevloopbk),
		.pcs8gtxboundarysel(pcs8gtxboundarysel),
		.pcs8gtxdatavalid(pcs8gtxdatavalid),
		.dataoutto8gpcs(dataoutto8gpcs),
		.pcs8gtxurstpcs(pcs8gtxurstpcs),
		.pcs8gwrenabletx(pcs8gwrenabletx),
		.pld8gemptytx(pld8gemptytx),
		.pld8gfulltx(pld8gfulltx),
		.pld8gtxclkout(pld8gtxclkout),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule

`timescale 1 ps/1 ps

module cyclonev_hssi_refclk_divider 
  #(  
      parameter lpm_type                    = "cyclonev_hssi_refclk_divider",
      parameter divide_by                   =  1,
      parameter enabled                     = "true",
      parameter refclk_coupling_termination = "normal_100_ohm_termination"
  ) (
  input    [0:0]       refclkin,
  output   [0:0]       refclkout,
  input    [0:0]       nonuserfrompmaux
);

	cyclonev_hssi_refclk_divider_encrypted 
		#(
			.lpm_type(lpm_type),
			.divide_by(divide_by),
			.enabled(enabled),
			.refclk_coupling_termination(refclk_coupling_termination)
		)
	cyclonev_hssi_refclk_divider_encrypted_inst (
			.refclkin(refclkin),
			.refclkout(refclkout),
			.nonuserfrompmaux(nonuserfrompmaux)
		);
	

endmodule
module cyclonev_pll_aux
(
 input atb0out,
 input atb1out,
 output atbcompout 
 );


parameter lpm_type = "cyclonev_pll_aux";
parameter pl_aux_atb_atben0_precomp =  01'b1 ;
parameter pl_aux_atb_atben1_precomp =  01'b1 ;
parameter pl_aux_atb_comp_minus =  01'b0 ;
parameter pl_aux_atb_comp_plus =  01'b0 ;
parameter pl_aux_comp_pwr_dn =  01'b1 ;

assign atbcompout= 01'b0;

   /* empty */

endmodule

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : cyclonev_channel_pll_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_channel_pll
#(
	parameter sim_use_fast_model = "true",
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
        
        parameter cvp_en_iocsr = "false", //valid values: true|false
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter output_clock_frequency = "",	//Valid values: 
	parameter enabled_for_reconfig = "false",	//Valid values: false|true
	parameter bbpd_salatch_offset_ctrl_clk0 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk180 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk270 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk90 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_rightoffset_delta7_right
	parameter bbpd_salatch_sel = "normal",	//Valid values: testmux|normal
	parameter bypass_cp_rgla = "false",	//Valid values: true|false
	parameter cdr_atb_select = "atb_disable",	//Valid values: atb_disable|atb_sel_1|atb_sel_2|atb_sel_3|atb_sel_4|atb_sel_5|atb_sel_6|atb_sel_7|atb_sel_8|atb_sel_9|atb_sel_10|atb_sel_11|atb_sel_12|atb_sel_13|atb_sel_14
	parameter cgb_clk_enable = "false",	//Valid values: false|true
	parameter charge_pump_current_test = "enable_ch_pump_normal",	//Valid values: enable_ch_pump_normal|enable_ch_pump_curr_test_up|enable_ch_pump_curr_test_down|disable_ch_pump_curr_test
	parameter clklow_fref_to_ppm_div_sel = 1,	//Valid values: 1|2
	parameter clock_monitor = "lpbk_data",	//Valid values: lpbk_clk|lpbk_data
	parameter diag_rev_lpbk = "false",	//Valid values: false|true
	parameter enable_gpon_detection = "false",	//Valid values: false|true
	parameter fast_lock_mode = "true",	//Valid values: false|true
	parameter fb_sel = "vcoclk",	//Valid values: vcoclk|extclk
	parameter hs_levshift_power_supply_setting = 1,	//Valid values: 0|1|2|3
	parameter ignore_phslock = "false",	//Valid values: true|false
	parameter l_counter_pd_clock_disable = "false",	//Valid values: false|true
	parameter m_counter = -1,	//Valid values: 1|4|5|8|10|12|16|20|25|32|40|50
	parameter pcie_freq_control = "pcie_100mhz",	//Valid values: pcie_100mhz|pcie_125mhz
	parameter pd_charge_pump_current_ctrl = 5,	//Valid values: 5|10|20|30|40
	parameter pd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter pfd_charge_pump_current_ctrl = 20,	//Valid values: 5|10|20|30|40|50|60|80|100|120
	parameter pfd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter powerdown = "false",	//Valid values: false|true
	parameter ref_clk_div = -1,	//Valid values: 1|2|4|8
	parameter regulator_volt_inc = "0",	//Valid values: 0|5|10|15|20|25|30|not_used
	parameter replica_bias_ctrl = "true",	//Valid values: true|false
	parameter reverse_serial_lpbk = "false",	//Valid values: false|true
	parameter ripple_cap_ctrl = "none",	//Valid values: reserved_11|reserved_10|plus_2pf|none
	parameter rxpll_pd_bw_ctrl = 300,	//Valid values: 600|300|240|170
	parameter rxpll_pfd_bw_ctrl = 3200,	//Valid values: 1600|3200|4800|6400
	parameter txpll_hclk_driver_enable = "false",	//Valid values: false|true
	parameter vco_overange_ref = "ref_2",	//Valid values: off|ref_1|ref_2|ref_3
	parameter vco_range_ctrl_en = "true"	//Valid values: true|false
)
(
//input and output port declaration
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 0:0 ] clkindeser,
	input [ 0:0 ] crurstb,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] extclk,
	input [ 0:0 ] lpbkpreen,
	input [ 0:0 ] ltd,
	input [ 0:0 ] ltr,
	input [ 0:0 ] occalen,
	input [ 0:0 ] pciel,
	input [ 1:0 ] pciesw,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] refclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxp,
	input [ 0:0 ] sd,
	output [ 0:0 ] ck0pd,
	output [ 0:0 ] ck180pd,
	output [ 0:0 ] ck270pd,
	output [ 0:0 ] ck90pd,
	output [ 0:0 ] clk270bdes,
	output [ 0:0 ] clk90bdes,
	output [ 0:0 ] clkcdr,
	output [ 0:0 ] clklow,
	output [ 0:0 ] deven,
	output [ 0:0 ] dodd,
	output [ 0:0 ] fref,
	output [ 3:0 ] pdof,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] rxlpbdp,
	output [ 0:0 ] rxlpbp,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] txpllhclk,
	output [ 0:0 ] txrlpbk,
	output [ 0:0 ] vctrloverrange); 

	cyclonev_channel_pll_encrypted 
	#(
		.sim_use_fast_model(sim_use_fast_model),
		.enable_debug_info(enable_debug_info),

		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.enabled_for_reconfig(enabled_for_reconfig),
		.bbpd_salatch_offset_ctrl_clk0(bbpd_salatch_offset_ctrl_clk0),
		.bbpd_salatch_offset_ctrl_clk180(bbpd_salatch_offset_ctrl_clk180),
		.bbpd_salatch_offset_ctrl_clk270(bbpd_salatch_offset_ctrl_clk270),
		.bbpd_salatch_offset_ctrl_clk90(bbpd_salatch_offset_ctrl_clk90),
		.bbpd_salatch_sel(bbpd_salatch_sel),
		.bypass_cp_rgla(bypass_cp_rgla),
		.cdr_atb_select(cdr_atb_select),
		.cgb_clk_enable(cgb_clk_enable),
		.charge_pump_current_test(charge_pump_current_test),
		.clklow_fref_to_ppm_div_sel(clklow_fref_to_ppm_div_sel),
		.clock_monitor(clock_monitor),
		.diag_rev_lpbk(diag_rev_lpbk),
		.enable_gpon_detection(enable_gpon_detection),
		.fast_lock_mode(fast_lock_mode),
		.fb_sel(fb_sel),
		.hs_levshift_power_supply_setting(hs_levshift_power_supply_setting),
		.ignore_phslock(ignore_phslock),
		.l_counter_pd_clock_disable(l_counter_pd_clock_disable),
		.m_counter(m_counter),
		.pcie_freq_control(pcie_freq_control),
		.pd_charge_pump_current_ctrl(pd_charge_pump_current_ctrl),
		.pd_l_counter(pd_l_counter),
		.pfd_charge_pump_current_ctrl(pfd_charge_pump_current_ctrl),
		.pfd_l_counter(pfd_l_counter),
		.powerdown(powerdown),
		.ref_clk_div(ref_clk_div),
		.regulator_volt_inc(regulator_volt_inc),
		.replica_bias_ctrl(replica_bias_ctrl),
		.reverse_serial_lpbk(reverse_serial_lpbk),
		.ripple_cap_ctrl(ripple_cap_ctrl),
		.rxpll_pd_bw_ctrl(rxpll_pd_bw_ctrl),
		.rxpll_pfd_bw_ctrl(rxpll_pfd_bw_ctrl),
		.txpll_hclk_driver_enable(txpll_hclk_driver_enable),
		.vco_overange_ref(vco_overange_ref),
		.vco_range_ctrl_en(vco_range_ctrl_en)

	)
	cyclonev_channel_pll_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clkindeser(clkindeser),
		.crurstb(crurstb),
		.earlyeios(earlyeios),
		.extclk(extclk),
		.lpbkpreen(lpbkpreen),
		.ltd(ltd),
		.ltr(ltr),
		.occalen(occalen),
		.pciel(pciel),
		.pciesw(pciesw),
		.ppmlock(ppmlock),
		.refclk(refclk),
		.rstn(rstn),
		.rxp(rxp),
		.sd(sd),
		.ck0pd(ck0pd),
		.ck180pd(ck180pd),
		.ck270pd(ck270pd),
		.ck90pd(ck90pd),
		.clk270bdes(clk270bdes),
		.clk90bdes(clk90bdes),
		.clkcdr(clkcdr),
		.clklow(clklow),
		.deven(deven),
		.dodd(dodd),
		.fref(fref),
		.pdof(pdof),
		.pfdmodelock(pfdmodelock),
		.rxlpbdp(rxlpbdp),
		.rxlpbp(rxlpbp),
		.rxplllock(rxplllock),
		.txpllhclk(txpllhclk),
		.txrlpbk(txrlpbk),
		.vctrloverrange(vctrloverrange)
	);


endmodule
// ----------------------------------------------------------------------------------
// This is the HSSI Simulation Atom Model Encryption wrapper for the AVMM Interface
// Module Name : cyclonev_hssi_avmm_interface
// ----------------------------------------------------------------------------------

`timescale 1 ps/1 ps
module cyclonev_hssi_avmm_interface
  #(
    parameter num_ch0_atoms = 0,
    parameter num_ch1_atoms = 0,
    parameter num_ch2_atoms = 0
    )
(
//input and output port declaration
    input  wire                 avmmrstn,
    input  wire                 avmmclk,
    input  wire                 avmmwrite,
    input  wire                 avmmread,
    input  wire  [ 1:0 ]        avmmbyteen,
    input  wire  [ 10:0 ]       avmmaddress,
    input  wire  [ 15:0 ]       avmmwritedata,
    input  wire  [ 90-1:0 ]     blockselect,
    input  wire  [ 90*16 -1:0 ] readdatachnl,

    output wire  [ 15:0 ]       avmmreaddata,

    output wire                 clkchnl,
    output wire                 rstnchnl,
    output wire  [ 15:0 ]       writedatachnl,
    output wire  [ 10:0 ]       regaddrchnl,
    output wire                 writechnl,
    output wire                 readchnl,
    output wire  [ 1:0 ]        byteenchnl,

    //The following ports are not modelled. They exist to match the avmm interface atom interface
    input  wire                 refclkdig,
    input  wire                 avmmreservedin,
    
    output wire                 avmmreservedout,
    output wire                 dpriorstntop,
    output wire                 dprioclktop,
    output wire                 mdiodistopchnl,
    output wire                 dpriorstnmid,
    output wire                 dprioclkmid,
    output wire                 mdiodismidchnl,
    output wire                 dpriorstnbot,
    output wire                 dprioclkbot,
    output wire                 mdiodisbotchnl,
    output wire  [ 3:0 ]        dpriotestsitopchnl,
    output wire  [ 3:0 ]        dpriotestsimidchnl,
    output wire  [ 3:0 ]        dpriotestsibotchnl,
 
    //The following ports belong to pm_adce and pm_tst_mux blocks in the PMA
    input  wire  [ 11:0 ]       pmatestbussel,
    output wire  [ 23:0 ]       pmatestbus,
  
    //
    input  wire                 scanmoden,
    input  wire                 scanshiftn,
    input  wire                 interfacesel,
    input  wire                 sershiftload
); 

  cyclonev_hssi_avmm_interface_encrypted
  #(
    .num_ch0_atoms(num_ch0_atoms),
    .num_ch1_atoms(num_ch1_atoms),
    .num_ch2_atoms(num_ch2_atoms)
  ) stratixv_hssi_avmm_interface_encrypted_inst (
    .avmmrstn          (avmmrstn),
    .avmmclk           (avmmclk),
    .avmmwrite         (avmmwrite),
    .avmmread          (avmmread),
    .avmmbyteen        (avmmbyteen),
    .avmmaddress       (avmmaddress),
    .avmmwritedata     (avmmwritedata),
    .blockselect       (blockselect),
    .readdatachnl      (readdatachnl),
    .avmmreaddata      (avmmreaddata),
    .clkchnl           (clkchnl),
    .rstnchnl          (rstnchnl),
    .writedatachnl     (writedatachnl),
    .regaddrchnl       (regaddrchnl),
    .writechnl         (writechnl),
    .readchnl          (readchnl),
    .byteenchnl        (byteenchnl),
    .refclkdig         (refclkdig),
    .avmmreservedin    (avmmreservedin),
    .avmmreservedout   (avmmreservedout),
    .dpriorstntop      (dpriorstntop),
    .dprioclktop       (dprioclktop),
    .mdiodistopchnl    (mdiodistopchnl),
    .dpriorstnmid      (dpriorstnmid),
    .dprioclkmid       (dprioclkmid),
    .mdiodismidchnl    (mdiodismidchnl),
    .dpriorstnbot      (dpriorstnbot),
    .dprioclkbot       (dprioclkbot),
    .mdiodisbotchnl    (mdiodisbotchnl),
    .dpriotestsitopchnl(dpriotestsitopchnl),
    .dpriotestsimidchnl(dpriotestsimidchnl),
    .dpriotestsibotchnl(dpriotestsibotchnl),
    .pmatestbus        (pmatestbus),
    .pmatestbussel     (pmatestbussel),
    .scanmoden         (scanmoden),
    .scanshiftn        (scanshiftn),
    .interfacesel      (interfacesel),
    .sershiftload      (sershiftload)
  );

endmodule
`timescale 1 ps/1 ps

module cyclonev_hssi_pma_hi_pmaif
  #(
    parameter lpm_type = "cyclonev_hssi_pma_hi_pmaif",
    parameter tx_pma_direction_sel = "pcs"    // valid values pcs|core
  )    
  (
   input [79:0] datainfromcore,
   input [79:0] datainfrompcs,
   output [79:0] dataouttopma

   // ... avmm and block select ports go here ...

   );

    cyclonev_hssi_pma_hi_pmaif_encrypted 
    # (
    .tx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfromcore(datainfromcore),
   .datainfrompcs(datainfrompcs),
   .dataouttopma(dataouttopma)
   );

endmodule // hi_pmaif
`timescale 1 ps/1 ps

module cyclonev_hssi_pma_hi_xcvrif
  #(
    parameter lpm_type = "cyclonev_hssi_pma_hi_xcvrif",
    parameter rx_pma_direction_sel = "pcs"    // valid values pcs|core
    )
  (
   input  [79:0] datainfrompma,
   input  [79:0] datainfrompcs,
   output [79:0] dataouttopld

   // ... avmm and block select ports go here ...

   );

    cyclonev_hssi_pma_hi_xcvrif_encrypted 
    # (
    .rx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfrompma(datainfrompma),
   .datainfrompcs(datainfrompcs),
   .dataouttopld(dataouttopld)
   );

endmodule // hi_pmaif
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_8g_pcs_aggregate_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_8g_pcs_aggregate
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter xaui_sm_operation = "en_xaui_sm",	//Valid values: dis_xaui_sm|en_xaui_sm|en_xaui_legacy_sm
	parameter dskw_sm_operation = "dskw_xaui_sm",	//Valid values: dskw_xaui_sm|dskw_srio_sm
	parameter data_agg_bonding = "agg_disable",	//Valid values: agg_disable|x4_cmu1|x4_cmu2|x4_cmu3|x4_lc1|x4_lc2|x4_lc3|x2_cmu1|x2_lc1
	parameter prot_mode_tx = "pipe_g1_tx",	//Valid values: pipe_g1_tx|pipe_g2_tx|cpri_tx|cpri_rx_tx_tx|gige_tx|xaui_tx|srio_2p1_tx|test_tx|basic_tx|disabled_prot_mode_tx
	parameter pcs_dw_datapath = "sw_data_path",	//Valid values: sw_data_path|dw_data_path
	parameter dskw_control = "dskw_write_control",	//Valid values: dskw_write_control|dskw_read_control
	parameter refclkdig_sel = "dis_refclk_dig_sel",	//Valid values: dis_refclk_dig_sel|en_refclk_dig_sel
	parameter agg_pwdn = "dis_agg_pwdn",	//Valid values: dis_agg_pwdn|en_agg_pwdn
	parameter [ 3:0 ] dskw_mnumber_data = 4'b100,	//Valid values: 4
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 1:0 ] aligndetsyncbotch2,
	input [ 1:0 ] aligndetsyncch0,
	input [ 1:0 ] aligndetsyncch1,
	input [ 1:0 ] aligndetsyncch2,
	input [ 1:0 ] aligndetsynctopch0,
	input [ 1:0 ] aligndetsynctopch1,
	input [ 0:0 ] alignstatussyncbotch2,
	input [ 0:0 ] alignstatussyncch0,
	input [ 0:0 ] alignstatussyncch1,
	input [ 0:0 ] alignstatussyncch2,
	input [ 0:0 ] alignstatussynctopch0,
	input [ 0:0 ] alignstatussynctopch1,
	input [ 1:0 ] cgcomprddinbotch2,
	input [ 1:0 ] cgcomprddinch0,
	input [ 1:0 ] cgcomprddinch1,
	input [ 1:0 ] cgcomprddinch2,
	input [ 1:0 ] cgcomprddintopch0,
	input [ 1:0 ] cgcomprddintopch1,
	input [ 1:0 ] cgcompwrinbotch2,
	input [ 1:0 ] cgcompwrinch0,
	input [ 1:0 ] cgcompwrinch1,
	input [ 1:0 ] cgcompwrinch2,
	input [ 1:0 ] cgcompwrintopch0,
	input [ 1:0 ] cgcompwrintopch1,
	input [ 0:0 ] decctlbotch2,
	input [ 0:0 ] decctlch0,
	input [ 0:0 ] decctlch1,
	input [ 0:0 ] decctlch2,
	input [ 0:0 ] decctltopch0,
	input [ 0:0 ] decctltopch1,
	input [ 7:0 ] decdatabotch2,
	input [ 7:0 ] decdatach0,
	input [ 7:0 ] decdatach1,
	input [ 7:0 ] decdatach2,
	input [ 7:0 ] decdatatopch0,
	input [ 7:0 ] decdatatopch1,
	input [ 0:0 ] decdatavalidbotch2,
	input [ 0:0 ] decdatavalidch0,
	input [ 0:0 ] decdatavalidch1,
	input [ 0:0 ] decdatavalidch2,
	input [ 0:0 ] decdatavalidtopch0,
	input [ 0:0 ] decdatavalidtopch1,
	input [ 0:0 ] dedicatedaggscaninch1,
	input [ 0:0 ] delcondmetinbotch2,
	input [ 0:0 ] delcondmetinch0,
	input [ 0:0 ] delcondmetinch1,
	input [ 0:0 ] delcondmetinch2,
	input [ 0:0 ] delcondmetintopch0,
	input [ 0:0 ] delcondmetintopch1,
	input [ 63:0 ] dprioagg,
	input [ 0:0 ] fifoovrinbotch2,
	input [ 0:0 ] fifoovrinch0,
	input [ 0:0 ] fifoovrinch1,
	input [ 0:0 ] fifoovrinch2,
	input [ 0:0 ] fifoovrintopch0,
	input [ 0:0 ] fifoovrintopch1,
	input [ 0:0 ] fifordinbotch2,
	input [ 0:0 ] fifordinch0,
	input [ 0:0 ] fifordinch1,
	input [ 0:0 ] fifordinch2,
	input [ 0:0 ] fifordintopch0,
	input [ 0:0 ] fifordintopch1,
	input [ 0:0 ] insertincompleteinbotch2,
	input [ 0:0 ] insertincompleteinch0,
	input [ 0:0 ] insertincompleteinch1,
	input [ 0:0 ] insertincompleteinch2,
	input [ 0:0 ] insertincompleteintopch0,
	input [ 0:0 ] insertincompleteintopch1,
	input [ 0:0 ] latencycompinbotch2,
	input [ 0:0 ] latencycompinch0,
	input [ 0:0 ] latencycompinch1,
	input [ 0:0 ] latencycompinch2,
	input [ 0:0 ] latencycompintopch0,
	input [ 0:0 ] latencycompintopch1,
	input [ 0:0 ] rcvdclkch0,
	input [ 0:0 ] rcvdclkch1,
	input [ 1:0 ] rdalignbotch2,
	input [ 1:0 ] rdalignch0,
	input [ 1:0 ] rdalignch1,
	input [ 1:0 ] rdalignch2,
	input [ 1:0 ] rdaligntopch0,
	input [ 1:0 ] rdaligntopch1,
	input [ 0:0 ] rdenablesyncbotch2,
	input [ 0:0 ] rdenablesyncch0,
	input [ 0:0 ] rdenablesyncch1,
	input [ 0:0 ] rdenablesyncch2,
	input [ 0:0 ] rdenablesynctopch0,
	input [ 0:0 ] rdenablesynctopch1,
	input [ 0:0 ] refclkdig,
	input [ 1:0 ] runningdispbotch2,
	input [ 1:0 ] runningdispch0,
	input [ 1:0 ] runningdispch1,
	input [ 1:0 ] runningdispch2,
	input [ 1:0 ] runningdisptopch0,
	input [ 1:0 ] runningdisptopch1,
	input [ 0:0 ] rxpcsrstn,
	input [ 0:0 ] scanmoden,
	input [ 0:0 ] scanshiftn,
	input [ 0:0 ] syncstatusbotch2,
	input [ 0:0 ] syncstatusch0,
	input [ 0:0 ] syncstatusch1,
	input [ 0:0 ] syncstatusch2,
	input [ 0:0 ] syncstatustopch0,
	input [ 0:0 ] syncstatustopch1,
	input [ 0:0 ] txctltcbotch2,
	input [ 0:0 ] txctltcch0,
	input [ 0:0 ] txctltcch1,
	input [ 0:0 ] txctltcch2,
	input [ 0:0 ] txctltctopch0,
	input [ 0:0 ] txctltctopch1,
	input [ 7:0 ] txdatatcbotch2,
	input [ 7:0 ] txdatatcch0,
	input [ 7:0 ] txdatatcch1,
	input [ 7:0 ] txdatatcch2,
	input [ 7:0 ] txdatatctopch0,
	input [ 7:0 ] txdatatctopch1,
	input [ 0:0 ] txpcsrstn,
	input [ 0:0 ] txpmaclk,
	output [ 15:0 ] aggtestbusch0,
	output [ 15:0 ] aggtestbusch1,
	output [ 15:0 ] aggtestbusch2,
	output [ 0:0 ] alignstatusbotch2,
	output [ 0:0 ] alignstatusch0,
	output [ 0:0 ] alignstatusch1,
	output [ 0:0 ] alignstatusch2,
	output [ 0:0 ] alignstatussync0botch2,
	output [ 0:0 ] alignstatussync0ch0,
	output [ 0:0 ] alignstatussync0ch1,
	output [ 0:0 ] alignstatussync0ch2,
	output [ 0:0 ] alignstatussync0topch0,
	output [ 0:0 ] alignstatussync0topch1,
	output [ 0:0 ] alignstatustopch0,
	output [ 0:0 ] alignstatustopch1,
	output [ 0:0 ] cgcomprddallbotch2,
	output [ 0:0 ] cgcomprddallch0,
	output [ 0:0 ] cgcomprddallch1,
	output [ 0:0 ] cgcomprddallch2,
	output [ 0:0 ] cgcomprddalltopch0,
	output [ 0:0 ] cgcomprddalltopch1,
	output [ 0:0 ] cgcompwrallbotch2,
	output [ 0:0 ] cgcompwrallch0,
	output [ 0:0 ] cgcompwrallch1,
	output [ 0:0 ] cgcompwrallch2,
	output [ 0:0 ] cgcompwralltopch0,
	output [ 0:0 ] cgcompwralltopch1,
	output [ 0:0 ] dedicatedaggscanoutch0tieoff,
	output [ 0:0 ] dedicatedaggscanoutch1,
	output [ 0:0 ] dedicatedaggscanoutch2tieoff,
	output [ 0:0 ] delcondmet0botch2,
	output [ 0:0 ] delcondmet0ch0,
	output [ 0:0 ] delcondmet0ch1,
	output [ 0:0 ] delcondmet0ch2,
	output [ 0:0 ] delcondmet0topch0,
	output [ 0:0 ] delcondmet0topch1,
	output [ 0:0 ] endskwqdbotch2,
	output [ 0:0 ] endskwqdch0,
	output [ 0:0 ] endskwqdch1,
	output [ 0:0 ] endskwqdch2,
	output [ 0:0 ] endskwqdtopch0,
	output [ 0:0 ] endskwqdtopch1,
	output [ 0:0 ] endskwrdptrsbotch2,
	output [ 0:0 ] endskwrdptrsch0,
	output [ 0:0 ] endskwrdptrsch1,
	output [ 0:0 ] endskwrdptrsch2,
	output [ 0:0 ] endskwrdptrstopch0,
	output [ 0:0 ] endskwrdptrstopch1,
	output [ 0:0 ] fifoovr0botch2,
	output [ 0:0 ] fifoovr0ch0,
	output [ 0:0 ] fifoovr0ch1,
	output [ 0:0 ] fifoovr0ch2,
	output [ 0:0 ] fifoovr0topch0,
	output [ 0:0 ] fifoovr0topch1,
	output [ 0:0 ] fifordoutcomp0botch2,
	output [ 0:0 ] fifordoutcomp0ch0,
	output [ 0:0 ] fifordoutcomp0ch1,
	output [ 0:0 ] fifordoutcomp0ch2,
	output [ 0:0 ] fifordoutcomp0topch0,
	output [ 0:0 ] fifordoutcomp0topch1,
	output [ 0:0 ] fiforstrdqdbotch2,
	output [ 0:0 ] fiforstrdqdch0,
	output [ 0:0 ] fiforstrdqdch1,
	output [ 0:0 ] fiforstrdqdch2,
	output [ 0:0 ] fiforstrdqdtopch0,
	output [ 0:0 ] fiforstrdqdtopch1,
	output [ 0:0 ] insertincomplete0botch2,
	output [ 0:0 ] insertincomplete0ch0,
	output [ 0:0 ] insertincomplete0ch1,
	output [ 0:0 ] insertincomplete0ch2,
	output [ 0:0 ] insertincomplete0topch0,
	output [ 0:0 ] insertincomplete0topch1,
	output [ 0:0 ] latencycomp0botch2,
	output [ 0:0 ] latencycomp0ch0,
	output [ 0:0 ] latencycomp0ch1,
	output [ 0:0 ] latencycomp0ch2,
	output [ 0:0 ] latencycomp0topch0,
	output [ 0:0 ] latencycomp0topch1,
	output [ 0:0 ] rcvdclkout,
	output [ 0:0 ] rcvdclkoutbot,
	output [ 0:0 ] rcvdclkouttop,
	output [ 0:0 ] rxctlrsbotch2,
	output [ 0:0 ] rxctlrsch0,
	output [ 0:0 ] rxctlrsch1,
	output [ 0:0 ] rxctlrsch2,
	output [ 0:0 ] rxctlrstopch0,
	output [ 0:0 ] rxctlrstopch1,
	output [ 7:0 ] rxdatarsbotch2,
	output [ 7:0 ] rxdatarsch0,
	output [ 7:0 ] rxdatarsch1,
	output [ 7:0 ] rxdatarsch2,
	output [ 7:0 ] rxdatarstopch0,
	output [ 7:0 ] rxdatarstopch1,
	output [ 0:0 ] txctltsbotch2,
	output [ 0:0 ] txctltsch0,
	output [ 0:0 ] txctltsch1,
	output [ 0:0 ] txctltsch2,
	output [ 0:0 ] txctltstopch0,
	output [ 0:0 ] txctltstopch1,
	output [ 7:0 ] txdatatsbotch2,
	output [ 7:0 ] txdatatsch0,
	output [ 7:0 ] txdatatsch1,
	output [ 7:0 ] txdatatsch2,
	output [ 7:0 ] txdatatstopch0,
	output [ 7:0 ] txdatatstopch1); 

	cyclonev_hssi_8g_pcs_aggregate_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.xaui_sm_operation(xaui_sm_operation),
		.dskw_sm_operation(dskw_sm_operation),
		.data_agg_bonding(data_agg_bonding),
		.prot_mode_tx(prot_mode_tx),
		.pcs_dw_datapath(pcs_dw_datapath),
		.dskw_control(dskw_control),
		.refclkdig_sel(refclkdig_sel),
		.agg_pwdn(agg_pwdn),
		.dskw_mnumber_data(dskw_mnumber_data),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_pcs_aggregate_encrypted_inst	(
		.aligndetsyncbotch2(aligndetsyncbotch2),
		.aligndetsyncch0(aligndetsyncch0),
		.aligndetsyncch1(aligndetsyncch1),
		.aligndetsyncch2(aligndetsyncch2),
		.aligndetsynctopch0(aligndetsynctopch0),
		.aligndetsynctopch1(aligndetsynctopch1),
		.alignstatussyncbotch2(alignstatussyncbotch2),
		.alignstatussyncch0(alignstatussyncch0),
		.alignstatussyncch1(alignstatussyncch1),
		.alignstatussyncch2(alignstatussyncch2),
		.alignstatussynctopch0(alignstatussynctopch0),
		.alignstatussynctopch1(alignstatussynctopch1),
		.cgcomprddinbotch2(cgcomprddinbotch2),
		.cgcomprddinch0(cgcomprddinch0),
		.cgcomprddinch1(cgcomprddinch1),
		.cgcomprddinch2(cgcomprddinch2),
		.cgcomprddintopch0(cgcomprddintopch0),
		.cgcomprddintopch1(cgcomprddintopch1),
		.cgcompwrinbotch2(cgcompwrinbotch2),
		.cgcompwrinch0(cgcompwrinch0),
		.cgcompwrinch1(cgcompwrinch1),
		.cgcompwrinch2(cgcompwrinch2),
		.cgcompwrintopch0(cgcompwrintopch0),
		.cgcompwrintopch1(cgcompwrintopch1),
		.decctlbotch2(decctlbotch2),
		.decctlch0(decctlch0),
		.decctlch1(decctlch1),
		.decctlch2(decctlch2),
		.decctltopch0(decctltopch0),
		.decctltopch1(decctltopch1),
		.decdatabotch2(decdatabotch2),
		.decdatach0(decdatach0),
		.decdatach1(decdatach1),
		.decdatach2(decdatach2),
		.decdatatopch0(decdatatopch0),
		.decdatatopch1(decdatatopch1),
		.decdatavalidbotch2(decdatavalidbotch2),
		.decdatavalidch0(decdatavalidch0),
		.decdatavalidch1(decdatavalidch1),
		.decdatavalidch2(decdatavalidch2),
		.decdatavalidtopch0(decdatavalidtopch0),
		.decdatavalidtopch1(decdatavalidtopch1),
		.dedicatedaggscaninch1(dedicatedaggscaninch1),
		.delcondmetinbotch2(delcondmetinbotch2),
		.delcondmetinch0(delcondmetinch0),
		.delcondmetinch1(delcondmetinch1),
		.delcondmetinch2(delcondmetinch2),
		.delcondmetintopch0(delcondmetintopch0),
		.delcondmetintopch1(delcondmetintopch1),
		.dprioagg(dprioagg),
		.fifoovrinbotch2(fifoovrinbotch2),
		.fifoovrinch0(fifoovrinch0),
		.fifoovrinch1(fifoovrinch1),
		.fifoovrinch2(fifoovrinch2),
		.fifoovrintopch0(fifoovrintopch0),
		.fifoovrintopch1(fifoovrintopch1),
		.fifordinbotch2(fifordinbotch2),
		.fifordinch0(fifordinch0),
		.fifordinch1(fifordinch1),
		.fifordinch2(fifordinch2),
		.fifordintopch0(fifordintopch0),
		.fifordintopch1(fifordintopch1),
		.insertincompleteinbotch2(insertincompleteinbotch2),
		.insertincompleteinch0(insertincompleteinch0),
		.insertincompleteinch1(insertincompleteinch1),
		.insertincompleteinch2(insertincompleteinch2),
		.insertincompleteintopch0(insertincompleteintopch0),
		.insertincompleteintopch1(insertincompleteintopch1),
		.latencycompinbotch2(latencycompinbotch2),
		.latencycompinch0(latencycompinch0),
		.latencycompinch1(latencycompinch1),
		.latencycompinch2(latencycompinch2),
		.latencycompintopch0(latencycompintopch0),
		.latencycompintopch1(latencycompintopch1),
		.rcvdclkch0(rcvdclkch0),
		.rcvdclkch1(rcvdclkch1),
		.rdalignbotch2(rdalignbotch2),
		.rdalignch0(rdalignch0),
		.rdalignch1(rdalignch1),
		.rdalignch2(rdalignch2),
		.rdaligntopch0(rdaligntopch0),
		.rdaligntopch1(rdaligntopch1),
		.rdenablesyncbotch2(rdenablesyncbotch2),
		.rdenablesyncch0(rdenablesyncch0),
		.rdenablesyncch1(rdenablesyncch1),
		.rdenablesyncch2(rdenablesyncch2),
		.rdenablesynctopch0(rdenablesynctopch0),
		.rdenablesynctopch1(rdenablesynctopch1),
		.refclkdig(refclkdig),
		.runningdispbotch2(runningdispbotch2),
		.runningdispch0(runningdispch0),
		.runningdispch1(runningdispch1),
		.runningdispch2(runningdispch2),
		.runningdisptopch0(runningdisptopch0),
		.runningdisptopch1(runningdisptopch1),
		.rxpcsrstn(rxpcsrstn),
		.scanmoden(scanmoden),
		.scanshiftn(scanshiftn),
		.syncstatusbotch2(syncstatusbotch2),
		.syncstatusch0(syncstatusch0),
		.syncstatusch1(syncstatusch1),
		.syncstatusch2(syncstatusch2),
		.syncstatustopch0(syncstatustopch0),
		.syncstatustopch1(syncstatustopch1),
		.txctltcbotch2(txctltcbotch2),
		.txctltcch0(txctltcch0),
		.txctltcch1(txctltcch1),
		.txctltcch2(txctltcch2),
		.txctltctopch0(txctltctopch0),
		.txctltctopch1(txctltctopch1),
		.txdatatcbotch2(txdatatcbotch2),
		.txdatatcch0(txdatatcch0),
		.txdatatcch1(txdatatcch1),
		.txdatatcch2(txdatatcch2),
		.txdatatctopch0(txdatatctopch0),
		.txdatatctopch1(txdatatctopch1),
		.txpcsrstn(txpcsrstn),
		.txpmaclk(txpmaclk),
		.aggtestbusch0(aggtestbusch0),
		.aggtestbusch1(aggtestbusch1),
		.aggtestbusch2(aggtestbusch2),
		.alignstatusbotch2(alignstatusbotch2),
		.alignstatusch0(alignstatusch0),
		.alignstatusch1(alignstatusch1),
		.alignstatusch2(alignstatusch2),
		.alignstatussync0botch2(alignstatussync0botch2),
		.alignstatussync0ch0(alignstatussync0ch0),
		.alignstatussync0ch1(alignstatussync0ch1),
		.alignstatussync0ch2(alignstatussync0ch2),
		.alignstatussync0topch0(alignstatussync0topch0),
		.alignstatussync0topch1(alignstatussync0topch1),
		.alignstatustopch0(alignstatustopch0),
		.alignstatustopch1(alignstatustopch1),
		.cgcomprddallbotch2(cgcomprddallbotch2),
		.cgcomprddallch0(cgcomprddallch0),
		.cgcomprddallch1(cgcomprddallch1),
		.cgcomprddallch2(cgcomprddallch2),
		.cgcomprddalltopch0(cgcomprddalltopch0),
		.cgcomprddalltopch1(cgcomprddalltopch1),
		.cgcompwrallbotch2(cgcompwrallbotch2),
		.cgcompwrallch0(cgcompwrallch0),
		.cgcompwrallch1(cgcompwrallch1),
		.cgcompwrallch2(cgcompwrallch2),
		.cgcompwralltopch0(cgcompwralltopch0),
		.cgcompwralltopch1(cgcompwralltopch1),
		.dedicatedaggscanoutch0tieoff(dedicatedaggscanoutch0tieoff),
		.dedicatedaggscanoutch1(dedicatedaggscanoutch1),
		.dedicatedaggscanoutch2tieoff(dedicatedaggscanoutch2tieoff),
		.delcondmet0botch2(delcondmet0botch2),
		.delcondmet0ch0(delcondmet0ch0),
		.delcondmet0ch1(delcondmet0ch1),
		.delcondmet0ch2(delcondmet0ch2),
		.delcondmet0topch0(delcondmet0topch0),
		.delcondmet0topch1(delcondmet0topch1),
		.endskwqdbotch2(endskwqdbotch2),
		.endskwqdch0(endskwqdch0),
		.endskwqdch1(endskwqdch1),
		.endskwqdch2(endskwqdch2),
		.endskwqdtopch0(endskwqdtopch0),
		.endskwqdtopch1(endskwqdtopch1),
		.endskwrdptrsbotch2(endskwrdptrsbotch2),
		.endskwrdptrsch0(endskwrdptrsch0),
		.endskwrdptrsch1(endskwrdptrsch1),
		.endskwrdptrsch2(endskwrdptrsch2),
		.endskwrdptrstopch0(endskwrdptrstopch0),
		.endskwrdptrstopch1(endskwrdptrstopch1),
		.fifoovr0botch2(fifoovr0botch2),
		.fifoovr0ch0(fifoovr0ch0),
		.fifoovr0ch1(fifoovr0ch1),
		.fifoovr0ch2(fifoovr0ch2),
		.fifoovr0topch0(fifoovr0topch0),
		.fifoovr0topch1(fifoovr0topch1),
		.fifordoutcomp0botch2(fifordoutcomp0botch2),
		.fifordoutcomp0ch0(fifordoutcomp0ch0),
		.fifordoutcomp0ch1(fifordoutcomp0ch1),
		.fifordoutcomp0ch2(fifordoutcomp0ch2),
		.fifordoutcomp0topch0(fifordoutcomp0topch0),
		.fifordoutcomp0topch1(fifordoutcomp0topch1),
		.fiforstrdqdbotch2(fiforstrdqdbotch2),
		.fiforstrdqdch0(fiforstrdqdch0),
		.fiforstrdqdch1(fiforstrdqdch1),
		.fiforstrdqdch2(fiforstrdqdch2),
		.fiforstrdqdtopch0(fiforstrdqdtopch0),
		.fiforstrdqdtopch1(fiforstrdqdtopch1),
		.insertincomplete0botch2(insertincomplete0botch2),
		.insertincomplete0ch0(insertincomplete0ch0),
		.insertincomplete0ch1(insertincomplete0ch1),
		.insertincomplete0ch2(insertincomplete0ch2),
		.insertincomplete0topch0(insertincomplete0topch0),
		.insertincomplete0topch1(insertincomplete0topch1),
		.latencycomp0botch2(latencycomp0botch2),
		.latencycomp0ch0(latencycomp0ch0),
		.latencycomp0ch1(latencycomp0ch1),
		.latencycomp0ch2(latencycomp0ch2),
		.latencycomp0topch0(latencycomp0topch0),
		.latencycomp0topch1(latencycomp0topch1),
		.rcvdclkout(rcvdclkout),
		.rcvdclkoutbot(rcvdclkoutbot),
		.rcvdclkouttop(rcvdclkouttop),
		.rxctlrsbotch2(rxctlrsbotch2),
		.rxctlrsch0(rxctlrsch0),
		.rxctlrsch1(rxctlrsch1),
		.rxctlrsch2(rxctlrsch2),
		.rxctlrstopch0(rxctlrstopch0),
		.rxctlrstopch1(rxctlrstopch1),
		.rxdatarsbotch2(rxdatarsbotch2),
		.rxdatarsch0(rxdatarsch0),
		.rxdatarsch1(rxdatarsch1),
		.rxdatarsch2(rxdatarsch2),
		.rxdatarstopch0(rxdatarstopch0),
		.rxdatarstopch1(rxdatarstopch1),
		.txctltsbotch2(txctltsbotch2),
		.txctltsch0(txctltsch0),
		.txctltsch1(txctltsch1),
		.txctltsch2(txctltsch2),
		.txctltstopch0(txctltstopch0),
		.txctltstopch1(txctltstopch1),
		.txdatatsbotch2(txdatatsbotch2),
		.txdatatsch0(txdatatsch0),
		.txdatatsch1(txdatatsch1),
		.txdatatsch2(txdatatsch2),
		.txdatatstopch0(txdatatstopch0),
		.txdatatstopch1(txdatatstopch1)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_8g_rx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_8g_rx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "gige",	//Valid values: pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter tx_rx_parallel_loopback = "dis_plpbk",	//Valid values: dis_plpbk|en_plpbk
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter polarity_inversion = "dis_pol_inv",	//Valid values: dis_pol_inv|en_pol_inv
	parameter wa_pd = "wa_pd_10",	//Valid values: dont_care_wa_pd_0|dont_care_wa_pd_1|wa_pd_7|wa_pd_10|wa_pd_20|wa_pd_40|wa_pd_8_sw|wa_pd_8_dw|wa_pd_16_sw|wa_pd_16_dw|wa_pd_32|wa_pd_fixed_7_k28p5|wa_pd_fixed_10_k28p5|wa_pd_fixed_16_a1a2_sw|wa_pd_fixed_16_a1a2_dw|wa_pd_fixed_32_a1a1a2a2|prbs15_fixed_wa_pd_16_sw|prbs15_fixed_wa_pd_16_dw|prbs15_fixed_wa_pd_20_dw|prbs31_fixed_wa_pd_16_sw|prbs31_fixed_wa_pd_16_dw|prbs31_fixed_wa_pd_10_sw|prbs31_fixed_wa_pd_40_dw|prbs8_fixed_wa|prbs10_fixed_wa|prbs7_fixed_wa_pd_16_sw|prbs7_fixed_wa_pd_16_dw|prbs7_fixed_wa_pd_20_dw|prbs23_fixed_wa_pd_16_sw|prbs23_fixed_wa_pd_32_dw|prbs23_fixed_wa_pd_40_dw
	parameter [ 39:0 ] wa_pd_data = 40'b0,	//Valid values: 40
	parameter wa_boundary_lock_ctrl = "bit_slip",	//Valid values: bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
	parameter wa_pld_controlled = "dis_pld_ctrl",	//Valid values: dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw
	parameter wa_sync_sm_ctrl = "gige_sync_sm",	//Valid values: gige_sync_sm|pipe_sync_sm|xaui_sync_sm|srio1p3_sync_sm|srio2p1_sync_sm|sw_basic_sync_sm|dw_basic_sync_sm|fibre_channel_sync_sm
	parameter [ 7:0 ] wa_rknumber_data = 8'b0,	//Valid values: 8
	parameter [ 5:0 ] wa_renumber_data = 6'b0,	//Valid values: 6
	parameter [ 7:0 ] wa_rgnumber_data = 8'b0,	//Valid values: 8
	parameter [ 1:0 ] wa_rosnumber_data = 2'b0,	//Valid values: 2
	parameter wa_kchar = "dis_kchar",	//Valid values: dis_kchar|en_kchar
	parameter wa_det_latency_sync_status_beh = "assert_sync_status_non_imm",	//Valid values: assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
	parameter wa_clk_slip_spacing = "min_clk_slip_spacing",	//Valid values: min_clk_slip_spacing|user_programmable_clk_slip_spacing
	parameter [ 9:0 ] wa_clk_slip_spacing_data = 10'b10000,	//Valid values: 10
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter [ 9:0 ] deskew_pattern = 10'b1101101000,	//Valid values: 10
	parameter deskew_prog_pattern_only = "en_deskew_prog_pat_only",	//Valid values: dis_deskew_prog_pat_only|en_deskew_prog_pat_only
	parameter rate_match = "dis_rm",	//Valid values: dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
	parameter eightb_tenb_decoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter err_flags_sel = "err_flags_wa",	//Valid values: err_flags_wa|err_flags_8b10b
	parameter polinv_8b10b_dec = "dis_polinv_8b10b_dec",	//Valid values: dis_polinv_8b10b_dec|en_polinv_8b10b_dec
	parameter eightbtenb_decoder_output_sel = "data_8b10b_decoder",	//Valid values: data_8b10b_decoder|data_xaui_sm
	parameter invalid_code_flag_only = "dis_invalid_code_only",	//Valid values: dis_invalid_code_only|en_invalid_code_only
	parameter auto_error_replacement = "dis_err_replace",	//Valid values: dis_err_replace|en_err_replace
	parameter pad_or_edb_error_replace = "replace_edb",	//Valid values: replace_edb|replace_pad|replace_edb_dynamic
	parameter byte_deserializer = "dis_bds",	//Valid values: dis_bds|en_bds_by_2|en_bds_by_2_det
	parameter byte_order = "dis_bo",	//Valid values: dis_bo|en_pcs_ctrl_eight_bit_bo|en_pcs_ctrl_nine_bit_bo|en_pcs_ctrl_ten_bit_bo|en_pld_ctrl_eight_bit_bo|en_pld_ctrl_nine_bit_bo|en_pld_ctrl_ten_bit_bo
	parameter re_bo_on_wa = "dis_re_bo_on_wa",	//Valid values: dis_re_bo_on_wa|en_re_bo_on_wa
	parameter [ 19:0 ] bo_pattern = 20'b0,	//Valid values: 20
	parameter [ 9:0 ] bo_pad = 10'b0,	//Valid values: 10
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter prbs_ver = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter [ 7:0 ] cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_ver = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter cdr_ctrl = "dis_cdr_ctrl",	//Valid values: dis_cdr_ctrl|en_cdr_ctrl|en_cdr_ctrl_w_cid
	parameter cdr_ctrl_rxvalid_mask = "dis_rxvalid_mask",	//Valid values: dis_rxvalid_mask|en_rxvalid_mask
	parameter [ 7:0 ] wait_cnt = 8'b0,	//Valid values: 8
	parameter [ 9:0 ] mask_cnt = 10'h3ff,	//Valid values: 10
	parameter eidle_entry_sd = "dis_eidle_sd",	//Valid values: dis_eidle_sd|en_eidle_sd
	parameter eidle_entry_eios = "dis_eidle_eios",	//Valid values: dis_eidle_eios|en_eidle_eios
	parameter eidle_entry_iei = "dis_eidle_iei",	//Valid values: dis_eidle_iei|en_eidle_iei
	parameter rx_rcvd_clk = "rcvd_clk_rcvd_clk",	//Valid values: rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
	parameter rx_clk1 = "rcvd_clk_clk1",	//Valid values: rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|rcvd_clk_agg_top_or_bottom_clk1
	parameter rx_clk2 = "rcvd_clk_clk2",	//Valid values: rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2
	parameter rx_rd_clk = "pld_rx_clk",	//Valid values: pld_rx_clk|rx_clk
	parameter dw_one_or_two_symbol_bo = "donot_care_one_two_bo",	//Valid values: donot_care_one_two_bo|one_symbol_bo|two_symbol_bo_eight_bit|two_symbol_bo_nine_bit|two_symbol_bo_ten_bit
	parameter comp_fifo_rst_pld_ctrl = "dis_comp_fifo_rst_pld_ctrl",	//Valid values: dis_comp_fifo_rst_pld_ctrl|en_comp_fifo_rst_pld_ctrl
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter test_bus_sel = "prbs_bist_testbus",	//Valid values: prbs_bist_testbus|tx_testbus|tx_ctrl_plane_testbus|wa_testbus|deskew_testbus|rm_testbus|rx_ctrl_testbus|pcie_ctrl_testbus|rx_ctrl_plane_testbus|agg_testbus
	parameter [ 12:0 ] wa_rvnumber_data = 13'b0,	//Valid values: 13
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter prbs_ver_clr_flag = "dis_prbs_clr_flag",	//Valid values: dis_prbs_clr_flag|en_prbs_clr_flag
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter [ 17:0 ] pma_done_count = 18'b0,	//Valid values: 18
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter bist_ver_clr_flag = "dis_bist_clr_flag",	//Valid values: dis_bist_clr_flag|en_bist_clr_flag
	parameter wa_disp_err_flag = "dis_disp_err_flag",	//Valid values: dis_disp_err_flag|en_disp_err_flag
	parameter runlength_check = "en_runlength_sw",	//Valid values: dis_runlength|en_runlength_sw|en_runlength_dw
	parameter [ 5:0 ] runlength_val = 6'b0,	//Valid values: 6
	parameter force_signal_detect = "en_force_signal_detect",	//Valid values: en_force_signal_detect|dis_force_signal_detect
	parameter deskew = "dis_deskew",	//Valid values: dis_deskew|en_srio_v2p1|en_xaui
	parameter rx_wr_clk = "rx_clk2_div_1_2_4",	//Valid values: rx_clk2_div_1_2_4|txfifo_rd_clk
	parameter rx_clk_free_running = "en_rx_clk_free_run",	//Valid values: dis_rx_clk_free_run|en_rx_clk_free_run
	parameter rx_pcs_urst = "en_rx_pcs_urst",	//Valid values: dis_rx_pcs_urst|en_rx_pcs_urst
	parameter pipe_if_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx
	parameter pc_fifo_rst_pld_ctrl = "dis_pc_fifo_rst_pld_ctrl",	//Valid values: dis_pc_fifo_rst_pld_ctrl|en_pc_fifo_rst_pld_ctrl
	parameter ibm_invalid_code = "dis_ibm_invalid_code",	//Valid values: dis_ibm_invalid_code|en_ibm_invalid_code
	parameter channel_number = 0,	//Valid values: 0..65
	parameter rx_refclk = "dis_refclk_sel",	//Valid values: dis_refclk_sel|en_refclk_sel
	parameter clock_gate_dw_rm_wr = "dis_dw_rm_wrclk_gating",	//Valid values: dis_dw_rm_wrclk_gating|en_dw_rm_wrclk_gating
	parameter clock_gate_bds_dec_asn = "dis_bds_dec_asn_clk_gating",	//Valid values: dis_bds_dec_asn_clk_gating|en_bds_dec_asn_clk_gating
	parameter fixed_pat_det = "dis_fixed_patdet",	//Valid values: dis_fixed_patdet|en_fixed_patdet
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_cdr_eidle = "dis_cdr_eidle_clk_gating",	//Valid values: dis_cdr_eidle_clk_gating|en_cdr_eidle_clk_gating
	parameter [ 19:0 ] clkcmp_pattern_p = 20'b0,	//Valid values: 20
	parameter [ 19:0 ] clkcmp_pattern_n = 20'b0,	//Valid values: 20
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter clock_gate_pc_rdclk = "dis_pc_rdclk_gating",	//Valid values: dis_pc_rdclk_gating|en_pc_rdclk_gating
	parameter wa_pd_polarity = "dis_pd_both_pol",	//Valid values: dis_pd_both_pol|en_pd_both_pol|dont_care_both_pol
	parameter clock_gate_dskw_rd = "dis_dskw_rdclk_gating",	//Valid values: dis_dskw_rdclk_gating|en_dskw_rdclk_gating
	parameter clock_gate_byteorder = "dis_byteorder_clk_gating",	//Valid values: dis_byteorder_clk_gating|en_byteorder_clk_gating
	parameter clock_gate_dw_pc_wrclk = "dis_dw_pc_wrclk_gating",	//Valid values: dis_dw_pc_wrclk_gating|en_dw_pc_wrclk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter clock_gate_sw_wa = "dis_sw_wa_clk_gating",	//Valid values: dis_sw_wa_clk_gating|en_sw_wa_clk_gating
	parameter clock_gate_dw_dskw_wr = "dis_dw_dskw_wrclk_gating",	//Valid values: dis_dw_dskw_wrclk_gating|en_dw_dskw_wrclk_gating
	parameter clock_gate_sw_pc_wrclk = "dis_sw_pc_wrclk_gating",	//Valid values: dis_sw_pc_wrclk_gating|en_sw_pc_wrclk_gating
	parameter clock_gate_sw_rm_rd = "dis_sw_rm_rdclk_gating",	//Valid values: dis_sw_rm_rdclk_gating|en_sw_rm_rdclk_gating
	parameter clock_gate_sw_rm_wr = "dis_sw_rm_wrclk_gating",	//Valid values: dis_sw_rm_wrclk_gating|en_sw_rm_wrclk_gating
	parameter auto_speed_nego = "dis_asn",	//Valid values: dis_asn|en_asn_g2_freq_scal
	parameter [ 3:0 ] fixed_pat_num = 4'b1111,	//Valid values: 4
	parameter clock_gate_sw_dskw_wr = "dis_sw_dskw_wrclk_gating",	//Valid values: dis_sw_dskw_wrclk_gating|en_sw_dskw_wrclk_gating
	parameter clock_gate_dw_rm_rd = "dis_dw_rm_rdclk_gating",	//Valid values: dis_dw_rm_rdclk_gating|en_dw_rm_rdclk_gating
	parameter clock_gate_dw_wa = "dis_dw_wa_clk_gating",	//Valid values: dis_dw_wa_clk_gating|en_dw_wa_clk_gating
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] a1a2size,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] alignstatus,
	input [ 0:0 ] alignstatussync0,
	input [ 0:0 ] alignstatussync0toporbot,
	input [ 0:0 ] alignstatustoporbot,
	input [ 0:0 ] bitreversalenable,
	input [ 0:0 ] bitslip,
	input [ 0:0 ] bytereversalenable,
	input [ 0:0 ] byteorder,
	input [ 0:0 ] cgcomprddall,
	input [ 0:0 ] cgcomprddalltoporbot,
	input [ 0:0 ] cgcompwrall,
	input [ 0:0 ] cgcompwralltoporbot,
	input [ 0:0 ] rmfifouserrst,
	input [ 0:0 ] configselinchnldown,
	input [ 0:0 ] configselinchnlup,
	input [ 0:0 ] delcondmet0,
	input [ 0:0 ] delcondmet0toporbot,
	input [ 0:0 ] dynclkswitchn,
	input [ 2:0 ] eidleinfersel,
	input [ 0:0 ] endskwqd,
	input [ 0:0 ] endskwqdtoporbot,
	input [ 0:0 ] endskwrdptrs,
	input [ 0:0 ] endskwrdptrstoporbot,
	input [ 0:0 ] enablecommadetect,
	input [ 0:0 ] fifoovr0,
	input [ 0:0 ] fifoovr0toporbot,
	input [ 0:0 ] rmfifordincomp0,
	input [ 0:0 ] fifordincomp0toporbot,
	input [ 0:0 ] fiforstrdqd,
	input [ 0:0 ] fiforstrdqdtoporbot,
	input [ 0:0 ] gen2ngen1,
	input [ 0:0 ] hrdrst,
	input [ 0:0 ] insertincomplete0,
	input [ 0:0 ] insertincomplete0toporbot,
	input [ 0:0 ] latencycomp0,
	input [ 0:0 ] latencycomp0toporbot,
	input [ 0:0 ] phfifouserrst,
	input [ 0:0 ] phystatusinternal,
	input [ 0:0 ] phystatuspcsgen3,
	input [ 0:0 ] pipeloopbk,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] pldrxclk,
	input [ 0:0 ] polinvrx,
	input [ 0:0 ] prbscidenable,
	input [ 19:0 ] datain,
	input [ 0:0 ] rateswitchcontrol,
	input [ 0:0 ] rcvdclkagg,
	input [ 0:0 ] rcvdclkaggtoporbot,
	input [ 0:0 ] rcvdclkpma,
	input [ 0:0 ] rdenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] rmfiforeadenable,
	input [ 0:0 ] pcfifordenable,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] refclkdig2,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 0:0 ] resetppmcntrsinchnldown,
	input [ 0:0 ] resetppmcntrsinchnlup,
	input [ 0:0 ] ctrlfromaggblock,
	input [ 0:0 ] rxcontrolrstoporbot,
	input [ 7:0 ] datafrinaggblock,
	input [ 7:0 ] rxdatarstoporbot,
	input [ 1:0 ] rxdivsyncinchnldown,
	input [ 1:0 ] rxdivsyncinchnlup,
	input [ 1:0 ] rxsynchdrpcsgen3,
	input [ 1:0 ] rxweinchnldown,
	input [ 1:0 ] rxweinchnlup,
	input [ 2:0 ] rxstatusinternal,
	input [ 0:0 ] rxpcsrst,
	input [ 0:0 ] rxvalidinternal,
	input [ 0:0 ] scanmode,
	input [ 0:0 ] sigdetfrompma,
	input [ 0:0 ] speedchangeinchnldown,
	input [ 0:0 ] speedchangeinchnlup,
	input [ 0:0 ] syncsmen,
	input [ 19:0 ] txctrlplanetestbus,
	input [ 1:0 ] txdivsync,
	input [ 0:0 ] txpmaclk,
	input [ 19:0 ] txtestbus,
	input [ 19:0 ] parallelloopback,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] pxfifowrdisable,
	input [ 0:0 ] rmfifowriteenable,
	output [ 3:0 ] a1a2k1k2flag,
	output [ 0:0 ] aggrxpcsrst,
	output [ 1:0 ] aligndetsync,
	output [ 0:0 ] alignstatuspld,
	output [ 0:0 ] alignstatussync,
	output [ 0:0 ] rmfifopartialfull,
	output [ 0:0 ] rmfifopartialempty,
	output [ 0:0 ] bistdone,
	output [ 0:0 ] bisterr,
	output [ 0:0 ] byteordflag,
	output [ 1:0 ] cgcomprddout,
	output [ 1:0 ] cgcompwrout,
	output [ 19:0 ] channeltestbusout,
	output [ 0:0 ] configseloutchnldown,
	output [ 0:0 ] configseloutchnlup,
	output [ 0:0 ] decoderctrl,
	output [ 7:0 ] decoderdata,
	output [ 0:0 ] decoderdatavalid,
	output [ 0:0 ] delcondmetout,
	output [ 0:0 ] disablepcfifobyteserdes,
	output [ 0:0 ] earlyeios,
	output [ 0:0 ] eidleexit,
	output [ 0:0 ] rmfifoempty,
	output [ 0:0 ] pcfifoempty,
	output [ 1:0 ] errctrl,
	output [ 15:0 ] errdata,
	output [ 0:0 ] fifoovrout,
	output [ 0:0 ] fifordoutcomp,
	output [ 0:0 ] rmfifofull,
	output [ 0:0 ] pcfifofull,
	output [ 0:0 ] insertincompleteout,
	output [ 0:0 ] latencycompout,
	output [ 0:0 ] ltr,
	output [ 0:0 ] pcieswitch,
	output [ 0:0 ] phystatus,
	output [ 63:0 ] pipedata,
	output [ 0:0 ] prbsdone,
	output [ 0:0 ] prbserrlt,
	output [ 1:0 ] rdalign,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] resetpcptrs,
	output [ 0:0 ] resetpcptrsinchnldownpipe,
	output [ 0:0 ] resetpcptrsinchnluppipe,
	output [ 0:0 ] resetpcptrsoutchnldown,
	output [ 0:0 ] resetpcptrsoutchnlup,
	output [ 0:0 ] resetppmcntrsoutchnldown,
	output [ 0:0 ] resetppmcntrsoutchnlup,
	output [ 0:0 ] resetppmcntrspcspma,
	output [ 19:0 ] parallelrevloopback,
	output [ 0:0 ] runlengthviolation,
	output [ 0:0 ] rlvlt,
	output [ 1:0 ] runningdisparity,
	output [ 3:0 ] rxblkstart,
	output [ 0:0 ] clocktopld,
	output [ 0:0 ] rxclkslip,
	output [ 3:0 ] rxdatavalid,
	output [ 1:0 ] rxdivsyncoutchnldown,
	output [ 1:0 ] rxdivsyncoutchnlup,
	output [ 0:0 ] rxpipeclk,
	output [ 0:0 ] rxpipesoftreset,
	output [ 1:0 ] rxsynchdr,
	output [ 1:0 ] rxweoutchnldown,
	output [ 1:0 ] rxweoutchnlup,
	output [ 63:0 ] dataout,
	output [ 0:0 ] eidledetected,
	output [ 2:0 ] rxstatus,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] selftestdone,
	output [ 0:0 ] selftesterr,
	output [ 0:0 ] signaldetectout,
	output [ 0:0 ] speedchange,
	output [ 0:0 ] speedchangeinchnldownpipe,
	output [ 0:0 ] speedchangeinchnluppipe,
	output [ 0:0 ] speedchangeoutchnldown,
	output [ 0:0 ] speedchangeoutchnlup,
	output [ 0:0 ] syncstatus,
	output [ 4:0 ] wordalignboundary,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_8g_rx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.tx_rx_parallel_loopback(tx_rx_parallel_loopback),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.polarity_inversion(polarity_inversion),
		.wa_pd(wa_pd),
		.wa_pd_data(wa_pd_data),
		.wa_boundary_lock_ctrl(wa_boundary_lock_ctrl),
		.wa_pld_controlled(wa_pld_controlled),
		.wa_sync_sm_ctrl(wa_sync_sm_ctrl),
		.wa_rknumber_data(wa_rknumber_data),
		.wa_renumber_data(wa_renumber_data),
		.wa_rgnumber_data(wa_rgnumber_data),
		.wa_rosnumber_data(wa_rosnumber_data),
		.wa_kchar(wa_kchar),
		.wa_det_latency_sync_status_beh(wa_det_latency_sync_status_beh),
		.wa_clk_slip_spacing(wa_clk_slip_spacing),
		.wa_clk_slip_spacing_data(wa_clk_slip_spacing_data),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.deskew_pattern(deskew_pattern),
		.deskew_prog_pattern_only(deskew_prog_pattern_only),
		.rate_match(rate_match),
		.eightb_tenb_decoder(eightb_tenb_decoder),
		.err_flags_sel(err_flags_sel),
		.polinv_8b10b_dec(polinv_8b10b_dec),
		.eightbtenb_decoder_output_sel(eightbtenb_decoder_output_sel),
		.invalid_code_flag_only(invalid_code_flag_only),
		.auto_error_replacement(auto_error_replacement),
		.pad_or_edb_error_replace(pad_or_edb_error_replace),
		.byte_deserializer(byte_deserializer),
		.byte_order(byte_order),
		.re_bo_on_wa(re_bo_on_wa),
		.bo_pattern(bo_pattern),
		.bo_pad(bo_pad),
		.phase_compensation_fifo(phase_compensation_fifo),
		.prbs_ver(prbs_ver),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_ver(bist_ver),
		.cdr_ctrl(cdr_ctrl),
		.cdr_ctrl_rxvalid_mask(cdr_ctrl_rxvalid_mask),
		.wait_cnt(wait_cnt),
		.mask_cnt(mask_cnt),
		.eidle_entry_sd(eidle_entry_sd),
		.eidle_entry_eios(eidle_entry_eios),
		.eidle_entry_iei(eidle_entry_iei),
		.rx_rcvd_clk(rx_rcvd_clk),
		.rx_clk1(rx_clk1),
		.rx_clk2(rx_clk2),
		.rx_rd_clk(rx_rd_clk),
		.dw_one_or_two_symbol_bo(dw_one_or_two_symbol_bo),
		.comp_fifo_rst_pld_ctrl(comp_fifo_rst_pld_ctrl),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.agg_block_sel(agg_block_sel),
		.test_bus_sel(test_bus_sel),
		.wa_rvnumber_data(wa_rvnumber_data),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.prbs_ver_clr_flag(prbs_ver_clr_flag),
		.hip_mode(hip_mode),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.pma_done_count(pma_done_count),
		.test_mode(test_mode),
		.bist_ver_clr_flag(bist_ver_clr_flag),
		.wa_disp_err_flag(wa_disp_err_flag),
		.runlength_check(runlength_check),
		.runlength_val(runlength_val),
		.force_signal_detect(force_signal_detect),
		.deskew(deskew),
		.rx_wr_clk(rx_wr_clk),
		.rx_clk_free_running(rx_clk_free_running),
		.rx_pcs_urst(rx_pcs_urst),
		.pipe_if_enable(pipe_if_enable),
		.pc_fifo_rst_pld_ctrl(pc_fifo_rst_pld_ctrl),
		.ibm_invalid_code(ibm_invalid_code),
		.channel_number(channel_number),
		.rx_refclk(rx_refclk),
		.clock_gate_dw_rm_wr(clock_gate_dw_rm_wr),
		.clock_gate_bds_dec_asn(clock_gate_bds_dec_asn),
		.fixed_pat_det(fixed_pat_det),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_cdr_eidle(clock_gate_cdr_eidle),
		.clkcmp_pattern_p(clkcmp_pattern_p),
		.clkcmp_pattern_n(clkcmp_pattern_n),
		.clock_gate_prbs(clock_gate_prbs),
		.clock_gate_pc_rdclk(clock_gate_pc_rdclk),
		.wa_pd_polarity(wa_pd_polarity),
		.clock_gate_dskw_rd(clock_gate_dskw_rd),
		.clock_gate_byteorder(clock_gate_byteorder),
		.clock_gate_dw_pc_wrclk(clock_gate_dw_pc_wrclk),
		.sup_mode(sup_mode),
		.clock_gate_sw_wa(clock_gate_sw_wa),
		.clock_gate_dw_dskw_wr(clock_gate_dw_dskw_wr),
		.clock_gate_sw_pc_wrclk(clock_gate_sw_pc_wrclk),
		.clock_gate_sw_rm_rd(clock_gate_sw_rm_rd),
		.clock_gate_sw_rm_wr(clock_gate_sw_rm_wr),
		.auto_speed_nego(auto_speed_nego),
		.fixed_pat_num(fixed_pat_num),
		.clock_gate_sw_dskw_wr(clock_gate_sw_dskw_wr),
		.clock_gate_dw_rm_rd(clock_gate_dw_rm_rd),
		.clock_gate_dw_wa(clock_gate_dw_wa),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_rx_pcs_encrypted_inst	(
		.a1a2size(a1a2size),
		.aggtestbus(aggtestbus),
		.alignstatus(alignstatus),
		.alignstatussync0(alignstatussync0),
		.alignstatussync0toporbot(alignstatussync0toporbot),
		.alignstatustoporbot(alignstatustoporbot),
		.bitreversalenable(bitreversalenable),
		.bitslip(bitslip),
		.bytereversalenable(bytereversalenable),
		.byteorder(byteorder),
		.cgcomprddall(cgcomprddall),
		.cgcomprddalltoporbot(cgcomprddalltoporbot),
		.cgcompwrall(cgcompwrall),
		.cgcompwralltoporbot(cgcompwralltoporbot),
		.rmfifouserrst(rmfifouserrst),
		.configselinchnldown(configselinchnldown),
		.configselinchnlup(configselinchnlup),
		.delcondmet0(delcondmet0),
		.delcondmet0toporbot(delcondmet0toporbot),
		.dynclkswitchn(dynclkswitchn),
		.eidleinfersel(eidleinfersel),
		.endskwqd(endskwqd),
		.endskwqdtoporbot(endskwqdtoporbot),
		.endskwrdptrs(endskwrdptrs),
		.endskwrdptrstoporbot(endskwrdptrstoporbot),
		.enablecommadetect(enablecommadetect),
		.fifoovr0(fifoovr0),
		.fifoovr0toporbot(fifoovr0toporbot),
		.rmfifordincomp0(rmfifordincomp0),
		.fifordincomp0toporbot(fifordincomp0toporbot),
		.fiforstrdqd(fiforstrdqd),
		.fiforstrdqdtoporbot(fiforstrdqdtoporbot),
		.gen2ngen1(gen2ngen1),
		.hrdrst(hrdrst),
		.insertincomplete0(insertincomplete0),
		.insertincomplete0toporbot(insertincomplete0toporbot),
		.latencycomp0(latencycomp0),
		.latencycomp0toporbot(latencycomp0toporbot),
		.phfifouserrst(phfifouserrst),
		.phystatusinternal(phystatusinternal),
		.phystatuspcsgen3(phystatuspcsgen3),
		.pipeloopbk(pipeloopbk),
		.pldltr(pldltr),
		.pldrxclk(pldrxclk),
		.polinvrx(polinvrx),
		.prbscidenable(prbscidenable),
		.datain(datain),
		.rateswitchcontrol(rateswitchcontrol),
		.rcvdclkagg(rcvdclkagg),
		.rcvdclkaggtoporbot(rcvdclkaggtoporbot),
		.rcvdclkpma(rcvdclkpma),
		.rdenableinchnldown(rdenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.rmfiforeadenable(rmfiforeadenable),
		.pcfifordenable(pcfifordenable),
		.refclkdig(refclkdig),
		.refclkdig2(refclkdig2),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.resetppmcntrsinchnldown(resetppmcntrsinchnldown),
		.resetppmcntrsinchnlup(resetppmcntrsinchnlup),
		.ctrlfromaggblock(ctrlfromaggblock),
		.rxcontrolrstoporbot(rxcontrolrstoporbot),
		.datafrinaggblock(datafrinaggblock),
		.rxdatarstoporbot(rxdatarstoporbot),
		.rxdivsyncinchnldown(rxdivsyncinchnldown),
		.rxdivsyncinchnlup(rxdivsyncinchnlup),
		.rxsynchdrpcsgen3(rxsynchdrpcsgen3),
		.rxweinchnldown(rxweinchnldown),
		.rxweinchnlup(rxweinchnlup),
		.rxstatusinternal(rxstatusinternal),
		.rxpcsrst(rxpcsrst),
		.rxvalidinternal(rxvalidinternal),
		.scanmode(scanmode),
		.sigdetfrompma(sigdetfrompma),
		.speedchangeinchnldown(speedchangeinchnldown),
		.speedchangeinchnlup(speedchangeinchnlup),
		.syncsmen(syncsmen),
		.txctrlplanetestbus(txctrlplanetestbus),
		.txdivsync(txdivsync),
		.txpmaclk(txpmaclk),
		.txtestbus(txtestbus),
		.parallelloopback(parallelloopback),
		.wrenableinchnldown(wrenableinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.pxfifowrdisable(pxfifowrdisable),
		.rmfifowriteenable(rmfifowriteenable),
		.a1a2k1k2flag(a1a2k1k2flag),
		.aggrxpcsrst(aggrxpcsrst),
		.aligndetsync(aligndetsync),
		.alignstatuspld(alignstatuspld),
		.alignstatussync(alignstatussync),
		.rmfifopartialfull(rmfifopartialfull),
		.rmfifopartialempty(rmfifopartialempty),
		.bistdone(bistdone),
		.bisterr(bisterr),
		.byteordflag(byteordflag),
		.cgcomprddout(cgcomprddout),
		.cgcompwrout(cgcompwrout),
		.channeltestbusout(channeltestbusout),
		.configseloutchnldown(configseloutchnldown),
		.configseloutchnlup(configseloutchnlup),
		.decoderctrl(decoderctrl),
		.decoderdata(decoderdata),
		.decoderdatavalid(decoderdatavalid),
		.delcondmetout(delcondmetout),
		.disablepcfifobyteserdes(disablepcfifobyteserdes),
		.earlyeios(earlyeios),
		.eidleexit(eidleexit),
		.rmfifoempty(rmfifoempty),
		.pcfifoempty(pcfifoempty),
		.errctrl(errctrl),
		.errdata(errdata),
		.fifoovrout(fifoovrout),
		.fifordoutcomp(fifordoutcomp),
		.rmfifofull(rmfifofull),
		.pcfifofull(pcfifofull),
		.insertincompleteout(insertincompleteout),
		.latencycompout(latencycompout),
		.ltr(ltr),
		.pcieswitch(pcieswitch),
		.phystatus(phystatus),
		.pipedata(pipedata),
		.prbsdone(prbsdone),
		.prbserrlt(prbserrlt),
		.rdalign(rdalign),
		.rdenableoutchnldown(rdenableoutchnldown),
		.rdenableoutchnlup(rdenableoutchnlup),
		.resetpcptrs(resetpcptrs),
		.resetpcptrsinchnldownpipe(resetpcptrsinchnldownpipe),
		.resetpcptrsinchnluppipe(resetpcptrsinchnluppipe),
		.resetpcptrsoutchnldown(resetpcptrsoutchnldown),
		.resetpcptrsoutchnlup(resetpcptrsoutchnlup),
		.resetppmcntrsoutchnldown(resetppmcntrsoutchnldown),
		.resetppmcntrsoutchnlup(resetppmcntrsoutchnlup),
		.resetppmcntrspcspma(resetppmcntrspcspma),
		.parallelrevloopback(parallelrevloopback),
		.runlengthviolation(runlengthviolation),
		.rlvlt(rlvlt),
		.runningdisparity(runningdisparity),
		.rxblkstart(rxblkstart),
		.clocktopld(clocktopld),
		.rxclkslip(rxclkslip),
		.rxdatavalid(rxdatavalid),
		.rxdivsyncoutchnldown(rxdivsyncoutchnldown),
		.rxdivsyncoutchnlup(rxdivsyncoutchnlup),
		.rxpipeclk(rxpipeclk),
		.rxpipesoftreset(rxpipesoftreset),
		.rxsynchdr(rxsynchdr),
		.rxweoutchnldown(rxweoutchnldown),
		.rxweoutchnlup(rxweoutchnlup),
		.dataout(dataout),
		.eidledetected(eidledetected),
		.rxstatus(rxstatus),
		.rxvalid(rxvalid),
		.selftestdone(selftestdone),
		.selftesterr(selftesterr),
		.signaldetectout(signaldetectout),
		.speedchange(speedchange),
		.speedchangeinchnldownpipe(speedchangeinchnldownpipe),
		.speedchangeinchnluppipe(speedchangeinchnluppipe),
		.speedchangeoutchnldown(speedchangeoutchnldown),
		.speedchangeoutchnlup(speedchangeoutchnlup),
		.syncstatus(syncstatus),
		.wordalignboundary(wordalignboundary),
		.wrenableoutchnldown(wrenableoutchnldown),
		.wrenableoutchnlup(wrenableoutchnlup),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_8g_tx_pcs_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_8g_tx_pcs
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "basic",	//Valid values: pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter pma_dw = "eight_bit",	//Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter pcs_bypass = "dis_pcs_bypass",	//Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter phase_compensation_fifo = "low_latency",	//Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter tx_compliance_controlled_disparity = "dis_txcompliance",	//Valid values: dis_txcompliance|en_txcompliance_pipe2p0
	parameter force_kchar = "dis_force_kchar",	//Valid values: dis_force_kchar|en_force_kchar
	parameter force_echar = "dis_force_echar",	//Valid values: dis_force_echar|en_force_echar
	parameter byte_serializer = "dis_bs",	//Valid values: dis_bs|en_bs_by_2
	parameter data_selection_8b10b_encoder_input = "normal_data_path",	//Valid values: normal_data_path|xaui_sm|gige_idle_conversion
	parameter eightb_tenb_disp_ctrl = "dis_disp_ctrl",	//Valid values: dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
	parameter eightb_tenb_encoder = "dis_8b10b",	//Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter prbs_gen = "dis_prbs",	//Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter cid_pattern = "cid_pattern_0",	//Valid values: cid_pattern_0|cid_pattern_1
	parameter [ 7:0 ] cid_pattern_len = 8'b0,	//Valid values: 8
	parameter bist_gen = "dis_bist",	//Valid values: dis_bist|incremental|cjpat|crpat
	parameter bit_reversal = "dis_bit_reversal",	//Valid values: dis_bit_reversal|en_bit_reversal
	parameter symbol_swap = "dis_symbol_swap",	//Valid values: dis_symbol_swap|en_symbol_swap
	parameter polarity_inversion = "dis_polinv",	//Valid values: dis_polinv|enable_polinv
	parameter tx_bitslip = "dis_tx_bitslip",	//Valid values: dis_tx_bitslip|en_tx_bitslip
	parameter agg_block_sel = "same_smrt_pack",	//Valid values: same_smrt_pack|other_smrt_pack
	parameter revloop_back_rm = "dis_rev_loopback_rx_rm",	//Valid values: dis_rev_loopback_rx_rm|en_rev_loopback_rx_rm
	parameter phfifo_write_clk_sel = "pld_tx_clk",	//Valid values: pld_tx_clk|tx_clk
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",	//Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",	//Valid values: master_chnl_distr|not_master_chnl_distr
	parameter test_mode = "prbs",	//Valid values: dont_care_test|prbs|bist
	parameter ctrl_plane_bonding_compensation = "dis_compensation",	//Valid values: dis_compensation|en_compensation
	parameter refclk_b_clk_sel = "tx_pma_clock",	//Valid values: tx_pma_clock|refclk_dig
	parameter auto_speed_nego_gen2 = "dis_asn_g2",	//Valid values: dis_asn_g2|en_asn_g2_freq_scal
	parameter txpcs_urst = "en_txpcs_urst",	//Valid values: dis_txpcs_urst|en_txpcs_urst
	parameter clock_gate_dw_fifowr = "dis_dw_fifowr_clk_gating",	//Valid values: dis_dw_fifowr_clk_gating|en_dw_fifowr_clk_gating
	parameter clock_gate_prbs = "dis_prbs_clk_gating",	//Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter txclk_freerun = "dis_freerun_tx",	//Valid values: dis_freerun_tx|en_freerun_tx
	parameter clock_gate_bs_enc = "dis_bs_enc_clk_gating",	//Valid values: dis_bs_enc_clk_gating|en_bs_enc_clk_gating
	parameter clock_gate_bist = "dis_bist_clk_gating",	//Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_fiford = "dis_fiford_clk_gating",	//Valid values: dis_fiford_clk_gating|en_fiford_clk_gating
	parameter pcfifo_urst = "dis_pcfifourst",	//Valid values: dis_pcfifourst|en_pcfifourst
	parameter clock_gate_sw_fifowr = "dis_sw_fifowr_clk_gating",	//Valid values: dis_sw_fifowr_clk_gating|en_sw_fifowr_clk_gating
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter dynamic_clk_switch = "dis_dyn_clk_switch",	//Valid values: dis_dyn_clk_switch|en_dyn_clk_switch
	parameter channel_number = 0,	//Valid values: 0..65
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] dispcbyte,
	input [ 2:0 ] elecidleinfersel,
	input [ 1:0 ] fifoselectinchnldown,
	input [ 1:0 ] fifoselectinchnlup,
	input [ 0:0 ] rateswitch,
	input [ 0:0 ] hrdrst,
	input [ 0:0 ] pipetxdeemph,
	input [ 2:0 ] pipetxmargin,
	input [ 0:0 ] phfiforeset,
	input [ 0:0 ] coreclk,
	input [ 0:0 ] polinvrxin,
	input [ 0:0 ] invpol,
	input [ 1:0 ] powerdn,
	input [ 0:0 ] prbscidenable,
	input [ 0:0 ] rdenableinchnldown,
	input [ 0:0 ] rdenableinchnlup,
	input [ 0:0 ] phfiforddisable,
	input [ 0:0 ] refclkdig,
	input [ 0:0 ] resetpcptrs,
	input [ 0:0 ] resetpcptrsinchnldown,
	input [ 0:0 ] resetpcptrsinchnlup,
	input [ 19:0 ] revparallellpbkdata,
	input [ 0:0 ] enrevparallellpbk,
	input [ 0:0 ] pipeenrevparallellpbkin,
	input [ 0:0 ] rxpolarityin,
	input [ 0:0 ] scanmode,
	input [ 3:0 ] txblkstart,
	input [ 4:0 ] bitslipboundaryselect,
	input [ 0:0 ] xgmctrl,
	input [ 0:0 ] xgmctrltoporbottom,
	input [ 7:0 ] xgmdatain,
	input [ 7:0 ] xgmdataintoporbottom,
	input [ 3:0 ] txdatavalid,
	input [ 1:0 ] txdivsyncinchnldown,
	input [ 1:0 ] txdivsyncinchnlup,
	input [ 1:0 ] txsynchdr,
	input [ 43:0 ] datain,
	input [ 0:0 ] detectrxloopin,
	input [ 0:0 ] txpmalocalclk,
	input [ 0:0 ] pipetxswing,
	input [ 0:0 ] txpcsreset,
	input [ 0:0 ] wrenableinchnldown,
	input [ 0:0 ] wrenableinchnlup,
	input [ 0:0 ] phfifowrenable,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] dynclkswitchn,
	output [ 0:0 ] phfifounderflow,
	output [ 1:0 ] fifoselectoutchnldown,
	output [ 1:0 ] fifoselectoutchnlup,
	output [ 0:0 ] phfifooverflow,
	output [ 2:0 ] grayelecidleinferselout,
	output [ 0:0 ] phfifotxdeemph,
	output [ 2:0 ] phfifotxmargin,
	output [ 0:0 ] phfifotxswing,
	output [ 0:0 ] polinvrxout,
	output [ 1:0 ] pipepowerdownout,
	output [ 19:0 ] dataout,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] rdenablesync,
	output [ 0:0 ] refclkb,
	output [ 0:0 ] refclkbreset,
	output [ 0:0 ] pipeenrevparallellpbkout,
	output [ 0:0 ] rxpolarityout,
	output [ 3:0 ] txblkstartout,
	output [ 0:0 ] clkout,
	output [ 0:0 ] xgmctrlenable,
	output [ 19:0 ] txctrlplanetestbus,
	output [ 31:0 ] txdataouttogen3,
	output [ 7:0 ] xgmdataout,
	output [ 3:0 ] txdatavalidouttogen3,
	output [ 3:0 ] txdatakouttogen3,
	output [ 1:0 ] txdivsync,
	output [ 1:0 ] txdivsyncoutchnldown,
	output [ 1:0 ] txdivsyncoutchnlup,
	output [ 0:0 ] txpipeclk,
	output [ 0:0 ] txpipeelectidle,
	output [ 0:0 ] txpipesoftreset,
	output [ 1:0 ] txsynchdrout,
	output [ 19:0 ] txtestbus,
	output [ 0:0 ] txcomplianceout,
	output [ 0:0 ] detectrxloopout,
	output [ 0:0 ] txelecidleout,
	output [ 19:0 ] parallelfdbkout,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	output [ 0:0 ] syncdatain,
	output [ 0:0 ] observablebyteserdesclock,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_8g_tx_pcs_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.pma_dw(pma_dw),
		.pcs_bypass(pcs_bypass),
		.phase_compensation_fifo(phase_compensation_fifo),
		.tx_compliance_controlled_disparity(tx_compliance_controlled_disparity),
		.force_kchar(force_kchar),
		.force_echar(force_echar),
		.byte_serializer(byte_serializer),
		.data_selection_8b10b_encoder_input(data_selection_8b10b_encoder_input),
		.eightb_tenb_disp_ctrl(eightb_tenb_disp_ctrl),
		.eightb_tenb_encoder(eightb_tenb_encoder),
		.prbs_gen(prbs_gen),
		.cid_pattern(cid_pattern),
		.cid_pattern_len(cid_pattern_len),
		.bist_gen(bist_gen),
		.bit_reversal(bit_reversal),
		.symbol_swap(symbol_swap),
		.polarity_inversion(polarity_inversion),
		.tx_bitslip(tx_bitslip),
		.agg_block_sel(agg_block_sel),
		.revloop_back_rm(revloop_back_rm),
		.phfifo_write_clk_sel(phfifo_write_clk_sel),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.bypass_pipeline_reg(bypass_pipeline_reg),
		.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
		.test_mode(test_mode),
		.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
		.refclk_b_clk_sel(refclk_b_clk_sel),
		.auto_speed_nego_gen2(auto_speed_nego_gen2),
		.txpcs_urst(txpcs_urst),
		.clock_gate_dw_fifowr(clock_gate_dw_fifowr),
		.clock_gate_prbs(clock_gate_prbs),
		.txclk_freerun(txclk_freerun),
		.clock_gate_bs_enc(clock_gate_bs_enc),
		.clock_gate_bist(clock_gate_bist),
		.clock_gate_fiford(clock_gate_fiford),
		.pcfifo_urst(pcfifo_urst),
		.clock_gate_sw_fifowr(clock_gate_sw_fifowr),
		.sup_mode(sup_mode),
		.dynamic_clk_switch(dynamic_clk_switch),
		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_8g_tx_pcs_encrypted_inst	(
		.dispcbyte(dispcbyte),
		.elecidleinfersel(elecidleinfersel),
		.fifoselectinchnldown(fifoselectinchnldown),
		.fifoselectinchnlup(fifoselectinchnlup),
		.rateswitch(rateswitch),
		.hrdrst(hrdrst),
		.pipetxdeemph(pipetxdeemph),
		.pipetxmargin(pipetxmargin),
		.phfiforeset(phfiforeset),
		.coreclk(coreclk),
		.polinvrxin(polinvrxin),
		.invpol(invpol),
		.powerdn(powerdn),
		.prbscidenable(prbscidenable),
		.rdenableinchnldown(rdenableinchnldown),
		.rdenableinchnlup(rdenableinchnlup),
		.phfiforddisable(phfiforddisable),
		.refclkdig(refclkdig),
		.resetpcptrs(resetpcptrs),
		.resetpcptrsinchnldown(resetpcptrsinchnldown),
		.resetpcptrsinchnlup(resetpcptrsinchnlup),
		.revparallellpbkdata(revparallellpbkdata),
		.enrevparallellpbk(enrevparallellpbk),
		.pipeenrevparallellpbkin(pipeenrevparallellpbkin),
		.rxpolarityin(rxpolarityin),
		.scanmode(scanmode),
		.txblkstart(txblkstart),
		.bitslipboundaryselect(bitslipboundaryselect),
		.xgmctrl(xgmctrl),
		.xgmctrltoporbottom(xgmctrltoporbottom),
		.xgmdatain(xgmdatain),
		.xgmdataintoporbottom(xgmdataintoporbottom),
		.txdatavalid(txdatavalid),
		.txdivsyncinchnldown(txdivsyncinchnldown),
		.txdivsyncinchnlup(txdivsyncinchnlup),
		.txsynchdr(txsynchdr),
		.datain(datain),
		.detectrxloopin(detectrxloopin),
		.txpmalocalclk(txpmalocalclk),
		.pipetxswing(pipetxswing),
		.txpcsreset(txpcsreset),
		.wrenableinchnldown(wrenableinchnldown),
		.wrenableinchnlup(wrenableinchnlup),
		.phfifowrenable(phfifowrenable),
		.aggtxpcsrst(aggtxpcsrst),
		.dynclkswitchn(dynclkswitchn),
		.phfifounderflow(phfifounderflow),
		.fifoselectoutchnldown(fifoselectoutchnldown),
		.fifoselectoutchnlup(fifoselectoutchnlup),
		.phfifooverflow(phfifooverflow),
		.grayelecidleinferselout(grayelecidleinferselout),
		.phfifotxdeemph(phfifotxdeemph),
		.phfifotxmargin(phfifotxmargin),
		.phfifotxswing(phfifotxswing),
		.polinvrxout(polinvrxout),
		.pipepowerdownout(pipepowerdownout),
		.dataout(dataout),
		.rdenableoutchnldown(rdenableoutchnldown),
		.rdenableoutchnlup(rdenableoutchnlup),
		.rdenablesync(rdenablesync),
		.refclkb(refclkb),
		.refclkbreset(refclkbreset),
		.pipeenrevparallellpbkout(pipeenrevparallellpbkout),
		.rxpolarityout(rxpolarityout),
		.txblkstartout(txblkstartout),
		.clkout(clkout),
		.xgmctrlenable(xgmctrlenable),
		.txctrlplanetestbus(txctrlplanetestbus),
		.txdataouttogen3(txdataouttogen3),
		.xgmdataout(xgmdataout),
		.txdatavalidouttogen3(txdatavalidouttogen3),
		.txdatakouttogen3(txdatakouttogen3),
		.txdivsync(txdivsync),
		.txdivsyncoutchnldown(txdivsyncoutchnldown),
		.txdivsyncoutchnlup(txdivsyncoutchnlup),
		.txpipeclk(txpipeclk),
		.txpipeelectidle(txpipeelectidle),
		.txpipesoftreset(txpipesoftreset),
		.txsynchdrout(txsynchdrout),
		.txtestbus(txtestbus),
		.txcomplianceout(txcomplianceout),
		.detectrxloopout(detectrxloopout),
		.txelecidleout(txelecidleout),
		.parallelfdbkout(parallelfdbkout),
		.wrenableoutchnldown(wrenableoutchnldown),
		.wrenableoutchnlup(wrenableoutchnlup),
		.syncdatain(syncdatain),
		.observablebyteserdesclock(observablebyteserdesclock),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_common_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_common_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "disabled_prot_mode",	//Valid values: disabled_prot_mode|pipe_g1|pipe_g2|other_protocols
	parameter force_freqdet = "force_freqdet_dis",	//Valid values: force_freqdet_dis|force1_freqdet_en|force0_freqdet_en
	parameter ppmsel = "ppmsel_default",	//Valid values: ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
	parameter ppm_cnt_rst = "ppm_cnt_rst_dis",	//Valid values: ppm_cnt_rst_dis|ppm_cnt_rst_en
	parameter auto_speed_ena = "dis_auto_speed_ena",	//Valid values: dis_auto_speed_ena|en_auto_speed_ena
	parameter ppm_gen1_2_cnt = "cnt_32k",	//Valid values: cnt_32k|cnt_64k
	parameter ppm_post_eidle_delay = "cnt_200_cycles",	//Valid values: cnt_200_cycles|cnt_400_cycles
	parameter func_mode = "disable",	//Valid values: disable|hrdrstctrl_cmu|eightg_only_pld|eightg_only_hip|pma_direct
	parameter pma_if_dft_val = "dft_0",	//Valid values: dft_0
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs
	parameter ppm_deassert_early = "deassert_early_dis",	//Valid values: deassert_early_dis|deassert_early_en
	parameter pipe_if_g3pcs = "pipe_if_8gpcs",	//Valid values: pipe_if_8gpcs
	parameter pma_if_dft_en = "dft_dis",	//Valid values: dft_dis
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] aggalignstatus,
	input [ 0:0 ] aggalignstatussync0,
	input [ 0:0 ] aggalignstatussync0toporbot,
	input [ 0:0 ] aggalignstatustoporbot,
	input [ 0:0 ] aggcgcomprddall,
	input [ 0:0 ] aggcgcomprddalltoporbot,
	input [ 0:0 ] aggcgcompwrall,
	input [ 0:0 ] aggcgcompwralltoporbot,
	input [ 0:0 ] aggdelcondmet0,
	input [ 0:0 ] aggdelcondmet0toporbot,
	input [ 0:0 ] aggendskwqd,
	input [ 0:0 ] aggendskwqdtoporbot,
	input [ 0:0 ] aggendskwrdptrs,
	input [ 0:0 ] aggendskwrdptrstoporbot,
	input [ 0:0 ] aggfifoovr0,
	input [ 0:0 ] aggfifoovr0toporbot,
	input [ 0:0 ] aggfifordincomp0,
	input [ 0:0 ] aggfifordincomp0toporbot,
	input [ 0:0 ] aggfiforstrdqd,
	input [ 0:0 ] aggfiforstrdqdtoporbot,
	input [ 0:0 ] agginsertincomplete0,
	input [ 0:0 ] agginsertincomplete0toporbot,
	input [ 0:0 ] agglatencycomp0,
	input [ 0:0 ] agglatencycomp0toporbot,
	input [ 0:0 ] aggrcvdclkagg,
	input [ 0:0 ] aggrcvdclkaggtoporbot,
	input [ 0:0 ] aggrxcontrolrs,
	input [ 0:0 ] aggrxcontrolrstoporbot,
	input [ 7:0 ] aggrxdatars,
	input [ 7:0 ] aggrxdatarstoporbot,
	input [ 0:0 ] aggtestsotopldin,
	input [ 15:0 ] aggtestbus,
	input [ 0:0 ] aggtxctlts,
	input [ 0:0 ] aggtxctltstoporbot,
	input [ 7:0 ] aggtxdatats,
	input [ 7:0 ] aggtxdatatstoporbot,
	input [ 0:0 ] hardreset,
	input [ 0:0 ] pcs8gearlyeios,
	input [ 0:0 ] pcs8geidleexit,
	input [ 0:0 ] pcs8gltrpma,
	input [ 0:0 ] pcs8gpcieswitch,
	input [ 17:0 ] pcs8gpmacurrentcoeff,
	input [ 0:0 ] pcs8gtxelecidle,
	input [ 0:0 ] pcs8gtxdetectrx,
	input [ 1:0 ] pcsaggaligndetsync,
	input [ 0:0 ] pcsaggalignstatussync,
	input [ 1:0 ] pcsaggcgcomprddout,
	input [ 1:0 ] pcsaggcgcompwrout,
	input [ 0:0 ] pcsaggdecctl,
	input [ 7:0 ] pcsaggdecdata,
	input [ 0:0 ] pcsaggdecdatavalid,
	input [ 0:0 ] pcsaggdelcondmetout,
	input [ 0:0 ] pcsaggfifoovrout,
	input [ 0:0 ] pcsaggfifordoutcomp,
	input [ 0:0 ] pcsagginsertincompleteout,
	input [ 0:0 ] pcsagglatencycompout,
	input [ 1:0 ] pcsaggrdalign,
	input [ 0:0 ] pcsaggrdenablesync,
	input [ 0:0 ] pcsaggrefclkdig,
	input [ 1:0 ] pcsaggrunningdisp,
	input [ 0:0 ] pcsaggrxpcsrst,
	input [ 0:0 ] pcsaggscanmoden,
	input [ 0:0 ] pcsaggscanshiftn,
	input [ 0:0 ] pcsaggsyncstatus,
	input [ 0:0 ] pcsaggtxctltc,
	input [ 7:0 ] pcsaggtxdatatc,
	input [ 0:0 ] pcsaggtxpcsrst,
	input [ 0:0 ] pcsrefclkdig,
	input [ 0:0 ] pcsscanmoden,
	input [ 0:0 ] pcsscanshiftn,
	input [ 0:0 ] pldnfrzdrv,
	input [ 0:0 ] pldpartialreconfig,
	input [ 0:0 ] pldtestsitoaggin,
	input [ 0:0 ] clklow,
	input [ 0:0 ] fref,
	input [ 0:0 ] pmahclk,
	input [ 1:0 ] pmapcieswdone,
	input [ 0:0 ] pmarxdetectvalid,
	input [ 0:0 ] pmarxfound,
	input [ 0:0 ] pmarxpmarstb,
	input [ 0:0 ] resetppmcntrs,
	output [ 1:0 ] aggaligndetsync,
	output [ 0:0 ] aggalignstatussync,
	output [ 1:0 ] aggcgcomprddout,
	output [ 1:0 ] aggcgcompwrout,
	output [ 0:0 ] aggdecctl,
	output [ 7:0 ] aggdecdata,
	output [ 0:0 ] aggdecdatavalid,
	output [ 0:0 ] aggdelcondmetout,
	output [ 0:0 ] aggfifoovrout,
	output [ 0:0 ] aggfifordoutcomp,
	output [ 0:0 ] agginsertincompleteout,
	output [ 0:0 ] agglatencycompout,
	output [ 1:0 ] aggrdalign,
	output [ 0:0 ] aggrdenablesync,
	output [ 0:0 ] aggrefclkdig,
	output [ 1:0 ] aggrunningdisp,
	output [ 0:0 ] aggrxpcsrst,
	output [ 0:0 ] aggscanmoden,
	output [ 0:0 ] aggscanshiftn,
	output [ 0:0 ] aggsyncstatus,
	output [ 0:0 ] aggtestsotopldout,
	output [ 0:0 ] aggtxctltc,
	output [ 7:0 ] aggtxdatatc,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] pcs8ggen2ngen1,
	output [ 0:0 ] pcs8gpmarxfound,
	output [ 0:0 ] pcs8gpowerstatetransitiondone,
	output [ 0:0 ] pcs8grxdetectvalid,
	output [ 0:0 ] pcsaggalignstatus,
	output [ 0:0 ] pcsaggalignstatussync0,
	output [ 0:0 ] pcsaggalignstatussync0toporbot,
	output [ 0:0 ] pcsaggalignstatustoporbot,
	output [ 0:0 ] pcsaggcgcomprddall,
	output [ 0:0 ] pcsaggcgcomprddalltoporbot,
	output [ 0:0 ] pcsaggcgcompwrall,
	output [ 0:0 ] pcsaggcgcompwralltoporbot,
	output [ 0:0 ] pcsaggdelcondmet0,
	output [ 0:0 ] pcsaggdelcondmet0toporbot,
	output [ 0:0 ] pcsaggendskwqd,
	output [ 0:0 ] pcsaggendskwqdtoporbot,
	output [ 0:0 ] pcsaggendskwrdptrs,
	output [ 0:0 ] pcsaggendskwrdptrstoporbot,
	output [ 0:0 ] pcsaggfifoovr0,
	output [ 0:0 ] pcsaggfifoovr0toporbot,
	output [ 0:0 ] pcsaggfifordincomp0,
	output [ 0:0 ] pcsaggfifordincomp0toporbot,
	output [ 0:0 ] pcsaggfiforstrdqd,
	output [ 0:0 ] pcsaggfiforstrdqdtoporbot,
	output [ 0:0 ] pcsagginsertincomplete0,
	output [ 0:0 ] pcsagginsertincomplete0toporbot,
	output [ 0:0 ] pcsagglatencycomp0,
	output [ 0:0 ] pcsagglatencycomp0toporbot,
	output [ 0:0 ] pcsaggrcvdclkagg,
	output [ 0:0 ] pcsaggrcvdclkaggtoporbot,
	output [ 0:0 ] pcsaggrxcontrolrs,
	output [ 0:0 ] pcsaggrxcontrolrstoporbot,
	output [ 7:0 ] pcsaggrxdatars,
	output [ 7:0 ] pcsaggrxdatarstoporbot,
	output [ 15:0 ] pcsaggtestbus,
	output [ 0:0 ] pcsaggtxctlts,
	output [ 0:0 ] pcsaggtxctltstoporbot,
	output [ 7:0 ] pcsaggtxdatats,
	output [ 7:0 ] pcsaggtxdatatstoporbot,
	output [ 0:0 ] pldhclkout,
	output [ 0:0 ] pldtestsitoaggout,
	output [ 0:0 ] pmaclklowout,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmafrefout,
	output [ 9:0 ] pmaiftestbus,
	output [ 0:0 ] pmaltr,
	output [ 0:0 ] pmanfrzdrv,
	output [ 0:0 ] pmapartialreconfig,
	output [ 1:0 ] pmapcieswitch,
	output [ 0:0 ] freqlock,
	output [ 0:0 ] pmatxelecidle,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] asynchdatain,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_common_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.force_freqdet(force_freqdet),
		.ppmsel(ppmsel),
		.ppm_cnt_rst(ppm_cnt_rst),
		.auto_speed_ena(auto_speed_ena),
		.ppm_gen1_2_cnt(ppm_gen1_2_cnt),
		.ppm_post_eidle_delay(ppm_post_eidle_delay),
		.func_mode(func_mode),
		.pma_if_dft_val(pma_if_dft_val),
		.sup_mode(sup_mode),
		.selectpcs(selectpcs),
		.ppm_deassert_early(ppm_deassert_early),
		.pipe_if_g3pcs(pipe_if_g3pcs),
		.pma_if_dft_en(pma_if_dft_en),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_common_pcs_pma_interface_encrypted_inst	(
		.aggalignstatus(aggalignstatus),
		.aggalignstatussync0(aggalignstatussync0),
		.aggalignstatussync0toporbot(aggalignstatussync0toporbot),
		.aggalignstatustoporbot(aggalignstatustoporbot),
		.aggcgcomprddall(aggcgcomprddall),
		.aggcgcomprddalltoporbot(aggcgcomprddalltoporbot),
		.aggcgcompwrall(aggcgcompwrall),
		.aggcgcompwralltoporbot(aggcgcompwralltoporbot),
		.aggdelcondmet0(aggdelcondmet0),
		.aggdelcondmet0toporbot(aggdelcondmet0toporbot),
		.aggendskwqd(aggendskwqd),
		.aggendskwqdtoporbot(aggendskwqdtoporbot),
		.aggendskwrdptrs(aggendskwrdptrs),
		.aggendskwrdptrstoporbot(aggendskwrdptrstoporbot),
		.aggfifoovr0(aggfifoovr0),
		.aggfifoovr0toporbot(aggfifoovr0toporbot),
		.aggfifordincomp0(aggfifordincomp0),
		.aggfifordincomp0toporbot(aggfifordincomp0toporbot),
		.aggfiforstrdqd(aggfiforstrdqd),
		.aggfiforstrdqdtoporbot(aggfiforstrdqdtoporbot),
		.agginsertincomplete0(agginsertincomplete0),
		.agginsertincomplete0toporbot(agginsertincomplete0toporbot),
		.agglatencycomp0(agglatencycomp0),
		.agglatencycomp0toporbot(agglatencycomp0toporbot),
		.aggrcvdclkagg(aggrcvdclkagg),
		.aggrcvdclkaggtoporbot(aggrcvdclkaggtoporbot),
		.aggrxcontrolrs(aggrxcontrolrs),
		.aggrxcontrolrstoporbot(aggrxcontrolrstoporbot),
		.aggrxdatars(aggrxdatars),
		.aggrxdatarstoporbot(aggrxdatarstoporbot),
		.aggtestsotopldin(aggtestsotopldin),
		.aggtestbus(aggtestbus),
		.aggtxctlts(aggtxctlts),
		.aggtxctltstoporbot(aggtxctltstoporbot),
		.aggtxdatats(aggtxdatats),
		.aggtxdatatstoporbot(aggtxdatatstoporbot),
		.hardreset(hardreset),
		.pcs8gearlyeios(pcs8gearlyeios),
		.pcs8geidleexit(pcs8geidleexit),
		.pcs8gltrpma(pcs8gltrpma),
		.pcs8gpcieswitch(pcs8gpcieswitch),
		.pcs8gpmacurrentcoeff(pcs8gpmacurrentcoeff),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxdetectrx(pcs8gtxdetectrx),
		.pcsaggaligndetsync(pcsaggaligndetsync),
		.pcsaggalignstatussync(pcsaggalignstatussync),
		.pcsaggcgcomprddout(pcsaggcgcomprddout),
		.pcsaggcgcompwrout(pcsaggcgcompwrout),
		.pcsaggdecctl(pcsaggdecctl),
		.pcsaggdecdata(pcsaggdecdata),
		.pcsaggdecdatavalid(pcsaggdecdatavalid),
		.pcsaggdelcondmetout(pcsaggdelcondmetout),
		.pcsaggfifoovrout(pcsaggfifoovrout),
		.pcsaggfifordoutcomp(pcsaggfifordoutcomp),
		.pcsagginsertincompleteout(pcsagginsertincompleteout),
		.pcsagglatencycompout(pcsagglatencycompout),
		.pcsaggrdalign(pcsaggrdalign),
		.pcsaggrdenablesync(pcsaggrdenablesync),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.pcsaggrunningdisp(pcsaggrunningdisp),
		.pcsaggrxpcsrst(pcsaggrxpcsrst),
		.pcsaggscanmoden(pcsaggscanmoden),
		.pcsaggscanshiftn(pcsaggscanshiftn),
		.pcsaggsyncstatus(pcsaggsyncstatus),
		.pcsaggtxctltc(pcsaggtxctltc),
		.pcsaggtxdatatc(pcsaggtxdatatc),
		.pcsaggtxpcsrst(pcsaggtxpcsrst),
		.pcsrefclkdig(pcsrefclkdig),
		.pcsscanmoden(pcsscanmoden),
		.pcsscanshiftn(pcsscanshiftn),
		.pldnfrzdrv(pldnfrzdrv),
		.pldpartialreconfig(pldpartialreconfig),
		.pldtestsitoaggin(pldtestsitoaggin),
		.clklow(clklow),
		.fref(fref),
		.pmahclk(pmahclk),
		.pmapcieswdone(pmapcieswdone),
		.pmarxdetectvalid(pmarxdetectvalid),
		.pmarxfound(pmarxfound),
		.pmarxpmarstb(pmarxpmarstb),
		.resetppmcntrs(resetppmcntrs),
		.aggaligndetsync(aggaligndetsync),
		.aggalignstatussync(aggalignstatussync),
		.aggcgcomprddout(aggcgcomprddout),
		.aggcgcompwrout(aggcgcompwrout),
		.aggdecctl(aggdecctl),
		.aggdecdata(aggdecdata),
		.aggdecdatavalid(aggdecdatavalid),
		.aggdelcondmetout(aggdelcondmetout),
		.aggfifoovrout(aggfifoovrout),
		.aggfifordoutcomp(aggfifordoutcomp),
		.agginsertincompleteout(agginsertincompleteout),
		.agglatencycompout(agglatencycompout),
		.aggrdalign(aggrdalign),
		.aggrdenablesync(aggrdenablesync),
		.aggrefclkdig(aggrefclkdig),
		.aggrunningdisp(aggrunningdisp),
		.aggrxpcsrst(aggrxpcsrst),
		.aggscanmoden(aggscanmoden),
		.aggscanshiftn(aggscanshiftn),
		.aggsyncstatus(aggsyncstatus),
		.aggtestsotopldout(aggtestsotopldout),
		.aggtxctltc(aggtxctltc),
		.aggtxdatatc(aggtxdatatc),
		.aggtxpcsrst(aggtxpcsrst),
		.pcs8ggen2ngen1(pcs8ggen2ngen1),
		.pcs8gpmarxfound(pcs8gpmarxfound),
		.pcs8gpowerstatetransitiondone(pcs8gpowerstatetransitiondone),
		.pcs8grxdetectvalid(pcs8grxdetectvalid),
		.pcsaggalignstatus(pcsaggalignstatus),
		.pcsaggalignstatussync0(pcsaggalignstatussync0),
		.pcsaggalignstatussync0toporbot(pcsaggalignstatussync0toporbot),
		.pcsaggalignstatustoporbot(pcsaggalignstatustoporbot),
		.pcsaggcgcomprddall(pcsaggcgcomprddall),
		.pcsaggcgcomprddalltoporbot(pcsaggcgcomprddalltoporbot),
		.pcsaggcgcompwrall(pcsaggcgcompwrall),
		.pcsaggcgcompwralltoporbot(pcsaggcgcompwralltoporbot),
		.pcsaggdelcondmet0(pcsaggdelcondmet0),
		.pcsaggdelcondmet0toporbot(pcsaggdelcondmet0toporbot),
		.pcsaggendskwqd(pcsaggendskwqd),
		.pcsaggendskwqdtoporbot(pcsaggendskwqdtoporbot),
		.pcsaggendskwrdptrs(pcsaggendskwrdptrs),
		.pcsaggendskwrdptrstoporbot(pcsaggendskwrdptrstoporbot),
		.pcsaggfifoovr0(pcsaggfifoovr0),
		.pcsaggfifoovr0toporbot(pcsaggfifoovr0toporbot),
		.pcsaggfifordincomp0(pcsaggfifordincomp0),
		.pcsaggfifordincomp0toporbot(pcsaggfifordincomp0toporbot),
		.pcsaggfiforstrdqd(pcsaggfiforstrdqd),
		.pcsaggfiforstrdqdtoporbot(pcsaggfiforstrdqdtoporbot),
		.pcsagginsertincomplete0(pcsagginsertincomplete0),
		.pcsagginsertincomplete0toporbot(pcsagginsertincomplete0toporbot),
		.pcsagglatencycomp0(pcsagglatencycomp0),
		.pcsagglatencycomp0toporbot(pcsagglatencycomp0toporbot),
		.pcsaggrcvdclkagg(pcsaggrcvdclkagg),
		.pcsaggrcvdclkaggtoporbot(pcsaggrcvdclkaggtoporbot),
		.pcsaggrxcontrolrs(pcsaggrxcontrolrs),
		.pcsaggrxcontrolrstoporbot(pcsaggrxcontrolrstoporbot),
		.pcsaggrxdatars(pcsaggrxdatars),
		.pcsaggrxdatarstoporbot(pcsaggrxdatarstoporbot),
		.pcsaggtestbus(pcsaggtestbus),
		.pcsaggtxctlts(pcsaggtxctlts),
		.pcsaggtxctltstoporbot(pcsaggtxctltstoporbot),
		.pcsaggtxdatats(pcsaggtxdatats),
		.pcsaggtxdatatstoporbot(pcsaggtxdatatstoporbot),
		.pldhclkout(pldhclkout),
		.pldtestsitoaggout(pldtestsitoaggout),
		.pmaclklowout(pmaclklowout),
		.pmacurrentcoeff(pmacurrentcoeff),
		.pmaearlyeios(pmaearlyeios),
		.pmafrefout(pmafrefout),
		.pmaiftestbus(pmaiftestbus),
		.pmaltr(pmaltr),
		.pmanfrzdrv(pmanfrzdrv),
		.pmapartialreconfig(pmapartialreconfig),
		.pmapcieswitch(pmapcieswitch),
		.freqlock(freqlock),
		.pmatxelecidle(pmatxelecidle),
		.pmatxdetectrx(pmatxdetectrx),
		.asynchdatain(asynchdatain),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_common_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_common_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter hip_enable = "hip_disable",	//Valid values: hip_disable|hip_enable
	parameter hrdrstctrl_en_cfgusr = "hrst_dis_cfgusr",	//Valid values: hrst_dis_cfgusr|hrst_en_cfgusr
	parameter pld_side_reserved_source10 = "pld_res10",	//Valid values: pld_res10|hip_res10
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter pld_side_reserved_source0 = "pld_res0",	//Valid values: pld_res0|hip_res0
	parameter pld_side_reserved_source1 = "pld_res1",	//Valid values: pld_res1|hip_res1
	parameter pld_side_reserved_source2 = "pld_res2",	//Valid values: pld_res2|hip_res2
	parameter pld_side_reserved_source3 = "pld_res3",	//Valid values: pld_res3|hip_res3
	parameter pld_side_reserved_source4 = "pld_res4",	//Valid values: pld_res4|hip_res4
	parameter pld_side_reserved_source5 = "pld_res5",	//Valid values: pld_res5|hip_res5
	parameter pld_side_reserved_source6 = "pld_res6",	//Valid values: pld_res6|hip_res6
	parameter pld_side_reserved_source7 = "pld_res7",	//Valid values: pld_res7|hip_res7
	parameter pld_side_reserved_source8 = "pld_res8",	//Valid values: pld_res8|hip_res8
	parameter pld_side_reserved_source9 = "pld_res9",	//Valid values: pld_res9|hip_res9
	parameter hrdrstctrl_en_cfg = "hrst_dis_cfg",	//Valid values: hrst_dis_cfg|hrst_en_cfg
	parameter testbus_sel = "eight_g_pcs",	//Valid values: eight_g_pcs|pma_if
	parameter usrmode_sel4rst = "usermode",	//Valid values: usermode|last_frz
	parameter pld_side_reserved_source11 = "pld_res11",	//Valid values: pld_res11|hip_res11
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 37:0 ] emsipcomin,
	input [ 19:0 ] pcs8gchnltestbusout,
	input [ 0:0 ] pcs8gphystatus,
	input [ 2:0 ] pcs8gpldextraout,
	input [ 0:0 ] pcs8grxelecidle,
	input [ 2:0 ] pcs8grxstatus,
	input [ 0:0 ] pcs8grxvalid,
	input [ 5:0 ] pcs8gtestso,
	input [ 0:0 ] pcsaggtestso,
	input [ 0:0 ] pcspmaiftestso,
	input [ 9:0 ] pcspmaiftestbusout,
	input [ 1:0 ] pld8gpowerdown,
	input [ 0:0 ] pld8gprbsciden,
	input [ 0:0 ] pld8grefclkdig,
	input [ 0:0 ] pld8grefclkdig2,
	input [ 0:0 ] pld8grxpolarity,
	input [ 0:0 ] pld8gtxdeemph,
	input [ 0:0 ] pld8gtxdetectrxloopback,
	input [ 0:0 ] pld8gtxelecidle,
	input [ 2:0 ] pld8gtxmargin,
	input [ 0:0 ] pld8gtxswing,
	input [ 0:0 ] pldaggrefclkdig,
	input [ 2:0 ] pldeidleinfersel,
	input [ 0:0 ] pldhclkin,
	input [ 0:0 ] pldltr,
	input [ 0:0 ] pldpartialreconfigin,
	input [ 0:0 ] pldpcspmaifrefclkdig,
	input [ 0:0 ] pldrate,
	input [ 11:0 ] pldreservedin,
	input [ 0:0 ] pldscanmoden,
	input [ 0:0 ] pldscanshiftn,
	input [ 0:0 ] pmaclklow,
	input [ 0:0 ] pmafref,
	output [ 2:0 ] emsipcomclkout,
	output [ 26:0 ] emsipcomout,
	output [ 0:0 ] emsipenablediocsrrdydly,
	output [ 2:0 ] pcs8geidleinfersel,
	output [ 0:0 ] pcs8ghardreset,
	output [ 0:0 ] pcs8gltr,
	output [ 3:0 ] pcs8gpldextrain,
	output [ 1:0 ] pcs8gpowerdown,
	output [ 0:0 ] pcs8gprbsciden,
	output [ 0:0 ] pcs8grate,
	output [ 0:0 ] pcs8grefclkdig,
	output [ 0:0 ] pcs8grefclkdig2,
	output [ 0:0 ] pcs8grxpolarity,
	output [ 0:0 ] pcs8gscanmoden,
	output [ 0:0 ] pcs8gscanshift,
	output [ 5:0 ] pcs8gtestsi,
	output [ 0:0 ] pcs8gtxdeemph,
	output [ 0:0 ] pcs8gtxdetectrxloopback,
	output [ 0:0 ] pcs8gtxelecidle,
	output [ 2:0 ] pcs8gtxmargin,
	output [ 0:0 ] pcs8gtxswing,
	output [ 0:0 ] pcsaggrefclkdig,
	output [ 0:0 ] pcsaggscanmoden,
	output [ 0:0 ] pcsaggscanshift,
	output [ 0:0 ] pcsaggtestsi,
	output [ 0:0 ] pcspcspmaifrefclkdig,
	output [ 0:0 ] pcspcspmaifscanmoden,
	output [ 0:0 ] pcspcspmaifscanshiftn,
	output [ 0:0 ] pcspmaifhardreset,
	output [ 0:0 ] pcspmaiftestsi,
	output [ 0:0 ] pld8gphystatus,
	output [ 0:0 ] pld8grxelecidle,
	output [ 2:0 ] pld8grxstatus,
	output [ 0:0 ] pld8grxvalid,
	output [ 0:0 ] pldclklow,
	output [ 0:0 ] pldfref,
	output [ 0:0 ] pldnfrzdrv,
	output [ 0:0 ] pldpartialreconfigout,
	output [ 10:0 ] pldreservedout,
	output [ 19:0 ] pldtestdata,
	output [ 0:0 ] rstsel,
	output [ 0:0 ] usrrstsel,
	output [ 0:0 ] asynchdatain,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_common_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.hip_enable(hip_enable),
		.hrdrstctrl_en_cfgusr(hrdrstctrl_en_cfgusr),
		.pld_side_reserved_source10(pld_side_reserved_source10),
		.pld_side_data_source(pld_side_data_source),
		.pld_side_reserved_source0(pld_side_reserved_source0),
		.pld_side_reserved_source1(pld_side_reserved_source1),
		.pld_side_reserved_source2(pld_side_reserved_source2),
		.pld_side_reserved_source3(pld_side_reserved_source3),
		.pld_side_reserved_source4(pld_side_reserved_source4),
		.pld_side_reserved_source5(pld_side_reserved_source5),
		.pld_side_reserved_source6(pld_side_reserved_source6),
		.pld_side_reserved_source7(pld_side_reserved_source7),
		.pld_side_reserved_source8(pld_side_reserved_source8),
		.pld_side_reserved_source9(pld_side_reserved_source9),
		.hrdrstctrl_en_cfg(hrdrstctrl_en_cfg),
		.testbus_sel(testbus_sel),
		.usrmode_sel4rst(usrmode_sel4rst),
		.pld_side_reserved_source11(pld_side_reserved_source11),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_common_pld_pcs_interface_encrypted_inst	(
		.emsipcomin(emsipcomin),
		.pcs8gchnltestbusout(pcs8gchnltestbusout),
		.pcs8gphystatus(pcs8gphystatus),
		.pcs8gpldextraout(pcs8gpldextraout),
		.pcs8grxelecidle(pcs8grxelecidle),
		.pcs8grxstatus(pcs8grxstatus),
		.pcs8grxvalid(pcs8grxvalid),
		.pcs8gtestso(pcs8gtestso),
		.pcsaggtestso(pcsaggtestso),
		.pcspmaiftestso(pcspmaiftestso),
		.pcspmaiftestbusout(pcspmaiftestbusout),
		.pld8gpowerdown(pld8gpowerdown),
		.pld8gprbsciden(pld8gprbsciden),
		.pld8grefclkdig(pld8grefclkdig),
		.pld8grefclkdig2(pld8grefclkdig2),
		.pld8grxpolarity(pld8grxpolarity),
		.pld8gtxdeemph(pld8gtxdeemph),
		.pld8gtxdetectrxloopback(pld8gtxdetectrxloopback),
		.pld8gtxelecidle(pld8gtxelecidle),
		.pld8gtxmargin(pld8gtxmargin),
		.pld8gtxswing(pld8gtxswing),
		.pldaggrefclkdig(pldaggrefclkdig),
		.pldeidleinfersel(pldeidleinfersel),
		.pldhclkin(pldhclkin),
		.pldltr(pldltr),
		.pldpartialreconfigin(pldpartialreconfigin),
		.pldpcspmaifrefclkdig(pldpcspmaifrefclkdig),
		.pldrate(pldrate),
		.pldreservedin(pldreservedin),
		.pldscanmoden(pldscanmoden),
		.pldscanshiftn(pldscanshiftn),
		.pmaclklow(pmaclklow),
		.pmafref(pmafref),
		.emsipcomclkout(emsipcomclkout),
		.emsipcomout(emsipcomout),
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.pcs8geidleinfersel(pcs8geidleinfersel),
		.pcs8ghardreset(pcs8ghardreset),
		.pcs8gltr(pcs8gltr),
		.pcs8gpldextrain(pcs8gpldextrain),
		.pcs8gpowerdown(pcs8gpowerdown),
		.pcs8gprbsciden(pcs8gprbsciden),
		.pcs8grate(pcs8grate),
		.pcs8grefclkdig(pcs8grefclkdig),
		.pcs8grefclkdig2(pcs8grefclkdig2),
		.pcs8grxpolarity(pcs8grxpolarity),
		.pcs8gscanmoden(pcs8gscanmoden),
		.pcs8gscanshift(pcs8gscanshift),
		.pcs8gtestsi(pcs8gtestsi),
		.pcs8gtxdeemph(pcs8gtxdeemph),
		.pcs8gtxdetectrxloopback(pcs8gtxdetectrxloopback),
		.pcs8gtxelecidle(pcs8gtxelecidle),
		.pcs8gtxmargin(pcs8gtxmargin),
		.pcs8gtxswing(pcs8gtxswing),
		.pcsaggrefclkdig(pcsaggrefclkdig),
		.pcsaggscanmoden(pcsaggscanmoden),
		.pcsaggscanshift(pcsaggscanshift),
		.pcsaggtestsi(pcsaggtestsi),
		.pcspcspmaifrefclkdig(pcspcspmaifrefclkdig),
		.pcspcspmaifscanmoden(pcspcspmaifscanmoden),
		.pcspcspmaifscanshiftn(pcspcspmaifscanshiftn),
		.pcspmaifhardreset(pcspmaifhardreset),
		.pcspmaiftestsi(pcspmaiftestsi),
		.pld8gphystatus(pld8gphystatus),
		.pld8grxelecidle(pld8grxelecidle),
		.pld8grxstatus(pld8grxstatus),
		.pld8grxvalid(pld8grxvalid),
		.pldclklow(pldclklow),
		.pldfref(pldfref),
		.pldnfrzdrv(pldnfrzdrv),
		.pldpartialreconfigout(pldpartialreconfigout),
		.pldreservedout(pldreservedout),
		.pldtestdata(pldtestdata),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.asynchdatain(asynchdatain),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pipe_gen1_2_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pipe_gen1_2
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter prot_mode = "pipe_g1",	//Valid values: pipe_g1|pipe_g2|srio_2p1|basic|disabled_prot_mode
	parameter hip_mode = "dis_hip",	//Valid values: dis_hip|en_hip
	parameter tx_pipe_enable = "dis_pipe_tx",	//Valid values: dis_pipe_tx|en_pipe_tx
	parameter rx_pipe_enable = "dis_pipe_rx",	//Valid values: dis_pipe_rx|en_pipe_rx
	parameter pipe_byte_de_serializer_en = "dont_care_bds",	//Valid values: dis_bds|en_bds_by_2|dont_care_bds
	parameter txswing = "dis_txswing",	//Valid values: dis_txswing|en_txswing
	parameter rxdetect_bypass = "dis_rxdetect_bypass",	//Valid values: dis_rxdetect_bypass|en_rxdetect_bypass
	parameter error_replace_pad = "replace_edb",	//Valid values: replace_edb|replace_pad
	parameter ind_error_reporting = "dis_ind_error_reporting",	//Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter phystatus_rst_toggle = "dis_phystatus_rst_toggle",	//Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter elecidle_delay = "elec_idle_delay",	//Valid values: elec_idle_delay
	parameter [ 2:0 ] elec_idle_delay_val = 3'b0,	//Valid values: 3
	parameter phy_status_delay = "phystatus_delay",	//Valid values: phystatus_delay
	parameter [ 2:0 ] phystatus_delay_val = 3'b0,	//Valid values: 3
	parameter [ 5:0 ] rvod_sel_d_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_b_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_c_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_c_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_settings = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_a_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_d_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_settings = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rvod_sel_b_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_e_val = 6'b0,	//Valid values: 6
	parameter sup_mode = "user_mode",	//Valid values: user_mode|engineering_mode
	parameter [ 5:0 ] rvod_sel_e_val = 6'b0,	//Valid values: 6
	parameter [ 5:0 ] rpre_emph_a_val = 6'b0,	//Valid values: 6
	parameter ctrl_plane_bonding_consumption = "individual",	//Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] pcieswitch,
	input [ 0:0 ] piperxclk,
	input [ 0:0 ] pipetxclk,
	input [ 0:0 ] polinvrx,
	input [ 0:0 ] powerstatetransitiondone,
	input [ 0:0 ] powerstatetransitiondoneena,
	input [ 1:0 ] powerdown,
	input [ 0:0 ] refclkb,
	input [ 0:0 ] refclkbreset,
	input [ 0:0 ] revloopbkpcsgen3,
	input [ 0:0 ] revloopback,
	input [ 0:0 ] rxdetectvalid,
	input [ 0:0 ] rxfound,
	input [ 0:0 ] rxpipereset,
	input [ 63:0 ] rxd,
	input [ 0:0 ] rxelectricalidle,
	input [ 0:0 ] rxpolarity,
	input [ 0:0 ] sigdetni,
	input [ 0:0 ] speedchange,
	input [ 0:0 ] speedchangechnldown,
	input [ 0:0 ] speedchangechnlup,
	input [ 0:0 ] txelecidlecomp,
	input [ 0:0 ] txpipereset,
	input [ 43:0 ] txdch,
	input [ 0:0 ] txdeemph,
	input [ 0:0 ] txdetectrxloopback,
	input [ 0:0 ] txelecidlein,
	input [ 2:0 ] txmargin,
	input [ 0:0 ] txswingport,
	output [ 17:0 ] currentcoeff,
	output [ 0:0 ] phystatus,
	output [ 0:0 ] polinvrxint,
	output [ 0:0 ] revloopbk,
	output [ 63:0 ] rxdch,
	output [ 0:0 ] rxelecidle,
	output [ 0:0 ] rxelectricalidleout,
	output [ 2:0 ] rxstatus,
	output [ 0:0 ] rxvalid,
	output [ 0:0 ] speedchangeout,
	output [ 0:0 ] txelecidleout,
	output [ 43:0 ] txd,
	output [ 0:0 ] txdetectrx,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pipe_gen1_2_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.prot_mode(prot_mode),
		.hip_mode(hip_mode),
		.tx_pipe_enable(tx_pipe_enable),
		.rx_pipe_enable(rx_pipe_enable),
		.pipe_byte_de_serializer_en(pipe_byte_de_serializer_en),
		.txswing(txswing),
		.rxdetect_bypass(rxdetect_bypass),
		.error_replace_pad(error_replace_pad),
		.ind_error_reporting(ind_error_reporting),
		.phystatus_rst_toggle(phystatus_rst_toggle),
		.elecidle_delay(elecidle_delay),
		.elec_idle_delay_val(elec_idle_delay_val),
		.phy_status_delay(phy_status_delay),
		.phystatus_delay_val(phystatus_delay_val),
		.rvod_sel_d_val(rvod_sel_d_val),
		.rpre_emph_b_val(rpre_emph_b_val),
		.rvod_sel_c_val(rvod_sel_c_val),
		.rpre_emph_c_val(rpre_emph_c_val),
		.rpre_emph_settings(rpre_emph_settings),
		.rvod_sel_a_val(rvod_sel_a_val),
		.rpre_emph_d_val(rpre_emph_d_val),
		.rvod_sel_settings(rvod_sel_settings),
		.rvod_sel_b_val(rvod_sel_b_val),
		.rpre_emph_e_val(rpre_emph_e_val),
		.sup_mode(sup_mode),
		.rvod_sel_e_val(rvod_sel_e_val),
		.rpre_emph_a_val(rpre_emph_a_val),
		.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_pipe_gen1_2_encrypted_inst	(
		.pcieswitch(pcieswitch),
		.piperxclk(piperxclk),
		.pipetxclk(pipetxclk),
		.polinvrx(polinvrx),
		.powerstatetransitiondone(powerstatetransitiondone),
		.powerstatetransitiondoneena(powerstatetransitiondoneena),
		.powerdown(powerdown),
		.refclkb(refclkb),
		.refclkbreset(refclkbreset),
		.revloopbkpcsgen3(revloopbkpcsgen3),
		.revloopback(revloopback),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.rxpipereset(rxpipereset),
		.rxd(rxd),
		.rxelectricalidle(rxelectricalidle),
		.rxpolarity(rxpolarity),
		.sigdetni(sigdetni),
		.speedchange(speedchange),
		.speedchangechnldown(speedchangechnldown),
		.speedchangechnlup(speedchangechnlup),
		.txelecidlecomp(txelecidlecomp),
		.txpipereset(txpipereset),
		.txdch(txdch),
		.txdeemph(txdeemph),
		.txdetectrxloopback(txdetectrxloopback),
		.txelecidlein(txelecidlein),
		.txmargin(txmargin),
		.txswingport(txswingport),
		.currentcoeff(currentcoeff),
		.phystatus(phystatus),
		.polinvrxint(polinvrxint),
		.revloopbk(revloopbk),
		.rxdch(rxdch),
		.rxelecidle(rxelecidle),
		.rxelectricalidleout(rxelectricalidleout),
		.rxstatus(rxstatus),
		.rxvalid(rxvalid),
		.speedchangeout(speedchangeout),
		.txelecidleout(txelecidleout),
		.txd(txd),
		.txdetectrx(txdetectrx),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_aux_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_aux
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter cal_clk_sel = "pm_aux_iqclk_cal_clk_sel_cal_clk",	//Valid values: pm_aux_iqclk_cal_clk_sel_cal_clk|pm_aux_iqclk_cal_clk_sel_iqclk0|pm_aux_iqclk_cal_clk_sel_iqclk1|pm_aux_iqclk_cal_clk_sel_iqclk2|pm_aux_iqclk_cal_clk_sel_iqclk3|pm_aux_iqclk_cal_clk_sel_iqclk4|pm_aux_iqclk_cal_clk_sel_iqclk5
	parameter cal_result_status = "pm_aux_result_status_tx",	//Valid values: pm_aux_result_status_tx|pm_aux_result_status_rx
	parameter continuous_calibration = "false",	//Valid values: false|true
	parameter pm_aux_cal_clk_test_sel = "false",	//Valid values: false|true
	parameter rx_cal_override_value = 0,	//Valid values: 0..31
	parameter rx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter rx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter test_counter_enable = "false",	//Valid values: false|true
	parameter tx_cal_override_value = 0,	//Valid values: 0..31
	parameter tx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter tx_imp = "cal_imp_48_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	inout [ 0:0 ] atb0out,
	inout [ 0:0 ] atb1out,
	input [ 0:0 ] calclk,
	input [ 0:0 ] calpdb,
	input [ 5:0 ] refiqclk,
	input [ 0:0 ] testcntl,
	output [ 0:0 ] nonusertoio,
	output [ 4:0 ] zrxtx50); 

	cyclonev_hssi_pma_aux_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.cal_clk_sel(cal_clk_sel),
		.cal_result_status(cal_result_status),
		.continuous_calibration(continuous_calibration),
		.pm_aux_cal_clk_test_sel(pm_aux_cal_clk_test_sel),
		.rx_cal_override_value(rx_cal_override_value),
		.rx_cal_override_value_enable(rx_cal_override_value_enable),
		.rx_imp(rx_imp),
		.test_counter_enable(test_counter_enable),
		.tx_cal_override_value(tx_cal_override_value),
		.tx_cal_override_value_enable(tx_cal_override_value_enable),
		.tx_imp(tx_imp),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_pma_aux_encrypted_inst	(
		.atb0out(atb0out),
		.atb1out(atb1out),
		.calclk(calclk),
		.calpdb(calpdb),
		.refiqclk(refiqclk),
		.testcntl(testcntl),
		.nonusertoio(nonusertoio),
		.zrxtx50(zrxtx50)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_int_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_int
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..255
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter cvp_mode = "cvp_mode_off",	//Valid values: cvp_mode_off|cvp_mode_on
	parameter early_eios_sel = "pcs_early_eios",	//Valid values: pcs_early_eios|core_early_eios
	parameter ffclk_enable = "ffclk_off",	//Valid values: ffclk_off|ffclk_on
	parameter iqtxrxclk_a_sel = "tristage_outa",	//Valid values: iqtxrxclk_a_pma_rx_clk|iqtxrxclk_a_pcs_rx_clk|iqtxrxclk_a_pma_tx_clk|iqtxrxclk_a_pcs_tx_clk|tristage_outa
	parameter iqtxrxclk_b_sel = "tristage_outb",	//Valid values: iqtxrxclk_b_pma_rx_clk|iqtxrxclk_b_pcs_rx_clk|iqtxrxclk_b_pma_tx_clk|iqtxrxclk_b_pcs_tx_clk|tristage_outb
	parameter ltr_sel = "pcs_ltr",	//Valid values: pcs_ltr|core_ltr
	parameter pcie_switch_sel = "pcs_pcie_switch_sw",	//Valid values: pcs_pcie_switch_sw|core_pcie_switch_sw
	parameter pclk_0_clk_sel = "pclk_0_power_down",	//Valid values: pclk_0_pma_rx_clk|pclk_0_pcs_rx_clk|pclk_0_pma_tx_clk|pclk_0_pcs_tx_clk|pclk_0_power_down
	parameter pclk_1_clk_sel = "pclk_1_power_down",	//Valid values: pclk_1_pma_rx_clk|pclk_1_pcs_rx_clk|pclk_1_pma_tx_clk|pclk_1_pcs_tx_clk|pclk_1_power_down
	parameter tx_elec_idle_sel = "pcs_tx_elec_idle",	//Valid values: pcs_tx_elec_idle|core_tx_elec_idle
	parameter txdetectrx_sel = "pcs_txdetectrx"	//Valid values: pcs_txdetectrx|core_txdetectrx
)
(
//input and output port declaration
	input [ 0:0 ] bslip,
	input [ 0:0 ] ccrurstb,
	input [ 0:0 ] cearlyeios,
	input [ 0:0 ] clkdivrxi,
	input [ 0:0 ] clkdivtxi,
	input [ 0:0 ] clklowi,
	input [ 0:0 ] cltd,
	input [ 0:0 ] cltr,
	input [ 0:0 ] cpcieswitch,
	input [ 0:0 ] crslpbk,
	input [ 0:0 ] ctxdetectrx,
	input [ 0:0 ] ctxelecidle,
	input [ 0:0 ] ctxpmarstb,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] frefi,
	input [ 0:0 ] hclkpcsi,
	input [ 11:0 ] icoeff,
	input [ 0:0 ] ltr,
	input [ 0:0 ] pcieswdonei,
	input [ 0:0 ] pcieswitch,
	input [ 0:0 ] pcsrxclkout,
	input [ 0:0 ] pcstxclkout,
	input [ 0:0 ] pfdmodelocki,
	input [ 0:0 ] pldclk,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] rxdetclk,
	input [ 0:0 ] rxdetectvalidi,
	input [ 0:0 ] rxfoundi,
	input [ 0:0 ] rxplllocki,
	input [ 0:0 ] rxpmarstb,
	input [ 0:0 ] sdi,
	input [ 7:0 ] testbusi,
	input [ 3:0 ] testsel,
	input [ 0:0 ] txdetectrx,
	input [ 0:0 ] txelecidle,
	output [ 0:0 ] bslipo,
	output [ 0:0 ] clklow,
	output [ 0:0 ] cpcieswdone,
	output [ 1:0 ] cpclk,
	output [ 0:0 ] cpfdmodelock,
	output [ 0:0 ] crurstbo,
	output [ 0:0 ] crxdetectvalid,
	output [ 0:0 ] crxfound,
	output [ 0:0 ] crxplllock,
	output [ 0:0 ] csd,
	output [ 0:0 ] earlyeioso,
	output [ 0:0 ] fref,
	output [ 0:0 ] hclkpcs,
	output [ 11:0 ] icoeffo,
	output [ 0:0 ] iqtxrxclka,
	output [ 0:0 ] iqtxrxclkb,
	output [ 0:0 ] ltdo,
	output [ 0:0 ] ltro,
	output [ 0:0 ] pcieswdone,
	output [ 0:0 ] pcieswitcho,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] pldclko,
	output [ 0:0 ] ppmlocko,
	output [ 0:0 ] rxdetclko,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] rxpmarstbo,
	output [ 0:0 ] sd,
	output [ 0:0 ] slpbko,
	output [ 7:0 ] testbus,
	output [ 3:0 ] testselo,
	output [ 0:0 ] txdetectrxo,
	output [ 0:0 ] txelecidleo,
	output [ 0:0 ] txpmarstbo,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmwrite,
	input [ 0:0 ] avmmread,
	input [ 1:0 ] avmmbyteen,
	input [ 10:0 ] avmmaddress,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_int_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.cvp_mode(cvp_mode),
		.early_eios_sel(early_eios_sel),
		.ffclk_enable(ffclk_enable),
		.iqtxrxclk_a_sel(iqtxrxclk_a_sel),
		.iqtxrxclk_b_sel(iqtxrxclk_b_sel),
		.ltr_sel(ltr_sel),
		.pcie_switch_sel(pcie_switch_sel),
		.pclk_0_clk_sel(pclk_0_clk_sel),
		.pclk_1_clk_sel(pclk_1_clk_sel),
		.tx_elec_idle_sel(tx_elec_idle_sel),
		.txdetectrx_sel(txdetectrx_sel)

	)
	cyclonev_hssi_pma_int_encrypted_inst	(
		.bslip(bslip),
		.ccrurstb(ccrurstb),
		.cearlyeios(cearlyeios),
		.clkdivrxi(clkdivrxi),
		.clkdivtxi(clkdivtxi),
		.clklowi(clklowi),
		.cltd(cltd),
		.cltr(cltr),
		.cpcieswitch(cpcieswitch),
		.crslpbk(crslpbk),
		.ctxdetectrx(ctxdetectrx),
		.ctxelecidle(ctxelecidle),
		.ctxpmarstb(ctxpmarstb),
		.earlyeios(earlyeios),
		.frefi(frefi),
		.hclkpcsi(hclkpcsi),
		.icoeff(icoeff),
		.ltr(ltr),
		.pcieswdonei(pcieswdonei),
		.pcieswitch(pcieswitch),
		.pcsrxclkout(pcsrxclkout),
		.pcstxclkout(pcstxclkout),
		.pfdmodelocki(pfdmodelocki),
		.pldclk(pldclk),
		.ppmlock(ppmlock),
		.rxdetclk(rxdetclk),
		.rxdetectvalidi(rxdetectvalidi),
		.rxfoundi(rxfoundi),
		.rxplllocki(rxplllocki),
		.rxpmarstb(rxpmarstb),
		.sdi(sdi),
		.testbusi(testbusi),
		.testsel(testsel),
		.txdetectrx(txdetectrx),
		.txelecidle(txelecidle),
		.bslipo(bslipo),
		.clklow(clklow),
		.cpcieswdone(cpcieswdone),
		.cpclk(cpclk),
		.cpfdmodelock(cpfdmodelock),
		.crurstbo(crurstbo),
		.crxdetectvalid(crxdetectvalid),
		.crxfound(crxfound),
		.crxplllock(crxplllock),
		.csd(csd),
		.earlyeioso(earlyeioso),
		.fref(fref),
		.hclkpcs(hclkpcs),
		.icoeffo(icoeffo),
		.iqtxrxclka(iqtxrxclka),
		.iqtxrxclkb(iqtxrxclkb),
		.ltdo(ltdo),
		.ltro(ltro),
		.pcieswdone(pcieswdone),
		.pcieswitcho(pcieswitcho),
		.pfdmodelock(pfdmodelock),
		.pldclko(pldclko),
		.ppmlocko(ppmlocko),
		.rxdetclko(rxdetclko),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.rxplllock(rxplllock),
		.rxpmarstbo(rxpmarstbo),
		.sd(sd),
		.slpbko(slpbko),
		.testbus(testbus),
		.testselo(testselo),
		.txdetectrxo(txdetectrxo),
		.txelecidleo(txelecidleo),
		.txpmarstbo(txpmarstbo),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_rx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_rx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter cdrclk_to_cgb = "cdrclk_2cgb_dis",	//Valid values: cdrclk_2cgb_dis|cdrclk_2cgb_en
	parameter channel_number = 0,	//Valid values: 0..65
	parameter diagnostic_loopback = "diag_lpbk_off",	//Valid values: diag_lpbk_on|diag_lpbk_off
	parameter pdb_sd = "false",	//Valid values: false|true
	parameter rx_dc_gain = 0,	//Valid values: 0..1
	parameter sd_off = 1,	//Valid values: 0..29
	parameter sd_on = 1,	//Valid values: 0..16
	parameter sd_threshold = 3,	//Valid values: 0..7
	parameter term_sel = "100 ohms",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vcm_current_add = "vcm_current_1",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vcm_sel = "vtt_0p80v",	//Valid values: vtt_0p80v|vtt_0p75v|vtt_0p70v|vtt_0p65v|vtt_0p60v|vtt_0p55v|vtt_0p50v|vtt_0p35v|vtt_pup_weak|vtt_pdn_weak|tristate1|vtt_pdn_strong|vtt_pup_strong|tristate2|tristate3|tristate4
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter rx_sel_half_bw = "full_bw",	//Valid values: full_bw|half_bw
	parameter rx_acgain_a = "aref_volt_0",	//Valid values: aref_volt_0|aref_volt_0p5|aref_volt_0p75|aref_volt_1p0
	parameter rx_acgain_v = "vref_volt_1p0",	//Valid values: vref_volt_1p0|vref_volt_0p75|vref_volt_0p5|vref_volt_0
	parameter ct_equalizer_setting = 0,
// NOTE: This parameter was added by hand to deal with the recent addition of
// this parameter to the atom.  It does not require simulation support but
// needs to be here to prevent issues when handling the postfit netlist.
	parameter reverse_loopback = "reverse_lpbk_cdr"	//Valid values: reverse_lpbk_cdr|reverse_lpbk_rx
)
(
//input and output port declaration
	input [ 0:0 ] ck0sigdet,
	input [ 0:0 ] datain,
	input [ 0:0 ] hardoccalen,
	input [ 0:0 ] lpbkp,
	input [ 0:0 ] rstn,
	input [ 0:0 ] slpbk,
	output [ 0:0 ] dataout,
	input [ 0:0 ] nonuserfrompmaux,
	output [ 0:0 ] rdlpbkp,
	output [ 0:0 ] sd,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_rx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.cdrclk_to_cgb(cdrclk_to_cgb),
		.channel_number(channel_number),
		.diagnostic_loopback(diagnostic_loopback),
		.pdb_sd(pdb_sd),
		.rx_dc_gain(rx_dc_gain),
		.sd_off(sd_off),
		.sd_on(sd_on),
		.sd_threshold(sd_threshold),
		.term_sel(term_sel),
		.vcm_current_add(vcm_current_add),
		.vcm_sel(vcm_sel),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.rx_sel_half_bw(rx_sel_half_bw),
		.rx_acgain_a(rx_acgain_a),
		.rx_acgain_v(rx_acgain_v)

	)
	cyclonev_hssi_pma_rx_buf_encrypted_inst	(
		.ck0sigdet(ck0sigdet),
		.datain(datain),
		.hardoccalen(hardoccalen),
		.lpbkp(lpbkp),
		.rstn(rstn),
		.slpbk(slpbk),
		.dataout(dataout),
		.nonuserfrompmaux(nonuserfrompmaux),
		.rdlpbkp(rdlpbkp),
		.sd(sd),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_rx_deser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_rx_deser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter enable_bit_slip = "true",	//Valid values: false|true
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter sdclk_enable = "false",	//Valid values: false|true
	parameter vco_bypass = "vco_bypass_normal",	//Valid values: vco_bypass_normal|vco_bypass_normal_dont_care|clklow_to_clkdivrx|fref_to_clkdivrx
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter pma_direct = "false"	//Valid values: false|true
)
(
//input and output port declaration
	input [ 0:0 ] bslip,
	input [ 0:0 ] clk270b,
	input [ 0:0 ] clk90b,
	input [ 0:0 ] deven,
	input [ 0:0 ] dodd,
	input [ 0:0 ] pciesw,
	input [ 0:0 ] rstn,
	output [ 0:0 ] clkdivrx,
	output [ 0:0 ] clkdivrxrx,
	output [ 79:0 ] dout,
	output [ 0:0 ] pciel,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_rx_deser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.channel_number(channel_number),
		.clk_forward_only_mode(clk_forward_only_mode),
		.enable_bit_slip(enable_bit_slip),
		.mode(mode),
		.sdclk_enable(sdclk_enable),
		.vco_bypass(vco_bypass),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.pma_direct(pma_direct)

	)
	cyclonev_hssi_pma_rx_deser_encrypted_inst	(
		.bslip(bslip),
		.clk270b(clk270b),
		.clk90b(clk90b),
		.deven(deven),
		.dodd(dodd),
		.pciesw(pciesw),
		.rstn(rstn),
		.clkdivrx(clkdivrx),
		.clkdivrxrx(clkdivrxrx),
		.dout(dout),
		.pciel(pciel),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_tx_buf_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_tx_buf
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter channel_number = 0,	//Valid values: 0..65
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter common_mode_driver_sel = "volt_0p65v",	//Valid values: volt_0p80v|volt_0p75v|volt_0p70v|volt_0p65v|volt_0p60v|volt_0p55v|volt_0p50v|volt_0p35v|pull_up|pull_dn|tristated1|grounded|pull_up_to_vccela|tristated2|tristated3|tristated4
	parameter driver_resolution_ctrl = "disabled",	//Valid values: offset_main|offset_po1|conbination1|disabled
	parameter fir_coeff_ctrl_sel = "ram_ctl",	//Valid values: ram_ctl|dynamic_ctl
	parameter local_ib_ctl = "ib_29ohm",	//Valid values: ib_49ohm|ib_29ohm|ib_42ohm|ib_22ohm
	parameter lst = "atb_disabled",	//Valid values: atb_disabled|atb_0|atb_1|atb_2|atb_3|atb_4|atb_5|atb_6|atb_7|atb_8|atb_9|atb_10|atb_11|atb_12|atb_13|atb_14
	parameter pre_emp_switching_ctrl_1st_post_tap = 0,	//Valid values: 0..31
	parameter rx_det = 0,	//Valid values: 0..15
	parameter rx_det_pdb = "false",	//Valid values: false|true
	parameter slew_rate_ctrl = 5,	//Valid values: 1..5
	parameter swing_boost = "not_boost",	//Valid values: boost|not_boost
	parameter term_sel = "100 ohms",	//Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter vcm_current_addl = "vcm_current_1",	//Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter vod_boost = "not_boost",	//Valid values: boost|not_boost
	parameter vod_switching_ctrl_main_tap = 10,	//Valid values: 0..63
	parameter local_ib_en = "no_local_ib",	//Valid values: no_local_ib|local_ib
	parameter cml_en = "no_cml",	//Valid values: no_cml|cml
	parameter tx_powerdown = "normal_tx_on"		// Valid values: normal_tx_on|power_down_tx
	
)
(
//input and output port declaration
	input [ 0:0 ] avgvon,
	input [ 0:0 ] avgvop,
	input [ 0:0 ] datain,
	input [ 11:0 ] icoeff,
	input [ 0:0 ] rxdetclk,
	input [ 0:0 ] txdetrx,
	input [ 0:0 ] txelecidl,
	input [ 0:0 ] vrlpbkn,
	input [ 0:0 ] vrlpbkn1t,
	input [ 0:0 ] vrlpbkp,
	input [ 0:0 ] vrlpbkp1t,
	output [ 0:0 ] compass,
	output [ 0:0 ] dataout,
	output [ 1:0 ] detecton,
	output [ 0:0 ] fixedclkout,
	input [ 0:0 ] nonuserfrompmaux,
	output [ 0:0 ] probepass,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_tx_buf_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.channel_number(channel_number),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.common_mode_driver_sel(common_mode_driver_sel),
		.driver_resolution_ctrl(driver_resolution_ctrl),
		.fir_coeff_ctrl_sel(fir_coeff_ctrl_sel),
		.local_ib_ctl(local_ib_ctl),
		.lst(lst),
		.pre_emp_switching_ctrl_1st_post_tap(pre_emp_switching_ctrl_1st_post_tap),
		.rx_det(rx_det),
		.rx_det_pdb(rx_det_pdb),
		.slew_rate_ctrl(slew_rate_ctrl),
		.swing_boost(swing_boost),
		.term_sel(term_sel),
		.vcm_current_addl(vcm_current_addl),
		.vod_boost(vod_boost),
		.vod_switching_ctrl_main_tap(vod_switching_ctrl_main_tap),
		.local_ib_en(local_ib_en),
		.cml_en(cml_en)

	)
	cyclonev_hssi_pma_tx_buf_encrypted_inst	(
		.avgvon(avgvon),
		.avgvop(avgvop),
		.datain(datain),
		.icoeff(icoeff),
		.rxdetclk(rxdetclk),
		.txdetrx(txdetrx),
		.txelecidl(txelecidl),
		.vrlpbkn(vrlpbkn),
		.vrlpbkn1t(vrlpbkn1t),
		.vrlpbkp(vrlpbkp),
		.vrlpbkp1t(vrlpbkp1t),
		.compass(compass),
		.dataout(dataout),
		.detecton(detecton),
		.fixedclkout(fixedclkout),
		.nonuserfrompmaux(nonuserfrompmaux),
		.probepass(probepass),
		.rxdetectvalid(rxdetectvalid),
		.rxfound(rxfound),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_tx_cgb_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_tx_cgb
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter reserved_transmit_channel = "false",	//Valid values: false|true; this is for declaring dummy channels for AV Degradation issue only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter cgb_iqclk_sel = "tristate",	//Valid values: cgb_x1_n_div|rx_output|tristate
	parameter cgb_sync = "normal",	//Valid values: sync_rst|normal
	parameter channel_number = 0,	//Valid values: 0..255
	parameter clk_mute = "disable_clockmute",	//Valid values: disable_clockmute|enable_clock_mute|enable_clock_mute_master_channel
	parameter data_rate = "",	//Valid values: 
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter reset_scheme = "counter_reset_disable",	//Valid values: counter_reset_disable|counter_reset_enable
	parameter tx_mux_power_down = "normal",	//Valid values: power_down|normal
	parameter x1_clock_source_sel = "x1_clk_unused",	//Valid values: up_segmented|down_segmented|ffpll|ch1_txpll_t|ch1_txpll_b|same_ch_txpll|hfclk_xn_up|hfclk_ch1_x6_dn|hfclk_xn_dn|hfclk_ch1_x6_up|x1_clk_unused
	parameter x1_div_m_sel = 1,	//Valid values: 1|2|4|8
	parameter xn_clock_source_sel = "cgb_x1_m_div",	//Valid values: xn_up|ch1_x6_dn|xn_dn|ch1_x6_up|cgb_x1_m_div|cgb_xn_unused
	parameter pcie_rst = "normal_reset",	//Valid values: normal_reset|pcie_reset
	parameter fref_vco_bypass = "normal_operation",	//Valid values: normal_operation|fref_bypass
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter x1_clock0_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock1_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock2_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock3_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock4_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock5_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock6_logical_to_physical_mapping = "x1_clk_unused",	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
	parameter x1_clock7_logical_to_physical_mapping = "x1_clk_unused"	//Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|ffpll|up_segmented|down_segmented|hfclk_ch1_x6_up|hfclk_ch1_x6_dn|hfclk_xn_up|hfclk_xn_dn|x1_clk_unused
)
(
//input and output port declaration
	input [ 0:0 ] clkbcdr1b,
	input [ 0:0 ] clkbcdr1t,
	input [ 0:0 ] clkbcdrloc,
	input [ 0:0 ] clkbdnseg,
	input [ 0:0 ] clkbffpll,
	input [ 0:0 ] clkbupseg,
	input [ 0:0 ] clkcdr1b,
	input [ 0:0 ] clkcdr1t,
	input [ 0:0 ] clkcdrloc,
	input [ 0:0 ] clkdnseg,
	input [ 0:0 ] clkffpll,
	input [ 0:0 ] clkupseg,
	input [ 0:0 ] cpulsex6dn,
	input [ 0:0 ] cpulsex6up,
	input [ 0:0 ] cpulsexndn,
	input [ 0:0 ] cpulsexnup,
	input [ 0:0 ] hfclknx6dn,
	input [ 0:0 ] hfclknx6up,
	input [ 0:0 ] hfclknxndn,
	input [ 0:0 ] hfclknxnup,
	input [ 0:0 ] hfclkpx6dn,
	input [ 0:0 ] hfclkpx6up,
	input [ 0:0 ] hfclkpxndn,
	input [ 0:0 ] hfclkpxnup,
	input [ 0:0 ] lfclknx6dn,
	input [ 0:0 ] lfclknx6up,
	input [ 0:0 ] lfclknxndn,
	input [ 0:0 ] lfclknxnup,
	input [ 0:0 ] lfclkpx6dn,
	input [ 0:0 ] lfclkpx6up,
	input [ 0:0 ] lfclkpxndn,
	input [ 0:0 ] lfclkpxnup,
	input [ 0:0 ] pciesw,
	input [ 0:0 ] pclkx6dn,
	input [ 0:0 ] pclkx6up,
	input [ 0:0 ] pclkxndn,
	input [ 0:0 ] pclkxnup,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxclk,
	output [ 0:0 ] cpulse,
	output [ 0:0 ] cpulseout,
	output [ 0:0 ] hfclkn,
	output [ 0:0 ] hfclknout,
	output [ 0:0 ] hfclkp,
	output [ 0:0 ] hfclkpout,
	output [ 0:0 ] lfclkn,
	output [ 0:0 ] lfclknout,
	output [ 0:0 ] lfclkp,
	output [ 0:0 ] lfclkpout,
	output [ 0:0 ] pcieswdone,
	output [ 0:0 ] pciesyncp,
	output [ 2:0 ] pclk,
	output [ 0:0 ] pclkout,
	output [ 0:0 ] rxiqclk,
	input [ 0:0 ] fref,
	input [ 0:0 ] pcsrstn,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_pma_tx_cgb_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.cgb_iqclk_sel(cgb_iqclk_sel),
		.cgb_sync(cgb_sync),
		.channel_number(channel_number),
		.clk_mute(clk_mute),
		.data_rate(data_rate),
		.mode(mode),
		.reset_scheme(reset_scheme),
		.tx_mux_power_down(tx_mux_power_down),
		.x1_clock_source_sel(x1_clock_source_sel),
		.x1_div_m_sel(x1_div_m_sel),
		.xn_clock_source_sel(xn_clock_source_sel),
		.pcie_rst(pcie_rst),
		.fref_vco_bypass(fref_vco_bypass),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.x1_clock0_logical_to_physical_mapping(x1_clock0_logical_to_physical_mapping),
		.x1_clock1_logical_to_physical_mapping(x1_clock1_logical_to_physical_mapping),
		.x1_clock2_logical_to_physical_mapping(x1_clock2_logical_to_physical_mapping),
		.x1_clock3_logical_to_physical_mapping(x1_clock3_logical_to_physical_mapping),
		.x1_clock4_logical_to_physical_mapping(x1_clock4_logical_to_physical_mapping),
		.x1_clock5_logical_to_physical_mapping(x1_clock5_logical_to_physical_mapping),
		.x1_clock6_logical_to_physical_mapping(x1_clock6_logical_to_physical_mapping),
		.x1_clock7_logical_to_physical_mapping(x1_clock7_logical_to_physical_mapping)

	)
	cyclonev_hssi_pma_tx_cgb_encrypted_inst	(
		.clkbcdr1b(clkbcdr1b),
		.clkbcdr1t(clkbcdr1t),
		.clkbcdrloc(clkbcdrloc),
		.clkbdnseg(clkbdnseg),
		.clkbffpll(clkbffpll),
		.clkbupseg(clkbupseg),
		.clkcdr1b(clkcdr1b),
		.clkcdr1t(clkcdr1t),
		.clkcdrloc(clkcdrloc),
		.clkdnseg(clkdnseg),
		.clkffpll(clkffpll),
		.clkupseg(clkupseg),
		.cpulsex6dn(cpulsex6dn),
		.cpulsex6up(cpulsex6up),
		.cpulsexndn(cpulsexndn),
		.cpulsexnup(cpulsexnup),
		.hfclknx6dn(hfclknx6dn),
		.hfclknx6up(hfclknx6up),
		.hfclknxndn(hfclknxndn),
		.hfclknxnup(hfclknxnup),
		.hfclkpx6dn(hfclkpx6dn),
		.hfclkpx6up(hfclkpx6up),
		.hfclkpxndn(hfclkpxndn),
		.hfclkpxnup(hfclkpxnup),
		.lfclknx6dn(lfclknx6dn),
		.lfclknx6up(lfclknx6up),
		.lfclknxndn(lfclknxndn),
		.lfclknxnup(lfclknxnup),
		.lfclkpx6dn(lfclkpx6dn),
		.lfclkpx6up(lfclkpx6up),
		.lfclkpxndn(lfclkpxndn),
		.lfclkpxnup(lfclkpxnup),
		.pciesw(pciesw),
		.pclkx6dn(pclkx6dn),
		.pclkx6up(pclkx6up),
		.pclkxndn(pclkxndn),
		.pclkxnup(pclkxnup),
		.rstn(rstn),
		.rxclk(rxclk),
		.cpulse(cpulse),
		.cpulseout(cpulseout),
		.hfclkn(hfclkn),
		.hfclknout(hfclknout),
		.hfclkp(hfclkp),
		.hfclkpout(hfclkpout),
		.lfclkn(lfclkn),
		.lfclknout(lfclknout),
		.lfclkp(lfclkp),
		.lfclkpout(lfclkpout),
		.pcieswdone(pcieswdone),
		.pciesyncp(pciesyncp),
		.pclk(pclk),
		.pclkout(pclkout),
		.rxiqclk(rxiqclk),
		.fref(fref),
		.pcsrstn(pcsrstn),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_pma_tx_ser_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_pma_tx_ser
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter auto_negotiation = "false",	//Valid values: false|true
	parameter channel_number = 0,	//Valid values: 0..65
	parameter clk_divtx_deskew = 0,	//Valid values: 0..15
	parameter clk_forward_only_mode = "false",	//Valid values: false|true
	parameter [ 0:0 ] forced_data_mode = 1'b0,	//Valid values: 1
	parameter mode = 8,	//Valid values: 8|10|16|20|64|80
	parameter post_tap_1_en = "false",	//Valid values: false|true
	parameter ser_loopback = "false",	//Valid values: false|true
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter pma_direct = "false",	//Valid values: false|true
	parameter duty_cycle_tune = "duty_cycle3"	//Valid values: duty_cycle0|duty_cycle1|duty_cycle2|duty_cycle3|duty_cycle4|duty_cycle5|duty_cycle6|duty_cycle7
)
(
//input and output port declaration
	input [ 0:0 ] cpulse,
	input [ 79:0 ] datain,
	input [ 0:0 ] hfclk,
	input [ 0:0 ] hfclkn,
	input [ 0:0 ] lfclk,
	input [ 0:0 ] lfclkn,
	input [ 2:0 ] pclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] slpbk,
	output [ 0:0 ] clkdivtx,
	output [ 0:0 ] dataout,
	output [ 0:0 ] lbvop,
	output [ 0:0 ] preenout,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] avgvon,
	output [ 0:0 ] avgvop); 

	cyclonev_hssi_pma_tx_ser_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.auto_negotiation(auto_negotiation),
		.channel_number(channel_number),
		.clk_divtx_deskew(clk_divtx_deskew),
		.clk_forward_only_mode(clk_forward_only_mode),
		.forced_data_mode(forced_data_mode),
		.mode(mode),
		.post_tap_1_en(post_tap_1_en),
		.ser_loopback(ser_loopback),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.pma_direct(pma_direct),
		.duty_cycle_tune(duty_cycle_tune)

	)
	cyclonev_hssi_pma_tx_ser_encrypted_inst	(
		.cpulse(cpulse),
		.datain(datain),
		.hfclk(hfclk),
		.hfclkn(hfclkn),
		.lfclk(lfclk),
		.lfclkn(lfclkn),
		.pclk(pclk),
		.rstn(rstn),
		.slpbk(slpbk),
		.clkdivtx(clkdivtx),
		.dataout(dataout),
		.lbvop(lbvop),
		.preenout(preenout),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.avgvon(avgvon),
		.avgvop(avgvop)
	);


endmodule
`timescale 1 ps/1 ps

module    arriav_hssi_pma_cdr_refclk_select_mux    (
    calclk,
	refclklc,  //not supported
	occalen,  //not supported
    ffplloutbot,
    ffpllouttop,
    pldclk,
    refiqclk0,
    refiqclk1,
    refiqclk10,
    refiqclk2,
    refiqclk3,
    refiqclk4,
    refiqclk5,
    refiqclk6,
    refiqclk7,
    refiqclk8,
    refiqclk9,
    rxiqclk0,
    rxiqclk1,
    rxiqclk10,
    rxiqclk2,
    rxiqclk3,
    rxiqclk4,
    rxiqclk5,
    rxiqclk6,
    rxiqclk7,
    rxiqclk8,
    rxiqclk9,
    avmmclk,
    avmmrstn,
    avmmwrite,
    avmmread,
    avmmbyteen,
    avmmaddress,
    avmmwritedata,
    avmmreaddata,
    blockselect,
    clkout);

    parameter    lpm_type    =    "arriav_hssi_pma_cdr_refclk_select_mux";
    parameter    channel_number    =    0;
      // the mux_type parameter is used for dynamic reconfiguration
   // support. It specifies whethter this mux should listen to the
   // DPRIO memory space for the CDR REF CLK mux or for the LC REF CLK
   // mux
parameter mux_type = "cdr_refclk_select_mux"; // cdr_refclk_select_mux|lc_refclk_select_mux

parameter    refclk_select    =    "ref_iqclk0";
parameter    reference_clock_frequency    =    "0 ps";
parameter    avmm_group_channel_index = 0;
parameter    use_default_base_address = "true";
parameter    user_base_address = 0;

parameter inclk0_logical_to_physical_mapping = "";
parameter inclk1_logical_to_physical_mapping = "";
parameter inclk2_logical_to_physical_mapping = "";
parameter inclk3_logical_to_physical_mapping = "";
parameter inclk4_logical_to_physical_mapping = "";
parameter inclk5_logical_to_physical_mapping = "";
parameter inclk6_logical_to_physical_mapping = "";
parameter inclk7_logical_to_physical_mapping = "";
parameter inclk8_logical_to_physical_mapping = "";
parameter inclk9_logical_to_physical_mapping = "";
parameter inclk10_logical_to_physical_mapping = "";
parameter inclk11_logical_to_physical_mapping = "";
parameter inclk12_logical_to_physical_mapping = "";
parameter inclk13_logical_to_physical_mapping = "";
parameter inclk14_logical_to_physical_mapping = "";
parameter inclk15_logical_to_physical_mapping = "";
parameter inclk16_logical_to_physical_mapping = "";
parameter inclk17_logical_to_physical_mapping = "";
parameter inclk18_logical_to_physical_mapping = "";
parameter inclk19_logical_to_physical_mapping = "";
parameter inclk20_logical_to_physical_mapping = "";
parameter inclk21_logical_to_physical_mapping = "";
parameter inclk22_logical_to_physical_mapping = "";
parameter inclk23_logical_to_physical_mapping = "";
parameter inclk24_logical_to_physical_mapping = "";
parameter inclk25_logical_to_physical_mapping = "";
   



    input         calclk;
	input         refclklc;  //not supported
	input         occalen;  //not supported
    input         ffplloutbot;
    input         ffpllouttop;
    input         pldclk;
    input         refiqclk0;
    input         refiqclk1;
    input         refiqclk10;
    input         refiqclk2;
    input         refiqclk3;
    input         refiqclk4;
    input         refiqclk5;
    input         refiqclk6;
    input         refiqclk7;
    input         refiqclk8;
    input         refiqclk9;
    input         rxiqclk0;
    input         rxiqclk1;
    input         rxiqclk10;
    input         rxiqclk2;
    input         rxiqclk3;
    input         rxiqclk4;
    input         rxiqclk5;
    input         rxiqclk6;
    input         rxiqclk7;
    input         rxiqclk8;
    input         rxiqclk9;
    input         avmmclk;
    input         avmmrstn;
    input         avmmwrite;
    input         avmmread;
    input  [ 1:0] avmmbyteen;
    input  [10:0] avmmaddress;
    input  [15:0] avmmwritedata;
    output [15:0] avmmreaddata;
    output        blockselect;
    output        clkout;

    cyclonev_hssi_pma_cdr_refclk_select_mux_encrypted  
    #(
    .lpm_type(lpm_type),
    .channel_number(channel_number),
    .refclk_select(refclk_select),
    .reference_clock_frequency(reference_clock_frequency),
    .avmm_group_channel_index(avmm_group_channel_index),
    .use_default_base_address(use_default_base_address),
    .user_base_address(user_base_address),
    .inclk0_logical_to_physical_mapping(inclk0_logical_to_physical_mapping),
    .inclk1_logical_to_physical_mapping(inclk1_logical_to_physical_mapping),
    .inclk2_logical_to_physical_mapping(inclk2_logical_to_physical_mapping),
    .inclk3_logical_to_physical_mapping(inclk3_logical_to_physical_mapping),
    .inclk4_logical_to_physical_mapping(inclk4_logical_to_physical_mapping),
    .inclk5_logical_to_physical_mapping(inclk5_logical_to_physical_mapping),
    .inclk6_logical_to_physical_mapping(inclk6_logical_to_physical_mapping),
    .inclk7_logical_to_physical_mapping(inclk7_logical_to_physical_mapping),
    .inclk8_logical_to_physical_mapping(inclk8_logical_to_physical_mapping),
    .inclk9_logical_to_physical_mapping(inclk9_logical_to_physical_mapping),
    .inclk10_logical_to_physical_mapping(inclk10_logical_to_physical_mapping),
    .inclk11_logical_to_physical_mapping(inclk11_logical_to_physical_mapping),
    .inclk12_logical_to_physical_mapping(inclk12_logical_to_physical_mapping),
    .inclk13_logical_to_physical_mapping(inclk13_logical_to_physical_mapping)
    ) inst (
        .calclk(calclk),
		.refclklc(refclklc),
		.occalen(occalen),
        .ffplloutbot(ffplloutbot),
        .ffpllouttop(ffpllouttop),
        .pldclk(pldclk),
        .refiqclk0(refiqclk0),
        .refiqclk1(refiqclk1),
        .refiqclk10(refiqclk10),
        .refiqclk2(refiqclk2),
        .refiqclk3(refiqclk3),
        .refiqclk4(refiqclk4),
        .refiqclk5(refiqclk5),
        .refiqclk6(refiqclk6),
        .refiqclk7(refiqclk7),
        .refiqclk8(refiqclk8),
        .refiqclk9(refiqclk9),
        .rxiqclk0(rxiqclk0),
        .rxiqclk1(rxiqclk1),
        .rxiqclk10(rxiqclk10),
        .rxiqclk2(rxiqclk2),
        .rxiqclk3(rxiqclk3),
        .rxiqclk4(rxiqclk4),
        .rxiqclk5(rxiqclk5),
        .rxiqclk6(rxiqclk6),
        .rxiqclk7(rxiqclk7),
        .rxiqclk8(rxiqclk8),
        .rxiqclk9(rxiqclk9),
		.avmmclk(avmmclk),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmread(avmmread),
		.avmmbyteen(avmmbyteen),
		.avmmaddress(avmmaddress),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clkout(clkout) );
    
   // need to add assignment for the rest of the parameter assignments
   

endmodule //arriav_hssi_pma_cdr_refclk_select_mux

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_rx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_rx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter clkslip_sel = "pld",	//Valid values: pld|slip_eight_g_pcs
	parameter prot_mode = "other_protocols",	//Valid values: other_protocols|cpri_8g
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] pcs8grxclkiqout,
	input [ 0:0 ] pcs8grxclkslip,
	input [ 0:0 ] pldrxclkslip,
	input [ 0:0 ] pldrxpmarstb,
	input [ 4:0 ] pmareservedin,
	input [ 79:0 ] datainfrompma,
	input [ 0:0 ] pmarxpllphaselockin,
	input [ 0:0 ] clockinfrompma,
	input [ 0:0 ] pmasigdet,
	output [ 19:0 ] dataoutto8gpcs,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 0:0 ] pcs8gsigdetni,
	output [ 4:0 ] pmareservedout,
	output [ 0:0 ] pmarxclkout,
	output [ 0:0 ] pmarxpllphaselockout,
	output [ 0:0 ] pmarxclkslip,
	output [ 0:0 ] pmarxpmarstb,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_rx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.clkslip_sel(clkslip_sel),
		.prot_mode(prot_mode),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_rx_pcs_pma_interface_encrypted_inst	(
		.pcs8grxclkiqout(pcs8grxclkiqout),
		.pcs8grxclkslip(pcs8grxclkslip),
		.pldrxclkslip(pldrxclkslip),
		.pldrxpmarstb(pldrxpmarstb),
		.pmareservedin(pmareservedin),
		.datainfrompma(datainfrompma),
		.pmarxpllphaselockin(pmarxpllphaselockin),
		.clockinfrompma(clockinfrompma),
		.pmasigdet(pmasigdet),
		.dataoutto8gpcs(dataoutto8gpcs),
		.clockoutto8gpcs(clockoutto8gpcs),
		.pcs8gsigdetni(pcs8gsigdetni),
		.pmareservedout(pmareservedout),
		.pmarxclkout(pmarxclkout),
		.pmarxpllphaselockout(pmarxpllphaselockout),
		.pmarxclkslip(pmarxclkslip),
		.pmarxpmarstb(pmarxpmarstb),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_rx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_rx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter pcs_side_block_sel = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] emsipenablediocsrrdydly,
	input [ 12:0 ] emsiprxspecialin,
	input [ 3:0 ] pcs8ga1a2k1k2flag,
	input [ 0:0 ] pcs8galignstatus,
	input [ 0:0 ] pcs8gbistdone,
	input [ 0:0 ] pcs8gbisterr,
	input [ 0:0 ] pcs8gbyteordflag,
	input [ 0:0 ] pcs8gemptyrmf,
	input [ 0:0 ] pcs8gemptyrx,
	input [ 0:0 ] pcs8gfullrmf,
	input [ 0:0 ] pcs8gfullrx,
	input [ 0:0 ] pcs8grlvlt,
	input [ 0:0 ] clockinfrom8gpcs,
	input [ 3:0 ] pcs8grxdatavalid,
	input [ 63:0 ] datainfrom8gpcs,
	input [ 0:0 ] pcs8gsignaldetectout,
	input [ 4:0 ] pcs8gwaboundary,
	input [ 0:0 ] pld8ga1a2size,
	input [ 0:0 ] pld8gbitlocreven,
	input [ 0:0 ] pld8gbitslip,
	input [ 0:0 ] pld8gbytereven,
	input [ 0:0 ] pld8gbytordpld,
	input [ 0:0 ] pld8gcmpfifourstn,
	input [ 0:0 ] pld8gencdt,
	input [ 0:0 ] pld8gphfifourstrxn,
	input [ 0:0 ] pld8gpldrxclk,
	input [ 0:0 ] pld8gpolinvrx,
	input [ 0:0 ] pld8grdenablermf,
	input [ 0:0 ] pld8grdenablerx,
	input [ 0:0 ] pld8grxurstpcsn,
	input [ 0:0 ] pld8gwrdisablerx,
	input [ 0:0 ] pld8gwrenablermf,
	input [ 0:0 ] pldrxclkslipin,
	input [ 0:0 ] pldrxpmarstbin,
	input [ 0:0 ] pld8gsyncsmeninput,
	input [ 0:0 ] pmarxplllock,
	input [ 0:0 ] rstsel,
	input [ 0:0 ] usrrstsel,
	output [ 128:0 ] emsiprxout,
	output [ 15:0 ] emsiprxspecialout,
	output [ 0:0 ] pcs8ga1a2size,
	output [ 0:0 ] pcs8gbitlocreven,
	output [ 0:0 ] pcs8gbitslip,
	output [ 0:0 ] pcs8gbytereven,
	output [ 0:0 ] pcs8gbytordpld,
	output [ 0:0 ] pcs8gcmpfifourst,
	output [ 0:0 ] pcs8gencdt,
	output [ 0:0 ] pcs8gphfifourstrx,
	output [ 0:0 ] pcs8gpldrxclk,
	output [ 0:0 ] pcs8gpolinvrx,
	output [ 0:0 ] pcs8grdenablermf,
	output [ 0:0 ] pcs8grdenablerx,
	output [ 0:0 ] pcs8grxurstpcs,
	output [ 0:0 ] pcs8gsyncsmenoutput,
	output [ 0:0 ] pcs8gwrdisablerx,
	output [ 0:0 ] pcs8gwrenablermf,
	output [ 3:0 ] pld8ga1a2k1k2flag,
	output [ 0:0 ] pld8galignstatus,
	output [ 0:0 ] pld8gbistdone,
	output [ 0:0 ] pld8gbisterr,
	output [ 0:0 ] pld8gbyteordflag,
	output [ 0:0 ] pld8gemptyrmf,
	output [ 0:0 ] pld8gemptyrx,
	output [ 0:0 ] pld8gfullrmf,
	output [ 0:0 ] pld8gfullrx,
	output [ 0:0 ] pld8grlvlt,
	output [ 0:0 ] pld8grxclkout,
	output [ 3:0 ] pld8grxdatavalid,
	output [ 0:0 ] pld8gsignaldetectout,
	output [ 4:0 ] pld8gwaboundary,
	output [ 0:0 ] pldrxclkslipout,
	output [ 63:0 ] dataouttopld,
	output [ 0:0 ] pldrxpmarstbout,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_rx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_8g_0ppm(is_8g_0ppm),
		.pcs_side_block_sel(pcs_side_block_sel),
		.pld_side_data_source(pld_side_data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_rx_pld_pcs_interface_encrypted_inst	(
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.emsiprxspecialin(emsiprxspecialin),
		.pcs8ga1a2k1k2flag(pcs8ga1a2k1k2flag),
		.pcs8galignstatus(pcs8galignstatus),
		.pcs8gbistdone(pcs8gbistdone),
		.pcs8gbisterr(pcs8gbisterr),
		.pcs8gbyteordflag(pcs8gbyteordflag),
		.pcs8gemptyrmf(pcs8gemptyrmf),
		.pcs8gemptyrx(pcs8gemptyrx),
		.pcs8gfullrmf(pcs8gfullrmf),
		.pcs8gfullrx(pcs8gfullrx),
		.pcs8grlvlt(pcs8grlvlt),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pcs8grxdatavalid(pcs8grxdatavalid),
		.datainfrom8gpcs(datainfrom8gpcs),
		.pcs8gsignaldetectout(pcs8gsignaldetectout),
		.pcs8gwaboundary(pcs8gwaboundary),
		.pld8ga1a2size(pld8ga1a2size),
		.pld8gbitlocreven(pld8gbitlocreven),
		.pld8gbitslip(pld8gbitslip),
		.pld8gbytereven(pld8gbytereven),
		.pld8gbytordpld(pld8gbytordpld),
		.pld8gcmpfifourstn(pld8gcmpfifourstn),
		.pld8gencdt(pld8gencdt),
		.pld8gphfifourstrxn(pld8gphfifourstrxn),
		.pld8gpldrxclk(pld8gpldrxclk),
		.pld8gpolinvrx(pld8gpolinvrx),
		.pld8grdenablermf(pld8grdenablermf),
		.pld8grdenablerx(pld8grdenablerx),
		.pld8grxurstpcsn(pld8grxurstpcsn),
		.pld8gwrdisablerx(pld8gwrdisablerx),
		.pld8gwrenablermf(pld8gwrenablermf),
		.pldrxclkslipin(pldrxclkslipin),
		.pldrxpmarstbin(pldrxpmarstbin),
		.pld8gsyncsmeninput(pld8gsyncsmeninput),
		.pmarxplllock(pmarxplllock),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.emsiprxout(emsiprxout),
		.emsiprxspecialout(emsiprxspecialout),
		.pcs8ga1a2size(pcs8ga1a2size),
		.pcs8gbitlocreven(pcs8gbitlocreven),
		.pcs8gbitslip(pcs8gbitslip),
		.pcs8gbytereven(pcs8gbytereven),
		.pcs8gbytordpld(pcs8gbytordpld),
		.pcs8gcmpfifourst(pcs8gcmpfifourst),
		.pcs8gencdt(pcs8gencdt),
		.pcs8gphfifourstrx(pcs8gphfifourstrx),
		.pcs8gpldrxclk(pcs8gpldrxclk),
		.pcs8gpolinvrx(pcs8gpolinvrx),
		.pcs8grdenablermf(pcs8grdenablermf),
		.pcs8grdenablerx(pcs8grdenablerx),
		.pcs8grxurstpcs(pcs8grxurstpcs),
		.pcs8gsyncsmenoutput(pcs8gsyncsmenoutput),
		.pcs8gwrdisablerx(pcs8gwrdisablerx),
		.pcs8gwrenablermf(pcs8gwrenablermf),
		.pld8ga1a2k1k2flag(pld8ga1a2k1k2flag),
		.pld8galignstatus(pld8galignstatus),
		.pld8gbistdone(pld8gbistdone),
		.pld8gbisterr(pld8gbisterr),
		.pld8gbyteordflag(pld8gbyteordflag),
		.pld8gemptyrmf(pld8gemptyrmf),
		.pld8gemptyrx(pld8gemptyrx),
		.pld8gfullrmf(pld8gfullrmf),
		.pld8gfullrx(pld8gfullrx),
		.pld8grlvlt(pld8grlvlt),
		.pld8grxclkout(pld8grxclkout),
		.pld8grxdatavalid(pld8grxdatavalid),
		.pld8gsignaldetectout(pld8gsignaldetectout),
		.pld8gwaboundary(pld8gwaboundary),
		.pldrxclkslipout(pldrxclkslipout),
		.dataouttopld(dataouttopld),
		.pldrxpmarstbout(pldrxpmarstbout),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_tx_pcs_pma_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_tx_pcs_pma_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter selectpcs = "eight_g_pcs",	//Valid values: eight_g_pcs|default
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 19:0 ] datainfrom8gpcs,
	input [ 0:0 ] pcs8gtxclkiqout,
	input [ 0:0 ] pmarxfreqtxcmuplllockin,
	input [ 0:0 ] clockinfrompma,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 0:0 ] pmarxfreqtxcmuplllockout,
	output [ 0:0 ] pmatxclkout,
	output [ 79:0 ] dataouttopma,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_tx_pcs_pma_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.selectpcs(selectpcs),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_tx_pcs_pma_interface_encrypted_inst	(
		.datainfrom8gpcs(datainfrom8gpcs),
		.pcs8gtxclkiqout(pcs8gtxclkiqout),
		.pmarxfreqtxcmuplllockin(pmarxfreqtxcmuplllockin),
		.clockinfrompma(clockinfrompma),
		.clockoutto8gpcs(clockoutto8gpcs),
		.pmarxfreqtxcmuplllockout(pmarxfreqtxcmuplllockout),
		.pmatxclkout(pmatxclkout),
		.dataouttopma(dataouttopma),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_hssi_tx_pld_pcs_interface_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_tx_pld_pcs_interface
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter is_8g_0ppm = "false",	//Valid values: false|true
	parameter pld_side_data_source = "pld",	//Valid values: hip|pld
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] emsipenablediocsrrdydly,
	input [ 103:0 ] emsiptxin,
	input [ 12:0 ] emsiptxspecialin,
	input [ 0:0 ] pcs8gemptytx,
	input [ 0:0 ] pcs8gfulltx,
	input [ 0:0 ] clockinfrom8gpcs,
	input [ 0:0 ] pld8gphfifoursttxn,
	input [ 0:0 ] pld8gpldtxclk,
	input [ 0:0 ] pld8gpolinvtx,
	input [ 0:0 ] pld8grddisabletx,
	input [ 0:0 ] pld8grevloopbk,
	input [ 4:0 ] pld8gtxboundarysel,
	input [ 3:0 ] pld8gtxdatavalid,
	input [ 0:0 ] pld8gtxurstpcsn,
	input [ 0:0 ] pld8gwrenabletx,
	input [ 43:0 ] datainfrompld,
	input [ 0:0 ] pmatxcmuplllock,
	input [ 0:0 ] rstsel,
	input [ 0:0 ] usrrstsel,
	output [ 2:0 ] emsippcstxclkout,
	output [ 15:0 ] emsiptxspecialout,
	output [ 0:0 ] pcs8gphfifoursttx,
	output [ 0:0 ] pcs8gpldtxclk,
	output [ 0:0 ] pcs8gpolinvtx,
	output [ 0:0 ] pcs8grddisabletx,
	output [ 0:0 ] pcs8grevloopbk,
	output [ 4:0 ] pcs8gtxboundarysel,
	output [ 3:0 ] pcs8gtxdatavalid,
	output [ 43:0 ] dataoutto8gpcs,
	output [ 0:0 ] pcs8gtxurstpcs,
	output [ 0:0 ] pcs8gwrenabletx,
	output [ 0:0 ] pld8gemptytx,
	output [ 0:0 ] pld8gfulltx,
	output [ 0:0 ] pld8gtxclkout,
	output [ 0:0 ] asynchdatain,
	output [ 0:0 ] reset,
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect); 

	cyclonev_hssi_tx_pld_pcs_interface_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.is_8g_0ppm(is_8g_0ppm),
		.pld_side_data_source(pld_side_data_source),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	cyclonev_hssi_tx_pld_pcs_interface_encrypted_inst	(
		.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
		.emsiptxin(emsiptxin),
		.emsiptxspecialin(emsiptxspecialin),
		.pcs8gemptytx(pcs8gemptytx),
		.pcs8gfulltx(pcs8gfulltx),
		.clockinfrom8gpcs(clockinfrom8gpcs),
		.pld8gphfifoursttxn(pld8gphfifoursttxn),
		.pld8gpldtxclk(pld8gpldtxclk),
		.pld8gpolinvtx(pld8gpolinvtx),
		.pld8grddisabletx(pld8grddisabletx),
		.pld8grevloopbk(pld8grevloopbk),
		.pld8gtxboundarysel(pld8gtxboundarysel),
		.pld8gtxdatavalid(pld8gtxdatavalid),
		.pld8gtxurstpcsn(pld8gtxurstpcsn),
		.pld8gwrenabletx(pld8gwrenabletx),
		.datainfrompld(datainfrompld),
		.pmatxcmuplllock(pmatxcmuplllock),
		.rstsel(rstsel),
		.usrrstsel(usrrstsel),
		.emsippcstxclkout(emsippcstxclkout),
		.emsiptxspecialout(emsiptxspecialout),
		.pcs8gphfifoursttx(pcs8gphfifoursttx),
		.pcs8gpldtxclk(pcs8gpldtxclk),
		.pcs8gpolinvtx(pcs8gpolinvtx),
		.pcs8grddisabletx(pcs8grddisabletx),
		.pcs8grevloopbk(pcs8grevloopbk),
		.pcs8gtxboundarysel(pcs8gtxboundarysel),
		.pcs8gtxdatavalid(pcs8gtxdatavalid),
		.dataoutto8gpcs(dataoutto8gpcs),
		.pcs8gtxurstpcs(pcs8gtxurstpcs),
		.pcs8gwrenabletx(pcs8gwrenabletx),
		.pld8gemptytx(pld8gemptytx),
		.pld8gfulltx(pld8gfulltx),
		.pld8gtxclkout(pld8gtxclkout),
		.asynchdatain(asynchdatain),
		.reset(reset),
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect)
	);


endmodule

`timescale 1 ps/1 ps

module arriav_hssi_refclk_divider 
  #(  
      parameter lpm_type                    = "arriav_hssi_refclk_divider",
      parameter divide_by                   =  1,
      parameter enabled                     = "true",
      parameter refclk_coupling_termination = "normal_100_ohm_termination"
  ) (
  input    [0:0]       refclkin,
  output   [0:0]       refclkout,
  input    [0:0]       nonuserfrompmaux
);

	cyclonev_hssi_refclk_divider_encrypted 
		#(
			.lpm_type(lpm_type),
			.divide_by(divide_by),
			.enabled(enabled),
			.refclk_coupling_termination(refclk_coupling_termination)
		)
	cyclonev_hssi_refclk_divider_encrypted_inst (
			.refclkin(refclkin),
			.refclkout(refclkout),
			.nonuserfrompmaux(nonuserfrompmaux)
		);
	

endmodule
module arriav_pll_aux
(
 input atb0out,
 input atb1out,
 output atbcompout 
 );


parameter lpm_type = "arriav_pll_aux";
parameter pl_aux_atb_atben0_precomp =  01'b1 ;
parameter pl_aux_atb_atben1_precomp =  01'b1 ;
parameter pl_aux_atb_comp_minus =  01'b0 ;
parameter pl_aux_atb_comp_plus =  01'b0 ;
parameter pl_aux_comp_pwr_dn =  01'b1 ;

assign atbcompout= 01'b0;

   /* empty */

endmodule

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : arriav_channel_pll_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_channel_pll
#(
	parameter sim_use_fast_model = "true",
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
        
        parameter cvp_en_iocsr = "false", //valid values: true|false
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter output_clock_frequency = "",	//Valid values: 
	parameter enabled_for_reconfig = "false",	//Valid values: false|true
	parameter bbpd_salatch_offset_ctrl_clk0 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk180 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk270 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk90 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_rightoffset_delta7_right
	parameter bbpd_salatch_sel = "normal",	//Valid values: testmux|normal
	parameter bypass_cp_rgla = "false",	//Valid values: true|false
	parameter cdr_atb_select = "atb_disable",	//Valid values: atb_disable|atb_sel_1|atb_sel_2|atb_sel_3|atb_sel_4|atb_sel_5|atb_sel_6|atb_sel_7|atb_sel_8|atb_sel_9|atb_sel_10|atb_sel_11|atb_sel_12|atb_sel_13|atb_sel_14
	parameter cgb_clk_enable = "false",	//Valid values: false|true
	parameter charge_pump_current_test = "enable_ch_pump_normal",	//Valid values: enable_ch_pump_normal|enable_ch_pump_curr_test_up|enable_ch_pump_curr_test_down|disable_ch_pump_curr_test
	parameter clklow_fref_to_ppm_div_sel = 1,	//Valid values: 1|2
	parameter clock_monitor = "lpbk_data",	//Valid values: lpbk_clk|lpbk_data
	parameter diag_rev_lpbk = "false",	//Valid values: false|true
	parameter enable_gpon_detection = "false",	//Valid values: false|true
	parameter fast_lock_mode = "true",	//Valid values: false|true
	parameter fb_sel = "vcoclk",	//Valid values: vcoclk|extclk
	parameter hs_levshift_power_supply_setting = 1,	//Valid values: 0|1|2|3
	parameter ignore_phslock = "false",	//Valid values: true|false
	parameter l_counter_pd_clock_disable = "false",	//Valid values: false|true
	parameter m_counter = -1,	//Valid values: 1|4|5|8|10|12|16|20|25|32|40|50
	parameter pcie_freq_control = "pcie_100mhz",	//Valid values: pcie_100mhz|pcie_125mhz
	parameter pd_charge_pump_current_ctrl = 5,	//Valid values: 5|10|20|30|40
	parameter pd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter pfd_charge_pump_current_ctrl = 20,	//Valid values: 5|10|20|30|40|50|60|80|100|120
	parameter pfd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter powerdown = "false",	//Valid values: false|true
	parameter ref_clk_div = -1,	//Valid values: 1|2|4|8
	parameter regulator_volt_inc = "0",	//Valid values: 0|5|10|15|20|25|30|not_used
	parameter replica_bias_ctrl = "true",	//Valid values: true|false
	parameter reverse_serial_lpbk = "false",	//Valid values: false|true
	parameter ripple_cap_ctrl = "none",	//Valid values: reserved_11|reserved_10|plus_2pf|none
	parameter rxpll_pd_bw_ctrl = 300,	//Valid values: 600|300|240|170
	parameter rxpll_pfd_bw_ctrl = 3200,	//Valid values: 1600|3200|4800|6400
	parameter txpll_hclk_driver_enable = "false",	//Valid values: false|true
	parameter vco_overange_ref = "ref_2",	//Valid values: off|ref_1|ref_2|ref_3
	parameter vco_range_ctrl_en = "true"	//Valid values: true|false
)
(
//input and output port declaration
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	input [ 0:0 ] clkindeser,
	input [ 0:0 ] crurstb,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] extclk,
	input [ 0:0 ] lpbkpreen,
	input [ 0:0 ] ltd,
	input [ 0:0 ] ltr,
	input [ 0:0 ] occalen,
	input [ 0:0 ] pciel,
	input [ 1:0 ] pciesw,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] refclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxp,
	input [ 0:0 ] sd,
	output [ 0:0 ] ck0pd,
	output [ 0:0 ] ck180pd,
	output [ 0:0 ] ck270pd,
	output [ 0:0 ] ck90pd,
	output [ 0:0 ] clk270bdes,
	output [ 0:0 ] clk90bdes,
	output [ 0:0 ] clkcdr,
	output [ 0:0 ] clklow,
	output [ 0:0 ] deven,
	output [ 0:0 ] dodd,
	output [ 0:0 ] fref,
	output [ 3:0 ] pdof,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] rxlpbdp,
	output [ 0:0 ] rxlpbp,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] txpllhclk,
	output [ 0:0 ] txrlpbk,
	output [ 0:0 ] vctrloverrange); 

	cyclonev_channel_pll_encrypted 
	#(
		.sim_use_fast_model(sim_use_fast_model),
		.enable_debug_info(enable_debug_info),

		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
		.reference_clock_frequency(reference_clock_frequency),
		.output_clock_frequency(output_clock_frequency),
		.enabled_for_reconfig(enabled_for_reconfig),
		.bbpd_salatch_offset_ctrl_clk0(bbpd_salatch_offset_ctrl_clk0),
		.bbpd_salatch_offset_ctrl_clk180(bbpd_salatch_offset_ctrl_clk180),
		.bbpd_salatch_offset_ctrl_clk270(bbpd_salatch_offset_ctrl_clk270),
		.bbpd_salatch_offset_ctrl_clk90(bbpd_salatch_offset_ctrl_clk90),
		.bbpd_salatch_sel(bbpd_salatch_sel),
		.bypass_cp_rgla(bypass_cp_rgla),
		.cdr_atb_select(cdr_atb_select),
		.cgb_clk_enable(cgb_clk_enable),
		.charge_pump_current_test(charge_pump_current_test),
		.clklow_fref_to_ppm_div_sel(clklow_fref_to_ppm_div_sel),
		.clock_monitor(clock_monitor),
		.diag_rev_lpbk(diag_rev_lpbk),
		.enable_gpon_detection(enable_gpon_detection),
		.fast_lock_mode(fast_lock_mode),
		.fb_sel(fb_sel),
		.hs_levshift_power_supply_setting(hs_levshift_power_supply_setting),
		.ignore_phslock(ignore_phslock),
		.l_counter_pd_clock_disable(l_counter_pd_clock_disable),
		.m_counter(m_counter),
		.pcie_freq_control(pcie_freq_control),
		.pd_charge_pump_current_ctrl(pd_charge_pump_current_ctrl),
		.pd_l_counter(pd_l_counter),
		.pfd_charge_pump_current_ctrl(pfd_charge_pump_current_ctrl),
		.pfd_l_counter(pfd_l_counter),
		.powerdown(powerdown),
		.ref_clk_div(ref_clk_div),
		.regulator_volt_inc(regulator_volt_inc),
		.replica_bias_ctrl(replica_bias_ctrl),
		.reverse_serial_lpbk(reverse_serial_lpbk),
		.ripple_cap_ctrl(ripple_cap_ctrl),
		.rxpll_pd_bw_ctrl(rxpll_pd_bw_ctrl),
		.rxpll_pfd_bw_ctrl(rxpll_pfd_bw_ctrl),
		.txpll_hclk_driver_enable(txpll_hclk_driver_enable),
		.vco_overange_ref(vco_overange_ref),
		.vco_range_ctrl_en(vco_range_ctrl_en)

	)
	cyclonev_channel_pll_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clkindeser(clkindeser),
		.crurstb(crurstb),
		.earlyeios(earlyeios),
		.extclk(extclk),
		.lpbkpreen(lpbkpreen),
		.ltd(ltd),
		.ltr(ltr),
		.occalen(occalen),
		.pciel(pciel),
		.pciesw(pciesw),
		.ppmlock(ppmlock),
		.refclk(refclk),
		.rstn(rstn),
		.rxp(rxp),
		.sd(sd),
		.ck0pd(ck0pd),
		.ck180pd(ck180pd),
		.ck270pd(ck270pd),
		.ck90pd(ck90pd),
		.clk270bdes(clk270bdes),
		.clk90bdes(clk90bdes),
		.clkcdr(clkcdr),
		.clklow(clklow),
		.deven(deven),
		.dodd(dodd),
		.fref(fref),
		.pdof(pdof),
		.pfdmodelock(pfdmodelock),
		.rxlpbdp(rxlpbdp),
		.rxlpbp(rxlpbp),
		.rxplllock(rxplllock),
		.txpllhclk(txpllhclk),
		.txrlpbk(txrlpbk),
		.vctrloverrange(vctrloverrange)
	);


endmodule
// ----------------------------------------------------------------------------------
// This is the HSSI Simulation Atom Model Encryption wrapper for the AVMM Interface
// Module Name : arriav_hssi_avmm_interface
// ----------------------------------------------------------------------------------

`timescale 1 ps/1 ps
module arriav_hssi_avmm_interface
  #(
    parameter num_ch0_atoms = 0,
    parameter num_ch1_atoms = 0,
    parameter num_ch2_atoms = 0
    )
(
//input and output port declaration
    input  wire                 avmmrstn,
    input  wire                 avmmclk,
    input  wire                 avmmwrite,
    input  wire                 avmmread,
    input  wire  [ 1:0 ]        avmmbyteen,
    input  wire  [ 10:0 ]       avmmaddress,
    input  wire  [ 15:0 ]       avmmwritedata,
    input  wire  [ 90-1:0 ]     blockselect,
    input  wire  [ 90*16 -1:0 ] readdatachnl,

    output wire  [ 15:0 ]       avmmreaddata,

    output wire                 clkchnl,
    output wire                 rstnchnl,
    output wire  [ 15:0 ]       writedatachnl,
    output wire  [ 10:0 ]       regaddrchnl,
    output wire                 writechnl,
    output wire                 readchnl,
    output wire  [ 1:0 ]        byteenchnl,

    //The following ports are not modelled. They exist to match the avmm interface atom interface
    input  wire                 refclkdig,
    input  wire                 avmmreservedin,
    
    output wire                 avmmreservedout,
    output wire                 dpriorstntop,
    output wire                 dprioclktop,
    output wire                 mdiodistopchnl,
    output wire                 dpriorstnmid,
    output wire                 dprioclkmid,
    output wire                 mdiodismidchnl,
    output wire                 dpriorstnbot,
    output wire                 dprioclkbot,
    output wire                 mdiodisbotchnl,
    output wire  [ 3:0 ]        dpriotestsitopchnl,
    output wire  [ 3:0 ]        dpriotestsimidchnl,
    output wire  [ 3:0 ]        dpriotestsibotchnl,
 
    //The following ports belong to pm_adce and pm_tst_mux blocks in the PMA
    input  wire  [ 11:0 ]       pmatestbussel,
    output wire  [ 23:0 ]       pmatestbus,
  
    //
    input  wire                 scanmoden,
    input  wire                 scanshiftn,
    input  wire                 interfacesel,
    input  wire                 sershiftload
); 

  cyclonev_hssi_avmm_interface_encrypted
  #(
    .num_ch0_atoms(num_ch0_atoms),
    .num_ch1_atoms(num_ch1_atoms),
    .num_ch2_atoms(num_ch2_atoms)
  ) stratixv_hssi_avmm_interface_encrypted_inst (
    .avmmrstn          (avmmrstn),
    .avmmclk           (avmmclk),
    .avmmwrite         (avmmwrite),
    .avmmread          (avmmread),
    .avmmbyteen        (avmmbyteen),
    .avmmaddress       (avmmaddress),
    .avmmwritedata     (avmmwritedata),
    .blockselect       (blockselect),
    .readdatachnl      (readdatachnl),
    .avmmreaddata      (avmmreaddata),
    .clkchnl           (clkchnl),
    .rstnchnl          (rstnchnl),
    .writedatachnl     (writedatachnl),
    .regaddrchnl       (regaddrchnl),
    .writechnl         (writechnl),
    .readchnl          (readchnl),
    .byteenchnl        (byteenchnl),
    .refclkdig         (refclkdig),
    .avmmreservedin    (avmmreservedin),
    .avmmreservedout   (avmmreservedout),
    .dpriorstntop      (dpriorstntop),
    .dprioclktop       (dprioclktop),
    .mdiodistopchnl    (mdiodistopchnl),
    .dpriorstnmid      (dpriorstnmid),
    .dprioclkmid       (dprioclkmid),
    .mdiodismidchnl    (mdiodismidchnl),
    .dpriorstnbot      (dpriorstnbot),
    .dprioclkbot       (dprioclkbot),
    .mdiodisbotchnl    (mdiodisbotchnl),
    .dpriotestsitopchnl(dpriotestsitopchnl),
    .dpriotestsimidchnl(dpriotestsimidchnl),
    .dpriotestsibotchnl(dpriotestsibotchnl),
    .pmatestbus        (pmatestbus),
    .pmatestbussel     (pmatestbussel),
    .scanmoden         (scanmoden),
    .scanshiftn        (scanshiftn),
    .interfacesel      (interfacesel),
    .sershiftload      (sershiftload)
  );

endmodule
`timescale 1 ps/1 ps

module arriav_hssi_pma_hi_pmaif
  #(
    parameter lpm_type = "arriav_hssi_pma_hi_pmaif",
    parameter tx_pma_direction_sel = "pcs"    // valid values pcs|core
  )    
  (
   input [79:0] datainfromcore,
   input [79:0] datainfrompcs,
   output [79:0] dataouttopma

   // ... avmm and block select ports go here ...

   );

    cyclonev_hssi_pma_hi_pmaif_encrypted 
    # (
    .tx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfromcore(datainfromcore),
   .datainfrompcs(datainfrompcs),
   .dataouttopma(dataouttopma)
   );

endmodule // hi_pmaif
`timescale 1 ps/1 ps

module arriav_hssi_pma_hi_xcvrif
  #(
    parameter lpm_type = "arriav_hssi_pma_hi_xcvrif",
    parameter rx_pma_direction_sel = "pcs"    // valid values pcs|core
    )
  (
   input  [79:0] datainfrompma,
   input  [79:0] datainfrompcs,
   output [79:0] dataouttopld

   // ... avmm and block select ports go here ...

   );

    cyclonev_hssi_pma_hi_xcvrif_encrypted 
    # (
    .rx_pma_direction_sel("pcs")    // valid values pcs|core
    )
    inst (
   .datainfrompma(datainfrompma),
   .datainfrompcs(datainfrompcs),
   .dataouttopld(dataouttopld)
   );

endmodule // hi_pmaif

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
// Module Name : ./sim_model_wrappers//stratixv_channel_pll_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_channel_pll
#(      
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter enabled_for_reconfig = "false", 
        parameter sim_use_fast_model = "true",
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter cvp_en_iocsr = "false",	//Valid values: false|true
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter output_clock_frequency = "",	//Valid values: 
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter bbpd_salatch_offset_ctrl_clk0 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk180 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk270 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk90 = "offset_0mv",	//Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_sel = "normal",	//Valid values: testmux|normal
	parameter bypass_cp_rgla = "false",	//Valid values: false|true
	parameter cdr_atb_select = "atb_disable",	//Valid values: atb_disable|atb_sel_1|atb_sel_2|atb_sel_3|atb_sel_4|atb_sel_5|atb_sel_6|atb_sel_7|atb_sel_8|atb_sel_9|atb_sel_10|atb_sel_11|atb_sel_12|atb_sel_13|atb_sel_14
	parameter cgb_clk_enable = "false",	//Valid values: false|true
	parameter charge_pump_current_test = "enable_ch_pump_normal",	//Valid values: enable_ch_pump_normal|enable_ch_pump_curr_test_up|enable_ch_pump_curr_test_down|disable_ch_pump_curr_test
	parameter clklow_fref_to_ppm_div_sel = 1,	//Valid values: 1|2
	parameter clock_monitor = "lpbk_data",	//Valid values: lpbk_clk|lpbk_data
	parameter diag_rev_lpbk = "false",	//Valid values: false|true
	parameter eye_monitor_bbpd_data_ctrl = "cdr_data",	//Valid values: eye_mon_data|eye_mon_data_remote|cdr_data
	parameter fast_lock_mode = "false",	//Valid values: false|true
	parameter fb_sel = "vcoclk",	//Valid values: vcoclk|extclk|fbext_ctrla|fbext_ctrla_inv|fbext_ctrlb|fbext_ctrlb_inv
	parameter gpon_lock2ref_ctrl = "lck2ref",	//Valid values: lck2ref|lck2ref_gpon|lck2ref_gpon_neighbor
	parameter hs_levshift_power_supply_setting = 1,	//Valid values: 0|1|2|3
	parameter ignore_phslock = "false",	//Valid values: false|true
	parameter l_counter_pd_clock_disable = "false",	//Valid values: false|true
	parameter m_counter = -1,	//Valid values: 1|4|5|8|10|12|16|20|25|32|40|50
	parameter pcie_freq_control = "pcie_100mhz",	//Valid values: pcie_100mhz|pcie_125mhz
	parameter pd_charge_pump_current_ctrl = 5,	//Valid values: 5|10|20|30|40
	parameter pd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter pfd_charge_pump_current_ctrl = 20,	//Valid values: 5|10|20|30|40|50|60|80|100|120|160|180|200|240|300|320|400
	parameter pfd_l_counter = 1,	//Valid values: 1|2|4|8
	parameter powerdown = "false",	//Valid values: false|true
	parameter ref_clk_div = -1,	//Valid values: 1|2|4|8
	parameter regulator_volt_inc = "0",	//Valid values: 0|5|10|15|20|25|30|not_used
	parameter replica_bias_ctrl = "true",	//Valid values: false|true
	parameter reverse_serial_lpbk = "false",	//Valid values: false|true
	parameter ripple_cap_ctrl = "none",	//Valid values: reserved_11|reserved_10|plus_2pf|none
	parameter rxpll_pd_bw_ctrl = 300,	//Valid values: 600|300|240|170
	parameter rxpll_pfd_bw_ctrl = 3200,	//Valid values: 1600|3200|6400|9600
	parameter txpll_hclk_driver_enable = "false",	//Valid values: false|true
	parameter vco_overange_ref = "off",	//Valid values: off|ref_1|ref_2|ref_3
	parameter vco_range_ctrl_en = "false"	//Valid values: false|true
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
	input [ 0:0 ] clk270beyerm,
	input [ 0:0 ] clk270eye,
	input [ 0:0 ] clk90beyerm,
	input [ 0:0 ] clk90eye,
	input [ 0:0 ] clkindeser,
	input [ 0:0 ] crurstb,
	input [ 0:0 ] deeye,
	input [ 0:0 ] deeyerm,
	input [ 0:0 ] doeye,
	input [ 0:0 ] doeyerm,
	input [ 0:0 ] earlyeios,
	input [ 0:0 ] extclk,
	input [ 0:0 ] extfbctrla,
	input [ 0:0 ] extfbctrlb,
	input [ 0:0 ] gpblck2refb,
	input [ 0:0 ] lpbkpreen,
	input [ 0:0 ] ltd,
	input [ 0:0 ] ltr,
	input [ 0:0 ] occalen,
	input [ 0:0 ] pciel,
	input [ 0:0 ] pciem,
	input [ 1:0 ] pciesw,
	input [ 0:0 ] ppmlock,
	input [ 0:0 ] refclk,
	input [ 0:0 ] rstn,
	input [ 0:0 ] rxp,
	input [ 0:0 ] sd,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] ck0pd,
	output [ 0:0 ] ck180pd,
	output [ 0:0 ] ck270pd,
	output [ 0:0 ] ck90pd,
	output [ 0:0 ] clk270bcdr,
	output [ 0:0 ] clk270bdes,
	output [ 0:0 ] clk90bcdr,
	output [ 0:0 ] clk90bdes,
	output [ 0:0 ] clkcdr,
	output [ 0:0 ] clklow,
	output [ 0:0 ] decdr,
	output [ 0:0 ] deven,
	output [ 0:0 ] docdr,
	output [ 0:0 ] dodd,
	output [ 0:0 ] fref,
	output [ 3:0 ] pdof,
	output [ 0:0 ] pfdmodelock,
	output [ 0:0 ] rxlpbdp,
	output [ 0:0 ] rxlpbp,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] txpllhclk,
	output [ 0:0 ] txrlpbk,
	output [ 0:0 ] vctrloverrange
); 

	stratixv_channel_pll_encrypted 
	#(
                .enabled_for_reconfig(enabled_for_reconfig),
		.enable_debug_info(enable_debug_info),
	        .sim_use_fast_model(sim_use_fast_model),

		.avmm_group_channel_index(avmm_group_channel_index),
		.output_clock_frequency(output_clock_frequency),
		.reference_clock_frequency(reference_clock_frequency),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address),
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
		.eye_monitor_bbpd_data_ctrl(eye_monitor_bbpd_data_ctrl),
		.fast_lock_mode(fast_lock_mode),
		.fb_sel(fb_sel),
		.gpon_lock2ref_ctrl(gpon_lock2ref_ctrl),
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
	stratixv_channel_pll_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmrstn(avmmrstn),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.clk270beyerm(clk270beyerm),
		.clk270eye(clk270eye),
		.clk90beyerm(clk90beyerm),
		.clk90eye(clk90eye),
		.clkindeser(clkindeser),
		.crurstb(crurstb),
		.deeye(deeye),
		.deeyerm(deeyerm),
		.doeye(doeye),
		.doeyerm(doeyerm),
		.earlyeios(earlyeios),
		.extclk(extclk),
		.extfbctrla(extfbctrla),
		.extfbctrlb(extfbctrlb),
		.gpblck2refb(gpblck2refb),
		.lpbkpreen(lpbkpreen),
		.ltd(ltd),
		.ltr(ltr),
		.occalen(occalen),
		.pciel(pciel),
		.pciem(pciem),
		.pciesw(pciesw),
		.ppmlock(ppmlock),
		.refclk(refclk),
		.rstn(rstn),
		.rxp(rxp),
		.sd(sd),
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.ck0pd(ck0pd),
		.ck180pd(ck180pd),
		.ck270pd(ck270pd),
		.ck90pd(ck90pd),
		.clk270bcdr(clk270bcdr),
		.clk270bdes(clk270bdes),
		.clk90bcdr(clk90bcdr),
		.clk90bdes(clk90bdes),
		.clkcdr(clkcdr),
		.clklow(clklow),
		.decdr(decdr),
		.deven(deven),
		.docdr(docdr),
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
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_aux_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_aux
#(
	parameter silicon_rev = "reve",      // Valid values: reve|es
  // 	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter continuous_calibration = "false",	//Valid values: false|true
	parameter rx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter rx_cal_override_value = 0,	//Valid values: 0..31
	parameter tx_cal_override_value_enable = "false",	//Valid values: false|true
	parameter tx_cal_override_value = 0,	//Valid values: 0..31
	parameter cal_result_status = "pm_aux_result_status_tx",	//Valid values: pm_aux_result_status_tx|pm_aux_result_status_rx
	parameter rx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter tx_imp = "cal_imp_46_ohm",	//Valid values: cal_imp_46_ohm|cal_imp_48_ohm|cal_imp_50_ohm|cal_imp_52_ohm
	parameter test_counter_enable = "false",	//Valid values: false|true
	parameter cal_clk_sel = "pm_aux_iqclk_cal_clk_sel_cal_clk",	//Valid values: pm_aux_iqclk_cal_clk_sel_cal_clk|pm_aux_iqclk_cal_clk_sel_iqclk0|pm_aux_iqclk_cal_clk_sel_iqclk1|pm_aux_iqclk_cal_clk_sel_iqclk2|pm_aux_iqclk_cal_clk_sel_iqclk3|pm_aux_iqclk_cal_clk_sel_iqclk4|pm_aux_iqclk_cal_clk_sel_iqclk5|pm_aux_iqclk_cal_clk_sel_iqclk6|pm_aux_iqclk_cal_clk_sel_iqclk7|pm_aux_iqclk_cal_clk_sel_iqclk8|pm_aux_iqclk_cal_clk_sel_iqclk9|pm_aux_iqclk_cal_clk_sel_iqclk10
	parameter pm_aux_cal_clk_test_sel = 1'b0,	//Valid values: 1
	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0	//Valid values: 0..2047
)
(
//input and output port declaration
	input [ 0:0 ] calpdb,
	input [ 0:0 ] calclk,
	input [ 0:0 ] testcntl,
	input [ 10:0 ] refiqclk,
	output [ 0:0 ] nonusertoio,
	output [ 4:0 ] zrxtx50
); 

	stratixv_hssi_pma_aux_encrypted 
	#(
		.enable_debug_info(enable_debug_info),
		.continuous_calibration(continuous_calibration),
		.rx_cal_override_value_enable(rx_cal_override_value_enable),
		.rx_cal_override_value(rx_cal_override_value),
		.tx_cal_override_value_enable(tx_cal_override_value_enable),
		.tx_cal_override_value(tx_cal_override_value),
		.cal_result_status(cal_result_status),
		.rx_imp(rx_imp),
		.tx_imp(tx_imp),
		.test_counter_enable(test_counter_enable),
		.cal_clk_sel(cal_clk_sel),
		.pm_aux_cal_clk_test_sel(pm_aux_cal_clk_test_sel),
		.avmm_group_channel_index(avmm_group_channel_index),
		.use_default_base_address(use_default_base_address),
		.user_base_address(user_base_address)

	)
	stratixv_hssi_pma_aux_encrypted_inst	(
		.calpdb(calpdb),
		.calclk(calclk),
		.testcntl(testcntl),
		.refiqclk(refiqclk),
		.nonusertoio(nonusertoio),
		.zrxtx50(zrxtx50)
	);


endmodule
// ----------------------------------------------------------------------------------
// This is the HSSI Simulation Atom Model Encryption wrapper for the AVMM Interface
// Module Name : stratixv_hssi_avmm_interface
// ----------------------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_avmm_interface
  #(
    parameter num_ch0_atoms = 0,
    parameter num_ch1_atoms = 0,
    parameter num_ch2_atoms = 0
    )
(
//input and output port declaration
    input  [ 0:0 ]        avmmrstn,
    input  [ 0:0 ]        avmmclk,
    input  [ 0:0 ]        avmmwrite,
    input  [ 0:0 ]        avmmread,
    input  [ 1:0 ]        avmmbyteen,
    input  [ 10:0 ]       avmmaddress,
    input  [ 15:0 ]       avmmwritedata,
    input  [ 89:0 ]     blockselect,
    input  [ 1439:0 ] readdatachnl,

    output  [ 15:0 ]       avmmreaddata,

    output  [ 0:0 ]        clkchnl,
    output  [ 0:0 ]        rstnchnl,
    output  [ 15:0 ]       writedatachnl,
    output  [ 10:0 ]       regaddrchnl,
    output  [ 0:0 ]        writechnl,
    output  [ 0:0 ]        readchnl,
    output  [ 1:0 ]        byteenchnl,

    //The following ports are not modelled. They exist to match the avmm interface atom interface
    input  [ 0:0 ]        refclkdig,
    input  [ 0:0 ]        avmmreservedin,
    
    output  [ 0:0 ]        avmmreservedout,
    output  [ 0:0 ]        dpriorstntop,
    output  [ 0:0 ]        dprioclktop,
    output  [ 0:0 ]        mdiodistopchnl,
    output  [ 0:0 ]        dpriorstnmid,
    output  [ 0:0 ]        dprioclkmid,
    output  [ 0:0 ]        mdiodismidchnl,
    output  [ 0:0 ]        dpriorstnbot,
    output  [ 0:0 ]        dprioclkbot,
    output  [ 0:0 ]        mdiodisbotchnl,
    output [ 3:0 ]        dpriotestsitopchnl,
    output [ 3:0 ]        dpriotestsimidchnl,
    output [ 3:0 ]        dpriotestsibotchnl,
 
    //The following ports belong to pm_adce and pm_tst_mux blocks in the PMA
    input  [ 11:0 ]       pmatestbussel,
    output [ 23:0 ]       pmatestbus,
  
    //
    input  [ 0:0 ]        scanmoden,
    input  [ 0:0 ]        scanshiftn,
    input  [ 0:0 ]        interfacesel,
    input  [ 0:0 ]        sershiftload
); 

  stratixv_hssi_avmm_interface_encrypted
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

`timescale 1 ps / 1 ps
module stratixv_hssi_aux_clock_div (
    clk,     // input clock
    reset,   // reset
    enable_d, // enable DPRIO
    d,        // division factor for DPRIO support
    clkout   // divided clock
);
input clk,reset;
input enable_d;
input [7:0] d;
output clkout;


parameter clk_divide_by  = 1;
parameter extra_latency  = 0;

integer clk_edges,m;
reg [2*extra_latency:0] div_n_register;
reg [7:0] d_factor_dly;
reg [31:0] clk_divide_value;

wire [7:0] d_factor;
wire int_reset;

initial
begin
    div_n_register = 'b0;
    clk_edges = -1;
    m = 0;
    d_factor_dly =  'b0;
    clk_divide_value = clk_divide_by;
end

assign d_factor = (enable_d === 1'b1) ? d : clk_divide_value[7:0];

always @(d_factor)
begin
    d_factor_dly <= d_factor;
end


// create a reset pulse when there is a change in the d_factor value
assign int_reset = (d_factor !== d_factor_dly) ? 1'b1 : 1'b0;

always @(posedge clk or negedge clk or posedge reset or posedge int_reset)
begin
    div_n_register <= {div_n_register, div_n_register[0]};

    if ((reset === 1'b1) || (int_reset === 1'b1)) 
    begin
        clk_edges = -1;
        div_n_register <= 'b0;
    end
    else
    begin
        if (clk_edges == -1) 
        begin
            div_n_register[0] <= clk;
            if (clk == 1'b1) clk_edges = 0;
        end
        else if (clk_edges % d_factor == 0) 
                div_n_register[0] <= ~div_n_register[0];
        if (clk_edges >= 0 || clk == 1'b1)
            clk_edges = (clk_edges + 1) % (2*d_factor) ;
    end
end

assign clkout = div_n_register[2*extra_latency];

endmodule

// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_10g_rx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_10g_rx_pcs
#(
  	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter stretch_en = "stretch_en",      // Valid values: stretch_en|stretch_dis
	parameter rxfifo_empty = 0,      // Valid values: 
	parameter rx_sm_pipeln = "rx_sm_pipeln_dis",      // Valid values: rx_sm_pipeln_dis|rx_sm_pipeln_en
	parameter bit_reverse = "bit_reverse_dis",      // Valid values: bit_reverse_dis|bit_reverse_en
	parameter rx_testbus_sel = "crc32_chk_testbus1",      // Valid values: crc32_chk_testbus1|crc32_chk_testbus2|disp_chk_testbus1|disp_chk_testbus2|frame_sync_testbus1|frame_sync_testbus2|dec64b66b_testbus|rxsm_testbus|ber_testbus|blksync_testbus1|blksync_testbus2|gearbox_exp_testbus1|gearbox_exp_testbus2|prbs_ver_xg_testbus|descramble_testbus1|descramble_testbus2|rx_fifo_testbus1|rx_fifo_testbus2
	parameter rx_signal_ok_sel = "synchronized_ver",      // Valid values: synchronized_ver|nonsync_ver
	parameter force_align = "force_align_dis",      // Valid values: force_align_dis|force_align_en
	parameter rx_scrm_width = "bit64",      // Valid values: bit64|bit66|bit67
	parameter lpbk_mode = "lpbk_dis",      // Valid values: lpbk_dis|lpbk_en
	parameter ber_xus_timer_window_user = 21'b100110001001010,      // Valid values: 21
	parameter frmgen_scrm_word = "0010100000000000000000000000000000000000000000000000000000000000",      // Valid values: 
	parameter blksync_bypass = "blksync_bypass_dis",      // Valid values: blksync_bypass_dis|blksync_bypass_en
	parameter rx_true_b2b = "b2b",      // Valid values: single|b2b
	parameter wrfifo_clken = "wrfifo_clk_dis",      // Valid values: wrfifo_clk_dis|wrfifo_clk_en
	parameter gb_rx_idwidth = "width_32",      // Valid values: width_40|width_32|width_64|width_32_default
	parameter descrm_clken = "descrm_clk_dis",      // Valid values: descrm_clk_dis|descrm_clk_en
	parameter ber_xus_timer_window = "xus_timer_window_10g",      // Valid values: xus_timer_window_10g|xus_timer_window_user_setting
	parameter frmgen_diag_word = "0000000000000000000000000000000000000000000000000000000000000000",      // Valid values: 
	parameter rx_sm_hiber = "rx_sm_hiber_en",      // Valid values: rx_sm_hiber_en|rx_sm_hiber_dis
	parameter frmsync_flag_type = "all_framing_words",      // Valid values: all_framing_words|location_only
	parameter blksync_pipeln = "blksync_pipeln_dis",      // Valid values: blksync_pipeln_dis|blksync_pipeln_en
	parameter rx_polarity_inv = "invert_disable",      // Valid values: invert_disable|invert_enable
	parameter prbs_clken = "prbs_clk_dis",      // Valid values: prbs_clk_dis|prbs_clk_en
	parameter ber_clken = "ber_clk_dis",      // Valid values: ber_clk_dis|ber_clk_en
	parameter rand_clken = "rand_clk_dis",      // Valid values: rand_clk_dis|rand_clk_en
	parameter rxfifo_mode = "phase_comp",      // Valid values: register_mode|clk_comp_10g|clk_comp_basic|generic_interlaken|generic_basic|phase_comp|phase_comp_dv|clk_comp|generic
	parameter rx_dfx_lpbk = "dfx_lpbk_dis",      // Valid values: dfx_lpbk_dis|dfx_lpbk_en
	parameter rxfifo_pfull = 23,      // Valid values: 
	parameter gb_sel_mode = "internal",      // Valid values: internal|external
	parameter bitslip_wait_cnt_user = 1,      // Valid values: 0..7
	parameter blksync_bitslip_type = "bitslip_comb",      // Valid values: bitslip_comb|bitslip_reg
	parameter ber_bit_err_total_cnt = "bit_err_total_cnt_10g",      // Valid values: bit_err_total_cnt_10g
	parameter align_del = "align_del_en",      // Valid values: align_del_dis|align_del_en
	parameter test_bus_mode = "tx",      // Valid values: tx|rx
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode|stretch_mode|engr_mode
	parameter dispchk_rd_level_user = 8'b1100000,      // Valid values: 8
	parameter dis_signal_ok = "dis_signal_ok_dis",      // Valid values: dis_signal_ok_dis|dis_signal_ok_en
	parameter frmsync_clken = "frmsync_clk_dis",      // Valid values: frmsync_clk_dis|frmsync_clk_en
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter frmgen_sync_word = "0111100011110110011110001111011001111000111101100111100011110110",      // Valid values: 
	parameter iqtxrx_clkout_sel = "iq_rx_clk_out",      // Valid values: iq_rx_clk_out|iq_rx_pma_clk_div33
	parameter frmsync_pipeln = "frmsync_pipeln_dis",      // Valid values: frmsync_pipeln_dis|frmsync_pipeln_en
	parameter descrm_mode = "async",      // Valid values: async|sync
	parameter rxfifo_full = 31,      // Valid values: 
	parameter fast_path = "fast_path_dis",      // Valid values: fast_path_dis|fast_path_en
	parameter dispchk_bypass = "dispchk_bypass_dis",      // Valid values: dispchk_bypass_dis|dispchk_bypass_en
	parameter rx_prbs_mask = "prbsmask128",      // Valid values: prbsmask128|prbsmask256|prbsmask512|prbsmask1024
	parameter rxfifo_pempty = 7,      // Valid values: 
	parameter master_clk_sel = "master_rx_pma_clk",      // Valid values: master_rx_pma_clk|master_tx_pma_clk|master_refclk_dig
	parameter frmsync_enum_sync = "enum_sync_default",      // Valid values: enum_sync_default
	parameter crcchk_clken = "crcchk_clk_dis",      // Valid values: crcchk_clk_dis|crcchk_clk_en
	parameter blksync_bitslip_wait_cnt = "bitslip_wait_cnt_min",      // Valid values: bitslip_wait_cnt_min|bitslip_wait_cnt_max|bitslip_wait_cnt_user_setting
	parameter skip_ctrl = "skip_ctrl_default",      // Valid values: skip_ctrl_default
	parameter gbexp_clken = "gbexp_clk_dis",      // Valid values: gbexp_clk_dis|gbexp_clk_en
	parameter dispchk_rd_level = "dispchk_rd_level_min",      // Valid values: dispchk_rd_level_min|dispchk_rd_level_max|dispchk_rd_level_user_setting
	parameter frmsync_bypass = "frmsync_bypass_dis",      // Valid values: frmsync_bypass_dis|frmsync_bypass_en
	parameter blksync_bitslip_wait_type = "bitslip_match",      // Valid values: bitslip_match|bitslip_cnt
	parameter rx_sh_location = "lsb",      // Valid values: lsb|msb
	parameter frmsync_knum_sync = "knum_sync_default",      // Valid values: knum_sync_default
	parameter dec64b66b_clken = "dec64b66b_clk_dis",      // Valid values: dec64b66b_clk_dis|dec64b66b_clk_en
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter descrm_bypass = "descrm_bypass_en",      // Valid values: descrm_bypass_dis|descrm_bypass_en
	parameter frmgen_skip_word = "0001111000011110000111100001111000011110000111100001111000011110",      // Valid values: 
	parameter frmsync_mfrm_length = "frmsync_mfrm_length_min",      // Valid values: frmsync_mfrm_length_min|frmsync_mfrm_length_max|frmsync_mfrm_length_user_setting
	parameter blksync_clken = "blksync_clk_dis",      // Valid values: blksync_clk_dis|blksync_clk_en
	parameter crcchk_bypass = "crcchk_bypass_dis",      // Valid values: crcchk_bypass_dis|crcchk_bypass_en
	parameter frmsync_mfrm_length_user = 2048,      // Valid values: 0..8191
	parameter rdfifo_clken = "rdfifo_clk_dis",      // Valid values: rdfifo_clk_dis|rdfifo_clk_en
	parameter crcchk_inv = "crcchk_inv_dis",      // Valid values: crcchk_inv_dis|crcchk_inv_en
	parameter blksync_knum_sh_cnt_prelock = "knum_sh_cnt_prelock_10g",      // Valid values: knum_sh_cnt_prelock_10g|knum_sh_cnt_prelock_40g100g
	parameter blksync_knum_sh_cnt_postlock = "knum_sh_cnt_postlock_10g",      // Valid values: knum_sh_cnt_postlock_10g|knum_sh_cnt_postlock_40g100g
	parameter dispchk_clken = "dispchk_clk_dis",      // Valid values: dispchk_clk_dis|dispchk_clk_en
	parameter dispchk_pipeln = "dispchk_pipeln_dis",      // Valid values: dispchk_pipeln_dis|dispchk_pipeln_en
	parameter crcflag_pipeln = "crcflag_pipeln_dis",      // Valid values: crcflag_pipeln_dis|crcflag_pipeln_en
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter gb_rx_odwidth = "width_66",      // Valid values: width_32|width_40|width_50|width_67|width_64|width_66
	parameter stretch_num_stages = "zero_stage",      // Valid values: zero_stage|one_stage|two_stage|three_stage
	parameter control_del = "control_del_all",      // Valid values: control_del_all|control_del_none
	parameter blksync_enum_invalid_sh_cnt = "enum_invalid_sh_cnt_10g",      // Valid values: enum_invalid_sh_cnt_10g|enum_invalid_sh_cnt_40g100g
	parameter dec_64b66b_rxsm_bypass = "dec_64b66b_rxsm_bypass_dis",      // Valid values: dec_64b66b_rxsm_bypass_dis|dec_64b66b_rxsm_bypass_en
	parameter channel_number = 0,      // Valid values: 0..65
	parameter crcchk_init_user = "11111111111111111111111111111111",      // Valid values: 
	parameter rd_clk_sel = "rd_rx_pma_clk",      // Valid values: rd_rx_pld_clk|rd_rx_pma_clk|rd_refclk_dig
	parameter frmsync_enum_scrm = "enum_scrm_default",      // Valid values: enum_scrm_default
	parameter crcchk_pipeln = "crcchk_pipeln_dis",      // Valid values: crcchk_pipeln_dis|crcchk_pipeln_en
	parameter test_mode = "test_off",      // Valid values: test_off|pseudo_random|prbs_31|prbs_23|prbs_9|prbs_7
	parameter prot_mode = "disable_mode",      // Valid values: disable_mode|teng_baser_mode|interlaken_mode|sfis_mode|teng_sdi_mode|basic_mode|test_prbs_mode|test_prp_mode
	parameter crcchk_init = "crcchk_init_user_setting",      // Valid values: crcchk_init_user_setting
	parameter rx_fifo_write_ctrl = "blklock_stops",      // Valid values: blklock_stops|blklock_ignore
	parameter bitslip_mode = "bitslip_dis",      // Valid values: bitslip_dis|bitslip_en
	parameter rx_sm_bypass = "rx_sm_bypass_dis",      // Valid values: rx_sm_bypass_dis|rx_sm_bypass_en
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter stretch_type = "stretch_auto",      // Valid values: stretch_auto|stretch_custom
	parameter full_flag_type = "full_wr_side",      // Valid values: full_rd_side|full_wr_side
	parameter ctrl_bit_reverse = "ctrl_bit_reverse_dis",      // Valid values: ctrl_bit_reverse_dis|ctrl_bit_reverse_en
	parameter empty_flag_type = "empty_rd_side",      // Valid values: empty_rd_side|empty_wr_side
	parameter fifo_stop_wr = "n_wr_full",      // Valid values: wr_full|n_wr_full
	parameter blksync_bitslip_wait_cnt_user = 3'b1,      // Valid values: 3
	parameter pfull_flag_type = "pfull_wr_side",      // Valid values: pfull_rd_side|pfull_wr_side
	parameter pempty_flag_type = "pempty_rd_side",      // Valid values: pempty_rd_side|pempty_wr_side
	parameter data_bit_reverse = "data_bit_reverse_dis",      // Valid values: data_bit_reverse_dis|data_bit_reverse_en
	parameter fifo_stop_rd = "n_rd_empty"      // Valid values: rd_empty|n_rd_empty
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 9:0 ] dfxlpbkcontrolin,
	input  [ 63:0 ] dfxlpbkdatain,
	input  [ 0:0 ] dfxlpbkdatavalidin,
	input  [ 0:0 ] hardresetn,
	input  [ 79:0 ] lpbkdatain,
	input  [ 0:0 ] pmaclkdiv33txorrx,
	input  [ 0:0 ] refclkdig,
	input  [ 0:0 ] rxalignclr,
	input  [ 0:0 ] rxalignen,
	output [ 0:0 ] rxalignval,
	input  [ 0:0 ] rxbitslip,
	output [ 0:0 ] rxblocklock,
	output [ 0:0 ] rxclkiqout,
	output [ 0:0 ] rxclkout,
	input  [ 0:0 ] rxclrbercount,
	input  [ 0:0 ] rxclrerrorblockcount,
	output [ 9:0 ] rxcontrol,
	output [ 0:0 ] rxcrc32error,
	output [ 63:0 ] rxdata,
	output [ 0:0 ] rxdatavalid,
	output [ 0:0 ] rxdiagnosticerror,
	output [ 1:0 ] rxdiagnosticstatus,
	input  [ 0:0 ] rxdisparityclr,
	output [ 0:0 ] rxfifodel,
	output [ 0:0 ] rxfifoempty,
	output [ 0:0 ] rxfifofull,
	output [ 0:0 ] rxfifoinsert,
	output [ 0:0 ] rxfifopartialempty,
	output [ 0:0 ] rxfifopartialfull,
	output [ 0:0 ] rxframelock,
	output [ 0:0 ] rxhighber,
	output [ 0:0 ] rxmetaframeerror,
	output [ 0:0 ] rxpayloadinserted,
	input  [ 0:0 ] rxpldclk,
	input  [ 0:0 ] rxpldrstn,
	input  [ 0:0 ] rxpmaclk,
	input  [ 79:0 ] rxpmadata,
	input  [ 0:0 ] rxpmadatavalid,
	output [ 0:0 ] rxprbsdone,
	output [ 0:0 ] rxprbserr,
	input  [ 0:0 ] rxprbserrorclr,
	input  [ 0:0 ] rxrden,
	output [ 0:0 ] rxrdnegsts,
	output [ 0:0 ] rxrdpossts,
	output [ 0:0 ] rxrxframe,
	output [ 0:0 ] rxscramblererror,
	output [ 0:0 ] rxskipinserted,
	output [ 0:0 ] rxskipworderror,
	output [ 0:0 ] rxsyncheadererror,
	output [ 0:0 ] rxsyncworderror,
	output [ 19:0 ] rxtestdata,
	output [ 0:0 ] syncdatain,
	input  [ 0:0 ] txpmaclk
);
	
   
	// Function to convert a 64bit binary to a string
	// This function also exists in stratixv_hssi_10g_tx_pcs_wrapper_multirev.v
	function [64*8-1 : 0] m_bin_to_str;
	    input	[64 : 1]	s;
	    
    	reg		[64 : 1]	reg_s;
	    reg		[7 : 0]		tmp;
    	reg		[64*8 : 1]	res;  
    
	    integer m, index;
    	begin
    		reg_s = s;
    		res = 64'h0000000000000000;
    		for (m = 64; m > 0; m = m-1 )
    		begin
    			tmp = reg_s[64];
    			res[(((m-1)*8)+1)] = tmp & 1'b1;
    			reg_s = reg_s << 1;
    		end
    	
    		m_bin_to_str = res;
    	end
	endfunction

	

	localparam [8*64-1 : 0] frmgen_sync_word_string	= m_bin_to_str(frmgen_sync_word);
	localparam [8*64-1 : 0] frmgen_scrm_word_string	= m_bin_to_str(frmgen_scrm_word);
	localparam [8*64-1 : 0] frmgen_skip_word_string	= m_bin_to_str(frmgen_skip_word);
	localparam [8*64-1 : 0] frmgen_diag_word_string	= m_bin_to_str(frmgen_diag_word);
	localparam [8*64-1 : 0] crcchk_init_user_string	= m_bin_to_str(crcchk_init_user);
	
	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_10g_rx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_10g_rx_pcs_encrypted_ES #(
				.enable_debug_info(enable_debug_info),				
				.stretch_en(stretch_en),
				.rxfifo_empty(rxfifo_empty),
				.rx_sm_pipeln(rx_sm_pipeln),
				.bit_reverse(bit_reverse),
				.rx_testbus_sel(rx_testbus_sel),
				.rx_signal_ok_sel(rx_signal_ok_sel),
				.force_align(force_align),
				.rx_scrm_width(rx_scrm_width),
				.lpbk_mode(lpbk_mode),
				.ber_xus_timer_window_user(ber_xus_timer_window_user),
				.frmgen_scrm_word(frmgen_scrm_word_string),
				.blksync_bypass(blksync_bypass),
				.rx_true_b2b(rx_true_b2b),
				.wrfifo_clken(wrfifo_clken),
				.gb_rx_idwidth(gb_rx_idwidth),
				.descrm_clken(descrm_clken),
				.ber_xus_timer_window(ber_xus_timer_window),
				.frmgen_diag_word(frmgen_diag_word_string),
				.rx_sm_hiber(rx_sm_hiber),
				.frmsync_flag_type(frmsync_flag_type),
				.blksync_pipeln(blksync_pipeln),
				.rx_polarity_inv(rx_polarity_inv),
				.prbs_clken(prbs_clken),
				.ber_clken(ber_clken),
				.rand_clken(rand_clken),
				.rxfifo_mode(rxfifo_mode),
				.rx_dfx_lpbk(rx_dfx_lpbk),
				.rxfifo_pfull(rxfifo_pfull),
				.gb_sel_mode(gb_sel_mode),
				.bitslip_wait_cnt_user(bitslip_wait_cnt_user),
				.blksync_bitslip_type(blksync_bitslip_type),
				.ber_bit_err_total_cnt(ber_bit_err_total_cnt),
				.align_del(align_del),
				.test_bus_mode(test_bus_mode),
				.sup_mode(sup_mode),
				.dispchk_rd_level_user(dispchk_rd_level_user),
				.dis_signal_ok(dis_signal_ok),
				.frmsync_clken(frmsync_clken),
				.use_default_base_address(use_default_base_address),
				.frmgen_sync_word(frmgen_sync_word_string),
				.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
				.frmsync_pipeln(frmsync_pipeln),
				.descrm_mode(descrm_mode),
				.rxfifo_full(rxfifo_full),
				.fast_path(fast_path),
				.dispchk_bypass(dispchk_bypass),
				.rx_prbs_mask(rx_prbs_mask),
				.rxfifo_pempty(rxfifo_pempty),
				.master_clk_sel(master_clk_sel),
				.frmsync_enum_sync(frmsync_enum_sync),
				.crcchk_clken(crcchk_clken),
				.blksync_bitslip_wait_cnt(blksync_bitslip_wait_cnt),
				.skip_ctrl(skip_ctrl),
				.gbexp_clken(gbexp_clken),
				.dispchk_rd_level(dispchk_rd_level),
				.frmsync_bypass(frmsync_bypass),
				.blksync_bitslip_wait_type(blksync_bitslip_wait_type),
				.rx_sh_location(rx_sh_location),
				.frmsync_knum_sync(frmsync_knum_sync),
				.dec64b66b_clken(dec64b66b_clken),
				.user_base_address(user_base_address),
				.descrm_bypass(descrm_bypass),
				.frmgen_skip_word(frmgen_skip_word_string),
				.frmsync_mfrm_length(frmsync_mfrm_length),
				.blksync_clken(blksync_clken),
				.crcchk_bypass(crcchk_bypass),
				.frmsync_mfrm_length_user(frmsync_mfrm_length_user),
				.rdfifo_clken(rdfifo_clken),
				.crcchk_inv(crcchk_inv),
				.blksync_knum_sh_cnt_prelock(blksync_knum_sh_cnt_prelock),
				.blksync_knum_sh_cnt_postlock(blksync_knum_sh_cnt_postlock),
				.dispchk_clken(dispchk_clken),
				.dispchk_pipeln(dispchk_pipeln),
				.crcflag_pipeln(crcflag_pipeln),
				.avmm_group_channel_index(avmm_group_channel_index),
				.gb_rx_odwidth(gb_rx_odwidth),
				.stretch_num_stages(stretch_num_stages),
				.control_del(control_del),
				.blksync_enum_invalid_sh_cnt(blksync_enum_invalid_sh_cnt),
				.dec_64b66b_rxsm_bypass(dec_64b66b_rxsm_bypass),
				.channel_number(channel_number),
				.crcchk_init_user(crcchk_init_user_string),
				.rd_clk_sel(rd_clk_sel),
				.frmsync_enum_scrm(frmsync_enum_scrm),
				.crcchk_pipeln(crcchk_pipeln),
				.test_mode(test_mode),
				.prot_mode(prot_mode),
				.crcchk_init(crcchk_init),
				.rx_fifo_write_ctrl(rx_fifo_write_ctrl),
				.bitslip_mode(bitslip_mode),
				.rx_sm_bypass(rx_sm_bypass)
			) stratixv_hssi_10g_rx_pcs_encrypted_ES_inst (
				.rxprbserr(rxprbserr),
				.rxrdpossts(rxrdpossts),
				.rxprbsdone(rxprbsdone),
				.rxclkiqout(rxclkiqout),
				.rxfifopartialempty(rxfifopartialempty),
				.rxpldclk(rxpldclk),
				.avmmclk(avmmclk),
				.rxfifoinsert(rxfifoinsert),
				.rxdiagnosticerror(rxdiagnosticerror),
				.rxpmaclk(rxpmaclk),
				.rxframelock(rxframelock),
				.avmmrstn(avmmrstn),
				.rxtestdata(rxtestdata),
				.rxmetaframeerror(rxmetaframeerror),
				.avmmbyteen(avmmbyteen),
				.rxhighber(rxhighber),
				.rxdiagnosticstatus(rxdiagnosticstatus),
				.refclkdig(refclkdig),
				.rxpmadata(rxpmadata),
				.rxfifopartialfull(rxfifopartialfull),
				.rxpayloadinserted(rxpayloadinserted),
				.dfxlpbkdatain(dfxlpbkdatain),
				.avmmreaddata(avmmreaddata),
				.rxskipworderror(rxskipworderror),
				.rxrxframe(rxrxframe),
				.rxblocklock(rxblocklock),
				.dfxlpbkcontrolin(dfxlpbkcontrolin),
				.rxfifodel(rxfifodel),
				.rxcontrol(rxcontrol),
				.rxalignval(rxalignval),
				.avmmwrite(avmmwrite),
				.rxscramblererror(rxscramblererror),
				.rxdisparityclr(rxdisparityclr),
				.rxcrc32error(rxcrc32error),
				.hardresetn(hardresetn),
				.rxdatavalid(rxdatavalid),
				.rxrden(rxrden),
				.avmmaddress(avmmaddress),
				.rxpmadatavalid(rxpmadatavalid),
				.rxsyncheadererror(rxsyncheadererror),
				.rxbitslip(rxbitslip),
				.rxclrbercount(rxclrbercount),
				.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
				.rxdata(rxdata),
				.rxclkout(rxclkout),
				.rxclrerrorblockcount(rxclrerrorblockcount),
				.syncdatain(syncdatain),
				.dfxlpbkdatavalidin(dfxlpbkdatavalidin),
				.avmmread(avmmread),
				.rxalignen(rxalignen),
				.rxalignclr(rxalignclr),
				.lpbkdatain(lpbkdatain),
				.blockselect(blockselect),
				.rxprbserrorclr(rxprbserrorclr),
				.rxrdnegsts(rxrdnegsts),
				.rxpldrstn(rxpldrstn),
				.txpmaclk(txpmaclk),
				.rxsyncworderror(rxsyncworderror),
				.rxfifoempty(rxfifoempty),
				.rxskipinserted(rxskipinserted),
				.rxfifofull(rxfifofull),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_10g_rx_pcs_encrypted #(
				.enable_debug_info(enable_debug_info),
				.stretch_en(stretch_en),
				.rxfifo_empty(rxfifo_empty),
				.rx_sm_pipeln(rx_sm_pipeln),
				.bit_reverse(bit_reverse),
				.rx_testbus_sel(rx_testbus_sel),
				.rx_signal_ok_sel(rx_signal_ok_sel),
				.force_align(force_align),
				.rx_scrm_width(rx_scrm_width),
				.lpbk_mode(lpbk_mode),
				.ber_xus_timer_window_user(ber_xus_timer_window_user),
				.frmgen_scrm_word(frmgen_scrm_word_string),
				.stretch_type(stretch_type),
				.full_flag_type(full_flag_type),
				.blksync_bypass(blksync_bypass),
				.rx_true_b2b(rx_true_b2b),
				.wrfifo_clken(wrfifo_clken),
				.gb_rx_idwidth(gb_rx_idwidth),
				.descrm_clken(descrm_clken),
				.ber_xus_timer_window(ber_xus_timer_window),
				.frmgen_diag_word(frmgen_diag_word_string),
				.rx_sm_hiber(rx_sm_hiber),
				.frmsync_flag_type(frmsync_flag_type),
				.blksync_pipeln(blksync_pipeln),
				.rx_polarity_inv(rx_polarity_inv),
				.prbs_clken(prbs_clken),
				.ber_clken(ber_clken),
				.rand_clken(rand_clken),
				.rxfifo_mode(rxfifo_mode),
				.rx_dfx_lpbk(rx_dfx_lpbk),
				.rxfifo_pfull(rxfifo_pfull),
				.ctrl_bit_reverse(ctrl_bit_reverse),
				.gb_sel_mode(gb_sel_mode),
				.bitslip_wait_cnt_user(bitslip_wait_cnt_user),
				.blksync_bitslip_type(blksync_bitslip_type),
				.ber_bit_err_total_cnt(ber_bit_err_total_cnt),
				.align_del(align_del),
				.test_bus_mode(test_bus_mode),
				.sup_mode(sup_mode),
				.dispchk_rd_level_user(dispchk_rd_level_user),
				.dis_signal_ok(dis_signal_ok),
				.frmsync_clken(frmsync_clken),
				.use_default_base_address(use_default_base_address),
				.frmgen_sync_word(frmgen_sync_word_string),
				.empty_flag_type(empty_flag_type),
				.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
				.frmsync_pipeln(frmsync_pipeln),
				.descrm_mode(descrm_mode),
				.fifo_stop_wr(fifo_stop_wr),
				.rxfifo_full(rxfifo_full),
				.blksync_bitslip_wait_cnt_user(blksync_bitslip_wait_cnt_user),
				.pfull_flag_type(pfull_flag_type),
				.fast_path(fast_path),
				.dispchk_bypass(dispchk_bypass),
				.rx_prbs_mask(rx_prbs_mask),
				.rxfifo_pempty(rxfifo_pempty),
				.master_clk_sel(master_clk_sel),
				.frmsync_enum_sync(frmsync_enum_sync),
				.crcchk_clken(crcchk_clken),
				.blksync_bitslip_wait_cnt(blksync_bitslip_wait_cnt),
				.skip_ctrl(skip_ctrl),
				.gbexp_clken(gbexp_clken),
				.dispchk_rd_level(dispchk_rd_level),
				.frmsync_bypass(frmsync_bypass),
				.blksync_bitslip_wait_type(blksync_bitslip_wait_type),
				.rx_sh_location(rx_sh_location),
				.frmsync_knum_sync(frmsync_knum_sync),
				.dec64b66b_clken(dec64b66b_clken),
				.user_base_address(user_base_address),
				.descrm_bypass(descrm_bypass),
				.frmgen_skip_word(frmgen_skip_word_string),
				.frmsync_mfrm_length(frmsync_mfrm_length),
				.blksync_clken(blksync_clken),
				.crcchk_bypass(crcchk_bypass),
				.frmsync_mfrm_length_user(frmsync_mfrm_length_user),
				.rdfifo_clken(rdfifo_clken),
				.crcchk_inv(crcchk_inv),
				.pempty_flag_type(pempty_flag_type),
				.blksync_knum_sh_cnt_prelock(blksync_knum_sh_cnt_prelock),
				.dispchk_clken(dispchk_clken),
				.blksync_knum_sh_cnt_postlock(blksync_knum_sh_cnt_postlock),
				.data_bit_reverse(data_bit_reverse),
				.dispchk_pipeln(dispchk_pipeln),
				.fifo_stop_rd(fifo_stop_rd),
				.crcflag_pipeln(crcflag_pipeln),
				.avmm_group_channel_index(avmm_group_channel_index),
				.gb_rx_odwidth(gb_rx_odwidth),
				.stretch_num_stages(stretch_num_stages),
				.control_del(control_del),
				.blksync_enum_invalid_sh_cnt(blksync_enum_invalid_sh_cnt),
				.dec_64b66b_rxsm_bypass(dec_64b66b_rxsm_bypass),
				.channel_number(channel_number),
				.crcchk_init_user(crcchk_init_user_string),
				.rd_clk_sel(rd_clk_sel),
				.frmsync_enum_scrm(frmsync_enum_scrm),
				.crcchk_pipeln(crcchk_pipeln),
				.test_mode(test_mode),
				.prot_mode(prot_mode),
				.crcchk_init(crcchk_init),
				.rx_fifo_write_ctrl(rx_fifo_write_ctrl),
				.bitslip_mode(bitslip_mode),
				.rx_sm_bypass(rx_sm_bypass)
			) stratixv_hssi_10g_rx_pcs_encrypted_inst (
				.rxprbserr(rxprbserr),
				.rxrdpossts(rxrdpossts),
				.rxprbsdone(rxprbsdone),
				.rxclkiqout(rxclkiqout),
				.rxfifopartialempty(rxfifopartialempty),
				.rxpldclk(rxpldclk),
				.avmmclk(avmmclk),
				.rxfifoinsert(rxfifoinsert),
				.rxdiagnosticerror(rxdiagnosticerror),
				.rxpmaclk(rxpmaclk),
				.rxframelock(rxframelock),
				.avmmrstn(avmmrstn),
				.rxtestdata(rxtestdata),
				.rxmetaframeerror(rxmetaframeerror),
				.avmmbyteen(avmmbyteen),
				.rxhighber(rxhighber),
				.rxdiagnosticstatus(rxdiagnosticstatus),
				.refclkdig(refclkdig),
				.rxpmadata(rxpmadata),
				.rxfifopartialfull(rxfifopartialfull),
				.rxpayloadinserted(rxpayloadinserted),
				.dfxlpbkdatain(dfxlpbkdatain),
				.avmmreaddata(avmmreaddata),
				.rxskipworderror(rxskipworderror),
				.rxrxframe(rxrxframe),
				.rxblocklock(rxblocklock),
				.dfxlpbkcontrolin(dfxlpbkcontrolin),
				.rxfifodel(rxfifodel),
				.rxcontrol(rxcontrol),
				.rxalignval(rxalignval),
				.avmmwrite(avmmwrite),
				.rxscramblererror(rxscramblererror),
				.rxdisparityclr(rxdisparityclr),
				.rxcrc32error(rxcrc32error),
				.hardresetn(hardresetn),
				.rxdatavalid(rxdatavalid),
				.rxrden(rxrden),
				.avmmaddress(avmmaddress),
				.rxpmadatavalid(rxpmadatavalid),
				.rxsyncheadererror(rxsyncheadererror),
				.rxbitslip(rxbitslip),
				.rxclrbercount(rxclrbercount),
				.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
				.rxdata(rxdata),
				.rxclkout(rxclkout),
				.rxclrerrorblockcount(rxclrerrorblockcount),
				.syncdatain(syncdatain),
				.dfxlpbkdatavalidin(dfxlpbkdatavalidin),
				.avmmread(avmmread),
				.rxalignen(rxalignen),
				.rxalignclr(rxalignclr),
				.lpbkdatain(lpbkdatain),
				.blockselect(blockselect),
				.rxprbserrorclr(rxprbserrorclr),
				.rxrdnegsts(rxrdnegsts),
				.rxpldrstn(rxpldrstn),
				.txpmaclk(txpmaclk),
				.rxsyncworderror(rxsyncworderror),
				.rxfifoempty(rxfifoempty),
				.rxskipinserted(rxskipinserted),
				.rxfifofull(rxfifofull),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_10g_tx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_10g_tx_pcs
#(
  	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter stretch_en = "stretch_en",      // Valid values: stretch_en|stretch_dis
	parameter dispgen_pipeln = "dispgen_pipeln_dis",      // Valid values: dispgen_pipeln_dis|dispgen_pipeln_en
	parameter pseudo_seed_a_user = "1111111111111111111111111111111111111111111111111111111111",      // Valid values: 
	parameter tx_polarity_inv = "invert_disable",      // Valid values: invert_disable|invert_enable
	parameter bit_reverse = "bit_reverse_dis",      // Valid values: bit_reverse_dis|bit_reverse_en
	parameter ctrl_plane_bonding = "individual",      // Valid values: individual|ctrl_master|ctrl_slave_abv|ctrl_slave_blw
	parameter crcgen_bypass = "crcgen_bypass_dis",      // Valid values: crcgen_bypass_dis|crcgen_bypass_en
	parameter frmgen_scrm_word = "0010100000000000000000000000000000000000000000000000000000000000",      // Valid values: 
	parameter tx_true_b2b = "b2b",      // Valid values: single|b2b
	parameter distdwn_bypass_pipeln = "distdwn_bypass_pipeln_dis",      // Valid values: distdwn_bypass_pipeln_dis|distdwn_bypass_pipeln_en
	parameter wrfifo_clken = "wrfifo_clk_dis",      // Valid values: wrfifo_clk_dis|wrfifo_clk_en
	parameter frmgen_diag_word = "0000000000000000000000000000000000000000000000000000000000000000",      // Valid values: 
	parameter pmagate_en = "pmagate_dis",      // Valid values: pmagate_dis|pmagate_en
	parameter tx_scrm_width = "bit64",      // Valid values: bit64|bit66|bit67
	parameter scrm_bypass = "scrm_bypass_dis",      // Valid values: scrm_bypass_dis|scrm_bypass_en
	parameter wr_clk_sel = "wr_tx_pma_clk",      // Valid values: wr_tx_pld_clk|wr_tx_pma_clk|wr_refclk_dig
	parameter prbs_clken = "prbs_clk_dis",      // Valid values: prbs_clk_dis|prbs_clk_en
	parameter tx_testbus_sel = "crc32_gen_testbus1",      // Valid values: crc32_gen_testbus1|crc32_gen_testbus2|disp_gen_testbus1|disp_gen_testbus2|frame_gen_testbus1|frame_gen_testbus2|enc64b66b_testbus|txsm_testbus|tx_cp_bond_testbus|prbs_gen_xg_testbus|gearbox_red_testbus1|gearbox_red_testbus2|scramble_testbus1|scramble_testbus2|tx_fifo_testbus1|tx_fifo_testbus2
	parameter scrm_seed_user = "1111111111111111111111111111111111111111111111111111111111",      // Valid values: 58
	parameter pseudo_seed_b = "pseudo_seed_b_user_setting",      // Valid values: pseudo_seed_b_user_setting
	parameter sqwgen_clken = "sqwgen_clk_dis",      // Valid values: sqwgen_clk_dis|sqwgen_clk_en
	parameter distup_bypass_pipeln = "distup_bypass_pipeln_dis",      // Valid values: distup_bypass_pipeln_dis|distup_bypass_pipeln_en
	parameter sh_err = "sh_err_dis",      // Valid values: sh_err_dis|sh_err_en
	parameter gb_sel_mode = "internal",      // Valid values: internal|external
	parameter pseudo_seed_b_user = "1111111111111111111111111111111111111111111111111111111111",      // Valid values: 
	parameter frmgen_wordslip = "frmgen_wordslip_dis",      // Valid values: frmgen_wordslip_dis|frmgen_wordslip_en
	parameter tx_sh_location = "lsb",      // Valid values: lsb|msb
	parameter fastpath = "fastpath_dis",      // Valid values: fastpath_dis|fastpath_en
	parameter test_bus_mode = "tx",      // Valid values: tx|rx
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode|stretch_mode|engr_mode
	parameter dispgen_clken = "dispgen_clk_dis",      // Valid values: dispgen_clk_dis|dispgen_clk_en
	parameter txfifo_pempty = 7,      // Valid values: 
	parameter scrm_seed = "scram_seed_user_setting",      // Valid values: scram_seed_min|scram_seed_max|scram_seed_user_setting
	parameter gbred_clken = "gbred_clk_dis",      // Valid values: gbred_clk_dis|gbred_clk_en
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter tx_scrm_err = "scrm_err_dis",      // Valid values: scrm_err_dis|scrm_err_en
	parameter frmgen_sync_word = "0111100011110110011110001111011001111000111101100111100011110110",      // Valid values: 
	parameter txfifo_full = 31,      // Valid values: 
	parameter frmgen_bypass = "frmgen_bypass_dis",      // Valid values: frmgen_bypass_dis|frmgen_bypass_en
	parameter iqtxrx_clkout_sel = "iq_tx_pma_clk",      // Valid values: iq_tx_pma_clk|iq_tx_pma_clk_div33
	parameter bitslip_en = "bitslip_dis",      // Valid values: bitslip_dis|bitslip_en
	parameter tx_sm_pipeln = "tx_sm_pipeln_dis",      // Valid values: tx_sm_pipeln_dis|tx_sm_pipeln_en
	parameter sq_wave = "sq_wave_4",      // Valid values: sq_wave_1|sq_wave_4|sq_wave_5|sq_wave_6|sq_wave_8|sq_wave_10
	parameter comp_del_sel_agg = "data_agg_del0",      // Valid values: data_agg_del0|data_agg_del1|data_agg_del2|data_agg_del3|data_agg_del4|data_agg_del5|data_agg_del6|data_agg_del7|data_agg_del8
	parameter master_clk_sel = "master_tx_pma_clk",      // Valid values: master_tx_pma_clk|master_refclk_dig
	parameter distup_master = "distup_master_en",      // Valid values: distup_master_en|distup_master_dis
	parameter txfifo_pfull = 23,      // Valid values: 
	parameter skip_ctrl = "skip_ctrl_default",      // Valid values: skip_ctrl_default
	parameter enc64b66b_txsm_clken = "enc64b66b_txsm_clk_dis",      // Valid values: enc64b66b_txsm_clk_dis|enc64b66b_txsm_clk_en
	parameter comp_cnt = "comp_cnt_00",      // Valid values: comp_cnt_00|comp_cnt_02|comp_cnt_04|comp_cnt_06|comp_cnt_08|comp_cnt_0a|comp_cnt_0c|comp_cnt_0e|comp_cnt_10|comp_cnt_12|comp_cnt_14|comp_cnt_16|comp_cnt_18|comp_cnt_1a
	parameter distdwn_master = "distdwn_master_en",      // Valid values: distdwn_master_en|distdwn_master_dis
	parameter txfifo_empty = 0,      // Valid values: 
	parameter phcomp_rd_del = "phcomp_rd_del1",      // Valid values: phcomp_rd_del5|phcomp_rd_del4|phcomp_rd_del3|phcomp_rd_del2|phcomp_rd_del1
	parameter gb_tx_odwidth = "width_32",      // Valid values: width_32|width_40|width_64|width_32_default
	parameter distdwn_bypass_pipeln_agg = "distdwn_bypass_pipeln_agg_dis",      // Valid values: distdwn_bypass_pipeln_agg_dis|distdwn_bypass_pipeln_agg_en
	parameter crcgen_err = "crcgen_err_dis",      // Valid values: crcgen_err_dis|crcgen_err_en
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter scrm_mode = "async",      // Valid values: async|sync
	parameter frmgen_skip_word = "0001111000011110000111100001111000011110000111100001111000011110",      // Valid values: 
	parameter txfifo_mode = "phase_comp",      // Valid values: register_mode|clk_comp|interlaken_generic|basic_generic|phase_comp|generic
	parameter crcgen_init = "crcgen_init_user_setting",      // Valid values: crcgen_init_user_setting
	parameter crcgen_init_user = "11111111111111111111111111111111",      // Valid values: 
	parameter frmgen_pipeln = "frmgen_pipeln_dis",      // Valid values: frmgen_pipeln_dis|frmgen_pipeln_en
	parameter frmgen_mfrm_length = "frmgen_mfrm_length_min",      // Valid values: frmgen_mfrm_length_min|frmgen_mfrm_length_max|frmgen_mfrm_length_user_setting
	parameter rdfifo_clken = "rdfifo_clk_dis",      // Valid values: rdfifo_clk_dis|rdfifo_clk_en
	parameter crcgen_inv = "crcgen_inv_dis",      // Valid values: crcgen_inv_dis|crcgen_inv_en
	parameter scrm_clken = "scrm_clk_dis",      // Valid values: scrm_clk_dis|scrm_clk_en
	parameter enc_64b66b_txsm_bypass = "enc_64b66b_txsm_bypass_dis",      // Valid values: enc_64b66b_txsm_bypass_dis|enc_64b66b_txsm_bypass_en
	parameter frmgen_pyld_ins = "frmgen_pyld_ins_dis",      // Valid values: frmgen_pyld_ins_dis|frmgen_pyld_ins_en
	parameter frmgen_burst = "frmgen_burst_dis",      // Valid values: frmgen_burst_dis|frmgen_burst_en
	parameter indv = "indv_en",      // Valid values: indv_en|indv_dis
	parameter pseudo_seed_a = "pseudo_seed_a_user_setting",      // Valid values: pseudo_seed_a_user_setting
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter compin_sel = "compin_master",      // Valid values: compin_master|compin_slave_top|compin_slave_bot|compin_default
	parameter gb_tx_idwidth = "width_50",      // Valid values: width_32|width_40|width_50|width_67|width_64|width_66
	parameter stretch_num_stages = "zero_stage",      // Valid values: zero_stage|one_stage|two_stage|three_stage
	parameter pseudo_random = "all_0",      // Valid values: all_0|two_lf
	parameter channel_number = 0,      // Valid values: 0..65
	parameter dispgen_err = "dispgen_err_dis",      // Valid values: dispgen_err_dis|dispgen_err_en
	parameter dispgen_bypass = "dispgen_bypass_dis",      // Valid values: dispgen_bypass_dis|dispgen_bypass_en
	parameter tx_sm_bypass = "tx_sm_bypass_dis",      // Valid values: tx_sm_bypass_dis|tx_sm_bypass_en
	parameter test_mode = "test_off",      // Valid values: test_off|pseudo_random|sq_wave|prbs_31|prbs_23|prbs_9|prbs_7
	parameter crcgen_clken = "crcgen_clk_dis",      // Valid values: crcgen_clk_dis|crcgen_clk_en
	parameter frmgen_mfrm_length_user = 5,      // Valid values: 
	parameter distup_bypass_pipeln_agg = "distup_bypass_pipeln_agg_dis",      // Valid values: distup_bypass_pipeln_agg_dis|distup_bypass_pipeln_agg_en
	parameter prot_mode = "disable_mode",      // Valid values: disable_mode|teng_baser_mode|interlaken_mode|sfis_mode|teng_sdi_mode|basic_mode|test_prbs_mode|test_prp_mode|test_rpg_mode
	parameter frmgen_clken = "frmgen_clk_dis",      // Valid values: frmgen_clk_dis|frmgen_clk_en
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter stretch_type = "stretch_auto",      // Valid values: stretch_auto|stretch_custom
	parameter full_flag_type = "full_wr_side",      // Valid values: full_rd_side|full_wr_side
	parameter distup_master_agg = "distup_master_agg_en",      // Valid values: distup_master_agg_en|distup_master_agg_dis
	parameter ctrl_bit_reverse = "ctrl_bit_reverse_dis",      // Valid values: ctrl_bit_reverse_dis|ctrl_bit_reverse_en
	parameter empty_flag_type = "empty_rd_side",      // Valid values: empty_rd_side|empty_wr_side
	parameter data_agg_comp = "data_agg_del0",      // Valid values: data_agg_del0|data_agg_del1|data_agg_del2|data_agg_del3|data_agg_del4|data_agg_del5|data_agg_del6|data_agg_del7|data_agg_del8
	parameter fifo_stop_wr = "n_wr_full",      // Valid values: wr_full|n_wr_full
	parameter pfull_flag_type = "pfull_wr_side",      // Valid values: pfull_rd_side|pfull_wr_side
	parameter distdwn_master_agg = "distdwn_master_agg_en",      // Valid values: distdwn_master_agg_en|distdwn_master_agg_dis
	parameter compin_sel_agg = "compin_agg_master",      // Valid values: compin_agg_master|compin_agg_slave_top|compin_agg_slave_bot|compin_agg_default
	parameter pempty_flag_type = "pempty_rd_side",      // Valid values: pempty_rd_side|pempty_wr_side
	parameter data_bit_reverse = "data_bit_reverse_dis",      // Valid values: data_bit_reverse_dis|data_bit_reverse_en
	parameter fifo_stop_rd = "n_rd_empty",      // Valid values: rd_empty|n_rd_empty
	parameter data_agg_bonding = "agg_individual",      // Valid values: agg_individual|agg_master|agg_slave_abv|agg_slave_blw
	parameter del_sel_frame_gen = "del_sel_frame_gen_del0"      // Valid values: del_sel_frame_gen_del0
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 8:0 ] dfxlpbkcontrolout,
	output [ 63:0 ] dfxlpbkdataout,
	output [ 0:0 ] dfxlpbkdatavalidout,
	input  [ 0:0 ] distdwnindv,
	input  [ 0:0 ] distdwninintlknrden,
	input  [ 0:0 ] distdwninrden,
	input  [ 0:0 ] distdwninrdpfull,
	input  [ 0:0 ] distdwninwren,
	output [ 0:0 ] distdwnoutdv,
	output [ 0:0 ] distdwnoutintlknrden,
	output [ 0:0 ] distdwnoutrden,
	output [ 0:0 ] distdwnoutrdpfull,
	output [ 0:0 ] distdwnoutwren,
	input  [ 0:0 ] distupindv,
	input  [ 0:0 ] distupinintlknrden,
	input  [ 0:0 ] distupinrden,
	input  [ 0:0 ] distupinrdpfull,
	input  [ 0:0 ] distupinwren,
	output [ 0:0 ] distupoutdv,
	output [ 0:0 ] distupoutintlknrden,
	output [ 0:0 ] distupoutrden,
	output [ 0:0 ] distupoutrdpfull,
	output [ 0:0 ] distupoutwren,
	input  [ 0:0 ] hardresetn,
	output [ 79:0 ] lpbkdataout,
	input  [ 0:0 ] pmaclkdiv33lc,
	input  [ 0:0 ] refclkdig,
	output [ 0:0 ] syncdatain,
	input  [ 6:0 ] txbitslip,
	input  [ 0:0 ] txbursten,
	output [ 0:0 ] txburstenexe,
	output [ 0:0 ] txclkiqout,
	output [ 0:0 ] txclkout,
	input  [ 8:0 ] txcontrol,
	input  [ 63:0 ] txdata,
	input  [ 0:0 ] txdatavalid,
	input  [ 1:0 ] txdiagnosticstatus,
	input  [ 0:0 ] txdisparityclr,
	output [ 0:0 ] txfifodel,
	output [ 0:0 ] txfifoempty,
	output [ 0:0 ] txfifofull,
	output [ 0:0 ] txfifoinsert,
	output [ 0:0 ] txfifopartialempty,
	output [ 0:0 ] txfifopartialfull,
	output [ 0:0 ] txframe,
	input  [ 0:0 ] txpldclk,
	input  [ 0:0 ] txpldrstn,
	input  [ 0:0 ] txpmaclk,
	output [ 79:0 ] txpmadata,
	input  [ 0:0 ] txwordslip,
	output [ 0:0 ] txwordslipexe
);
	// Function to convert a 64bit binary to a string
	// This function also exists in stratixv_hssi_10g_rx_pcs_wrapper_multirev.v
	function [64*8-1 : 0] m_bin_to_str;
	    input	[64 : 1]	s;
	    
    	reg		[64 : 1]	reg_s;
	    reg		[7 : 0]		tmp;
    	reg		[64*8 : 1]	res;  
    
	    integer m, index;
    	begin
    		reg_s = s;
    		res = 64'h0000000000000000;
    		for (m = 64; m > 0; m = m-1 )
    		begin
    			tmp = reg_s[64];
    			res[(((m-1)*8)+1)] = tmp & 1'b1;
    			reg_s = reg_s << 1;
    		end
    	
    		m_bin_to_str = res;
    	end
	endfunction

	localparam [8*64-1 : 0] pseudo_seed_a_user_string	= m_bin_to_str(pseudo_seed_a_user);
	localparam [8*64-1 : 0] pseudo_seed_b_user_string	= m_bin_to_str(pseudo_seed_b_user);
	localparam [8*64-1 : 0] scrm_seed_user_string		= m_bin_to_str(scrm_seed_user);
	localparam [8*64-1 : 0] frmgen_sync_word_string	= m_bin_to_str(frmgen_sync_word);
	localparam [8*64-1 : 0] frmgen_scrm_word_string	= m_bin_to_str(frmgen_scrm_word);
	localparam [8*64-1 : 0] frmgen_skip_word_string	= m_bin_to_str(frmgen_skip_word);
	localparam [8*64-1 : 0] frmgen_diag_word_string	= m_bin_to_str(frmgen_diag_word);

	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_10g_tx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_10g_tx_pcs_encrypted_ES #(
				.enable_debug_info(enable_debug_info),
				.stretch_en(stretch_en),
				.dispgen_pipeln(dispgen_pipeln),
				.pseudo_seed_a_user(pseudo_seed_a_user_string),
				.tx_polarity_inv(tx_polarity_inv),
				.bit_reverse(bit_reverse),
				.ctrl_plane_bonding(ctrl_plane_bonding),
				.crcgen_bypass(crcgen_bypass),
				.frmgen_scrm_word(frmgen_scrm_word_string),
				.tx_true_b2b(tx_true_b2b),
				.distdwn_bypass_pipeln(distdwn_bypass_pipeln),
				.wrfifo_clken(wrfifo_clken),
				.frmgen_diag_word(frmgen_diag_word_string),
				.pmagate_en(pmagate_en),
				.tx_scrm_width(tx_scrm_width),
				.scrm_bypass(scrm_bypass),
				.wr_clk_sel(wr_clk_sel),
				.prbs_clken(prbs_clken),
				.tx_testbus_sel(tx_testbus_sel),
				.scrm_seed_user(scrm_seed_user_string),
				.pseudo_seed_b(pseudo_seed_b),
				.sqwgen_clken(sqwgen_clken),
				.distup_bypass_pipeln(distup_bypass_pipeln),
				.sh_err(sh_err),
				.gb_sel_mode(gb_sel_mode),
				.pseudo_seed_b_user(pseudo_seed_b_user_string),
				.frmgen_wordslip(frmgen_wordslip),
				.tx_sh_location(tx_sh_location),
				.fastpath(fastpath),
				.test_bus_mode(test_bus_mode),
				.sup_mode(sup_mode),
				.dispgen_clken(dispgen_clken),
				.txfifo_pempty(txfifo_pempty),
				.scrm_seed(scrm_seed),
				.gbred_clken(gbred_clken),
				.use_default_base_address(use_default_base_address),
				.tx_scrm_err(tx_scrm_err),
				.frmgen_sync_word(frmgen_sync_word_string),
				.txfifo_full(txfifo_full),
				.frmgen_bypass(frmgen_bypass),
				.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
				.bitslip_en(bitslip_en),
				.tx_sm_pipeln(tx_sm_pipeln),
				.sq_wave(sq_wave),
				.comp_del_sel_agg(comp_del_sel_agg),
				.master_clk_sel(master_clk_sel),
				.distup_master(distup_master),
				.txfifo_pfull(txfifo_pfull),
				.skip_ctrl(skip_ctrl),
				.enc64b66b_txsm_clken(enc64b66b_txsm_clken),
				.comp_cnt(comp_cnt),
				.distdwn_master(distdwn_master),
				.txfifo_empty(txfifo_empty),
				.phcomp_rd_del(phcomp_rd_del),
				.gb_tx_odwidth(gb_tx_odwidth),
				.distdwn_bypass_pipeln_agg(distdwn_bypass_pipeln_agg),
				.crcgen_err(crcgen_err),
				.user_base_address(user_base_address),
				.scrm_mode(scrm_mode),
				.frmgen_skip_word(frmgen_skip_word_string),
				.txfifo_mode(txfifo_mode),
				.crcgen_init(crcgen_init),
				.crcgen_init_user(crcgen_init_user),
				.frmgen_pipeln(frmgen_pipeln),
				.frmgen_mfrm_length(frmgen_mfrm_length),
				.rdfifo_clken(rdfifo_clken),
				.crcgen_inv(crcgen_inv),
				.scrm_clken(scrm_clken),
				.enc_64b66b_txsm_bypass(enc_64b66b_txsm_bypass),
				.frmgen_pyld_ins(frmgen_pyld_ins),
				.frmgen_burst(frmgen_burst),
				.indv(indv),
				.pseudo_seed_a(pseudo_seed_a),
				.avmm_group_channel_index(avmm_group_channel_index),
				.compin_sel(compin_sel),
				.gb_tx_idwidth(gb_tx_idwidth),
				.stretch_num_stages(stretch_num_stages),
				.pseudo_random(pseudo_random),
				.channel_number(channel_number),
				.dispgen_err(dispgen_err),
				.dispgen_bypass(dispgen_bypass),
				.tx_sm_bypass(tx_sm_bypass),
				.test_mode(test_mode),
				.crcgen_clken(crcgen_clken),
				.frmgen_mfrm_length_user(frmgen_mfrm_length_user),
				.distup_bypass_pipeln_agg(distup_bypass_pipeln_agg),
				.prot_mode(prot_mode),
				.frmgen_clken(frmgen_clken)
			) stratixv_hssi_10g_tx_pcs_encrypted_ES_inst (
				.txfifopartialfull(txfifopartialfull),
				.txclkout(txclkout),
				.distdwninrdpfull(distdwninrdpfull),
				.distdwnoutwren(distdwnoutwren),
				.avmmclk(avmmclk),
				.txdatavalid(txdatavalid),
				.txfifodel(txfifodel),
				.txwordslip(txwordslip),
				.avmmrstn(avmmrstn),
				.txfifofull(txfifofull),
				.txpldrstn(txpldrstn),
				.avmmbyteen(avmmbyteen),
				.txbursten(txbursten),
				.refclkdig(refclkdig),
				.distupinintlknrden(distupinintlknrden),
				.txclkiqout(txclkiqout),
				.distdwnoutrden(distdwnoutrden),
				.distdwnoutdv(distdwnoutdv),
				.txpmadata(txpmadata),
				.distdwnoutrdpfull(distdwnoutrdpfull),
				.avmmreaddata(avmmreaddata),
				.distdwninwren(distdwninwren),
				.txfifoempty(txfifoempty),
				.distupoutrden(distupoutrden),
				.lpbkdataout(lpbkdataout),
				.distupoutdv(distupoutdv),
				.avmmwrite(avmmwrite),
				.hardresetn(hardresetn),
				.avmmaddress(avmmaddress),
				.dfxlpbkdatavalidout(dfxlpbkdatavalidout),
				.dfxlpbkdataout(dfxlpbkdataout),
				.distdwninintlknrden(distdwninintlknrden),
				.txfifoinsert(txfifoinsert),
				.distdwnoutintlknrden(distdwnoutintlknrden),
				.distupoutwren(distupoutwren),
				.distdwnindv(distdwnindv),
				.txdiagnosticstatus(txdiagnosticstatus),
				.distupinrdpfull(distupinrdpfull),
				.txcontrol(txcontrol),
				.txwordslipexe(txwordslipexe),
				.distupinwren(distupinwren),
				.syncdatain(syncdatain),
				.dfxlpbkcontrolout(dfxlpbkcontrolout),
				.avmmread(avmmread),
				.distupindv(distupindv),
				.blockselect(blockselect),
				.distupoutintlknrden(distupoutintlknrden),
				.distdwninrden(distdwninrden),
				.pmaclkdiv33lc(pmaclkdiv33lc),
				.txburstenexe(txburstenexe),
				.distupinrden(distupinrden),
				.distupoutrdpfull(distupoutrdpfull),
				.txdata(txdata),
				.txpmaclk(txpmaclk),
				.txbitslip(txbitslip),
				.txdisparityclr(txdisparityclr),
				.txframe(txframe),
				.txfifopartialempty(txfifopartialempty),
				.txpldclk(txpldclk),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_10g_tx_pcs_encrypted #(
				.enable_debug_info(enable_debug_info),
				.stretch_en(stretch_en),
				.dispgen_pipeln(dispgen_pipeln),
				.pseudo_seed_a_user(pseudo_seed_a_user_string),
				.tx_polarity_inv(tx_polarity_inv),
				.bit_reverse(bit_reverse),
				.ctrl_plane_bonding(ctrl_plane_bonding),
				.crcgen_bypass(crcgen_bypass),
				.frmgen_scrm_word(frmgen_scrm_word_string),
				.stretch_type(stretch_type),
				.full_flag_type(full_flag_type),
				.tx_true_b2b(tx_true_b2b),
				.distdwn_bypass_pipeln(distdwn_bypass_pipeln),
				.wrfifo_clken(wrfifo_clken),
				.distup_master_agg(distup_master_agg),
				.frmgen_diag_word(frmgen_diag_word_string),
				.pmagate_en(pmagate_en),
				.tx_scrm_width(tx_scrm_width),
				.scrm_bypass(scrm_bypass),
				.wr_clk_sel(wr_clk_sel),
				.prbs_clken(prbs_clken),
				.tx_testbus_sel(tx_testbus_sel),
				.scrm_seed_user(scrm_seed_user_string),
				.pseudo_seed_b(pseudo_seed_b),
				.sqwgen_clken(sqwgen_clken),
				.distup_bypass_pipeln(distup_bypass_pipeln),
				.sh_err(sh_err),
				.ctrl_bit_reverse(ctrl_bit_reverse),
				.gb_sel_mode(gb_sel_mode),
				.pseudo_seed_b_user(pseudo_seed_b_user_string),
				.frmgen_wordslip(frmgen_wordslip),
				.tx_sh_location(tx_sh_location),
				.fastpath(fastpath),
				.test_bus_mode(test_bus_mode),
				.sup_mode(sup_mode),
				.dispgen_clken(dispgen_clken),
				.txfifo_pempty(txfifo_pempty),
				.scrm_seed(scrm_seed),
				.gbred_clken(gbred_clken),
				.use_default_base_address(use_default_base_address),
				.tx_scrm_err(tx_scrm_err),
				.frmgen_sync_word(frmgen_sync_word_string),
				.txfifo_full(txfifo_full),
				.empty_flag_type(empty_flag_type),
				.frmgen_bypass(frmgen_bypass),
				.iqtxrx_clkout_sel(iqtxrx_clkout_sel),
				.data_agg_comp(data_agg_comp),
				.fifo_stop_wr(fifo_stop_wr),
				.bitslip_en(bitslip_en),
				.tx_sm_pipeln(tx_sm_pipeln),
				.pfull_flag_type(pfull_flag_type),
				.sq_wave(sq_wave),
				.comp_del_sel_agg(comp_del_sel_agg),
				.master_clk_sel(master_clk_sel),
				.distup_master(distup_master),
				.txfifo_pfull(txfifo_pfull),
				.skip_ctrl(skip_ctrl),
				.distdwn_master_agg(distdwn_master_agg),
				.enc64b66b_txsm_clken(enc64b66b_txsm_clken),
				.comp_cnt(comp_cnt),
				.distdwn_master(distdwn_master),
				.txfifo_empty(txfifo_empty),
				.phcomp_rd_del(phcomp_rd_del),
				.compin_sel_agg(compin_sel_agg),
				.gb_tx_odwidth(gb_tx_odwidth),
				.distdwn_bypass_pipeln_agg(distdwn_bypass_pipeln_agg),
				.crcgen_err(crcgen_err),
				.user_base_address(user_base_address),
				.scrm_mode(scrm_mode),
				.frmgen_skip_word(frmgen_skip_word_string),
				.txfifo_mode(txfifo_mode),
				.crcgen_init(crcgen_init),
				.crcgen_init_user(crcgen_init_user),
				.frmgen_pipeln(frmgen_pipeln),
				.frmgen_mfrm_length(frmgen_mfrm_length),
				.rdfifo_clken(rdfifo_clken),
				.crcgen_inv(crcgen_inv),
				.pempty_flag_type(pempty_flag_type),
				.data_bit_reverse(data_bit_reverse),
				.fifo_stop_rd(fifo_stop_rd),
				.scrm_clken(scrm_clken),
				.enc_64b66b_txsm_bypass(enc_64b66b_txsm_bypass),
				.frmgen_pyld_ins(frmgen_pyld_ins),
				.data_agg_bonding(data_agg_bonding),
				.frmgen_burst(frmgen_burst),
				.indv(indv),
				.pseudo_seed_a(pseudo_seed_a),
				.avmm_group_channel_index(avmm_group_channel_index),
				.compin_sel(compin_sel),
				.gb_tx_idwidth(gb_tx_idwidth),
				.stretch_num_stages(stretch_num_stages),
				.pseudo_random(pseudo_random),
				.channel_number(channel_number),
				.dispgen_err(dispgen_err),
				.dispgen_bypass(dispgen_bypass),
				.tx_sm_bypass(tx_sm_bypass),
				.test_mode(test_mode),
				.del_sel_frame_gen(del_sel_frame_gen),
				.crcgen_clken(crcgen_clken),
				.frmgen_mfrm_length_user(frmgen_mfrm_length_user),
				.distup_bypass_pipeln_agg(distup_bypass_pipeln_agg),
				.prot_mode(prot_mode),
				.frmgen_clken(frmgen_clken)
			) stratixv_hssi_10g_tx_pcs_encrypted_inst (
				.txfifopartialfull(txfifopartialfull),
				.txclkout(txclkout),
				.distdwninrdpfull(distdwninrdpfull),
				.distdwnoutwren(distdwnoutwren),
				.avmmclk(avmmclk),
				.txdatavalid(txdatavalid),
				.txfifodel(txfifodel),
				.txwordslip(txwordslip),
				.avmmrstn(avmmrstn),
				.txfifofull(txfifofull),
				.txpldrstn(txpldrstn),
				.avmmbyteen(avmmbyteen),
				.txbursten(txbursten),
				.refclkdig(refclkdig),
				.distupinintlknrden(distupinintlknrden),
				.txclkiqout(txclkiqout),
				.distdwnoutrden(distdwnoutrden),
				.distdwnoutdv(distdwnoutdv),
				.txpmadata(txpmadata),
				.distdwnoutrdpfull(distdwnoutrdpfull),
				.avmmreaddata(avmmreaddata),
				.distdwninwren(distdwninwren),
				.txfifoempty(txfifoempty),
				.distupoutrden(distupoutrden),
				.lpbkdataout(lpbkdataout),
				.distupoutdv(distupoutdv),
				.avmmwrite(avmmwrite),
				.hardresetn(hardresetn),
				.avmmaddress(avmmaddress),
				.dfxlpbkdatavalidout(dfxlpbkdatavalidout),
				.dfxlpbkdataout(dfxlpbkdataout),
				.distdwninintlknrden(distdwninintlknrden),
				.txfifoinsert(txfifoinsert),
				.distdwnoutintlknrden(distdwnoutintlknrden),
				.distupoutwren(distupoutwren),
				.distdwnindv(distdwnindv),
				.txdiagnosticstatus(txdiagnosticstatus),
				.distupinrdpfull(distupinrdpfull),
				.txcontrol(txcontrol),
				.txwordslipexe(txwordslipexe),
				.distupinwren(distupinwren),
				.syncdatain(syncdatain),
				.dfxlpbkcontrolout(dfxlpbkcontrolout),
				.avmmread(avmmread),
				.distupindv(distupindv),
				.blockselect(blockselect),
				.distupoutintlknrden(distupoutintlknrden),
				.distdwninrden(distdwninrden),
				.pmaclkdiv33lc(pmaclkdiv33lc),
				.txburstenexe(txburstenexe),
				.distupinrden(distupinrden),
				.distupoutrdpfull(distupoutrdpfull),
				.txdata(txdata),
				.txpmaclk(txpmaclk),
				.txbitslip(txbitslip),
				.txdisparityclr(txdisparityclr),
				.txframe(txframe),
				.txfifopartialempty(txfifopartialempty),
				.txpldclk(txpldclk),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_8g_pcs_aggregate_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_8g_pcs_aggregate
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter dskw_mnumber_data = 4'b100,      // Valid values: 4
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter data_agg_bonding = "agg_disable",      // Valid values: agg_disable|x4_cmu1|x4_cmu2|x4_cmu3|x4_lc1|x4_lc2|x4_lc3|x2_cmu1|x2_lc1
	parameter xaui_sm_operation = "en_xaui_sm",      // Valid values: dis_xaui_sm|en_xaui_sm|en_xaui_legacy_sm
	parameter pcs_dw_datapath = "sw_data_path",      // Valid values: sw_data_path|dw_data_path
	parameter prot_mode_tx = "pipe_g1_tx",      // Valid values: pipe_g1_tx|pipe_g2_tx|pipe_g3_tx|cpri_tx|cpri_rx_tx_tx|gige_tx|xaui_tx|srio_2p1_tx|test_tx|basic_tx|disabled_prot_mode_tx
	parameter dskw_control = "dskw_write_control",      // Valid values: dskw_write_control|dskw_read_control
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter dskw_sm_operation = "dskw_xaui_sm",      // Valid values: dskw_xaui_sm|dskw_srio_sm
	parameter refclkdig_sel = "dis_refclk_dig_sel",      // Valid values: dis_refclk_dig_sel|en_refclk_dig_sel
	parameter agg_pwdn = "dis_agg_pwdn",      // Valid values: dis_agg_pwdn|en_agg_pwdn
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 15:0 ] aggtestbusch0,
	output [ 15:0 ] aggtestbusch1,
	output [ 15:0 ] aggtestbusch2,
	input  [ 1:0 ] aligndetsyncbotch2,
	input  [ 1:0 ] aligndetsyncch0,
	input  [ 1:0 ] aligndetsyncch1,
	input  [ 1:0 ] aligndetsyncch2,
	input  [ 1:0 ] aligndetsynctopch0,
	input  [ 1:0 ] aligndetsynctopch1,
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
	input  [ 0:0 ] alignstatussyncbotch2,
	input  [ 0:0 ] alignstatussyncch0,
	input  [ 0:0 ] alignstatussyncch1,
	input  [ 0:0 ] alignstatussyncch2,
	input  [ 0:0 ] alignstatussynctopch0,
	input  [ 0:0 ] alignstatussynctopch1,
	output [ 0:0 ] alignstatustopch0,
	output [ 0:0 ] alignstatustopch1,
	output [ 0:0 ] cgcomprddallbotch2,
	output [ 0:0 ] cgcomprddallch0,
	output [ 0:0 ] cgcomprddallch1,
	output [ 0:0 ] cgcomprddallch2,
	output [ 0:0 ] cgcomprddalltopch0,
	output [ 0:0 ] cgcomprddalltopch1,
	input  [ 1:0 ] cgcomprddinbotch2,
	input  [ 1:0 ] cgcomprddinch0,
	input  [ 1:0 ] cgcomprddinch1,
	input  [ 1:0 ] cgcomprddinch2,
	input  [ 1:0 ] cgcomprddintopch0,
	input  [ 1:0 ] cgcomprddintopch1,
	output [ 0:0 ] cgcompwrallbotch2,
	output [ 0:0 ] cgcompwrallch0,
	output [ 0:0 ] cgcompwrallch1,
	output [ 0:0 ] cgcompwrallch2,
	output [ 0:0 ] cgcompwralltopch0,
	output [ 0:0 ] cgcompwralltopch1,
	input  [ 1:0 ] cgcompwrinbotch2,
	input  [ 1:0 ] cgcompwrinch0,
	input  [ 1:0 ] cgcompwrinch1,
	input  [ 1:0 ] cgcompwrinch2,
	input  [ 1:0 ] cgcompwrintopch0,
	input  [ 1:0 ] cgcompwrintopch1,
	input  [ 0:0 ] decctlbotch2,
	input  [ 0:0 ] decctlch0,
	input  [ 0:0 ] decctlch1,
	input  [ 0:0 ] decctlch2,
	input  [ 0:0 ] decctltopch0,
	input  [ 0:0 ] decctltopch1,
	input  [ 7:0 ] decdatabotch2,
	input  [ 7:0 ] decdatach0,
	input  [ 7:0 ] decdatach1,
	input  [ 7:0 ] decdatach2,
	input  [ 7:0 ] decdatatopch0,
	input  [ 7:0 ] decdatatopch1,
	input  [ 0:0 ] decdatavalidbotch2,
	input  [ 0:0 ] decdatavalidch0,
	input  [ 0:0 ] decdatavalidch1,
	input  [ 0:0 ] decdatavalidch2,
	input  [ 0:0 ] decdatavalidtopch0,
	input  [ 0:0 ] decdatavalidtopch1,
	input  [ 0:0 ] dedicatedaggscaninch1,
	output [ 0:0 ] dedicatedaggscanoutch0tieoff,
	output [ 0:0 ] dedicatedaggscanoutch1,
	output [ 0:0 ] dedicatedaggscanoutch2tieoff,
	output [ 0:0 ] delcondmet0botch2,
	output [ 0:0 ] delcondmet0ch0,
	output [ 0:0 ] delcondmet0ch1,
	output [ 0:0 ] delcondmet0ch2,
	output [ 0:0 ] delcondmet0topch0,
	output [ 0:0 ] delcondmet0topch1,
	input  [ 0:0 ] delcondmetinbotch2,
	input  [ 0:0 ] delcondmetinch0,
	input  [ 0:0 ] delcondmetinch1,
	input  [ 0:0 ] delcondmetinch2,
	input  [ 0:0 ] delcondmetintopch0,
	input  [ 0:0 ] delcondmetintopch1,
	input  [ 63:0 ] dprioagg,
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
	input  [ 0:0 ] fifoovrinbotch2,
	input  [ 0:0 ] fifoovrinch0,
	input  [ 0:0 ] fifoovrinch1,
	input  [ 0:0 ] fifoovrinch2,
	input  [ 0:0 ] fifoovrintopch0,
	input  [ 0:0 ] fifoovrintopch1,
	input  [ 0:0 ] fifordinbotch2,
	input  [ 0:0 ] fifordinch0,
	input  [ 0:0 ] fifordinch1,
	input  [ 0:0 ] fifordinch2,
	input  [ 0:0 ] fifordintopch0,
	input  [ 0:0 ] fifordintopch1,
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
	input  [ 0:0 ] insertincompleteinbotch2,
	input  [ 0:0 ] insertincompleteinch0,
	input  [ 0:0 ] insertincompleteinch1,
	input  [ 0:0 ] insertincompleteinch2,
	input  [ 0:0 ] insertincompleteintopch0,
	input  [ 0:0 ] insertincompleteintopch1,
	output [ 0:0 ] latencycomp0botch2,
	output [ 0:0 ] latencycomp0ch0,
	output [ 0:0 ] latencycomp0ch1,
	output [ 0:0 ] latencycomp0ch2,
	output [ 0:0 ] latencycomp0topch0,
	output [ 0:0 ] latencycomp0topch1,
	input  [ 0:0 ] latencycompinbotch2,
	input  [ 0:0 ] latencycompinch0,
	input  [ 0:0 ] latencycompinch1,
	input  [ 0:0 ] latencycompinch2,
	input  [ 0:0 ] latencycompintopch0,
	input  [ 0:0 ] latencycompintopch1,
	input  [ 0:0 ] rcvdclkch0,
	input  [ 0:0 ] rcvdclkch1,
	output [ 0:0 ] rcvdclkout,
	output [ 0:0 ] rcvdclkoutbot,
	output [ 0:0 ] rcvdclkouttop,
	input  [ 1:0 ] rdalignbotch2,
	input  [ 1:0 ] rdalignch0,
	input  [ 1:0 ] rdalignch1,
	input  [ 1:0 ] rdalignch2,
	input  [ 1:0 ] rdaligntopch0,
	input  [ 1:0 ] rdaligntopch1,
	input  [ 0:0 ] rdenablesyncbotch2,
	input  [ 0:0 ] rdenablesyncch0,
	input  [ 0:0 ] rdenablesyncch1,
	input  [ 0:0 ] rdenablesyncch2,
	input  [ 0:0 ] rdenablesynctopch0,
	input  [ 0:0 ] rdenablesynctopch1,
	input  [ 0:0 ] refclkdig,
	input  [ 1:0 ] runningdispbotch2,
	input  [ 1:0 ] runningdispch0,
	input  [ 1:0 ] runningdispch1,
	input  [ 1:0 ] runningdispch2,
	input  [ 1:0 ] runningdisptopch0,
	input  [ 1:0 ] runningdisptopch1,
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
	input  [ 0:0 ] rxpcsrstn,
	input  [ 0:0 ] scanmoden,
	input  [ 0:0 ] scanshiftn,
	input  [ 0:0 ] syncstatusbotch2,
	input  [ 0:0 ] syncstatusch0,
	input  [ 0:0 ] syncstatusch1,
	input  [ 0:0 ] syncstatusch2,
	input  [ 0:0 ] syncstatustopch0,
	input  [ 0:0 ] syncstatustopch1,
	input  [ 0:0 ] txctltcbotch2,
	input  [ 0:0 ] txctltcch0,
	input  [ 0:0 ] txctltcch1,
	input  [ 0:0 ] txctltcch2,
	input  [ 0:0 ] txctltctopch0,
	input  [ 0:0 ] txctltctopch1,
	output [ 0:0 ] txctltsbotch2,
	output [ 0:0 ] txctltsch0,
	output [ 0:0 ] txctltsch1,
	output [ 0:0 ] txctltsch2,
	output [ 0:0 ] txctltstopch0,
	output [ 0:0 ] txctltstopch1,
	input  [ 7:0 ] txdatatcbotch2,
	input  [ 7:0 ] txdatatcch0,
	input  [ 7:0 ] txdatatcch1,
	input  [ 7:0 ] txdatatcch2,
	input  [ 7:0 ] txdatatctopch0,
	input  [ 7:0 ] txdatatctopch1,
	output [ 7:0 ] txdatatsbotch2,
	output [ 7:0 ] txdatatsch0,
	output [ 7:0 ] txdatatsch1,
	output [ 7:0 ] txdatatsch2,
	output [ 7:0 ] txdatatstopch0,
	output [ 7:0 ] txdatatstopch1,
	input  [ 0:0 ] txpcsrstn,
	input  [ 0:0 ] txpmaclk
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_8g_pcs_aggregate : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_8g_pcs_aggregate_encrypted_ES #(
				.user_base_address(user_base_address),
				.dskw_mnumber_data(dskw_mnumber_data),
				.use_default_base_address(use_default_base_address),
				.data_agg_bonding(data_agg_bonding),
				.xaui_sm_operation(xaui_sm_operation),
				.pcs_dw_datapath(pcs_dw_datapath),
				.prot_mode_tx(prot_mode_tx),
				.dskw_control(dskw_control),
				.avmm_group_channel_index(avmm_group_channel_index),
				.dskw_sm_operation(dskw_sm_operation),
				.refclkdig_sel(refclkdig_sel),
				.agg_pwdn(agg_pwdn)
			) stratixv_hssi_8g_pcs_aggregate_encrypted_ES_inst (
				.latencycompinch0(latencycompinch0),
				.insertincompleteintopch0(insertincompleteintopch0),
				.delcondmet0ch1(delcondmet0ch1),
				.alignstatussync0botch2(alignstatussync0botch2),
				.rdenablesynctopch0(rdenablesynctopch0),
				.decdatabotch2(decdatabotch2),
				.rxdatarsch1(rxdatarsch1),
				.fifordintopch0(fifordintopch0),
				.fiforstrdqdch2(fiforstrdqdch2),
				.syncstatusch0(syncstatusch0),
				.txdatatsch1(txdatatsch1),
				.insertincomplete0ch2(insertincomplete0ch2),
				.latencycompinch2(latencycompinch2),
				.delcondmetintopch1(delcondmetintopch1),
				.rdenablesyncch2(rdenablesyncch2),
				.fiforstrdqdch0(fiforstrdqdch0),
				.fifordoutcomp0topch0(fifordoutcomp0topch0),
				.rdenablesyncch1(rdenablesyncch1),
				.decctlch0(decctlch0),
				.txctltsch0(txctltsch0),
				.rxctlrsch1(rxctlrsch1),
				.alignstatussynctopch1(alignstatussynctopch1),
				.alignstatusbotch2(alignstatusbotch2),
				.rxctlrsbotch2(rxctlrsbotch2),
				.alignstatussync0topch1(alignstatussync0topch1),
				.endskwrdptrstopch0(endskwrdptrstopch0),
				.decctltopch1(decctltopch1),
				.cgcomprddalltopch0(cgcomprddalltopch0),
				.cgcomprddinch1(cgcomprddinch1),
				.delcondmet0topch1(delcondmet0topch1),
				.endskwqdbotch2(endskwqdbotch2),
				.latencycomp0topch1(latencycomp0topch1),
				.aligndetsynctopch1(aligndetsynctopch1),
				.rxdatarstopch0(rxdatarstopch0),
				.fifoovrinbotch2(fifoovrinbotch2),
				.decdatatopch1(decdatatopch1),
				.alignstatustopch0(alignstatustopch0),
				.rxdatarstopch1(rxdatarstopch1),
				.fifoovrintopch0(fifoovrintopch0),
				.fiforstrdqdbotch2(fiforstrdqdbotch2),
				.runningdispbotch2(runningdispbotch2),
				.cgcompwrinch0(cgcompwrinch0),
				.syncstatustopch0(syncstatustopch0),
				.syncstatusch1(syncstatusch1),
				.decdatach1(decdatach1),
				.cgcompwrallbotch2(cgcompwrallbotch2),
				.latencycomp0ch1(latencycomp0ch1),
				.fiforstrdqdtopch1(fiforstrdqdtopch1),
				.endskwrdptrsch1(endskwrdptrsch1),
				.alignstatusch1(alignstatusch1),
				.rcvdclkch0(rcvdclkch0),
				.decdatavalidch2(decdatavalidch2),
				.fifordoutcomp0ch0(fifordoutcomp0ch0),
				.aligndetsyncch2(aligndetsyncch2),
				.runningdispch1(runningdispch1),
				.cgcompwrintopch0(cgcompwrintopch0),
				.insertincompleteinch1(insertincompleteinch1),
				.fifoovrinch2(fifoovrinch2),
				.decctlch2(decctlch2),
				.rdaligntopch0(rdaligntopch0),
				.fifordinch1(fifordinch1),
				.cgcomprddinch0(cgcomprddinch0),
				.scanmoden(scanmoden),
				.cgcompwrinch1(cgcompwrinch1),
				.txctltcch0(txctltcch0),
				.rdalignch1(rdalignch1),
				.txdatatsbotch2(txdatatsbotch2),
				.decdatavalidch1(decdatavalidch1),
				.endskwqdch1(endskwqdch1),
				.fifoovr0topch1(fifoovr0topch1),
				.aggtestbusch2(aggtestbusch2),
				.insertincomplete0topch0(insertincomplete0topch0),
				.fifordoutcomp0botch2(fifordoutcomp0botch2),
				.endskwqdtopch0(endskwqdtopch0),
				.refclkdig(refclkdig),
				.txdatatcch1(txdatatcch1),
				.txctltcch1(txctltcch1),
				.fifordinbotch2(fifordinbotch2),
				.dedicatedaggscanoutch1(dedicatedaggscanoutch1),
				.fifordoutcomp0ch1(fifordoutcomp0ch1),
				.rdalignch2(rdalignch2),
				.cgcompwrinch2(cgcompwrinch2),
				.fiforstrdqdtopch0(fiforstrdqdtopch0),
				.txdatatctopch1(txdatatctopch1),
				.aggtestbusch1(aggtestbusch1),
				.dedicatedaggscanoutch0tieoff(dedicatedaggscanoutch0tieoff),
				.alignstatussync0ch0(alignstatussync0ch0),
				.cgcomprddallch2(cgcomprddallch2),
				.syncstatusbotch2(syncstatusbotch2),
				.txctltsch2(txctltsch2),
				.decdatavalidtopch1(decdatavalidtopch1),
				.txctltstopch0(txctltstopch0),
				.delcondmetintopch0(delcondmetintopch0),
				.decdatach0(decdatach0),
				.rcvdclkch1(rcvdclkch1),
				.runningdisptopch1(runningdisptopch1),
				.fifoovrintopch1(fifoovrintopch1),
				.fifordintopch1(fifordintopch1),
				.rxdatarsch0(rxdatarsch0),
				.decctlbotch2(decctlbotch2),
				.latencycomp0botch2(latencycomp0botch2),
				.latencycompintopch1(latencycompintopch1),
				.delcondmet0ch2(delcondmet0ch2),
				.rdaligntopch1(rdaligntopch1),
				.alignstatussyncch2(alignstatussyncch2),
				.cgcompwrallch2(cgcompwrallch2),
				.delcondmetinbotch2(delcondmetinbotch2),
				.cgcompwrallch0(cgcompwrallch0),
				.txctltcch2(txctltcch2),
				.decdatavalidbotch2(decdatavalidbotch2),
				.alignstatussync0topch0(alignstatussync0topch0),
				.dprioagg(dprioagg),
				.fifordoutcomp0topch1(fifordoutcomp0topch1),
				.cgcomprddallbotch2(cgcomprddallbotch2),
				.cgcompwrintopch1(cgcompwrintopch1),
				.alignstatussyncbotch2(alignstatussyncbotch2),
				.fifordinch2(fifordinch2),
				.rdalignch0(rdalignch0),
				.rdenablesynctopch1(rdenablesynctopch1),
				.txdatatsch2(txdatatsch2),
				.alignstatussynctopch0(alignstatussynctopch0),
				.txctltsch1(txctltsch1),
				.insertincomplete0ch0(insertincomplete0ch0),
				.aligndetsynctopch0(aligndetsynctopch0),
				.aggtestbusch0(aggtestbusch0),
				.delcondmet0ch0(delcondmet0ch0),
				.fifoovr0ch0(fifoovr0ch0),
				.rdenablesyncbotch2(rdenablesyncbotch2),
				.fifordoutcomp0ch2(fifordoutcomp0ch2),
				.alignstatustopch1(alignstatustopch1),
				.rdalignbotch2(rdalignbotch2),
				.rxctlrsch0(rxctlrsch0),
				.insertincomplete0ch1(insertincomplete0ch1),
				.insertincompleteinch0(insertincompleteinch0),
				.endskwrdptrsch0(endskwrdptrsch0),
				.alignstatussyncch0(alignstatussyncch0),
				.rxctlrstopch1(rxctlrstopch1),
				.delcondmet0topch0(delcondmet0topch0),
				.txdatatcch0(txdatatcch0),
				.endskwrdptrsch2(endskwrdptrsch2),
				.aligndetsyncch0(aligndetsyncch0),
				.rdenablesyncch0(rdenablesyncch0),
				.rcvdclkout(rcvdclkout),
				.dedicatedaggscaninch1(dedicatedaggscaninch1),
				.decdatatopch0(decdatatopch0),
				.cgcompwrinbotch2(cgcompwrinbotch2),
				.cgcomprddintopch1(cgcomprddintopch1),
				.scanshiftn(scanshiftn),
				.decdatavalidch0(decdatavalidch0),
				.txctltcbotch2(txctltcbotch2),
				.txctltctopch0(txctltctopch0),
				.cgcomprddinbotch2(cgcomprddinbotch2),
				.fiforstrdqdch1(fiforstrdqdch1),
				.latencycomp0ch0(latencycomp0ch0),
				.cgcomprddintopch0(cgcomprddintopch0),
				.txctltstopch1(txctltstopch1),
				.fifoovr0ch2(fifoovr0ch2),
				.insertincomplete0botch2(insertincomplete0botch2),
				.fifordinch0(fifordinch0),
				.fifoovr0topch0(fifoovr0topch0),
				.txdatatcch2(txdatatcch2),
				.rxdatarsbotch2(rxdatarsbotch2),
				.delcondmetinch1(delcondmetinch1),
				.txctltsbotch2(txctltsbotch2),
				.endskwrdptrsbotch2(endskwrdptrsbotch2),
				.aligndetsyncch1(aligndetsyncch1),
				.endskwrdptrstopch1(endskwrdptrstopch1),
				.endskwqdch0(endskwqdch0),
				.alignstatussync0ch1(alignstatussync0ch1),
				.latencycomp0ch2(latencycomp0ch2),
				.latencycompinch1(latencycompinch1),
				.txpmaclk(txpmaclk),
				.cgcomprddalltopch1(cgcomprddalltopch1),
				.decdatach2(decdatach2),
				.txdatatcbotch2(txdatatcbotch2),
				.alignstatusch0(alignstatusch0),
				.cgcomprddinch2(cgcomprddinch2),
				.syncstatusch2(syncstatusch2),
				.dedicatedaggscanoutch2tieoff(dedicatedaggscanoutch2tieoff),
				.delcondmetinch0(delcondmetinch0),
				.fifoovrinch1(fifoovrinch1),
				.fifoovrinch0(fifoovrinch0),
				.rxpcsrstn(rxpcsrstn),
				.txpcsrstn(txpcsrstn),
				.insertincomplete0topch1(insertincomplete0topch1),
				.rcvdclkoutbot(rcvdclkoutbot),
				.decctlch1(decctlch1),
				.cgcompwralltopch0(cgcompwralltopch0),
				.cgcompwrallch1(cgcompwrallch1),
				.runningdispch0(runningdispch0),
				.insertincompleteinbotch2(insertincompleteinbotch2),
				.rxctlrsch2(rxctlrsch2),
				.alignstatussync0ch2(alignstatussync0ch2),
				.latencycompinbotch2(latencycompinbotch2),
				.insertincompleteinch2(insertincompleteinch2),
				.aligndetsyncbotch2(aligndetsyncbotch2),
				.endskwqdch2(endskwqdch2),
				.txdatatsch0(txdatatsch0),
				.fifoovr0botch2(fifoovr0botch2),
				.rcvdclkouttop(rcvdclkouttop),
				.delcondmetinch2(delcondmetinch2),
				.txdatatctopch0(txdatatctopch0),
				.rxdatarsch2(rxdatarsch2),
				.latencycomp0topch0(latencycomp0topch0),
				.alignstatusch2(alignstatusch2),
				.rxctlrstopch0(rxctlrstopch0),
				.alignstatussyncch1(alignstatussyncch1),
				.decctltopch0(decctltopch0),
				.latencycompintopch0(latencycompintopch0),
				.runningdisptopch0(runningdisptopch0),
				.txctltctopch1(txctltctopch1),
				.txdatatstopch0(txdatatstopch0),
				.cgcompwralltopch1(cgcompwralltopch1),
				.decdatavalidtopch0(decdatavalidtopch0),
				.cgcomprddallch0(cgcomprddallch0),
				.txdatatstopch1(txdatatstopch1),
				.syncstatustopch1(syncstatustopch1),
				.fifoovr0ch1(fifoovr0ch1),
				.cgcomprddallch1(cgcomprddallch1),
				.insertincompleteintopch1(insertincompleteintopch1),
				.runningdispch2(runningdispch2),
				.endskwqdtopch1(endskwqdtopch1),
				.delcondmet0botch2(delcondmet0botch2)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_8g_pcs_aggregate_encrypted #(
				.user_base_address(user_base_address),
				.dskw_mnumber_data(dskw_mnumber_data),
				.use_default_base_address(use_default_base_address),
				.data_agg_bonding(data_agg_bonding),
				.xaui_sm_operation(xaui_sm_operation),
				.pcs_dw_datapath(pcs_dw_datapath),
				.prot_mode_tx(prot_mode_tx),
				.dskw_control(dskw_control),
				.avmm_group_channel_index(avmm_group_channel_index),
				.dskw_sm_operation(dskw_sm_operation),
				.refclkdig_sel(refclkdig_sel),
				.agg_pwdn(agg_pwdn)
			) stratixv_hssi_8g_pcs_aggregate_encrypted_inst (
				.latencycompinch0(latencycompinch0),
				.insertincompleteintopch0(insertincompleteintopch0),
				.delcondmet0ch1(delcondmet0ch1),
				.alignstatussync0botch2(alignstatussync0botch2),
				.rdenablesynctopch0(rdenablesynctopch0),
				.decdatabotch2(decdatabotch2),
				.rxdatarsch1(rxdatarsch1),
				.fifordintopch0(fifordintopch0),
				.fiforstrdqdch2(fiforstrdqdch2),
				.syncstatusch0(syncstatusch0),
				.txdatatsch1(txdatatsch1),
				.insertincomplete0ch2(insertincomplete0ch2),
				.latencycompinch2(latencycompinch2),
				.delcondmetintopch1(delcondmetintopch1),
				.rdenablesyncch2(rdenablesyncch2),
				.fiforstrdqdch0(fiforstrdqdch0),
				.fifordoutcomp0topch0(fifordoutcomp0topch0),
				.rdenablesyncch1(rdenablesyncch1),
				.decctlch0(decctlch0),
				.txctltsch0(txctltsch0),
				.rxctlrsch1(rxctlrsch1),
				.alignstatussynctopch1(alignstatussynctopch1),
				.alignstatusbotch2(alignstatusbotch2),
				.rxctlrsbotch2(rxctlrsbotch2),
				.alignstatussync0topch1(alignstatussync0topch1),
				.endskwrdptrstopch0(endskwrdptrstopch0),
				.decctltopch1(decctltopch1),
				.cgcomprddalltopch0(cgcomprddalltopch0),
				.cgcomprddinch1(cgcomprddinch1),
				.delcondmet0topch1(delcondmet0topch1),
				.endskwqdbotch2(endskwqdbotch2),
				.latencycomp0topch1(latencycomp0topch1),
				.aligndetsynctopch1(aligndetsynctopch1),
				.rxdatarstopch0(rxdatarstopch0),
				.fifoovrinbotch2(fifoovrinbotch2),
				.decdatatopch1(decdatatopch1),
				.alignstatustopch0(alignstatustopch0),
				.rxdatarstopch1(rxdatarstopch1),
				.fifoovrintopch0(fifoovrintopch0),
				.fiforstrdqdbotch2(fiforstrdqdbotch2),
				.runningdispbotch2(runningdispbotch2),
				.cgcompwrinch0(cgcompwrinch0),
				.syncstatustopch0(syncstatustopch0),
				.syncstatusch1(syncstatusch1),
				.decdatach1(decdatach1),
				.cgcompwrallbotch2(cgcompwrallbotch2),
				.latencycomp0ch1(latencycomp0ch1),
				.fiforstrdqdtopch1(fiforstrdqdtopch1),
				.endskwrdptrsch1(endskwrdptrsch1),
				.alignstatusch1(alignstatusch1),
				.rcvdclkch0(rcvdclkch0),
				.decdatavalidch2(decdatavalidch2),
				.fifordoutcomp0ch0(fifordoutcomp0ch0),
				.aligndetsyncch2(aligndetsyncch2),
				.runningdispch1(runningdispch1),
				.cgcompwrintopch0(cgcompwrintopch0),
				.insertincompleteinch1(insertincompleteinch1),
				.fifoovrinch2(fifoovrinch2),
				.decctlch2(decctlch2),
				.rdaligntopch0(rdaligntopch0),
				.fifordinch1(fifordinch1),
				.cgcomprddinch0(cgcomprddinch0),
				.scanmoden(scanmoden),
				.cgcompwrinch1(cgcompwrinch1),
				.txctltcch0(txctltcch0),
				.rdalignch1(rdalignch1),
				.txdatatsbotch2(txdatatsbotch2),
				.decdatavalidch1(decdatavalidch1),
				.endskwqdch1(endskwqdch1),
				.fifoovr0topch1(fifoovr0topch1),
				.aggtestbusch2(aggtestbusch2),
				.insertincomplete0topch0(insertincomplete0topch0),
				.fifordoutcomp0botch2(fifordoutcomp0botch2),
				.endskwqdtopch0(endskwqdtopch0),
				.refclkdig(refclkdig),
				.txdatatcch1(txdatatcch1),
				.txctltcch1(txctltcch1),
				.fifordinbotch2(fifordinbotch2),
				.dedicatedaggscanoutch1(dedicatedaggscanoutch1),
				.fifordoutcomp0ch1(fifordoutcomp0ch1),
				.rdalignch2(rdalignch2),
				.cgcompwrinch2(cgcompwrinch2),
				.fiforstrdqdtopch0(fiforstrdqdtopch0),
				.txdatatctopch1(txdatatctopch1),
				.aggtestbusch1(aggtestbusch1),
				.dedicatedaggscanoutch0tieoff(dedicatedaggscanoutch0tieoff),
				.alignstatussync0ch0(alignstatussync0ch0),
				.cgcomprddallch2(cgcomprddallch2),
				.syncstatusbotch2(syncstatusbotch2),
				.txctltsch2(txctltsch2),
				.decdatavalidtopch1(decdatavalidtopch1),
				.txctltstopch0(txctltstopch0),
				.delcondmetintopch0(delcondmetintopch0),
				.decdatach0(decdatach0),
				.rcvdclkch1(rcvdclkch1),
				.runningdisptopch1(runningdisptopch1),
				.fifoovrintopch1(fifoovrintopch1),
				.fifordintopch1(fifordintopch1),
				.rxdatarsch0(rxdatarsch0),
				.decctlbotch2(decctlbotch2),
				.latencycomp0botch2(latencycomp0botch2),
				.latencycompintopch1(latencycompintopch1),
				.delcondmet0ch2(delcondmet0ch2),
				.rdaligntopch1(rdaligntopch1),
				.alignstatussyncch2(alignstatussyncch2),
				.cgcompwrallch2(cgcompwrallch2),
				.delcondmetinbotch2(delcondmetinbotch2),
				.cgcompwrallch0(cgcompwrallch0),
				.txctltcch2(txctltcch2),
				.decdatavalidbotch2(decdatavalidbotch2),
				.alignstatussync0topch0(alignstatussync0topch0),
				.dprioagg(dprioagg),
				.fifordoutcomp0topch1(fifordoutcomp0topch1),
				.cgcomprddallbotch2(cgcomprddallbotch2),
				.cgcompwrintopch1(cgcompwrintopch1),
				.alignstatussyncbotch2(alignstatussyncbotch2),
				.fifordinch2(fifordinch2),
				.rdalignch0(rdalignch0),
				.rdenablesynctopch1(rdenablesynctopch1),
				.txdatatsch2(txdatatsch2),
				.alignstatussynctopch0(alignstatussynctopch0),
				.txctltsch1(txctltsch1),
				.insertincomplete0ch0(insertincomplete0ch0),
				.aligndetsynctopch0(aligndetsynctopch0),
				.aggtestbusch0(aggtestbusch0),
				.delcondmet0ch0(delcondmet0ch0),
				.fifoovr0ch0(fifoovr0ch0),
				.rdenablesyncbotch2(rdenablesyncbotch2),
				.fifordoutcomp0ch2(fifordoutcomp0ch2),
				.alignstatustopch1(alignstatustopch1),
				.rdalignbotch2(rdalignbotch2),
				.rxctlrsch0(rxctlrsch0),
				.insertincomplete0ch1(insertincomplete0ch1),
				.insertincompleteinch0(insertincompleteinch0),
				.endskwrdptrsch0(endskwrdptrsch0),
				.alignstatussyncch0(alignstatussyncch0),
				.rxctlrstopch1(rxctlrstopch1),
				.delcondmet0topch0(delcondmet0topch0),
				.txdatatcch0(txdatatcch0),
				.endskwrdptrsch2(endskwrdptrsch2),
				.aligndetsyncch0(aligndetsyncch0),
				.rdenablesyncch0(rdenablesyncch0),
				.rcvdclkout(rcvdclkout),
				.dedicatedaggscaninch1(dedicatedaggscaninch1),
				.decdatatopch0(decdatatopch0),
				.cgcompwrinbotch2(cgcompwrinbotch2),
				.cgcomprddintopch1(cgcomprddintopch1),
				.scanshiftn(scanshiftn),
				.decdatavalidch0(decdatavalidch0),
				.txctltcbotch2(txctltcbotch2),
				.txctltctopch0(txctltctopch0),
				.cgcomprddinbotch2(cgcomprddinbotch2),
				.fiforstrdqdch1(fiforstrdqdch1),
				.latencycomp0ch0(latencycomp0ch0),
				.cgcomprddintopch0(cgcomprddintopch0),
				.txctltstopch1(txctltstopch1),
				.fifoovr0ch2(fifoovr0ch2),
				.insertincomplete0botch2(insertincomplete0botch2),
				.fifordinch0(fifordinch0),
				.fifoovr0topch0(fifoovr0topch0),
				.txdatatcch2(txdatatcch2),
				.rxdatarsbotch2(rxdatarsbotch2),
				.delcondmetinch1(delcondmetinch1),
				.txctltsbotch2(txctltsbotch2),
				.endskwrdptrsbotch2(endskwrdptrsbotch2),
				.aligndetsyncch1(aligndetsyncch1),
				.endskwrdptrstopch1(endskwrdptrstopch1),
				.endskwqdch0(endskwqdch0),
				.alignstatussync0ch1(alignstatussync0ch1),
				.latencycomp0ch2(latencycomp0ch2),
				.latencycompinch1(latencycompinch1),
				.txpmaclk(txpmaclk),
				.cgcomprddalltopch1(cgcomprddalltopch1),
				.decdatach2(decdatach2),
				.txdatatcbotch2(txdatatcbotch2),
				.alignstatusch0(alignstatusch0),
				.cgcomprddinch2(cgcomprddinch2),
				.syncstatusch2(syncstatusch2),
				.dedicatedaggscanoutch2tieoff(dedicatedaggscanoutch2tieoff),
				.delcondmetinch0(delcondmetinch0),
				.fifoovrinch1(fifoovrinch1),
				.fifoovrinch0(fifoovrinch0),
				.rxpcsrstn(rxpcsrstn),
				.txpcsrstn(txpcsrstn),
				.insertincomplete0topch1(insertincomplete0topch1),
				.rcvdclkoutbot(rcvdclkoutbot),
				.decctlch1(decctlch1),
				.cgcompwralltopch0(cgcompwralltopch0),
				.cgcompwrallch1(cgcompwrallch1),
				.runningdispch0(runningdispch0),
				.insertincompleteinbotch2(insertincompleteinbotch2),
				.rxctlrsch2(rxctlrsch2),
				.alignstatussync0ch2(alignstatussync0ch2),
				.latencycompinbotch2(latencycompinbotch2),
				.insertincompleteinch2(insertincompleteinch2),
				.aligndetsyncbotch2(aligndetsyncbotch2),
				.endskwqdch2(endskwqdch2),
				.txdatatsch0(txdatatsch0),
				.fifoovr0botch2(fifoovr0botch2),
				.rcvdclkouttop(rcvdclkouttop),
				.delcondmetinch2(delcondmetinch2),
				.txdatatctopch0(txdatatctopch0),
				.rxdatarsch2(rxdatarsch2),
				.latencycomp0topch0(latencycomp0topch0),
				.alignstatusch2(alignstatusch2),
				.rxctlrstopch0(rxctlrstopch0),
				.alignstatussyncch1(alignstatussyncch1),
				.decctltopch0(decctltopch0),
				.latencycompintopch0(latencycompintopch0),
				.runningdisptopch0(runningdisptopch0),
				.txctltctopch1(txctltctopch1),
				.txdatatstopch0(txdatatstopch0),
				.cgcompwralltopch1(cgcompwralltopch1),
				.decdatavalidtopch0(decdatavalidtopch0),
				.cgcomprddallch0(cgcomprddallch0),
				.txdatatstopch1(txdatatstopch1),
				.syncstatustopch1(syncstatustopch1),
				.fifoovr0ch1(fifoovr0ch1),
				.cgcomprddallch1(cgcomprddallch1),
				.insertincompleteintopch1(insertincompleteintopch1),
				.runningdispch2(runningdispch2),
				.endskwqdtopch1(endskwqdtopch1),
				.delcondmet0botch2(delcondmet0botch2)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_8g_rx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_8g_rx_pcs
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter fixed_pat_det = "dis_fixed_patdet",      // Valid values: dis_fixed_patdet|en_fixed_patdet
	parameter byte_deserializer = "dis_bds",      // Valid values: dis_bds|en_bds_by_2|en_bds_by_4|en_bds_by_2_det
	parameter polinv_8b10b_dec = "dis_polinv_8b10b_dec",      // Valid values: dis_polinv_8b10b_dec|en_polinv_8b10b_dec
	parameter clock_gate_bist = "dis_bist_clk_gating",      // Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter test_bus_sel = "prbs_bist_testbus",      // Valid values: prbs_bist_testbus|tx_testbus|tx_ctrl_plane_testbus|wa_testbus|deskew_testbus|rm_testbus|rx_ctrl_testbus|pcie_ctrl_testbus|rx_ctrl_plane_testbus|agg_testbus
	parameter rx_clk2 = "rcvd_clk_clk2",      // Valid values: rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2
	parameter cdr_ctrl = "dis_cdr_ctrl",      // Valid values: dis_cdr_ctrl|en_cdr_ctrl|en_cdr_ctrl_w_cid
	parameter deskew_prog_pattern_only = "en_deskew_prog_pat_only",      // Valid values: dis_deskew_prog_pat_only|en_deskew_prog_pat_only
	parameter wa_pld_controlled = "dis_pld_ctrl",      // Valid values: dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw
	parameter wa_rgnumber_data = 8'b0,      // Valid values: 8
	parameter eightb_tenb_decoder = "dis_8b10b",      // Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter wa_disp_err_flag = "dis_disp_err_flag",      // Valid values: dis_disp_err_flag|en_disp_err_flag
	parameter re_bo_on_wa = "dis_re_bo_on_wa",      // Valid values: dis_re_bo_on_wa|en_re_bo_on_wa
	parameter wa_renumber_data = 6'b0,      // Valid values: 6
	parameter ibm_invalid_code = "dis_ibm_invalid_code",      // Valid values: dis_ibm_invalid_code|en_ibm_invalid_code
	parameter tx_rx_parallel_loopback = "dis_plpbk",      // Valid values: dis_plpbk|en_plpbk
	parameter rate_match = "dis_rm",      // Valid values: dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
	parameter auto_error_replacement = "dis_err_replace",      // Valid values: dis_err_replace|en_err_replace
	parameter wa_sync_sm_ctrl = "gige_sync_sm",      // Valid values: gige_sync_sm|pipe_sync_sm|xaui_sync_sm|srio1p3_sync_sm|srio2p1_sync_sm|sw_basic_sync_sm|dw_basic_sync_sm|fibre_channel_sync_sm
	parameter wa_rknumber_data = 8'b0,      // Valid values: 8
	parameter hip_mode = "dis_hip",      // Valid values: dis_hip|en_hip
	parameter cdr_ctrl_rxvalid_mask = "dis_rxvalid_mask",      // Valid values: dis_rxvalid_mask|en_rxvalid_mask
	parameter deskew_pattern = 10'b1101101000,      // Valid values: 10
	parameter symbol_swap = "dis_symbol_swap",      // Valid values: dis_symbol_swap|en_symbol_swap
	parameter wa_kchar = "dis_kchar",      // Valid values: dis_kchar|en_kchar
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",      // Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter clock_gate_dw_wa = "dis_dw_wa_clk_gating",      // Valid values: dis_dw_wa_clk_gating|en_dw_wa_clk_gating
	parameter clock_gate_dw_pc_wrclk = "dis_dw_pc_wrclk_gating",      // Valid values: dis_dw_pc_wrclk_gating|en_dw_pc_wrclk_gating
	parameter pad_or_edb_error_replace = "replace_edb",      // Valid values: replace_edb|replace_pad|replace_edb_dynamic
	parameter wa_rvnumber_data = 13'b0,      // Valid values: 13
	parameter cid_pattern_len = 8'b0,      // Valid values: 8
	parameter deskew = "dis_deskew",      // Valid values: dis_deskew|en_srio_v2p1|en_xaui
	parameter eidle_entry_sd = "dis_eidle_sd",      // Valid values: dis_eidle_sd|en_eidle_sd
	parameter eightbtenb_decoder_output_sel = "data_8b10b_decoder",      // Valid values: data_8b10b_decoder|data_xaui_sm
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode
	parameter rx_pcs_urst = "en_rx_pcs_urst",      // Valid values: dis_rx_pcs_urst|en_rx_pcs_urst
	parameter prbs_ver = "dis_prbs",      // Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter agg_block_sel = "same_smrt_pack",      // Valid values: same_smrt_pack|other_smrt_pack
	parameter rx_wr_clk = "rx_clk2_div_1_2_4",      // Valid values: rx_clk2_div_1_2_4|txfifo_rd_clk
	parameter fixed_pat_num = 4'b1111,      // Valid values: 4
	parameter bo_pattern = 20'b0,      // Valid values: 20
	parameter eidle_entry_iei = "dis_eidle_iei",      // Valid values: dis_eidle_iei|en_eidle_iei
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter comp_fifo_rst_pld_ctrl = "dis_comp_fifo_rst_pld_ctrl",      // Valid values: dis_comp_fifo_rst_pld_ctrl|en_comp_fifo_rst_pld_ctrl
	parameter wait_cnt = 8'b0,      // Valid values: 8
	parameter clkcmp_pattern_n = 20'b0,      // Valid values: 20
	parameter force_signal_detect = "en_force_signal_detect",      // Valid values: en_force_signal_detect|dis_force_signal_detect
	parameter clock_gate_dw_dskw_wr = "dis_dw_dskw_wrclk_gating",      // Valid values: dis_dw_dskw_wrclk_gating|en_dw_dskw_wrclk_gating
	parameter rx_clk1 = "rcvd_clk_clk1",      // Valid values: rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|rcvd_clk_agg_top_or_bottom_clk1
	parameter pma_done_count = 18'b0,      // Valid values: 18
	parameter invalid_code_flag_only = "dis_invalid_code_only",      // Valid values: dis_invalid_code_only|en_invalid_code_only
	parameter clock_gate_cdr_eidle = "dis_cdr_eidle_clk_gating",      // Valid values: dis_cdr_eidle_clk_gating|en_cdr_eidle_clk_gating
	parameter clock_gate_bds_dec_asn = "dis_bds_dec_asn_clk_gating",      // Valid values: dis_bds_dec_asn_clk_gating|en_bds_dec_asn_clk_gating
	parameter wa_rosnumber_data = 2'b0,      // Valid values: 2
	parameter clock_gate_sw_rm_rd = "dis_sw_rm_rdclk_gating",      // Valid values: dis_sw_rm_rdclk_gating|en_sw_rm_rdclk_gating
	parameter err_flags_sel = "err_flags_wa",      // Valid values: err_flags_wa|err_flags_8b10b
	parameter ctrl_plane_bonding_compensation = "dis_compensation",      // Valid values: dis_compensation|en_compensation
	parameter bist_ver_clr_flag = "dis_bist_clr_flag",      // Valid values: dis_bist_clr_flag|en_bist_clr_flag
	parameter clock_gate_byteorder = "dis_byteorder_clk_gating",      // Valid values: dis_byteorder_clk_gating|en_byteorder_clk_gating
	parameter clock_gate_sw_rm_wr = "dis_sw_rm_wrclk_gating",      // Valid values: dis_sw_rm_wrclk_gating|en_sw_rm_wrclk_gating
	parameter rx_clk_free_running = "en_rx_clk_free_run",      // Valid values: dis_rx_clk_free_run|en_rx_clk_free_run
	parameter polarity_inversion = "dis_pol_inv",      // Valid values: dis_pol_inv|en_pol_inv
	parameter auto_deassert_pc_rst_cnt_data = 5'b0,      // Valid values: 5
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter bo_pad = 10'b0,      // Valid values: 10
	parameter clkcmp_pattern_p = 20'b0,      // Valid values: 20
	parameter wa_clk_slip_spacing_data = 10'b10000,      // Valid values: 10
	parameter clock_gate_prbs = "dis_prbs_clk_gating",      // Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter clock_gate_sw_wa = "dis_sw_wa_clk_gating",      // Valid values: dis_sw_wa_clk_gating|en_sw_wa_clk_gating
	parameter runlength_val = 6'b0,      // Valid values: 6
	parameter wa_pd = "wa_pd_10",      // Valid values: dont_care_wa_pd_0|dont_care_wa_pd_1|wa_pd_7|wa_pd_10|wa_pd_20|wa_pd_40|wa_pd_8_sw|wa_pd_8_dw|wa_pd_16_sw|wa_pd_16_dw|wa_pd_32|wa_pd_fixed_7_k28p5|wa_pd_fixed_10_k28p5|wa_pd_fixed_16_a1a2_sw|wa_pd_fixed_16_a1a2_dw|wa_pd_fixed_32_a1a1a2a2|prbs15_fixed_wa_pd_16_sw|prbs15_fixed_wa_pd_16_dw|prbs15_fixed_wa_pd_20_dw|prbs31_fixed_wa_pd_16_sw|prbs31_fixed_wa_pd_16_dw|prbs31_fixed_wa_pd_10_sw|prbs31_fixed_wa_pd_40_dw|prbs8_fixed_wa|prbs10_fixed_wa|prbs7_fixed_wa_pd_16_sw|prbs7_fixed_wa_pd_16_dw|prbs7_fixed_wa_pd_20_dw|prbs23_fixed_wa_pd_16_sw|prbs23_fixed_wa_pd_32_dw|prbs23_fixed_wa_pd_40_dw
	parameter bit_reversal = "dis_bit_reversal",      // Valid values: dis_bit_reversal|en_bit_reversal
	parameter wa_pd_data = 40'b0,      // Valid values: 40
	parameter pc_fifo_rst_pld_ctrl = "dis_pc_fifo_rst_pld_ctrl",      // Valid values: dis_pc_fifo_rst_pld_ctrl|en_pc_fifo_rst_pld_ctrl
	parameter mask_cnt = 10'h3FF,      // Valid values: 10
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",      // Valid values: master_chnl_distr|not_master_chnl_distr
	parameter cid_pattern = "cid_pattern_0",      // Valid values: cid_pattern_0|cid_pattern_1
	parameter wait_for_phfifo_cnt_data = 6'b0,      // Valid values: 6
	parameter pma_dw = "eight_bit",      // Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter byte_order = "dis_bo",      // Valid values: dis_bo|en_pcs_ctrl_eight_bit_bo|en_pcs_ctrl_nine_bit_bo|en_pcs_ctrl_ten_bit_bo|en_pld_ctrl_eight_bit_bo|en_pld_ctrl_nine_bit_bo|en_pld_ctrl_ten_bit_bo
	parameter wa_det_latency_sync_status_beh = "assert_sync_status_non_imm",      // Valid values: assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
	parameter clock_gate_sw_pc_wrclk = "dis_sw_pc_wrclk_gating",      // Valid values: dis_sw_pc_wrclk_gating|en_sw_pc_wrclk_gating
	parameter prbs_ver_clr_flag = "dis_prbs_clr_flag",      // Valid values: dis_prbs_clr_flag|en_prbs_clr_flag
	parameter clock_gate_pc_rdclk = "dis_pc_rdclk_gating",      // Valid values: dis_pc_rdclk_gating|en_pc_rdclk_gating
	parameter pcs_bypass = "dis_pcs_bypass",      // Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter dw_one_or_two_symbol_bo = "donot_care_one_two_bo",      // Valid values: donot_care_one_two_bo|one_symbol_bo|two_symbol_bo_eight_bit|two_symbol_bo_nine_bit|two_symbol_bo_ten_bit
	parameter pipe_if_enable = "dis_pipe_rx",      // Valid values: dis_pipe_rx|en_pipe_rx|en_pipe3_rx
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter phase_compensation_fifo = "low_latency",      // Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter clock_gate_dskw_rd = "dis_dskw_rdclk_gating",      // Valid values: dis_dskw_rdclk_gating|en_dskw_rdclk_gating
	parameter rx_rcvd_clk = "rcvd_clk_rcvd_clk",      // Valid values: rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
	parameter rx_refclk = "dis_refclk_sel",      // Valid values: dis_refclk_sel|en_refclk_sel
	parameter channel_number = 0,      // Valid values: 0..65
	parameter clock_gate_dw_rm_rd = "dis_dw_rm_rdclk_gating",      // Valid values: dis_dw_rm_rdclk_gating|en_dw_rm_rdclk_gating
	parameter clock_gate_sw_dskw_wr = "dis_sw_dskw_wrclk_gating",      // Valid values: dis_sw_dskw_wrclk_gating|en_sw_dskw_wrclk_gating
	parameter auto_pc_en_cnt_data = 7'b0,      // Valid values: 7
	parameter wa_pd_polarity = "dis_pd_both_pol",      // Valid values: dis_pd_both_pol|en_pd_both_pol|dont_care_both_pol
	parameter wa_clk_slip_spacing = "min_clk_slip_spacing",      // Valid values: min_clk_slip_spacing|user_programmable_clk_slip_spacing
	parameter test_mode = "prbs",      // Valid values: dont_care_test|prbs|bist
	parameter wa_boundary_lock_ctrl = "bit_slip",      // Valid values: bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
	parameter ctrl_plane_bonding_consumption = "individual",      // Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter prot_mode = "basic",      // Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter rx_rd_clk = "pld_rx_clk",      // Valid values: pld_rx_clk|rx_clk
	parameter eidle_entry_eios = "dis_eidle_eios",      // Valid values: dis_eidle_eios|en_eidle_eios
	parameter auto_speed_nego = "dis_asn",      // Valid values: dis_asn|en_asn_g2_freq_scal|en_asn_g3
	parameter bist_ver = "dis_bist",      // Valid values: dis_bist|incremental|cjpat|crpat
	parameter clock_gate_dw_rm_wr = "dis_dw_rm_wrclk_gating",      // Valid values: dis_dw_rm_wrclk_gating|en_dw_rm_wrclk_gating
	parameter runlength_check = "en_runlength_sw",      // Valid values: dis_runlength|en_runlength_sw|en_runlength_dw
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 3:0 ] a1a2k1k2flag,
	input  [ 0:0 ] a1a2size,
	output [ 0:0 ] aggrxpcsrst,
	input  [ 15:0 ] aggtestbus,
	output [ 1:0 ] aligndetsync,
	input  [ 0:0 ] alignstatus,
	output [ 0:0 ] alignstatuspld,
	output [ 0:0 ] alignstatussync,
	input  [ 0:0 ] alignstatussync0,
	input  [ 0:0 ] alignstatussync0toporbot,
	input  [ 0:0 ] alignstatustoporbot,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] bistdone,
	output [ 0:0 ] bisterr,
	input  [ 0:0 ] bitreversalenable,
	input  [ 0:0 ] bitslip,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] byteorder,
	output [ 0:0 ] byteordflag,
	input  [ 0:0 ] bytereversalenable,
	input  [ 0:0 ] cgcomprddall,
	input  [ 0:0 ] cgcomprddalltoporbot,
	output [ 1:0 ] cgcomprddout,
	input  [ 0:0 ] cgcompwrall,
	input  [ 0:0 ] cgcompwralltoporbot,
	output [ 1:0 ] cgcompwrout,
	output [ 19:0 ] channeltestbusout,
	output [ 0:0 ] clocktopld,
	input  [ 0:0 ] configselinchnldown,
	input  [ 0:0 ] configselinchnlup,
	output [ 0:0 ] configseloutchnldown,
	output [ 0:0 ] configseloutchnlup,
	input  [ 0:0 ] ctrlfromaggblock,
	input  [ 7:0 ] datafrinaggblock,
	input  [ 19:0 ] datain,
	output [ 63:0 ] dataout,
	output [ 0:0 ] decoderctrl,
	output [ 7:0 ] decoderdata,
	output [ 0:0 ] decoderdatavalid,
	input  [ 0:0 ] delcondmet0,
	input  [ 0:0 ] delcondmet0toporbot,
	output [ 0:0 ] delcondmetout,
	output [ 0:0 ] disablepcfifobyteserdes,
	input  [ 0:0 ] dispcbytegen3,
	input  [ 0:0 ] dynclkswitchn,
	output [ 0:0 ] earlyeios,
	output [ 0:0 ] eidledetected,
	output [ 0:0 ] eidleexit,
	input  [ 2:0 ] eidleinfersel,
	input  [ 0:0 ] enablecommadetect,
	input  [ 0:0 ] endskwqd,
	input  [ 0:0 ] endskwqdtoporbot,
	input  [ 0:0 ] endskwrdptrs,
	input  [ 0:0 ] endskwrdptrstoporbot,
	output [ 1:0 ] errctrl,
	output [ 15:0 ] errdata,
	input  [ 0:0 ] fifoovr0,
	input  [ 0:0 ] fifoovr0toporbot,
	output [ 0:0 ] fifoovrout,
	input  [ 0:0 ] fifordincomp0toporbot,
	output [ 0:0 ] fifordoutcomp,
	input  [ 0:0 ] fiforstrdqd,
	input  [ 0:0 ] fiforstrdqdtoporbot,
	input  [ 0:0 ] gen2ngen1,
	input  [ 0:0 ] hrdrst,
	input  [ 0:0 ] insertincomplete0,
	input  [ 0:0 ] insertincomplete0toporbot,
	output [ 0:0 ] insertincompleteout,
	input  [ 0:0 ] latencycomp0,
	input  [ 0:0 ] latencycomp0toporbot,
	output [ 0:0 ] latencycompout,
	output [ 0:0 ] ltr,
	output [ 0:0 ] observablebyteserdesclock,
	input  [ 19:0 ] parallelloopback,
	output [ 19:0 ] parallelrevloopback,
	output [ 0:0 ] pcfifoempty,
	output [ 0:0 ] pcfifofull,
	input  [ 0:0 ] pcfifordenable,
	output [ 0:0 ] pcieswitch,
	input  [ 0:0 ] pcieswitchgen3,
	input  [ 0:0 ] phfifouserrst,
	output [ 0:0 ] phystatus,
	input  [ 0:0 ] phystatusinternal,
	input  [ 0:0 ] phystatuspcsgen3,
	output [ 63:0 ] pipedata,
	input  [ 0:0 ] pipeloopbk,
	input  [ 0:0 ] pldltr,
	input  [ 0:0 ] pldrxclk,
	input  [ 0:0 ] polinvrx,
	input  [ 0:0 ] prbscidenable,
	output [ 0:0 ] prbsdone,
	output [ 0:0 ] prbserrlt,
	input  [ 0:0 ] pxfifowrdisable,
	input  [ 0:0 ] rateswitchcontrol,
	input  [ 0:0 ] rcvdclkagg,
	input  [ 0:0 ] rcvdclkaggtoporbot,
	input  [ 0:0 ] rcvdclkpma,
	output [ 1:0 ] rdalign,
	input  [ 0:0 ] rdenableinchnldown,
	input  [ 0:0 ] rdenableinchnlup,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	input  [ 0:0 ] refclkdig,
	input  [ 0:0 ] refclkdig2,
	output [ 0:0 ] resetpcptrs,
	input  [ 0:0 ] resetpcptrsgen3,
	input  [ 0:0 ] resetpcptrsinchnldown,
	output [ 0:0 ] resetpcptrsinchnldownpipe,
	input  [ 0:0 ] resetpcptrsinchnlup,
	output [ 0:0 ] resetpcptrsinchnluppipe,
	output [ 0:0 ] resetpcptrsoutchnldown,
	output [ 0:0 ] resetpcptrsoutchnlup,
	input  [ 0:0 ] resetppmcntrsgen3,
	input  [ 0:0 ] resetppmcntrsinchnldown,
	input  [ 0:0 ] resetppmcntrsinchnlup,
	output [ 0:0 ] resetppmcntrsoutchnldown,
	output [ 0:0 ] resetppmcntrsoutchnlup,
	output [ 0:0 ] resetppmcntrspcspma,
	output [ 0:0 ] rlvlt,
	output [ 0:0 ] rmfifoempty,
	output [ 0:0 ] rmfifofull,
	output [ 0:0 ] rmfifopartialempty,
	output [ 0:0 ] rmfifopartialfull,
	input  [ 0:0 ] rmfifordincomp0,
	input  [ 0:0 ] rmfiforeadenable,
	input  [ 0:0 ] rmfifouserrst,
	input  [ 0:0 ] rmfifowriteenable,
	output [ 0:0 ] runlengthviolation,
	output [ 1:0 ] runningdisparity,
	output [ 3:0 ] rxblkstart,
	input  [ 3:0 ] rxblkstartpcsgen3,
	output [ 0:0 ] rxclkoutgen3,
	output [ 0:0 ] rxclkslip,
	input  [ 0:0 ] rxcontrolrstoporbot,
	input  [ 63:0 ] rxdatapcsgen3,
	input  [ 7:0 ] rxdatarstoporbot,
	output [ 3:0 ] rxdatavalid,
	input  [ 3:0 ] rxdatavalidpcsgen3,
	input  [ 1:0 ] rxdivsyncinchnldown,
	input  [ 1:0 ] rxdivsyncinchnlup,
	output [ 1:0 ] rxdivsyncoutchnldown,
	output [ 1:0 ] rxdivsyncoutchnlup,
	input  [ 0:0 ] rxpcsrst,
	output [ 0:0 ] rxpipeclk,
	output [ 0:0 ] rxpipesoftreset,
	output [ 2:0 ] rxstatus,
	input  [ 2:0 ] rxstatusinternal,
	input  [ 2:0 ] rxstatuspcsgen3,
	output [ 1:0 ] rxsynchdr,
	input  [ 1:0 ] rxsynchdrpcsgen3,
	output [ 0:0 ] rxvalid,
	input  [ 0:0 ] rxvalidinternal,
	input  [ 0:0 ] rxvalidpcsgen3,
	input  [ 1:0 ] rxweinchnldown,
	input  [ 1:0 ] rxweinchnlup,
	output [ 1:0 ] rxweoutchnldown,
	output [ 1:0 ] rxweoutchnlup,
	input  [ 0:0 ] scanmode,
	output [ 0:0 ] selftestdone,
	output [ 0:0 ] selftesterr,
	input  [ 0:0 ] sigdetfrompma,
	output [ 0:0 ] signaldetectout,
	output [ 0:0 ] speedchange,
	input  [ 0:0 ] speedchangeinchnldown,
	output [ 0:0 ] speedchangeinchnldownpipe,
	input  [ 0:0 ] speedchangeinchnlup,
	output [ 0:0 ] speedchangeinchnluppipe,
	output [ 0:0 ] speedchangeoutchnldown,
	output [ 0:0 ] speedchangeoutchnlup,
	output [ 0:0 ] syncdatain,
	input  [ 0:0 ] syncsmen,
	output [ 0:0 ] syncstatus,
	input  [ 19:0 ] txctrlplanetestbus,
	input  [ 1:0 ] txdivsync,
	input  [ 0:0 ] txpmaclk,
	input  [ 19:0 ] txtestbus,
	output [ 4:0 ] wordalignboundary,
	input  [ 0:0 ] wrenableinchnldown,
	input  [ 0:0 ] wrenableinchnlup,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_8g_rx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_8g_rx_pcs_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.fixed_pat_det(fixed_pat_det),
				.byte_deserializer(byte_deserializer),
				.polinv_8b10b_dec(polinv_8b10b_dec),
				.clock_gate_bist(clock_gate_bist),
				.test_bus_sel(test_bus_sel),
				.rx_clk2(rx_clk2),
				.cdr_ctrl(cdr_ctrl),
				.deskew_prog_pattern_only(deskew_prog_pattern_only),
				.wa_pld_controlled(wa_pld_controlled),
				.wa_rgnumber_data(wa_rgnumber_data),
				.eightb_tenb_decoder(eightb_tenb_decoder),
				.wa_disp_err_flag(wa_disp_err_flag),
				.re_bo_on_wa(re_bo_on_wa),
				.wa_renumber_data(wa_renumber_data),
				.ibm_invalid_code(ibm_invalid_code),
				.tx_rx_parallel_loopback(tx_rx_parallel_loopback),
				.rate_match(rate_match),
				.auto_error_replacement(auto_error_replacement),
				.wa_sync_sm_ctrl(wa_sync_sm_ctrl),
				.wa_rknumber_data(wa_rknumber_data),
				.hip_mode(hip_mode),
				.cdr_ctrl_rxvalid_mask(cdr_ctrl_rxvalid_mask),
				.deskew_pattern(deskew_pattern),
				.symbol_swap(symbol_swap),
				.wa_kchar(wa_kchar),
				.bypass_pipeline_reg(bypass_pipeline_reg),
				.clock_gate_dw_wa(clock_gate_dw_wa),
				.clock_gate_dw_pc_wrclk(clock_gate_dw_pc_wrclk),
				.pad_or_edb_error_replace(pad_or_edb_error_replace),
				.wa_rvnumber_data(wa_rvnumber_data),
				.cid_pattern_len(cid_pattern_len),
				.deskew(deskew),
				.eidle_entry_sd(eidle_entry_sd),
				.eightbtenb_decoder_output_sel(eightbtenb_decoder_output_sel),
				.sup_mode(sup_mode),
				.rx_pcs_urst(rx_pcs_urst),
				.prbs_ver(prbs_ver),
				.agg_block_sel(agg_block_sel),
				.rx_wr_clk(rx_wr_clk),
				.fixed_pat_num(fixed_pat_num),
				.bo_pattern(bo_pattern),
				.eidle_entry_iei(eidle_entry_iei),
				.use_default_base_address(use_default_base_address),
				.comp_fifo_rst_pld_ctrl(comp_fifo_rst_pld_ctrl),
				.wait_cnt(wait_cnt),
				.clkcmp_pattern_n(clkcmp_pattern_n),
				.force_signal_detect(force_signal_detect),
				.clock_gate_dw_dskw_wr(clock_gate_dw_dskw_wr),
				.rx_clk1(rx_clk1),
				.pma_done_count(pma_done_count),
				.invalid_code_flag_only(invalid_code_flag_only),
				.clock_gate_cdr_eidle(clock_gate_cdr_eidle),
				.clock_gate_bds_dec_asn(clock_gate_bds_dec_asn),
				.wa_rosnumber_data(wa_rosnumber_data),
				.clock_gate_sw_rm_rd(clock_gate_sw_rm_rd),
				.err_flags_sel(err_flags_sel),
				.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
				.bist_ver_clr_flag(bist_ver_clr_flag),
				.clock_gate_byteorder(clock_gate_byteorder),
				.clock_gate_sw_rm_wr(clock_gate_sw_rm_wr),
				.rx_clk_free_running(rx_clk_free_running),
				.polarity_inversion(polarity_inversion),
				.auto_deassert_pc_rst_cnt_data(auto_deassert_pc_rst_cnt_data),
				.user_base_address(user_base_address),
				.bo_pad(bo_pad),
				.clkcmp_pattern_p(clkcmp_pattern_p),
				.wa_clk_slip_spacing_data(wa_clk_slip_spacing_data),
				.clock_gate_prbs(clock_gate_prbs),
				.clock_gate_sw_wa(clock_gate_sw_wa),
				.runlength_val(runlength_val),
				.wa_pd(wa_pd),
				.bit_reversal(bit_reversal),
				.wa_pd_data(wa_pd_data),
				.pc_fifo_rst_pld_ctrl(pc_fifo_rst_pld_ctrl),
				.mask_cnt(mask_cnt),
				.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
				.cid_pattern(cid_pattern),
				.wait_for_phfifo_cnt_data(wait_for_phfifo_cnt_data),
				.pma_dw(pma_dw),
				.byte_order(byte_order),
				.wa_det_latency_sync_status_beh(wa_det_latency_sync_status_beh),
				.clock_gate_sw_pc_wrclk(clock_gate_sw_pc_wrclk),
				.prbs_ver_clr_flag(prbs_ver_clr_flag),
				.clock_gate_pc_rdclk(clock_gate_pc_rdclk),
				.pcs_bypass(pcs_bypass),
				.dw_one_or_two_symbol_bo(dw_one_or_two_symbol_bo),
				.pipe_if_enable(pipe_if_enable),
				.avmm_group_channel_index(avmm_group_channel_index),
				.phase_compensation_fifo(phase_compensation_fifo),
				.clock_gate_dskw_rd(clock_gate_dskw_rd),
				.rx_rcvd_clk(rx_rcvd_clk),
				.rx_refclk(rx_refclk),
				.channel_number(channel_number),
				.clock_gate_dw_rm_rd(clock_gate_dw_rm_rd),
				.clock_gate_sw_dskw_wr(clock_gate_sw_dskw_wr),
				.auto_pc_en_cnt_data(auto_pc_en_cnt_data),
				.wa_pd_polarity(wa_pd_polarity),
				.wa_clk_slip_spacing(wa_clk_slip_spacing),
				.test_mode(test_mode),
				.wa_boundary_lock_ctrl(wa_boundary_lock_ctrl),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.prot_mode(prot_mode),
				.rx_rd_clk(rx_rd_clk),
				.eidle_entry_eios(eidle_entry_eios),
				.auto_speed_nego(auto_speed_nego),
				.bist_ver(bist_ver),
				.clock_gate_dw_rm_wr(clock_gate_dw_rm_wr),
				.runlength_check(runlength_check)
			) stratixv_hssi_8g_rx_pcs_encrypted_ES_inst (
				.speedchangeinchnldown(speedchangeinchnldown),
				.fiforstrdqd(fiforstrdqd),
				.rmfifouserrst(rmfifouserrst),
				.rxstatus(rxstatus),
				.cgcomprddalltoporbot(cgcomprddalltoporbot),
				.eidleexit(eidleexit),
				.ltr(ltr),
				.phfifouserrst(phfifouserrst),
				.rxsynchdr(rxsynchdr),
				.rmfifordincomp0(rmfifordincomp0),
				.refclkdig2(refclkdig2),
				.aligndetsync(aligndetsync),
				.txdivsync(txdivsync),
				.avmmwrite(avmmwrite),
				.rxclkoutgen3(rxclkoutgen3),
				.rateswitchcontrol(rateswitchcontrol),
				.insertincomplete0toporbot(insertincomplete0toporbot),
				.alignstatustoporbot(alignstatustoporbot),
				.insertincompleteout(insertincompleteout),
				.datain(datain),
				.rxpipesoftreset(rxpipesoftreset),
				.rxdatarstoporbot(rxdatarstoporbot),
				.pldltr(pldltr),
				.datafrinaggblock(datafrinaggblock),
				.rdalign(rdalign),
				.parallelrevloopback(parallelrevloopback),
				.rxweoutchnldown(rxweoutchnldown),
				.rxdivsyncoutchnlup(rxdivsyncoutchnlup),
				.resetppmcntrspcspma(resetppmcntrspcspma),
				.cgcompwralltoporbot(cgcompwralltoporbot),
				.rdenableoutchnldown(rdenableoutchnldown),
				.rxdivsyncinchnldown(rxdivsyncinchnldown),
				.rlvlt(rlvlt),
				.disablepcfifobyteserdes(disablepcfifobyteserdes),
				.wrenableinchnlup(wrenableinchnlup),
				.configselinchnlup(configselinchnlup),
				.rxdatavalidpcsgen3(rxdatavalidpcsgen3),
				.resetppmcntrsoutchnldown(resetppmcntrsoutchnldown),
				.pcfifoempty(pcfifoempty),
				.speedchangeoutchnlup(speedchangeoutchnlup),
				.sigdetfrompma(sigdetfrompma),
				.dynclkswitchn(dynclkswitchn),
				.pipedata(pipedata),
				.configseloutchnlup(configseloutchnlup),
				.errdata(errdata),
				.endskwqdtoporbot(endskwqdtoporbot),
				.eidleinfersel(eidleinfersel),
				.avmmrstn(avmmrstn),
				.wrenableoutchnlup(wrenableoutchnlup),
				.rxpcsrst(rxpcsrst),
				.avmmbyteen(avmmbyteen),
				.bytereversalenable(bytereversalenable),
				.syncstatus(syncstatus),
				.selftesterr(selftesterr),
				.byteorder(byteorder),
				.pxfifowrdisable(pxfifowrdisable),
				.bisterr(bisterr),
				.refclkdig(refclkdig),
				.rcvdclkagg(rcvdclkagg),
				.aggtestbus(aggtestbus),
				.wrenableoutchnldown(wrenableoutchnldown),
				.phystatuspcsgen3(phystatuspcsgen3),
				.speedchangeinchnluppipe(speedchangeinchnluppipe),
				.rcvdclkpma(rcvdclkpma),
				.avmmreaddata(avmmreaddata),
				.channeltestbusout(channeltestbusout),
				.alignstatussync0(alignstatussync0),
				.rxdatavalid(rxdatavalid),
				.cgcomprddall(cgcomprddall),
				.rcvdclkaggtoporbot(rcvdclkaggtoporbot),
				.rxvalidinternal(rxvalidinternal),
				.avmmaddress(avmmaddress),
				.parallelloopback(parallelloopback),
				.pipeloopbk(pipeloopbk),
				.selftestdone(selftestdone),
				.runningdisparity(runningdisparity),
				.resetpcptrsinchnlup(resetpcptrsinchnlup),
				.rdenableinchnldown(rdenableinchnldown),
				.rxpipeclk(rxpipeclk),
				.rdenableoutchnlup(rdenableoutchnlup),
				.prbsdone(prbsdone),
				.rxvalid(rxvalid),
				.scanmode(scanmode),
				.syncsmen(syncsmen),
				.txctrlplanetestbus(txctrlplanetestbus),
				.syncdatain(syncdatain),
				.dataout(dataout),
				.avmmread(avmmread),
				.rdenableinchnlup(rdenableinchnlup),
				.rmfifoempty(rmfifoempty),
				.prbserrlt(prbserrlt),
				.byteordflag(byteordflag),
				.speedchangeoutchnldown(speedchangeoutchnldown),
				.phystatus(phystatus),
				.resetppmcntrsinchnlup(resetppmcntrsinchnlup),
				.delcondmet0toporbot(delcondmet0toporbot),
				.fifoovr0toporbot(fifoovr0toporbot),
				.rxvalidpcsgen3(rxvalidpcsgen3),
				.bistdone(bistdone),
				.errctrl(errctrl),
				.rxblkstart(rxblkstart),
				.endskwrdptrs(endskwrdptrs),
				.speedchangeinchnlup(speedchangeinchnlup),
				.aggrxpcsrst(aggrxpcsrst),
				.alignstatussync(alignstatussync),
				.fifordoutcomp(fifordoutcomp),
				.rxstatusinternal(rxstatusinternal),
				.clocktopld(clocktopld),
				.resetpcptrsinchnldown(resetpcptrsinchnldown),
				.rmfifowriteenable(rmfifowriteenable),
				.wordalignboundary(wordalignboundary),
				.endskwrdptrstoporbot(endskwrdptrstoporbot),
				.bitslip(bitslip),
				.polinvrx(polinvrx),
				.decoderdatavalid(decoderdatavalid),
				.pcfifofull(pcfifofull),
				.dispcbytegen3(dispcbytegen3),
				.gen2ngen1(gen2ngen1),
				.rmfifopartialempty(rmfifopartialempty),
				.resetpcptrsinchnldownpipe(resetpcptrsinchnldownpipe),
				.fifoovrout(fifoovrout),
				.insertincomplete0(insertincomplete0),
				.rxcontrolrstoporbot(rxcontrolrstoporbot),
				.speedchange(speedchange),
				.phystatusinternal(phystatusinternal),
				.decoderctrl(decoderctrl),
				.resetpcptrsoutchnldown(resetpcptrsoutchnldown),
				.cgcompwrall(cgcompwrall),
				.alignstatus(alignstatus),
				.wrenableinchnldown(wrenableinchnldown),
				.observablebyteserdesclock(observablebyteserdesclock),
				.fifordincomp0toporbot(fifordincomp0toporbot),
				.latencycomp0toporbot(latencycomp0toporbot),
				.resetpcptrsgen3(resetpcptrsgen3),
				.txpmaclk(txpmaclk),
				.rxdivsyncinchnlup(rxdivsyncinchnlup),
				.configseloutchnldown(configseloutchnldown),
				.runlengthviolation(runlengthviolation),
				.pcieswitch(pcieswitch),
				.pcfifordenable(pcfifordenable),
				.avmmclk(avmmclk),
				.a1a2k1k2flag(a1a2k1k2flag),
				.signaldetectout(signaldetectout),
				.a1a2size(a1a2size),
				.delcondmetout(delcondmetout),
				.alignstatuspld(alignstatuspld),
				.resetpcptrs(resetpcptrs),
				.bitreversalenable(bitreversalenable),
				.rmfiforeadenable(rmfiforeadenable),
				.resetpcptrsoutchnlup(resetpcptrsoutchnlup),
				.rxsynchdrpcsgen3(rxsynchdrpcsgen3),
				.enablecommadetect(enablecommadetect),
				.fiforstrdqdtoporbot(fiforstrdqdtoporbot),
				.pldrxclk(pldrxclk),
				.endskwqd(endskwqd),
				.hrdrst(hrdrst),
				.alignstatussync0toporbot(alignstatussync0toporbot),
				.rxstatuspcsgen3(rxstatuspcsgen3),
				.txtestbus(txtestbus),
				.resetpcptrsinchnluppipe(resetpcptrsinchnluppipe),
				.fifoovr0(fifoovr0),
				.eidledetected(eidledetected),
				.rxweoutchnlup(rxweoutchnlup),
				.pcieswitchgen3(pcieswitchgen3),
				.cgcompwrout(cgcompwrout),
				.resetppmcntrsoutchnlup(resetppmcntrsoutchnlup),
				.delcondmet0(delcondmet0),
				.resetppmcntrsinchnldown(resetppmcntrsinchnldown),
				.speedchangeinchnldownpipe(speedchangeinchnldownpipe),
				.latencycomp0(latencycomp0),
				.rmfifofull(rmfifofull),
				.prbscidenable(prbscidenable),
				.rxweinchnldown(rxweinchnldown),
				.cgcomprddout(cgcomprddout),
				.configselinchnldown(configselinchnldown),
				.resetppmcntrsgen3(resetppmcntrsgen3),
				.rxblkstartpcsgen3(rxblkstartpcsgen3),
				.decoderdata(decoderdata),
				.rmfifopartialfull(rmfifopartialfull),
				.blockselect(blockselect),
				.rxclkslip(rxclkslip),
				.latencycompout(latencycompout),
				.rxdivsyncoutchnldown(rxdivsyncoutchnldown),
				.rxdatapcsgen3(rxdatapcsgen3),
				.rxweinchnlup(rxweinchnlup),
				.earlyeios(earlyeios),
				.ctrlfromaggblock(ctrlfromaggblock),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_8g_rx_pcs_encrypted #(
                .enable_debug_info(enable_debug_info),
				.fixed_pat_det(fixed_pat_det),
				.byte_deserializer(byte_deserializer),
				.polinv_8b10b_dec(polinv_8b10b_dec),
				.clock_gate_bist(clock_gate_bist),
				.test_bus_sel(test_bus_sel),
				.rx_clk2(rx_clk2),
				.cdr_ctrl(cdr_ctrl),
				.deskew_prog_pattern_only(deskew_prog_pattern_only),
				.wa_pld_controlled(wa_pld_controlled),
				.wa_rgnumber_data(wa_rgnumber_data),
				.eightb_tenb_decoder(eightb_tenb_decoder),
				.wa_disp_err_flag(wa_disp_err_flag),
				.re_bo_on_wa(re_bo_on_wa),
				.wa_renumber_data(wa_renumber_data),
				.ibm_invalid_code(ibm_invalid_code),
				.tx_rx_parallel_loopback(tx_rx_parallel_loopback),
				.rate_match(rate_match),
				.auto_error_replacement(auto_error_replacement),
				.wa_sync_sm_ctrl(wa_sync_sm_ctrl),
				.wa_rknumber_data(wa_rknumber_data),
				.hip_mode(hip_mode),
				.cdr_ctrl_rxvalid_mask(cdr_ctrl_rxvalid_mask),
				.deskew_pattern(deskew_pattern),
				.symbol_swap(symbol_swap),
				.wa_kchar(wa_kchar),
				.bypass_pipeline_reg(bypass_pipeline_reg),
				.clock_gate_dw_wa(clock_gate_dw_wa),
				.clock_gate_dw_pc_wrclk(clock_gate_dw_pc_wrclk),
				.pad_or_edb_error_replace(pad_or_edb_error_replace),
				.wa_rvnumber_data(wa_rvnumber_data),
				.cid_pattern_len(cid_pattern_len),
				.deskew(deskew),
				.eidle_entry_sd(eidle_entry_sd),
				.eightbtenb_decoder_output_sel(eightbtenb_decoder_output_sel),
				.sup_mode(sup_mode),
				.rx_pcs_urst(rx_pcs_urst),
				.prbs_ver(prbs_ver),
				.agg_block_sel(agg_block_sel),
				.rx_wr_clk(rx_wr_clk),
				.fixed_pat_num(fixed_pat_num),
				.bo_pattern(bo_pattern),
				.eidle_entry_iei(eidle_entry_iei),
				.use_default_base_address(use_default_base_address),
				.comp_fifo_rst_pld_ctrl(comp_fifo_rst_pld_ctrl),
				.wait_cnt(wait_cnt),
				.clkcmp_pattern_n(clkcmp_pattern_n),
				.force_signal_detect(force_signal_detect),
				.clock_gate_dw_dskw_wr(clock_gate_dw_dskw_wr),
				.rx_clk1(rx_clk1),
				.pma_done_count(pma_done_count),
				.invalid_code_flag_only(invalid_code_flag_only),
				.clock_gate_cdr_eidle(clock_gate_cdr_eidle),
				.clock_gate_bds_dec_asn(clock_gate_bds_dec_asn),
				.wa_rosnumber_data(wa_rosnumber_data),
				.clock_gate_sw_rm_rd(clock_gate_sw_rm_rd),
				.err_flags_sel(err_flags_sel),
				.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
				.bist_ver_clr_flag(bist_ver_clr_flag),
				.clock_gate_byteorder(clock_gate_byteorder),
				.clock_gate_sw_rm_wr(clock_gate_sw_rm_wr),
				.rx_clk_free_running(rx_clk_free_running),
				.polarity_inversion(polarity_inversion),
				.auto_deassert_pc_rst_cnt_data(auto_deassert_pc_rst_cnt_data),
				.user_base_address(user_base_address),
				.bo_pad(bo_pad),
				.clkcmp_pattern_p(clkcmp_pattern_p),
				.wa_clk_slip_spacing_data(wa_clk_slip_spacing_data),
				.clock_gate_prbs(clock_gate_prbs),
				.clock_gate_sw_wa(clock_gate_sw_wa),
				.runlength_val(runlength_val),
				.wa_pd(wa_pd),
				.bit_reversal(bit_reversal),
				.wa_pd_data(wa_pd_data),
				.pc_fifo_rst_pld_ctrl(pc_fifo_rst_pld_ctrl),
				.mask_cnt(mask_cnt),
				.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
				.cid_pattern(cid_pattern),
				.wait_for_phfifo_cnt_data(wait_for_phfifo_cnt_data),
				.pma_dw(pma_dw),
				.byte_order(byte_order),
				.wa_det_latency_sync_status_beh(wa_det_latency_sync_status_beh),
				.clock_gate_sw_pc_wrclk(clock_gate_sw_pc_wrclk),
				.prbs_ver_clr_flag(prbs_ver_clr_flag),
				.clock_gate_pc_rdclk(clock_gate_pc_rdclk),
				.pcs_bypass(pcs_bypass),
				.dw_one_or_two_symbol_bo(dw_one_or_two_symbol_bo),
				.pipe_if_enable(pipe_if_enable),
				.avmm_group_channel_index(avmm_group_channel_index),
				.phase_compensation_fifo(phase_compensation_fifo),
				.clock_gate_dskw_rd(clock_gate_dskw_rd),
				.rx_rcvd_clk(rx_rcvd_clk),
				.rx_refclk(rx_refclk),
				.channel_number(channel_number),
				.clock_gate_dw_rm_rd(clock_gate_dw_rm_rd),
				.clock_gate_sw_dskw_wr(clock_gate_sw_dskw_wr),
				.auto_pc_en_cnt_data(auto_pc_en_cnt_data),
				.wa_pd_polarity(wa_pd_polarity),
				.wa_clk_slip_spacing(wa_clk_slip_spacing),
				.test_mode(test_mode),
				.wa_boundary_lock_ctrl(wa_boundary_lock_ctrl),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.prot_mode(prot_mode),
				.rx_rd_clk(rx_rd_clk),
				.eidle_entry_eios(eidle_entry_eios),
				.auto_speed_nego(auto_speed_nego),
				.bist_ver(bist_ver),
				.clock_gate_dw_rm_wr(clock_gate_dw_rm_wr),
				.runlength_check(runlength_check)
			) stratixv_hssi_8g_rx_pcs_encrypted_inst (
				.speedchangeinchnldown(speedchangeinchnldown),
				.fiforstrdqd(fiforstrdqd),
				.rmfifouserrst(rmfifouserrst),
				.rxstatus(rxstatus),
				.cgcomprddalltoporbot(cgcomprddalltoporbot),
				.eidleexit(eidleexit),
				.ltr(ltr),
				.phfifouserrst(phfifouserrst),
				.rxsynchdr(rxsynchdr),
				.rmfifordincomp0(rmfifordincomp0),
				.refclkdig2(refclkdig2),
				.aligndetsync(aligndetsync),
				.txdivsync(txdivsync),
				.avmmwrite(avmmwrite),
				.rxclkoutgen3(rxclkoutgen3),
				.rateswitchcontrol(rateswitchcontrol),
				.insertincomplete0toporbot(insertincomplete0toporbot),
				.alignstatustoporbot(alignstatustoporbot),
				.insertincompleteout(insertincompleteout),
				.datain(datain),
				.rxpipesoftreset(rxpipesoftreset),
				.rxdatarstoporbot(rxdatarstoporbot),
				.pldltr(pldltr),
				.datafrinaggblock(datafrinaggblock),
				.rdalign(rdalign),
				.parallelrevloopback(parallelrevloopback),
				.rxweoutchnldown(rxweoutchnldown),
				.rxdivsyncoutchnlup(rxdivsyncoutchnlup),
				.resetppmcntrspcspma(resetppmcntrspcspma),
				.cgcompwralltoporbot(cgcompwralltoporbot),
				.rdenableoutchnldown(rdenableoutchnldown),
				.rxdivsyncinchnldown(rxdivsyncinchnldown),
				.rlvlt(rlvlt),
				.disablepcfifobyteserdes(disablepcfifobyteserdes),
				.wrenableinchnlup(wrenableinchnlup),
				.configselinchnlup(configselinchnlup),
				.rxdatavalidpcsgen3(rxdatavalidpcsgen3),
				.resetppmcntrsoutchnldown(resetppmcntrsoutchnldown),
				.pcfifoempty(pcfifoempty),
				.speedchangeoutchnlup(speedchangeoutchnlup),
				.sigdetfrompma(sigdetfrompma),
				.dynclkswitchn(dynclkswitchn),
				.pipedata(pipedata),
				.configseloutchnlup(configseloutchnlup),
				.errdata(errdata),
				.endskwqdtoporbot(endskwqdtoporbot),
				.eidleinfersel(eidleinfersel),
				.avmmrstn(avmmrstn),
				.wrenableoutchnlup(wrenableoutchnlup),
				.rxpcsrst(rxpcsrst),
				.avmmbyteen(avmmbyteen),
				.bytereversalenable(bytereversalenable),
				.syncstatus(syncstatus),
				.selftesterr(selftesterr),
				.byteorder(byteorder),
				.pxfifowrdisable(pxfifowrdisable),
				.bisterr(bisterr),
				.refclkdig(refclkdig),
				.rcvdclkagg(rcvdclkagg),
				.aggtestbus(aggtestbus),
				.wrenableoutchnldown(wrenableoutchnldown),
				.phystatuspcsgen3(phystatuspcsgen3),
				.speedchangeinchnluppipe(speedchangeinchnluppipe),
				.rcvdclkpma(rcvdclkpma),
				.avmmreaddata(avmmreaddata),
				.channeltestbusout(channeltestbusout),
				.alignstatussync0(alignstatussync0),
				.rxdatavalid(rxdatavalid),
				.cgcomprddall(cgcomprddall),
				.rcvdclkaggtoporbot(rcvdclkaggtoporbot),
				.rxvalidinternal(rxvalidinternal),
				.avmmaddress(avmmaddress),
				.parallelloopback(parallelloopback),
				.pipeloopbk(pipeloopbk),
				.selftestdone(selftestdone),
				.runningdisparity(runningdisparity),
				.resetpcptrsinchnlup(resetpcptrsinchnlup),
				.rdenableinchnldown(rdenableinchnldown),
				.rxpipeclk(rxpipeclk),
				.rdenableoutchnlup(rdenableoutchnlup),
				.prbsdone(prbsdone),
				.rxvalid(rxvalid),
				.scanmode(scanmode),
				.syncsmen(syncsmen),
				.txctrlplanetestbus(txctrlplanetestbus),
				.syncdatain(syncdatain),
				.dataout(dataout),
				.avmmread(avmmread),
				.rdenableinchnlup(rdenableinchnlup),
				.rmfifoempty(rmfifoempty),
				.prbserrlt(prbserrlt),
				.byteordflag(byteordflag),
				.speedchangeoutchnldown(speedchangeoutchnldown),
				.phystatus(phystatus),
				.resetppmcntrsinchnlup(resetppmcntrsinchnlup),
				.delcondmet0toporbot(delcondmet0toporbot),
				.fifoovr0toporbot(fifoovr0toporbot),
				.rxvalidpcsgen3(rxvalidpcsgen3),
				.bistdone(bistdone),
				.errctrl(errctrl),
				.rxblkstart(rxblkstart),
				.endskwrdptrs(endskwrdptrs),
				.speedchangeinchnlup(speedchangeinchnlup),
				.aggrxpcsrst(aggrxpcsrst),
				.alignstatussync(alignstatussync),
				.fifordoutcomp(fifordoutcomp),
				.rxstatusinternal(rxstatusinternal),
				.clocktopld(clocktopld),
				.resetpcptrsinchnldown(resetpcptrsinchnldown),
				.rmfifowriteenable(rmfifowriteenable),
				.wordalignboundary(wordalignboundary),
				.endskwrdptrstoporbot(endskwrdptrstoporbot),
				.bitslip(bitslip),
				.polinvrx(polinvrx),
				.decoderdatavalid(decoderdatavalid),
				.pcfifofull(pcfifofull),
				.dispcbytegen3(dispcbytegen3),
				.gen2ngen1(gen2ngen1),
				.rmfifopartialempty(rmfifopartialempty),
				.resetpcptrsinchnldownpipe(resetpcptrsinchnldownpipe),
				.fifoovrout(fifoovrout),
				.insertincomplete0(insertincomplete0),
				.rxcontrolrstoporbot(rxcontrolrstoporbot),
				.speedchange(speedchange),
				.phystatusinternal(phystatusinternal),
				.decoderctrl(decoderctrl),
				.resetpcptrsoutchnldown(resetpcptrsoutchnldown),
				.cgcompwrall(cgcompwrall),
				.alignstatus(alignstatus),
				.wrenableinchnldown(wrenableinchnldown),
				.observablebyteserdesclock(observablebyteserdesclock),
				.fifordincomp0toporbot(fifordincomp0toporbot),
				.latencycomp0toporbot(latencycomp0toporbot),
				.resetpcptrsgen3(resetpcptrsgen3),
				.txpmaclk(txpmaclk),
				.rxdivsyncinchnlup(rxdivsyncinchnlup),
				.configseloutchnldown(configseloutchnldown),
				.runlengthviolation(runlengthviolation),
				.pcieswitch(pcieswitch),
				.pcfifordenable(pcfifordenable),
				.avmmclk(avmmclk),
				.a1a2k1k2flag(a1a2k1k2flag),
				.signaldetectout(signaldetectout),
				.a1a2size(a1a2size),
				.delcondmetout(delcondmetout),
				.alignstatuspld(alignstatuspld),
				.resetpcptrs(resetpcptrs),
				.bitreversalenable(bitreversalenable),
				.rmfiforeadenable(rmfiforeadenable),
				.resetpcptrsoutchnlup(resetpcptrsoutchnlup),
				.rxsynchdrpcsgen3(rxsynchdrpcsgen3),
				.enablecommadetect(enablecommadetect),
				.fiforstrdqdtoporbot(fiforstrdqdtoporbot),
				.pldrxclk(pldrxclk),
				.endskwqd(endskwqd),
				.hrdrst(hrdrst),
				.alignstatussync0toporbot(alignstatussync0toporbot),
				.rxstatuspcsgen3(rxstatuspcsgen3),
				.txtestbus(txtestbus),
				.resetpcptrsinchnluppipe(resetpcptrsinchnluppipe),
				.fifoovr0(fifoovr0),
				.eidledetected(eidledetected),
				.rxweoutchnlup(rxweoutchnlup),
				.pcieswitchgen3(pcieswitchgen3),
				.cgcompwrout(cgcompwrout),
				.resetppmcntrsoutchnlup(resetppmcntrsoutchnlup),
				.delcondmet0(delcondmet0),
				.resetppmcntrsinchnldown(resetppmcntrsinchnldown),
				.speedchangeinchnldownpipe(speedchangeinchnldownpipe),
				.latencycomp0(latencycomp0),
				.rmfifofull(rmfifofull),
				.prbscidenable(prbscidenable),
				.rxweinchnldown(rxweinchnldown),
				.cgcomprddout(cgcomprddout),
				.configselinchnldown(configselinchnldown),
				.resetppmcntrsgen3(resetppmcntrsgen3),
				.rxblkstartpcsgen3(rxblkstartpcsgen3),
				.decoderdata(decoderdata),
				.rmfifopartialfull(rmfifopartialfull),
				.blockselect(blockselect),
				.rxclkslip(rxclkslip),
				.latencycompout(latencycompout),
				.rxdivsyncoutchnldown(rxdivsyncoutchnldown),
				.rxdatapcsgen3(rxdatapcsgen3),
				.rxweinchnlup(rxweinchnlup),
				.earlyeios(earlyeios),
				.ctrlfromaggblock(ctrlfromaggblock),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_8g_tx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_8g_tx_pcs
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter clock_gate_bist = "dis_bist_clk_gating",      // Valid values: dis_bist_clk_gating|en_bist_clk_gating
	parameter clock_gate_bs_enc = "dis_bs_enc_clk_gating",      // Valid values: dis_bs_enc_clk_gating|en_bs_enc_clk_gating
	parameter ctrl_plane_bonding_compensation = "dis_compensation",      // Valid values: dis_compensation|en_compensation
	parameter data_selection_8b10b_encoder_input = "normal_data_path",      // Valid values: normal_data_path|xaui_sm|gige_idle_conversion
	parameter dynamic_clk_switch = "dis_dyn_clk_switch",      // Valid values: dis_dyn_clk_switch|en_dyn_clk_switch
	parameter eightb_tenb_disp_ctrl = "dis_disp_ctrl",      // Valid values: dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
	parameter phfifo_write_clk_sel = "pld_tx_clk",      // Valid values: pld_tx_clk|tx_clk
	parameter bist_gen = "dis_bist",      // Valid values: dis_bist|incremental|cjpat|crpat
	parameter polarity_inversion = "dis_polinv",      // Valid values: dis_polinv|enable_polinv
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter byte_serializer = "dis_bs",      // Valid values: dis_bs|en_bs_by_2|en_bs_by_4
	parameter refclk_b_clk_sel = "tx_pma_clock",      // Valid values: tx_pma_clock|refclk_dig
	parameter clock_gate_prbs = "dis_prbs_clk_gating",      // Valid values: dis_prbs_clk_gating|en_prbs_clk_gating
	parameter tx_bitslip = "dis_tx_bitslip",      // Valid values: dis_tx_bitslip|en_tx_bitslip
	parameter bit_reversal = "dis_bit_reversal",      // Valid values: dis_bit_reversal|en_bit_reversal
	parameter force_kchar = "dis_force_kchar",      // Valid values: dis_force_kchar|en_force_kchar
	parameter force_echar = "dis_force_echar",      // Valid values: dis_force_echar|en_force_echar
	parameter hip_mode = "dis_hip",      // Valid values: dis_hip|en_hip
	parameter clock_gate_dw_fifowr = "dis_dw_fifowr_clk_gating",      // Valid values: dis_dw_fifowr_clk_gating|en_dw_fifowr_clk_gating
	parameter symbol_swap = "dis_symbol_swap",      // Valid values: dis_symbol_swap|en_symbol_swap
	parameter ctrl_plane_bonding_distribution = "not_master_chnl_distr",      // Valid values: master_chnl_distr|not_master_chnl_distr
	parameter cid_pattern = "cid_pattern_0",      // Valid values: cid_pattern_0|cid_pattern_1
	parameter pma_dw = "eight_bit",      // Valid values: eight_bit|ten_bit|sixteen_bit|twenty_bit
	parameter bypass_pipeline_reg = "dis_bypass_pipeline",      // Valid values: dis_bypass_pipeline|en_bypass_pipeline
	parameter cid_pattern_len = 8'b0,      // Valid values: 8
	parameter clock_gate_sw_fifowr = "dis_sw_fifowr_clk_gating",      // Valid values: dis_sw_fifowr_clk_gating|en_sw_fifowr_clk_gating
	parameter pcfifo_urst = "dis_pcfifourst",      // Valid values: dis_pcfifourst|en_pcfifourst
	parameter eightb_tenb_encoder = "dis_8b10b",      // Valid values: dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
	parameter pcs_bypass = "dis_pcs_bypass",      // Valid values: dis_pcs_bypass|en_pcs_bypass
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode
	parameter phase_compensation_fifo = "low_latency",      // Valid values: low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
	parameter txclk_freerun = "en_freerun_tx",      // Valid values: dis_freerun_tx|en_freerun_tx
	parameter agg_block_sel = "same_smrt_pack",      // Valid values: same_smrt_pack|other_smrt_pack
	parameter auto_speed_nego_gen2 = "dis_asn_g2",      // Valid values: dis_asn_g2|en_asn_g2_freq_scal
	parameter txpcs_urst = "en_txpcs_urst",      // Valid values: dis_txpcs_urst|en_txpcs_urst
	parameter channel_number = 0,      // Valid values: 0..65
	parameter revloop_back_rm = "dis_rev_loopback_rx_rm",      // Valid values: dis_rev_loopback_rx_rm|en_rev_loopback_rx_rm
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter test_mode = "prbs",      // Valid values: dont_care_test|prbs|bist
	parameter ctrl_plane_bonding_consumption = "individual",      // Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter clock_gate_fiford = "dis_fiford_clk_gating",      // Valid values: dis_fiford_clk_gating|en_fiford_clk_gating
	parameter prot_mode = "basic",      // Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter tx_compliance_controlled_disparity = "dis_txcompliance",      // Valid values: dis_txcompliance|en_txcompliance_pipe2p0|en_txcompliance_pipe3p0
	parameter prbs_gen = "dis_prbs",      // Valid values: dis_prbs|prbs_7_sw|prbs_7_dw|prbs_8|prbs_10|prbs_23_sw|prbs_23_dw|prbs_15|prbs_31|prbs_hf_sw|prbs_hf_dw|prbs_lf_sw|prbs_lf_dw|prbs_mf_sw|prbs_mf_dw
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] aggtxpcsrst,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	input  [ 4:0 ] bitslipboundaryselect,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkout,
	output [ 0:0 ] clkoutgen3,
	input  [ 0:0 ] clkselgen3,
	input  [ 0:0 ] coreclk,
	input  [ 43:0 ] datain,
	output [ 19:0 ] dataout,
	input  [ 0:0 ] detectrxloopin,
	output [ 0:0 ] detectrxloopout,
	input  [ 0:0 ] dispcbyte,
	output [ 0:0 ] dynclkswitchn,
	input  [ 2:0 ] elecidleinfersel,
	input  [ 0:0 ] enrevparallellpbk,
	input  [ 1:0 ] fifoselectinchnldown,
	input  [ 1:0 ] fifoselectinchnlup,
	output [ 1:0 ] fifoselectoutchnldown,
	output [ 1:0 ] fifoselectoutchnlup,
	output [ 2:0 ] grayelecidleinferselout,
	input  [ 0:0 ] hrdrst,
	input  [ 0:0 ] invpol,
	output [ 0:0 ] observablebyteserdesclock,
	output [ 19:0 ] parallelfdbkout,
	output [ 0:0 ] phfifooverflow,
	input  [ 0:0 ] phfiforddisable,
	input  [ 0:0 ] phfiforeset,
	output [ 0:0 ] phfifotxdeemph,
	output [ 2:0 ] phfifotxmargin,
	output [ 0:0 ] phfifotxswing,
	output [ 0:0 ] phfifounderflow,
	input  [ 0:0 ] phfifowrenable,
	input  [ 0:0 ] pipeenrevparallellpbkin,
	output [ 0:0 ] pipeenrevparallellpbkout,
	output [ 1:0 ] pipepowerdownout,
	input  [ 0:0 ] pipetxdeemph,
	input  [ 2:0 ] pipetxmargin,
	input  [ 0:0 ] pipetxswing,
	input  [ 0:0 ] polinvrxin,
	output [ 0:0 ] polinvrxout,
	input  [ 1:0 ] powerdn,
	input  [ 0:0 ] prbscidenable,
	input  [ 0:0 ] rateswitch,
	input  [ 0:0 ] rdenableinchnldown,
	input  [ 0:0 ] rdenableinchnlup,
	output [ 0:0 ] rdenableoutchnldown,
	output [ 0:0 ] rdenableoutchnlup,
	output [ 0:0 ] rdenablesync,
	output [ 0:0 ] refclkb,
	output [ 0:0 ] refclkbreset,
	input  [ 0:0 ] refclkdig,
	input  [ 0:0 ] resetpcptrs,
	input  [ 0:0 ] resetpcptrsinchnldown,
	input  [ 0:0 ] resetpcptrsinchnlup,
	input  [ 19:0 ] revparallellpbkdata,
	input  [ 0:0 ] rxpolarityin,
	output [ 0:0 ] rxpolarityout,
	input  [ 0:0 ] scanmode,
	output [ 0:0 ] syncdatain,
	input  [ 3:0 ] txblkstart,
	output [ 3:0 ] txblkstartout,
	output [ 0:0 ] txcomplianceout,
	output [ 19:0 ] txctrlplanetestbus,
	output [ 3:0 ] txdatakouttogen3,
	output [ 31:0 ] txdataouttogen3,
	input  [ 3:0 ] txdatavalid,
	output [ 3:0 ] txdatavalidouttogen3,
	output [ 1:0 ] txdivsync,
	input  [ 1:0 ] txdivsyncinchnldown,
	input  [ 1:0 ] txdivsyncinchnlup,
	output [ 1:0 ] txdivsyncoutchnldown,
	output [ 1:0 ] txdivsyncoutchnlup,
	output [ 0:0 ] txelecidleout,
	input  [ 0:0 ] txpcsreset,
	output [ 0:0 ] txpipeclk,
	output [ 0:0 ] txpipeelectidle,
	output [ 0:0 ] txpipesoftreset,
	input  [ 0:0 ] txpmalocalclk,
	input  [ 1:0 ] txsynchdr,
	output [ 1:0 ] txsynchdrout,
	output [ 19:0 ] txtestbus,
	input  [ 0:0 ] wrenableinchnldown,
	input  [ 0:0 ] wrenableinchnlup,
	output [ 0:0 ] wrenableoutchnldown,
	output [ 0:0 ] wrenableoutchnlup,
	input  [ 0:0 ] xgmctrl,
	output [ 0:0 ] xgmctrlenable,
	input  [ 0:0 ] xgmctrltoporbottom,
	input  [ 7:0 ] xgmdatain,
	input  [ 7:0 ] xgmdataintoporbottom,
	output [ 7:0 ] xgmdataout
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_8g_tx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_8g_tx_pcs_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.clock_gate_bist(clock_gate_bist),
				.clock_gate_bs_enc(clock_gate_bs_enc),
				.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
				.data_selection_8b10b_encoder_input(data_selection_8b10b_encoder_input),
				.dynamic_clk_switch(dynamic_clk_switch),
				.eightb_tenb_disp_ctrl(eightb_tenb_disp_ctrl),
				.phfifo_write_clk_sel(phfifo_write_clk_sel),
				.bist_gen(bist_gen),
				.polarity_inversion(polarity_inversion),
				.user_base_address(user_base_address),
				.byte_serializer(byte_serializer),
				.refclk_b_clk_sel(refclk_b_clk_sel),
				.clock_gate_prbs(clock_gate_prbs),
				.tx_bitslip(tx_bitslip),
				.bit_reversal(bit_reversal),
				.force_kchar(force_kchar),
				.force_echar(force_echar),
				.hip_mode(hip_mode),
				.clock_gate_dw_fifowr(clock_gate_dw_fifowr),
				.symbol_swap(symbol_swap),
				.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
				.cid_pattern(cid_pattern),
				.pma_dw(pma_dw),
				.bypass_pipeline_reg(bypass_pipeline_reg),
				.cid_pattern_len(cid_pattern_len),
				.clock_gate_sw_fifowr(clock_gate_sw_fifowr),
				.pcfifo_urst(pcfifo_urst),
				.eightb_tenb_encoder(eightb_tenb_encoder),
				.pcs_bypass(pcs_bypass),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.phase_compensation_fifo(phase_compensation_fifo),
				.txclk_freerun(txclk_freerun),
				.agg_block_sel(agg_block_sel),
				.auto_speed_nego_gen2(auto_speed_nego_gen2),
				.txpcs_urst(txpcs_urst),
				.channel_number(channel_number),
				.revloop_back_rm(revloop_back_rm),
				.use_default_base_address(use_default_base_address),
				.test_mode(test_mode),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.clock_gate_fiford(clock_gate_fiford),
				.prot_mode(prot_mode),
				.tx_compliance_controlled_disparity(tx_compliance_controlled_disparity),
				.prbs_gen(prbs_gen)
			) stratixv_hssi_8g_tx_pcs_encrypted_ES_inst (
				.polinvrxout(polinvrxout),
				.txcomplianceout(txcomplianceout),
				.xgmdataintoporbottom(xgmdataintoporbottom),
				.detectrxloopin(detectrxloopin),
				.txdatavalidouttogen3(txdatavalidouttogen3),
				.powerdn(powerdn),
				.phfiforddisable(phfiforddisable),
				.txpipesoftreset(txpipesoftreset),
				.clkoutgen3(clkoutgen3),
				.resetpcptrsinchnldown(resetpcptrsinchnldown),
				.txdivsync(txdivsync),
				.rdenablesync(rdenablesync),
				.pipeenrevparallellpbkout(pipeenrevparallellpbkout),
				.phfifooverflow(phfifooverflow),
				.avmmwrite(avmmwrite),
				.fifoselectoutchnldown(fifoselectoutchnldown),
				.dispcbyte(dispcbyte),
				.refclkb(refclkb),
				.phfifotxswing(phfifotxswing),
				.phfiforeset(phfiforeset),
				.txdataouttogen3(txdataouttogen3),
				.clkout(clkout),
				.datain(datain),
				.phfifowrenable(phfifowrenable),
				.txblkstartout(txblkstartout),
				.fifoselectoutchnlup(fifoselectoutchnlup),
				.xgmdataout(xgmdataout),
				.pipetxmargin(pipetxmargin),
				.txdivsyncinchnlup(txdivsyncinchnlup),
				.pipetxdeemph(pipetxdeemph),
				.parallelfdbkout(parallelfdbkout),
				.invpol(invpol),
				.rdenableoutchnldown(rdenableoutchnldown),
				.aggtxpcsrst(aggtxpcsrst),
				.fifoselectinchnldown(fifoselectinchnldown),
				.wrenableinchnlup(wrenableinchnlup),
				.wrenableinchnldown(wrenableinchnldown),
				.txpipeclk(txpipeclk),
				.observablebyteserdesclock(observablebyteserdesclock),
				.refclkbreset(refclkbreset),
				.revparallellpbkdata(revparallellpbkdata),
				.txdivsyncoutchnlup(txdivsyncoutchnlup),
				.polinvrxin(polinvrxin),
				.dynclkswitchn(dynclkswitchn),
				.txblkstart(txblkstart),
				.avmmclk(avmmclk),
				.txpcsreset(txpcsreset),
				.txdatavalid(txdatavalid),
				.phfifotxmargin(phfifotxmargin),
				.avmmrstn(avmmrstn),
				.wrenableoutchnlup(wrenableoutchnlup),
				.avmmbyteen(avmmbyteen),
				.resetpcptrs(resetpcptrs),
				.phfifotxdeemph(phfifotxdeemph),
				.txdivsyncoutchnldown(txdivsyncoutchnldown),
				.refclkdig(refclkdig),
				.xgmctrltoporbottom(xgmctrltoporbottom),
				.wrenableoutchnldown(wrenableoutchnldown),
				.avmmreaddata(avmmreaddata),
				.hrdrst(hrdrst),
				.fifoselectinchnlup(fifoselectinchnlup),
				.txsynchdr(txsynchdr),
				.phfifounderflow(phfifounderflow),
				.elecidleinfersel(elecidleinfersel),
				.txtestbus(txtestbus),
				.detectrxloopout(detectrxloopout),
				.pipepowerdownout(pipepowerdownout),
				.txsynchdrout(txsynchdrout),
				.coreclk(coreclk),
				.avmmaddress(avmmaddress),
				.rateswitch(rateswitch),
				.rdenableinchnldown(rdenableinchnldown),
				.resetpcptrsinchnlup(resetpcptrsinchnlup),
				.enrevparallellpbk(enrevparallellpbk),
				.grayelecidleinferselout(grayelecidleinferselout),
				.rxpolarityout(rxpolarityout),
				.rdenableoutchnlup(rdenableoutchnlup),
				.txpipeelectidle(txpipeelectidle),
				.pipetxswing(pipetxswing),
				.txdivsyncinchnldown(txdivsyncinchnldown),
				.pipeenrevparallellpbkin(pipeenrevparallellpbkin),
				.bitslipboundaryselect(bitslipboundaryselect),
				.scanmode(scanmode),
				.txctrlplanetestbus(txctrlplanetestbus),
				.xgmctrl(xgmctrl),
				.syncdatain(syncdatain),
				.avmmread(avmmread),
				.txpmalocalclk(txpmalocalclk),
				.dataout(dataout),
				.prbscidenable(prbscidenable),
				.clkselgen3(clkselgen3),
				.rxpolarityin(rxpolarityin),
				.rdenableinchnlup(rdenableinchnlup),
				.txelecidleout(txelecidleout),
				.blockselect(blockselect),
				.xgmctrlenable(xgmctrlenable),
				.txdatakouttogen3(txdatakouttogen3),
				.xgmdatain(xgmdatain),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_8g_tx_pcs_encrypted #(
                .enable_debug_info(enable_debug_info),
				.clock_gate_bist(clock_gate_bist),
				.clock_gate_bs_enc(clock_gate_bs_enc),
				.ctrl_plane_bonding_compensation(ctrl_plane_bonding_compensation),
				.data_selection_8b10b_encoder_input(data_selection_8b10b_encoder_input),
				.dynamic_clk_switch(dynamic_clk_switch),
				.eightb_tenb_disp_ctrl(eightb_tenb_disp_ctrl),
				.phfifo_write_clk_sel(phfifo_write_clk_sel),
				.bist_gen(bist_gen),
				.polarity_inversion(polarity_inversion),
				.user_base_address(user_base_address),
				.byte_serializer(byte_serializer),
				.refclk_b_clk_sel(refclk_b_clk_sel),
				.clock_gate_prbs(clock_gate_prbs),
				.tx_bitslip(tx_bitslip),
				.bit_reversal(bit_reversal),
				.force_kchar(force_kchar),
				.force_echar(force_echar),
				.hip_mode(hip_mode),
				.clock_gate_dw_fifowr(clock_gate_dw_fifowr),
				.symbol_swap(symbol_swap),
				.ctrl_plane_bonding_distribution(ctrl_plane_bonding_distribution),
				.cid_pattern(cid_pattern),
				.pma_dw(pma_dw),
				.bypass_pipeline_reg(bypass_pipeline_reg),
				.cid_pattern_len(cid_pattern_len),
				.clock_gate_sw_fifowr(clock_gate_sw_fifowr),
				.pcfifo_urst(pcfifo_urst),
				.eightb_tenb_encoder(eightb_tenb_encoder),
				.pcs_bypass(pcs_bypass),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.phase_compensation_fifo(phase_compensation_fifo),
				.txclk_freerun(txclk_freerun),
				.agg_block_sel(agg_block_sel),
				.auto_speed_nego_gen2(auto_speed_nego_gen2),
				.txpcs_urst(txpcs_urst),
				.channel_number(channel_number),
				.revloop_back_rm(revloop_back_rm),
				.use_default_base_address(use_default_base_address),
				.test_mode(test_mode),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.clock_gate_fiford(clock_gate_fiford),
				.prot_mode(prot_mode),
				.tx_compliance_controlled_disparity(tx_compliance_controlled_disparity),
				.prbs_gen(prbs_gen)
			) stratixv_hssi_8g_tx_pcs_encrypted_inst (
				.polinvrxout(polinvrxout),
				.txcomplianceout(txcomplianceout),
				.xgmdataintoporbottom(xgmdataintoporbottom),
				.detectrxloopin(detectrxloopin),
				.txdatavalidouttogen3(txdatavalidouttogen3),
				.powerdn(powerdn),
				.phfiforddisable(phfiforddisable),
				.txpipesoftreset(txpipesoftreset),
				.clkoutgen3(clkoutgen3),
				.resetpcptrsinchnldown(resetpcptrsinchnldown),
				.txdivsync(txdivsync),
				.rdenablesync(rdenablesync),
				.pipeenrevparallellpbkout(pipeenrevparallellpbkout),
				.phfifooverflow(phfifooverflow),
				.avmmwrite(avmmwrite),
				.fifoselectoutchnldown(fifoselectoutchnldown),
				.dispcbyte(dispcbyte),
				.refclkb(refclkb),
				.phfifotxswing(phfifotxswing),
				.phfiforeset(phfiforeset),
				.txdataouttogen3(txdataouttogen3),
				.clkout(clkout),
				.datain(datain),
				.phfifowrenable(phfifowrenable),
				.txblkstartout(txblkstartout),
				.fifoselectoutchnlup(fifoselectoutchnlup),
				.xgmdataout(xgmdataout),
				.pipetxmargin(pipetxmargin),
				.txdivsyncinchnlup(txdivsyncinchnlup),
				.pipetxdeemph(pipetxdeemph),
				.parallelfdbkout(parallelfdbkout),
				.invpol(invpol),
				.rdenableoutchnldown(rdenableoutchnldown),
				.aggtxpcsrst(aggtxpcsrst),
				.fifoselectinchnldown(fifoselectinchnldown),
				.wrenableinchnlup(wrenableinchnlup),
				.wrenableinchnldown(wrenableinchnldown),
				.txpipeclk(txpipeclk),
				.observablebyteserdesclock(observablebyteserdesclock),
				.refclkbreset(refclkbreset),
				.revparallellpbkdata(revparallellpbkdata),
				.txdivsyncoutchnlup(txdivsyncoutchnlup),
				.polinvrxin(polinvrxin),
				.dynclkswitchn(dynclkswitchn),
				.txblkstart(txblkstart),
				.avmmclk(avmmclk),
				.txpcsreset(txpcsreset),
				.txdatavalid(txdatavalid),
				.phfifotxmargin(phfifotxmargin),
				.avmmrstn(avmmrstn),
				.wrenableoutchnlup(wrenableoutchnlup),
				.avmmbyteen(avmmbyteen),
				.resetpcptrs(resetpcptrs),
				.phfifotxdeemph(phfifotxdeemph),
				.txdivsyncoutchnldown(txdivsyncoutchnldown),
				.refclkdig(refclkdig),
				.xgmctrltoporbottom(xgmctrltoporbottom),
				.wrenableoutchnldown(wrenableoutchnldown),
				.avmmreaddata(avmmreaddata),
				.hrdrst(hrdrst),
				.fifoselectinchnlup(fifoselectinchnlup),
				.txsynchdr(txsynchdr),
				.phfifounderflow(phfifounderflow),
				.elecidleinfersel(elecidleinfersel),
				.txtestbus(txtestbus),
				.detectrxloopout(detectrxloopout),
				.pipepowerdownout(pipepowerdownout),
				.txsynchdrout(txsynchdrout),
				.coreclk(coreclk),
				.avmmaddress(avmmaddress),
				.rateswitch(rateswitch),
				.rdenableinchnldown(rdenableinchnldown),
				.resetpcptrsinchnlup(resetpcptrsinchnlup),
				.enrevparallellpbk(enrevparallellpbk),
				.grayelecidleinferselout(grayelecidleinferselout),
				.rxpolarityout(rxpolarityout),
				.rdenableoutchnlup(rdenableoutchnlup),
				.txpipeelectidle(txpipeelectidle),
				.pipetxswing(pipetxswing),
				.txdivsyncinchnldown(txdivsyncinchnldown),
				.pipeenrevparallellpbkin(pipeenrevparallellpbkin),
				.bitslipboundaryselect(bitslipboundaryselect),
				.scanmode(scanmode),
				.txctrlplanetestbus(txctrlplanetestbus),
				.xgmctrl(xgmctrl),
				.syncdatain(syncdatain),
				.avmmread(avmmread),
				.txpmalocalclk(txpmalocalclk),
				.dataout(dataout),
				.prbscidenable(prbscidenable),
				.clkselgen3(clkselgen3),
				.rxpolarityin(rxpolarityin),
				.rdenableinchnlup(rdenableinchnlup),
				.txelecidleout(txelecidleout),
				.blockselect(blockselect),
				.xgmctrlenable(xgmctrlenable),
				.txdatakouttogen3(txdatakouttogen3),
				.xgmdatain(xgmdatain),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_common_pcs_pma_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_common_pcs_pma_interface
#(
	parameter ppm_deassert_early = "deassert_early_dis",      // Valid values: deassert_early_dis|deassert_early_en
	parameter auto_speed_ena = "dis_auto_speed_ena",      // Valid values: dis_auto_speed_ena|en_auto_speed_ena
	parameter pcie_gen3_cap = "non_pcie_gen3_cap",      // Valid values: pcie_gen3_cap|non_pcie_gen3_cap
	parameter pipe_if_g3pcs = "pipe_if_8gpcs",      // Valid values: pipe_if_g3pcs|pipe_if_8gpcs
	parameter ppmsel = "ppmsel_default",      // Valid values: ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
	parameter pma_if_dft_en = "dft_dis",      // Valid values: dft_dis
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode|stretch_mode
	parameter ppm_cnt_rst = "ppm_cnt_rst_dis",      // Valid values: ppm_cnt_rst_dis|ppm_cnt_rst_en
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter refclk_dig_sel = "refclk_dig_dis",      // Valid values: refclk_dig_dis|refclk_dig_en
	parameter selectpcs = "eight_g_pcs",      // Valid values: eight_g_pcs|pcie_gen3
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter force_freqdet = "force_freqdet_dis",      // Valid values: force_freqdet_dis|force1_freqdet_en|force0_freqdet_en
	parameter ppm_gen1_2_cnt = "cnt_32k",      // Valid values: cnt_32k|cnt_64k
	parameter prot_mode = "disabled_prot_mode",      // Valid values: disabled_prot_mode|pipe_g1|pipe_g2|pipe_g3|other_protocols
	parameter ppm_post_eidle_delay = "cnt_200_cycles",      // Valid values: cnt_200_cycles|cnt_400_cycles
	parameter pma_if_dft_val = "dft_0",      // Valid values: dft_0
	parameter func_mode = "disable",      // Valid values: disable|pma_direct|hrdrstctrl_cmu|eightg_only_pld|eightg_and_g3|eightg_only_emsip|teng_only|eightgtx_and_tengrx|eightgrx_and_tengtx
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 1:0 ] aggaligndetsync,
	input  [ 0:0 ] aggalignstatus,
	output [ 0:0 ] aggalignstatussync,
	input  [ 0:0 ] aggalignstatussync0,
	input  [ 0:0 ] aggalignstatussync0toporbot,
	input  [ 0:0 ] aggalignstatustoporbot,
	input  [ 0:0 ] aggcgcomprddall,
	input  [ 0:0 ] aggcgcomprddalltoporbot,
	output [ 1:0 ] aggcgcomprddout,
	input  [ 0:0 ] aggcgcompwrall,
	input  [ 0:0 ] aggcgcompwralltoporbot,
	output [ 1:0 ] aggcgcompwrout,
	output [ 0:0 ] aggdecctl,
	output [ 7:0 ] aggdecdata,
	output [ 0:0 ] aggdecdatavalid,
	input  [ 0:0 ] aggdelcondmet0,
	input  [ 0:0 ] aggdelcondmet0toporbot,
	output [ 0:0 ] aggdelcondmetout,
	input  [ 0:0 ] aggendskwqd,
	input  [ 0:0 ] aggendskwqdtoporbot,
	input  [ 0:0 ] aggendskwrdptrs,
	input  [ 0:0 ] aggendskwrdptrstoporbot,
	input  [ 0:0 ] aggfifoovr0,
	input  [ 0:0 ] aggfifoovr0toporbot,
	output [ 0:0 ] aggfifoovrout,
	input  [ 0:0 ] aggfifordincomp0,
	input  [ 0:0 ] aggfifordincomp0toporbot,
	output [ 0:0 ] aggfifordoutcomp,
	input  [ 0:0 ] aggfiforstrdqd,
	input  [ 0:0 ] aggfiforstrdqdtoporbot,
	input  [ 0:0 ] agginsertincomplete0,
	input  [ 0:0 ] agginsertincomplete0toporbot,
	output [ 0:0 ] agginsertincompleteout,
	input  [ 0:0 ] agglatencycomp0,
	input  [ 0:0 ] agglatencycomp0toporbot,
	output [ 0:0 ] agglatencycompout,
	input  [ 0:0 ] aggrcvdclkagg,
	input  [ 0:0 ] aggrcvdclkaggtoporbot,
	output [ 1:0 ] aggrdalign,
	output [ 0:0 ] aggrdenablesync,
	output [ 0:0 ] aggrefclkdig,
	output [ 1:0 ] aggrunningdisp,
	input  [ 0:0 ] aggrxcontrolrs,
	input  [ 0:0 ] aggrxcontrolrstoporbot,
	input  [ 7:0 ] aggrxdatars,
	input  [ 7:0 ] aggrxdatarstoporbot,
	output [ 0:0 ] aggrxpcsrst,
	output [ 0:0 ] aggscanmoden,
	output [ 0:0 ] aggscanshiftn,
	output [ 0:0 ] aggsyncstatus,
	input  [ 15:0 ] aggtestbus,
	input  [ 0:0 ] aggtestsotopldin,
	output [ 0:0 ] aggtestsotopldout,
	output [ 0:0 ] aggtxctltc,
	input  [ 0:0 ] aggtxctlts,
	input  [ 0:0 ] aggtxctltstoporbot,
	output [ 7:0 ] aggtxdatatc,
	input  [ 7:0 ] aggtxdatats,
	input  [ 7:0 ] aggtxdatatstoporbot,
	output [ 0:0 ] aggtxpcsrst,
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clklow,
	input  [ 0:0 ] fref,
	output [ 0:0 ] freqlock,
	input  [ 0:0 ] hardreset,
	input  [ 0:0 ] pcs8gearlyeios,
	input  [ 0:0 ] pcs8geidleexit,
	output [ 0:0 ] pcs8ggen2ngen1,
	input  [ 0:0 ] pcs8gltrpma,
	input  [ 0:0 ] pcs8gpcieswitch,
	input  [ 17:0 ] pcs8gpmacurrentcoeff,
	output [ 0:0 ] pcs8gpmarxfound,
	output [ 0:0 ] pcs8gpowerstatetransitiondone,
	output [ 0:0 ] pcs8grxdetectvalid,
	input  [ 0:0 ] pcs8gtxdetectrx,
	input  [ 0:0 ] pcs8gtxelecidle,
	input  [ 1:0 ] pcsaggaligndetsync,
	output [ 0:0 ] pcsaggalignstatus,
	input  [ 0:0 ] pcsaggalignstatussync,
	output [ 0:0 ] pcsaggalignstatussync0,
	output [ 0:0 ] pcsaggalignstatussync0toporbot,
	output [ 0:0 ] pcsaggalignstatustoporbot,
	output [ 0:0 ] pcsaggcgcomprddall,
	output [ 0:0 ] pcsaggcgcomprddalltoporbot,
	input  [ 1:0 ] pcsaggcgcomprddout,
	output [ 0:0 ] pcsaggcgcompwrall,
	output [ 0:0 ] pcsaggcgcompwralltoporbot,
	input  [ 1:0 ] pcsaggcgcompwrout,
	input  [ 0:0 ] pcsaggdecctl,
	input  [ 7:0 ] pcsaggdecdata,
	input  [ 0:0 ] pcsaggdecdatavalid,
	output [ 0:0 ] pcsaggdelcondmet0,
	output [ 0:0 ] pcsaggdelcondmet0toporbot,
	input  [ 0:0 ] pcsaggdelcondmetout,
	output [ 0:0 ] pcsaggendskwqd,
	output [ 0:0 ] pcsaggendskwqdtoporbot,
	output [ 0:0 ] pcsaggendskwrdptrs,
	output [ 0:0 ] pcsaggendskwrdptrstoporbot,
	output [ 0:0 ] pcsaggfifoovr0,
	output [ 0:0 ] pcsaggfifoovr0toporbot,
	input  [ 0:0 ] pcsaggfifoovrout,
	output [ 0:0 ] pcsaggfifordincomp0,
	output [ 0:0 ] pcsaggfifordincomp0toporbot,
	input  [ 0:0 ] pcsaggfifordoutcomp,
	output [ 0:0 ] pcsaggfiforstrdqd,
	output [ 0:0 ] pcsaggfiforstrdqdtoporbot,
	output [ 0:0 ] pcsagginsertincomplete0,
	output [ 0:0 ] pcsagginsertincomplete0toporbot,
	input  [ 0:0 ] pcsagginsertincompleteout,
	output [ 0:0 ] pcsagglatencycomp0,
	output [ 0:0 ] pcsagglatencycomp0toporbot,
	input  [ 0:0 ] pcsagglatencycompout,
	output [ 0:0 ] pcsaggrcvdclkagg,
	output [ 0:0 ] pcsaggrcvdclkaggtoporbot,
	input  [ 1:0 ] pcsaggrdalign,
	input  [ 0:0 ] pcsaggrdenablesync,
	input  [ 0:0 ] pcsaggrefclkdig,
	input  [ 1:0 ] pcsaggrunningdisp,
	output [ 0:0 ] pcsaggrxcontrolrs,
	output [ 0:0 ] pcsaggrxcontrolrstoporbot,
	output [ 7:0 ] pcsaggrxdatars,
	output [ 7:0 ] pcsaggrxdatarstoporbot,
	input  [ 0:0 ] pcsaggrxpcsrst,
	input  [ 0:0 ] pcsaggscanmoden,
	input  [ 0:0 ] pcsaggscanshiftn,
	input  [ 0:0 ] pcsaggsyncstatus,
	output [ 15:0 ] pcsaggtestbus,
	input  [ 0:0 ] pcsaggtxctltc,
	output [ 0:0 ] pcsaggtxctlts,
	output [ 0:0 ] pcsaggtxctltstoporbot,
	input  [ 7:0 ] pcsaggtxdatatc,
	output [ 7:0 ] pcsaggtxdatats,
	output [ 7:0 ] pcsaggtxdatatstoporbot,
	input  [ 0:0 ] pcsaggtxpcsrst,
	input  [ 0:0 ] pcsgen3gen3datasel,
	output [ 0:0 ] pcsgen3pllfixedclk,
	input  [ 17:0 ] pcsgen3pmacurrentcoeff,
	input  [ 2:0 ] pcsgen3pmacurrentrxpreset,
	input  [ 0:0 ] pcsgen3pmaearlyeios,
	input  [ 0:0 ] pcsgen3pmaltr,
	output [ 1:0 ] pcsgen3pmapcieswdone,
	input  [ 1:0 ] pcsgen3pmapcieswitch,
	output [ 0:0 ] pcsgen3pmarxdetectvalid,
	output [ 0:0 ] pcsgen3pmarxfound,
	input  [ 0:0 ] pcsgen3pmatxdetectrx,
	input  [ 0:0 ] pcsgen3pmatxelecidle,
	input  [ 0:0 ] pcsgen3ppmeidleexit,
	input  [ 0:0 ] pcsrefclkdig,
	input  [ 0:0 ] pcsscanmoden,
	input  [ 0:0 ] pcsscanshiftn,
	output [ 0:0 ] pldhclkout,
	input  [ 0:0 ] pldlccmurstb,
	input  [ 0:0 ] pldnfrzdrv,
	input  [ 0:0 ] pldpartialreconfig,
	input  [ 0:0 ] pldtestsitoaggin,
	output [ 0:0 ] pldtestsitoaggout,
	output [ 0:0 ] pmaclklowout,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 2:0 ] pmacurrentrxpreset,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmafrefout,
	input  [ 0:0 ] pmahclk,
	output [ 9:0 ] pmaiftestbus,
	output [ 0:0 ] pmalccmurstb,
	output [ 0:0 ] pmaltr,
	output [ 0:0 ] pmanfrzdrv,
	output [ 0:0 ] pmaoffcaldone,
	input  [ 0:0 ] pmaoffcalenin,
	output [ 0:0 ] pmapartialreconfig,
	input  [ 1:0 ] pmapcieswdone,
	output [ 1:0 ] pmapcieswitch,
	input  [ 0:0 ] pmarxdetectvalid,
	input  [ 0:0 ] pmarxfound,
	input  [ 0:0 ] pmarxpmarstb,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] pmatxelecidle,
	input  [ 0:0 ] resetppmcntrs
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_common_pcs_pma_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_common_pcs_pma_interface_encrypted_ES #(
				.ppm_deassert_early(ppm_deassert_early),
				.auto_speed_ena(auto_speed_ena),
				.pcie_gen3_cap(pcie_gen3_cap),
				.pipe_if_g3pcs(pipe_if_g3pcs),
				.ppmsel(ppmsel),
				.pma_if_dft_en(pma_if_dft_en),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.ppm_cnt_rst(ppm_cnt_rst),
				.user_base_address(user_base_address),
				.refclk_dig_sel(refclk_dig_sel),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.force_freqdet(force_freqdet),
				.ppm_gen1_2_cnt(ppm_gen1_2_cnt),
				.prot_mode(prot_mode),
				.ppm_post_eidle_delay(ppm_post_eidle_delay),
				.pma_if_dft_val(pma_if_dft_val),
				.func_mode(func_mode)
			) stratixv_hssi_common_pcs_pma_interface_encrypted_ES_inst (
				.agginsertincomplete0toporbot(agginsertincomplete0toporbot),
				.pcsaggtestbus(pcsaggtestbus),
				.pcsaggdecdatavalid(pcsaggdecdatavalid),
				.pcsgen3pmacurrentrxpreset(pcsgen3pmacurrentrxpreset),
				.pmatxelecidle(pmatxelecidle),
				.pcsaggfifoovrout(pcsaggfifoovrout),
				.pcsaggrxdatarstoporbot(pcsaggrxdatarstoporbot),
				.agginsertincomplete0(agginsertincomplete0),
				.pcsaggendskwrdptrs(pcsaggendskwrdptrs),
				.pcsrefclkdig(pcsrefclkdig),
				.pmafrefout(pmafrefout),
				.pldnfrzdrv(pldnfrzdrv),
				.pcsgen3pmaearlyeios(pcsgen3pmaearlyeios),
				.pcsaggalignstatustoporbot(pcsaggalignstatustoporbot),
				.aggdelcondmet0(aggdelcondmet0),
				.pcsagglatencycomp0toporbot(pcsagglatencycomp0toporbot),
				.avmmwrite(avmmwrite),
				.pcsaggdecctl(pcsaggdecctl),
				.pmaearlyeios(pmaearlyeios),
				.aggscanmoden(aggscanmoden),
				.aggrdenablesync(aggrdenablesync),
				.aggfifoovr0toporbot(aggfifoovr0toporbot),
				.aggrdalign(aggrdalign),
				.fref(fref),
				.pldlccmurstb(pldlccmurstb),
				.pcsaggaligndetsync(pcsaggaligndetsync),
				.pcsgen3pmarxdetectvalid(pcsgen3pmarxdetectvalid),
				.pcsaggtxdatatc(pcsaggtxdatatc),
				.pmalccmurstb(pmalccmurstb),
				.pcsaggalignstatus(pcsaggalignstatus),
				.aggrunningdisp(aggrunningdisp),
				.aggfifoovrout(aggfifoovrout),
				.pcsaggcgcomprddall(pcsaggcgcomprddall),
				.pldtestsitoaggout(pldtestsitoaggout),
				.aggdecdatavalid(aggdecdatavalid),
				.aggalignstatussync0(aggalignstatussync0),
				.pcsaggfifordincomp0(pcsaggfifordincomp0),
				.hardreset(hardreset),
				.pcsgen3pmatxelecidle(pcsgen3pmatxelecidle),
				.pcsaggdelcondmetout(pcsaggdelcondmetout),
				.pcsaggfifoovr0toporbot(pcsaggfifoovr0toporbot),
				.aggdecctl(aggdecctl),
				.agglatencycomp0toporbot(agglatencycomp0toporbot),
				.pcs8gpowerstatetransitiondone(pcs8gpowerstatetransitiondone),
				.pcsaggcgcompwrall(pcsaggcgcompwrall),
				.pcsgen3gen3datasel(pcsgen3gen3datasel),
				.pmaiftestbus(pmaiftestbus),
				.aggtxctltstoporbot(aggtxctltstoporbot),
				.aggtestsotopldin(aggtestsotopldin),
				.pcsaggrcvdclkaggtoporbot(pcsaggrcvdclkaggtoporbot),
				.pcsaggdelcondmet0(pcsaggdelcondmet0),
				.aggtxctltc(aggtxctltc),
				.aggdecdata(aggdecdata),
				.asynchdatain(asynchdatain),
				.aggcgcompwrout(aggcgcompwrout),
				.pmaoffcalenin(pmaoffcalenin),
				.aggendskwrdptrs(aggendskwrdptrs),
				.avmmrstn(avmmrstn),
				.pcsaggrxcontrolrs(pcsaggrxcontrolrs),
				.avmmbyteen(avmmbyteen),
				.pcsagginsertincompleteout(pcsagginsertincompleteout),
				.pcsaggrcvdclkagg(pcsaggrcvdclkagg),
				.aggsyncstatus(aggsyncstatus),
				.aggtestbus(aggtestbus),
				.aggendskwqdtoporbot(aggendskwqdtoporbot),
				.aggrxdatarstoporbot(aggrxdatarstoporbot),
				.avmmreaddata(avmmreaddata),
				.aggtxdatats(aggtxdatats),
				.pcsgen3pmapcieswdone(pcsgen3pmapcieswdone),
				.pldtestsitoaggin(pldtestsitoaggin),
				.aggrcvdclkagg(aggrcvdclkagg),
				.pcsaggendskwqd(pcsaggendskwqd),
				.avmmaddress(avmmaddress),
				.pmaclklowout(pmaclklowout),
				.aggalignstatus(aggalignstatus),
				.aggcgcomprddalltoporbot(aggcgcomprddalltoporbot),
				.clklow(clklow),
				.pmahclk(pmahclk),
				.pmarxfound(pmarxfound),
				.pmaltr(pmaltr),
				.pcsaggtxdatatstoporbot(pcsaggtxdatatstoporbot),
				.avmmread(avmmread),
				.pcsaggcgcompwrout(pcsaggcgcompwrout),
				.aggdelcondmetout(aggdelcondmetout),
				.pcsagginsertincomplete0(pcsagginsertincomplete0),
				.pcsgen3pmaltr(pcsgen3pmaltr),
				.pmanfrzdrv(pmanfrzdrv),
				.resetppmcntrs(resetppmcntrs),
				.aggendskwrdptrstoporbot(aggendskwrdptrstoporbot),
				.pmacurrentcoeff(pmacurrentcoeff),
				.pcs8ggen2ngen1(pcs8ggen2ngen1),
				.pcsscanshiftn(pcsscanshiftn),
				.pcs8gtxdetectrx(pcs8gtxdetectrx),
				.pcsaggrdalign(pcsaggrdalign),
				.pldhclkout(pldhclkout),
				.aggrcvdclkaggtoporbot(aggrcvdclkaggtoporbot),
				.pcsaggscanmoden(pcsaggscanmoden),
				.pcs8gpcieswitch(pcs8gpcieswitch),
				.aggfifordincomp0(aggfifordincomp0),
				.aggrxcontrolrstoporbot(aggrxcontrolrstoporbot),
				.aggrxpcsrst(aggrxpcsrst),
				.pcsaggdelcondmet0toporbot(pcsaggdelcondmet0toporbot),
				.pcsaggtxctltc(pcsaggtxctltc),
				.aggrxcontrolrs(aggrxcontrolrs),
				.pcsaggendskwrdptrstoporbot(pcsaggendskwrdptrstoporbot),
				.pmarxdetectvalid(pmarxdetectvalid),
				.pcsagginsertincomplete0toporbot(pcsagginsertincomplete0toporbot),
				.pcs8grxdetectvalid(pcs8grxdetectvalid),
				.aggtxctlts(aggtxctlts),
				.aggtxdatatstoporbot(aggtxdatatstoporbot),
				.pcsaggtxdatats(pcsaggtxdatats),
				.pcsgen3ppmeidleexit(pcsgen3ppmeidleexit),
				.pcsgen3pllfixedclk(pcsgen3pllfixedclk),
				.pcsagglatencycomp0(pcsagglatencycomp0),
				.pcsaggscanshiftn(pcsaggscanshiftn),
				.pcsaggrxcontrolrstoporbot(pcsaggrxcontrolrstoporbot),
				.aggfiforstrdqd(aggfiforstrdqd),
				.aggcgcomprddall(aggcgcomprddall),
				.pcsaggfifoovr0(pcsaggfifoovr0),
				.aggcgcompwrall(aggcgcompwrall),
				.pcsagglatencycompout(pcsagglatencycompout),
				.pcsaggrefclkdig(pcsaggrefclkdig),
				.aggfifoovr0(aggfifoovr0),
				.pcsaggcgcomprddout(pcsaggcgcomprddout),
				.pcsaggfiforstrdqdtoporbot(pcsaggfiforstrdqdtoporbot),
				.aggtxpcsrst(aggtxpcsrst),
				.pcs8geidleexit(pcs8geidleexit),
				.pcsaggtxctltstoporbot(pcsaggtxctltstoporbot),
				.pcsaggfiforstrdqd(pcsaggfiforstrdqd),
				.aggrefclkdig(aggrefclkdig),
				.agglatencycomp0(agglatencycomp0),
				.pcsaggrxpcsrst(pcsaggrxpcsrst),
				.aggtestsotopldout(aggtestsotopldout),
				.agginsertincompleteout(agginsertincompleteout),
				.pcsgen3pmatxdetectrx(pcsgen3pmatxdetectrx),
				.agglatencycompout(agglatencycompout),
				.aggalignstatussync(aggalignstatussync),
				.pcs8gtxelecidle(pcs8gtxelecidle),
				.aggcgcomprddout(aggcgcomprddout),
				.pcsaggalignstatussync0(pcsaggalignstatussync0),
				.avmmclk(avmmclk),
				.pcsaggtxctlts(pcsaggtxctlts),
				.pcsaggrunningdisp(pcsaggrunningdisp),
				.pcsaggalignstatussync0toporbot(pcsaggalignstatussync0toporbot),
				.pcsaggtxpcsrst(pcsaggtxpcsrst),
				.pcsaggdecdata(pcsaggdecdata),
				.pcsaggcgcomprddalltoporbot(pcsaggcgcomprddalltoporbot),
				.pcsaggrdenablesync(pcsaggrdenablesync),
				.pmarxpmarstb(pmarxpmarstb),
				.pcsaggfifordincomp0toporbot(pcsaggfifordincomp0toporbot),
				.pcsaggfifordoutcomp(pcsaggfifordoutcomp),
				.aggfifordoutcomp(aggfifordoutcomp),
				.aggalignstatussync0toporbot(aggalignstatussync0toporbot),
				.aggendskwqd(aggendskwqd),
				.aggalignstatustoporbot(aggalignstatustoporbot),
				.pcsgen3pmapcieswitch(pcsgen3pmapcieswitch),
				.pmapcieswdone(pmapcieswdone),
				.pmatxdetectrx(pmatxdetectrx),
				.aggdelcondmet0toporbot(aggdelcondmet0toporbot),
				.pcs8gltrpma(pcs8gltrpma),
				.pmapartialreconfig(pmapartialreconfig),
				.pcsaggrxdatars(pcsaggrxdatars),
				.aggrxdatars(aggrxdatars),
				.pcsaggendskwqdtoporbot(pcsaggendskwqdtoporbot),
				.pcsgen3pmarxfound(pcsgen3pmarxfound),
				.pcsscanmoden(pcsscanmoden),
				.pcsgen3pmacurrentcoeff(pcsgen3pmacurrentcoeff),
				.aggfiforstrdqdtoporbot(aggfiforstrdqdtoporbot),
				.aggfifordincomp0toporbot(aggfifordincomp0toporbot),
				.pmaoffcaldone(pmaoffcaldone),
				.aggtxdatatc(aggtxdatatc),
				.pcsaggalignstatussync(pcsaggalignstatussync),
				.blockselect(blockselect),
				.freqlock(freqlock),
				.pcsaggcgcompwralltoporbot(pcsaggcgcompwralltoporbot),
				.aggaligndetsync(aggaligndetsync),
				.pcs8gearlyeios(pcs8gearlyeios),
				.pmacurrentrxpreset(pmacurrentrxpreset),
				.pcs8gpmacurrentcoeff(pcs8gpmacurrentcoeff),
				.aggcgcompwralltoporbot(aggcgcompwralltoporbot),
				.pcs8gpmarxfound(pcs8gpmarxfound),
				.pldpartialreconfig(pldpartialreconfig),
				.pcsaggsyncstatus(pcsaggsyncstatus),
				.pmapcieswitch(pmapcieswitch),
				.aggscanshiftn(aggscanshiftn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_common_pcs_pma_interface_encrypted #(
				.ppm_deassert_early(ppm_deassert_early),
				.auto_speed_ena(auto_speed_ena),
				.pcie_gen3_cap(pcie_gen3_cap),
				.pipe_if_g3pcs(pipe_if_g3pcs),
				.ppmsel(ppmsel),
				.pma_if_dft_en(pma_if_dft_en),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.ppm_cnt_rst(ppm_cnt_rst),
				.user_base_address(user_base_address),
				.refclk_dig_sel(refclk_dig_sel),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.force_freqdet(force_freqdet),
				.ppm_gen1_2_cnt(ppm_gen1_2_cnt),
				.prot_mode(prot_mode),
				.ppm_post_eidle_delay(ppm_post_eidle_delay),
				.pma_if_dft_val(pma_if_dft_val),
				.func_mode(func_mode)
			) stratixv_hssi_common_pcs_pma_interface_encrypted_inst (
				.agginsertincomplete0toporbot(agginsertincomplete0toporbot),
				.pcsaggtestbus(pcsaggtestbus),
				.pcsaggdecdatavalid(pcsaggdecdatavalid),
				.pcsgen3pmacurrentrxpreset(pcsgen3pmacurrentrxpreset),
				.pmatxelecidle(pmatxelecidle),
				.pcsaggfifoovrout(pcsaggfifoovrout),
				.pcsaggrxdatarstoporbot(pcsaggrxdatarstoporbot),
				.agginsertincomplete0(agginsertincomplete0),
				.pcsaggendskwrdptrs(pcsaggendskwrdptrs),
				.pcsrefclkdig(pcsrefclkdig),
				.pmafrefout(pmafrefout),
				.pldnfrzdrv(pldnfrzdrv),
				.pcsgen3pmaearlyeios(pcsgen3pmaearlyeios),
				.pcsaggalignstatustoporbot(pcsaggalignstatustoporbot),
				.aggdelcondmet0(aggdelcondmet0),
				.pcsagglatencycomp0toporbot(pcsagglatencycomp0toporbot),
				.avmmwrite(avmmwrite),
				.pcsaggdecctl(pcsaggdecctl),
				.pmaearlyeios(pmaearlyeios),
				.aggscanmoden(aggscanmoden),
				.aggrdenablesync(aggrdenablesync),
				.aggfifoovr0toporbot(aggfifoovr0toporbot),
				.aggrdalign(aggrdalign),
				.fref(fref),
				.pldlccmurstb(pldlccmurstb),
				.pcsaggaligndetsync(pcsaggaligndetsync),
				.pcsgen3pmarxdetectvalid(pcsgen3pmarxdetectvalid),
				.pcsaggtxdatatc(pcsaggtxdatatc),
				.pmalccmurstb(pmalccmurstb),
				.pcsaggalignstatus(pcsaggalignstatus),
				.aggrunningdisp(aggrunningdisp),
				.aggfifoovrout(aggfifoovrout),
				.pcsaggcgcomprddall(pcsaggcgcomprddall),
				.pldtestsitoaggout(pldtestsitoaggout),
				.aggdecdatavalid(aggdecdatavalid),
				.aggalignstatussync0(aggalignstatussync0),
				.pcsaggfifordincomp0(pcsaggfifordincomp0),
				.hardreset(hardreset),
				.pcsgen3pmatxelecidle(pcsgen3pmatxelecidle),
				.pcsaggdelcondmetout(pcsaggdelcondmetout),
				.pcsaggfifoovr0toporbot(pcsaggfifoovr0toporbot),
				.aggdecctl(aggdecctl),
				.agglatencycomp0toporbot(agglatencycomp0toporbot),
				.pcs8gpowerstatetransitiondone(pcs8gpowerstatetransitiondone),
				.pcsaggcgcompwrall(pcsaggcgcompwrall),
				.pcsgen3gen3datasel(pcsgen3gen3datasel),
				.pmaiftestbus(pmaiftestbus),
				.aggtxctltstoporbot(aggtxctltstoporbot),
				.aggtestsotopldin(aggtestsotopldin),
				.pcsaggrcvdclkaggtoporbot(pcsaggrcvdclkaggtoporbot),
				.pcsaggdelcondmet0(pcsaggdelcondmet0),
				.aggtxctltc(aggtxctltc),
				.aggdecdata(aggdecdata),
				.asynchdatain(asynchdatain),
				.aggcgcompwrout(aggcgcompwrout),
				.pmaoffcalenin(pmaoffcalenin),
				.aggendskwrdptrs(aggendskwrdptrs),
				.avmmrstn(avmmrstn),
				.pcsaggrxcontrolrs(pcsaggrxcontrolrs),
				.avmmbyteen(avmmbyteen),
				.pcsagginsertincompleteout(pcsagginsertincompleteout),
				.pcsaggrcvdclkagg(pcsaggrcvdclkagg),
				.aggsyncstatus(aggsyncstatus),
				.aggtestbus(aggtestbus),
				.aggendskwqdtoporbot(aggendskwqdtoporbot),
				.aggrxdatarstoporbot(aggrxdatarstoporbot),
				.avmmreaddata(avmmreaddata),
				.aggtxdatats(aggtxdatats),
				.pcsgen3pmapcieswdone(pcsgen3pmapcieswdone),
				.pldtestsitoaggin(pldtestsitoaggin),
				.aggrcvdclkagg(aggrcvdclkagg),
				.pcsaggendskwqd(pcsaggendskwqd),
				.avmmaddress(avmmaddress),
				.pmaclklowout(pmaclklowout),
				.aggalignstatus(aggalignstatus),
				.aggcgcomprddalltoporbot(aggcgcomprddalltoporbot),
				.clklow(clklow),
				.pmahclk(pmahclk),
				.pmarxfound(pmarxfound),
				.pmaltr(pmaltr),
				.pcsaggtxdatatstoporbot(pcsaggtxdatatstoporbot),
				.avmmread(avmmread),
				.pcsaggcgcompwrout(pcsaggcgcompwrout),
				.aggdelcondmetout(aggdelcondmetout),
				.pcsagginsertincomplete0(pcsagginsertincomplete0),
				.pcsgen3pmaltr(pcsgen3pmaltr),
				.pmanfrzdrv(pmanfrzdrv),
				.resetppmcntrs(resetppmcntrs),
				.aggendskwrdptrstoporbot(aggendskwrdptrstoporbot),
				.pmacurrentcoeff(pmacurrentcoeff),
				.pcs8ggen2ngen1(pcs8ggen2ngen1),
				.pcsscanshiftn(pcsscanshiftn),
				.pcs8gtxdetectrx(pcs8gtxdetectrx),
				.pcsaggrdalign(pcsaggrdalign),
				.pldhclkout(pldhclkout),
				.aggrcvdclkaggtoporbot(aggrcvdclkaggtoporbot),
				.pcsaggscanmoden(pcsaggscanmoden),
				.pcs8gpcieswitch(pcs8gpcieswitch),
				.aggfifordincomp0(aggfifordincomp0),
				.aggrxcontrolrstoporbot(aggrxcontrolrstoporbot),
				.aggrxpcsrst(aggrxpcsrst),
				.pcsaggdelcondmet0toporbot(pcsaggdelcondmet0toporbot),
				.pcsaggtxctltc(pcsaggtxctltc),
				.aggrxcontrolrs(aggrxcontrolrs),
				.pcsaggendskwrdptrstoporbot(pcsaggendskwrdptrstoporbot),
				.pmarxdetectvalid(pmarxdetectvalid),
				.pcsagginsertincomplete0toporbot(pcsagginsertincomplete0toporbot),
				.pcs8grxdetectvalid(pcs8grxdetectvalid),
				.aggtxctlts(aggtxctlts),
				.aggtxdatatstoporbot(aggtxdatatstoporbot),
				.pcsaggtxdatats(pcsaggtxdatats),
				.pcsgen3ppmeidleexit(pcsgen3ppmeidleexit),
				.pcsgen3pllfixedclk(pcsgen3pllfixedclk),
				.pcsagglatencycomp0(pcsagglatencycomp0),
				.pcsaggscanshiftn(pcsaggscanshiftn),
				.pcsaggrxcontrolrstoporbot(pcsaggrxcontrolrstoporbot),
				.aggfiforstrdqd(aggfiforstrdqd),
				.aggcgcomprddall(aggcgcomprddall),
				.pcsaggfifoovr0(pcsaggfifoovr0),
				.aggcgcompwrall(aggcgcompwrall),
				.pcsagglatencycompout(pcsagglatencycompout),
				.pcsaggrefclkdig(pcsaggrefclkdig),
				.aggfifoovr0(aggfifoovr0),
				.pcsaggcgcomprddout(pcsaggcgcomprddout),
				.pcsaggfiforstrdqdtoporbot(pcsaggfiforstrdqdtoporbot),
				.aggtxpcsrst(aggtxpcsrst),
				.pcs8geidleexit(pcs8geidleexit),
				.pcsaggtxctltstoporbot(pcsaggtxctltstoporbot),
				.pcsaggfiforstrdqd(pcsaggfiforstrdqd),
				.aggrefclkdig(aggrefclkdig),
				.agglatencycomp0(agglatencycomp0),
				.pcsaggrxpcsrst(pcsaggrxpcsrst),
				.aggtestsotopldout(aggtestsotopldout),
				.agginsertincompleteout(agginsertincompleteout),
				.pcsgen3pmatxdetectrx(pcsgen3pmatxdetectrx),
				.agglatencycompout(agglatencycompout),
				.aggalignstatussync(aggalignstatussync),
				.pcs8gtxelecidle(pcs8gtxelecidle),
				.aggcgcomprddout(aggcgcomprddout),
				.pcsaggalignstatussync0(pcsaggalignstatussync0),
				.avmmclk(avmmclk),
				.pcsaggtxctlts(pcsaggtxctlts),
				.pcsaggrunningdisp(pcsaggrunningdisp),
				.pcsaggalignstatussync0toporbot(pcsaggalignstatussync0toporbot),
				.pcsaggtxpcsrst(pcsaggtxpcsrst),
				.pcsaggdecdata(pcsaggdecdata),
				.pcsaggcgcomprddalltoporbot(pcsaggcgcomprddalltoporbot),
				.pcsaggrdenablesync(pcsaggrdenablesync),
				.pmarxpmarstb(pmarxpmarstb),
				.pcsaggfifordincomp0toporbot(pcsaggfifordincomp0toporbot),
				.pcsaggfifordoutcomp(pcsaggfifordoutcomp),
				.aggfifordoutcomp(aggfifordoutcomp),
				.aggalignstatussync0toporbot(aggalignstatussync0toporbot),
				.aggendskwqd(aggendskwqd),
				.aggalignstatustoporbot(aggalignstatustoporbot),
				.pcsgen3pmapcieswitch(pcsgen3pmapcieswitch),
				.pmapcieswdone(pmapcieswdone),
				.pmatxdetectrx(pmatxdetectrx),
				.aggdelcondmet0toporbot(aggdelcondmet0toporbot),
				.pcs8gltrpma(pcs8gltrpma),
				.pmapartialreconfig(pmapartialreconfig),
				.pcsaggrxdatars(pcsaggrxdatars),
				.aggrxdatars(aggrxdatars),
				.pcsaggendskwqdtoporbot(pcsaggendskwqdtoporbot),
				.pcsgen3pmarxfound(pcsgen3pmarxfound),
				.pcsscanmoden(pcsscanmoden),
				.pcsgen3pmacurrentcoeff(pcsgen3pmacurrentcoeff),
				.aggfiforstrdqdtoporbot(aggfiforstrdqdtoporbot),
				.aggfifordincomp0toporbot(aggfifordincomp0toporbot),
				.pmaoffcaldone(pmaoffcaldone),
				.aggtxdatatc(aggtxdatatc),
				.pcsaggalignstatussync(pcsaggalignstatussync),
				.blockselect(blockselect),
				.freqlock(freqlock),
				.pcsaggcgcompwralltoporbot(pcsaggcgcompwralltoporbot),
				.aggaligndetsync(aggaligndetsync),
				.pcs8gearlyeios(pcs8gearlyeios),
				.pmacurrentrxpreset(pmacurrentrxpreset),
				.pcs8gpmacurrentcoeff(pcs8gpmacurrentcoeff),
				.aggcgcompwralltoporbot(aggcgcompwralltoporbot),
				.pcs8gpmarxfound(pcs8gpmarxfound),
				.pldpartialreconfig(pldpartialreconfig),
				.pcsaggsyncstatus(pcsaggsyncstatus),
				.pmapcieswitch(pmapcieswitch),
				.aggscanshiftn(aggscanshiftn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_common_pld_pcs_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_common_pld_pcs_interface
#(
	parameter pld_side_reserved_source9 = "pld_res9",      // Valid values: pld_res9|emsip_res9
	parameter usrmode_sel4rst = "usermode",      // Valid values: usermode|last_frz
	parameter pld_side_reserved_source0 = "pld_res0",      // Valid values: pld_res0|emsip_res0
	parameter pld_side_reserved_source5 = "pld_res5",      // Valid values: pld_res5|emsip_res5
	parameter pld_side_reserved_source2 = "pld_res2",      // Valid values: pld_res2|emsip_res2
	parameter pld_side_reserved_source3 = "pld_res3",      // Valid values: pld_res3|emsip_res3
	parameter data_source = "pld",      // Valid values: emsip|pld
	parameter testbus_sel = "eight_g_pcs",      // Valid values: eight_g_pcs|g3_pcs|ten_g_pcs|pma_if
	parameter hrdrstctrl_en_cfg = "hrst_dis_cfg",      // Valid values: hrst_dis_cfg|hrst_en_cfg
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter pld_side_reserved_source4 = "pld_res4",      // Valid values: pld_res4|emsip_res4
	parameter hrdrstctrl_en_cfgusr = "hrst_dis_cfgusr",      // Valid values: hrst_dis_cfgusr|hrst_en_cfgusr
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter pld_side_reserved_source10 = "pld_res10",      // Valid values: pld_res10|emsip_res10
	parameter pld_side_reserved_source6 = "pld_res6",      // Valid values: pld_res6|emsip_res6
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter pld_side_reserved_source1 = "pld_res1",      // Valid values: pld_res1|emsip_res1
	parameter pld_side_reserved_source8 = "pld_res8",      // Valid values: pld_res8|emsip_res8
	parameter pld_side_reserved_source11 = "pld_res11",      // Valid values: pld_res11|emsip_res11
	parameter pld_side_reserved_source7 = "pld_res7",      // Valid values: pld_res7|emsip_res7
	parameter emsip_enable = "emsip_disable",      // Valid values: emsip_enable|emsip_disable
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 2:0 ] emsipcomclkout,
	input  [ 37:0 ] emsipcomin,
	output [ 26:0 ] emsipcomout,
	input  [ 19:0 ] emsipcomspecialin,
	output [ 19:0 ] emsipcomspecialout,
	output [ 0:0 ] emsipenablediocsrrdydly,
	input  [ 0:0 ] entest,
	input  [ 0:0 ] frzreg,
	input  [ 0:0 ] iocsrrdydly,
	input  [ 0:0 ] nfrzdrv,
	input  [ 0:0 ] npor,
	output [ 3:0 ] pcs10gextrain,
	input  [ 3:0 ] pcs10gextraout,
	output [ 0:0 ] pcs10ghardreset,
	output [ 0:0 ] pcs10ghardresetn,
	output [ 0:0 ] pcs10grefclkdig,
	input  [ 19:0 ] pcs10gtestdata,
	output [ 8:0 ] pcs10gtestsi,
	input  [ 8:0 ] pcs10gtestso,
	input  [ 19:0 ] pcs8gchnltestbusout,
	output [ 2:0 ] pcs8geidleinfersel,
	output [ 0:0 ] pcs8ghardreset,
	output [ 0:0 ] pcs8ghardresetn,
	output [ 0:0 ] pcs8gltr,
	input  [ 0:0 ] pcs8gphystatus,
	output [ 3:0 ] pcs8gpldextrain,
	input  [ 2:0 ] pcs8gpldextraout,
	output [ 1:0 ] pcs8gpowerdown,
	output [ 0:0 ] pcs8gprbsciden,
	output [ 0:0 ] pcs8grate,
	output [ 0:0 ] pcs8grefclkdig,
	output [ 0:0 ] pcs8grefclkdig2,
	input  [ 0:0 ] pcs8grxelecidle,
	output [ 0:0 ] pcs8grxpolarity,
	input  [ 2:0 ] pcs8grxstatus,
	input  [ 0:0 ] pcs8grxvalid,
	output [ 0:0 ] pcs8gscanmoden,
	output [ 5:0 ] pcs8gtestsi,
	input  [ 5:0 ] pcs8gtestso,
	output [ 0:0 ] pcs8gtxdeemph,
	output [ 0:0 ] pcs8gtxdetectrxloopback,
	output [ 0:0 ] pcs8gtxelecidle,
	output [ 2:0 ] pcs8gtxmargin,
	output [ 0:0 ] pcs8gtxswing,
	output [ 0:0 ] pcsaggrefclkdig,
	output [ 0:0 ] pcsaggtestsi,
	input  [ 0:0 ] pcsaggtestso,
	output [ 17:0 ] pcsgen3currentcoeff,
	output [ 2:0 ] pcsgen3currentrxpreset,
	output [ 2:0 ] pcsgen3eidleinfersel,
	output [ 3:0 ] pcsgen3extrain,
	input  [ 3:0 ] pcsgen3extraout,
	output [ 0:0 ] pcsgen3hardreset,
	input  [ 0:0 ] pcsgen3masktxpll,
	output [ 0:0 ] pcsgen3pldltr,
	output [ 1:0 ] pcsgen3rate,
	input  [ 17:0 ] pcsgen3rxdeemph,
	input  [ 1:0 ] pcsgen3rxeqctrl,
	output [ 0:0 ] pcsgen3scanmoden,
	input  [ 19:0 ] pcsgen3testout,
	output [ 2:0 ] pcsgen3testsi,
	input  [ 2:0 ] pcsgen3testso,
	output [ 0:0 ] pcspcspmaifrefclkdig,
	output [ 0:0 ] pcspcspmaifscanmoden,
	output [ 0:0 ] pcspcspmaifscanshiftn,
	output [ 0:0 ] pcspmaifhardreset,
	input  [ 9:0 ] pcspmaiftestbusout,
	output [ 0:0 ] pcspmaiftestsi,
	input  [ 0:0 ] pcspmaiftestso,
	input  [ 0:0 ] pld10grefclkdig,
	output [ 0:0 ] pld8gphystatus,
	input  [ 1:0 ] pld8gpowerdown,
	input  [ 0:0 ] pld8gprbsciden,
	input  [ 0:0 ] pld8grefclkdig,
	input  [ 0:0 ] pld8grefclkdig2,
	output [ 0:0 ] pld8grxelecidle,
	input  [ 0:0 ] pld8grxpolarity,
	output [ 2:0 ] pld8grxstatus,
	output [ 0:0 ] pld8grxvalid,
	input  [ 0:0 ] pld8gtxdeemph,
	input  [ 0:0 ] pld8gtxdetectrxloopback,
	input  [ 0:0 ] pld8gtxelecidle,
	input  [ 2:0 ] pld8gtxmargin,
	input  [ 0:0 ] pld8gtxswing,
	input  [ 0:0 ] pldaggrefclkdig,
	output [ 0:0 ] pldclklow,
	input  [ 2:0 ] pldeidleinfersel,
	output [ 0:0 ] pldfref,
	input  [ 17:0 ] pldgen3currentcoeff,
	input  [ 2:0 ] pldgen3currentrxpreset,
	output [ 0:0 ] pldgen3masktxpll,
	output [ 17:0 ] pldgen3rxdeemph,
	output [ 1:0 ] pldgen3rxeqctrl,
	input  [ 0:0 ] pldhclkin,
	input  [ 0:0 ] pldltr,
	output [ 0:0 ] pldnfrzdrv,
	input  [ 0:0 ] pldoffcaldone,
	input  [ 0:0 ] pldoffcaldonein,
	output [ 0:0 ] pldoffcaldoneout,
	output [ 0:0 ] pldoffcalen,
	input  [ 0:0 ] pldpartialreconfigin,
	output [ 0:0 ] pldpartialreconfigout,
	input  [ 0:0 ] pldpcspmaifrefclkdig,
	input  [ 1:0 ] pldrate,
	input  [ 11:0 ] pldreservedin,
	output [ 10:0 ] pldreservedout,
	input  [ 0:0 ] pldscanmoden,
	input  [ 0:0 ] pldscanshiftn,
	output [ 19:0 ] pldtestdata,
	input  [ 0:0 ] plniotri,
	input  [ 0:0 ] pmaclklow,
	input  [ 0:0 ] pmafref,
	input  [ 0:0 ] pmaoffcalen,
	output [ 0:0 ] rstsel,
	input  [ 0:0 ] usermode,
	output [ 0:0 ] usrrstsel
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_common_pld_pcs_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_common_pld_pcs_interface_encrypted_ES #(
				.pld_side_reserved_source9(pld_side_reserved_source9),
				.usrmode_sel4rst(usrmode_sel4rst),
				.pld_side_reserved_source0(pld_side_reserved_source0),
				.pld_side_reserved_source5(pld_side_reserved_source5),
				.pld_side_reserved_source2(pld_side_reserved_source2),
				.pld_side_reserved_source3(pld_side_reserved_source3),
				.data_source(data_source),
				.testbus_sel(testbus_sel),
				.hrdrstctrl_en_cfg(hrdrstctrl_en_cfg),
				.avmm_group_channel_index(avmm_group_channel_index),
				.pld_side_reserved_source4(pld_side_reserved_source4),
				.hrdrstctrl_en_cfgusr(hrdrstctrl_en_cfgusr),
				.user_base_address(user_base_address),
				.pld_side_reserved_source10(pld_side_reserved_source10),
				.pld_side_reserved_source6(pld_side_reserved_source6),
				.use_default_base_address(use_default_base_address),
				.pld_side_reserved_source1(pld_side_reserved_source1),
				.pld_side_reserved_source8(pld_side_reserved_source8),
				.pld_side_reserved_source11(pld_side_reserved_source11),
				.pld_side_reserved_source7(pld_side_reserved_source7),
				.emsip_enable(emsip_enable)
			) stratixv_hssi_common_pld_pcs_interface_encrypted_ES_inst (
				.pcs8gltr(pcs8gltr),
				.pcsgen3rate(pcsgen3rate),
				.pcs10gextraout(pcs10gextraout),
				.pld8grxvalid(pld8grxvalid),
				.pmafref(pmafref),
				.pldoffcaldonein(pldoffcaldonein),
				.pldreservedin(pldreservedin),
				.pldpcspmaifrefclkdig(pldpcspmaifrefclkdig),
				.pmaoffcalen(pmaoffcalen),
				.pldgen3currentcoeff(pldgen3currentcoeff),
				.pcs8gchnltestbusout(pcs8gchnltestbusout),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.pld8grxstatus(pld8grxstatus),
				.pcs8gpowerdown(pcs8gpowerdown),
				.iocsrrdydly(iocsrrdydly),
				.pld8gtxdeemph(pld8gtxdeemph),
				.pldnfrzdrv(pldnfrzdrv),
				.emsipcomspecialout(emsipcomspecialout),
				.pcsgen3testsi(pcsgen3testsi),
				.pldoffcaldone(pldoffcaldone),
				.pcs8grxpolarity(pcs8grxpolarity),
				.pcsgen3extrain(pcsgen3extrain),
				.avmmwrite(avmmwrite),
				.pcspmaiftestso(pcspmaiftestso),
				.pld8gphystatus(pld8gphystatus),
				.pcs8gtxdeemph(pcs8gtxdeemph),
				.usermode(usermode),
				.pcs8gtestsi(pcs8gtestsi),
				.pcs8geidleinfersel(pcs8geidleinfersel),
				.pldpartialreconfigin(pldpartialreconfigin),
				.pcspcspmaifscanshiftn(pcspcspmaifscanshiftn),
				.pcs8gpldextraout(pcs8gpldextraout),
				.pcs10ghardreset(pcs10ghardreset),
				.pcs8grxstatus(pcs8grxstatus),
				.pld8grxpolarity(pld8grxpolarity),
				.usrrstsel(usrrstsel),
				.pcs8grefclkdig(pcs8grefclkdig),
				.pcspmaifhardreset(pcspmaifhardreset),
				.pldltr(pldltr),
				.pcsgen3testout(pcsgen3testout),
				.pldgen3masktxpll(pldgen3masktxpll),
				.pldrate(pldrate),
				.pcspmaiftestbusout(pcspmaiftestbusout),
				.pcsaggrefclkdig(pcsaggrefclkdig),
				.plniotri(plniotri),
				.pcs10gtestso(pcs10gtestso),
				.rstsel(rstsel),
				.emsipcomin(emsipcomin),
				.pld8grefclkdig(pld8grefclkdig),
				.pcspmaiftestsi(pcspmaiftestsi),
				.pldpartialreconfigout(pldpartialreconfigout),
				.pldoffcaldoneout(pldoffcaldoneout),
				.emsipcomspecialin(emsipcomspecialin),
				.pldgen3rxdeemph(pldgen3rxdeemph),
				.pldgen3rxeqctrl(pldgen3rxeqctrl),
				.pcs8gtxswing(pcs8gtxswing),
				.pcs8grxelecidle(pcs8grxelecidle),
				.pcsgen3currentcoeff(pcsgen3currentcoeff),
				.pldreservedout(pldreservedout),
				.pld8gprbsciden(pld8gprbsciden),
				.entest(entest),
				.pcs8grate(pcs8grate),
				.pcspcspmaifscanmoden(pcspcspmaifscanmoden),
				.pld8grefclkdig2(pld8grefclkdig2),
				.pcs8gtxelecidle(pcs8gtxelecidle),
				.asynchdatain(asynchdatain),
				.pcs8ghardresetn(pcs8ghardresetn),
				.avmmclk(avmmclk),
				.pld8gtxswing(pld8gtxswing),
				.avmmrstn(avmmrstn),
				.pld8gtxdetectrxloopback(pld8gtxdetectrxloopback),
				.emsipcomclkout(emsipcomclkout),
				.avmmbyteen(avmmbyteen),
				.pcsgen3pldltr(pcsgen3pldltr),
				.pcsgen3rxdeemph(pcsgen3rxdeemph),
				.pcs8grefclkdig2(pcs8grefclkdig2),
				.pcsgen3masktxpll(pcsgen3masktxpll),
				.pcs8gphystatus(pcs8gphystatus),
				.pldgen3currentrxpreset(pldgen3currentrxpreset),
				.pld8gtxelecidle(pld8gtxelecidle),
				.pmaclklow(pmaclklow),
				.pldoffcalen(pldoffcalen),
				.avmmreaddata(avmmreaddata),
				.pldclklow(pldclklow),
				.pld8grxelecidle(pld8grxelecidle),
				.pcsgen3currentrxpreset(pcsgen3currentrxpreset),
				.pcsaggtestsi(pcsaggtestsi),
				.pldfref(pldfref),
				.pcsgen3scanmoden(pcsgen3scanmoden),
				.pcs10gextrain(pcs10gextrain),
				.pcspcspmaifrefclkdig(pcspcspmaifrefclkdig),
				.pldhclkin(pldhclkin),
				.pld8gtxmargin(pld8gtxmargin),
				.pcsgen3extraout(pcsgen3extraout),
				.avmmaddress(avmmaddress),
				.nfrzdrv(nfrzdrv),
				.pcs10gtestdata(pcs10gtestdata),
				.pld10grefclkdig(pld10grefclkdig),
				.pcs8grxvalid(pcs8grxvalid),
				.pcsaggtestso(pcsaggtestso),
				.pcsgen3eidleinfersel(pcsgen3eidleinfersel),
				.pldscanmoden(pldscanmoden),
				.pldscanshiftn(pldscanshiftn),
				.pcs10ghardresetn(pcs10ghardresetn),
				.npor(npor),
				.pcsgen3rxeqctrl(pcsgen3rxeqctrl),
				.pcs8ghardreset(pcs8ghardreset),
				.pcs8gtestso(pcs8gtestso),
				.pcsgen3hardreset(pcsgen3hardreset),
				.pldeidleinfersel(pldeidleinfersel),
				.pcsgen3testso(pcsgen3testso),
				.avmmread(avmmread),
				.pcs8gprbsciden(pcs8gprbsciden),
				.pcs8gtxmargin(pcs8gtxmargin),
				.pldaggrefclkdig(pldaggrefclkdig),
				.blockselect(blockselect),
				.pcs10gtestsi(pcs10gtestsi),
				.frzreg(frzreg),
				.pcs8gpldextrain(pcs8gpldextrain),
				.pcs8gscanmoden(pcs8gscanmoden),
				.emsipcomout(emsipcomout),
				.pcs10grefclkdig(pcs10grefclkdig),
				.pldtestdata(pldtestdata),
				.pcs8gtxdetectrxloopback(pcs8gtxdetectrxloopback),
				.pld8gpowerdown(pld8gpowerdown),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_common_pld_pcs_interface_encrypted #(
				.pld_side_reserved_source9(pld_side_reserved_source9),
				.usrmode_sel4rst(usrmode_sel4rst),
				.pld_side_reserved_source0(pld_side_reserved_source0),
				.pld_side_reserved_source5(pld_side_reserved_source5),
				.pld_side_reserved_source2(pld_side_reserved_source2),
				.pld_side_reserved_source3(pld_side_reserved_source3),
				.data_source(data_source),
				.testbus_sel(testbus_sel),
				.hrdrstctrl_en_cfg(hrdrstctrl_en_cfg),
				.avmm_group_channel_index(avmm_group_channel_index),
				.pld_side_reserved_source4(pld_side_reserved_source4),
				.hrdrstctrl_en_cfgusr(hrdrstctrl_en_cfgusr),
				.user_base_address(user_base_address),
				.pld_side_reserved_source10(pld_side_reserved_source10),
				.pld_side_reserved_source6(pld_side_reserved_source6),
				.use_default_base_address(use_default_base_address),
				.pld_side_reserved_source1(pld_side_reserved_source1),
				.pld_side_reserved_source8(pld_side_reserved_source8),
				.pld_side_reserved_source11(pld_side_reserved_source11),
				.pld_side_reserved_source7(pld_side_reserved_source7),
				.emsip_enable(emsip_enable)
			) stratixv_hssi_common_pld_pcs_interface_encrypted_inst (
				.pcs8gltr(pcs8gltr),
				.pcsgen3rate(pcsgen3rate),
				.pcs10gextraout(pcs10gextraout),
				.pld8grxvalid(pld8grxvalid),
				.pmafref(pmafref),
				.pldoffcaldonein(pldoffcaldonein),
				.pldreservedin(pldreservedin),
				.pldpcspmaifrefclkdig(pldpcspmaifrefclkdig),
				.pmaoffcalen(pmaoffcalen),
				.pldgen3currentcoeff(pldgen3currentcoeff),
				.pcs8gchnltestbusout(pcs8gchnltestbusout),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.pld8grxstatus(pld8grxstatus),
				.pcs8gpowerdown(pcs8gpowerdown),
				.iocsrrdydly(iocsrrdydly),
				.pld8gtxdeemph(pld8gtxdeemph),
				.pldnfrzdrv(pldnfrzdrv),
				.emsipcomspecialout(emsipcomspecialout),
				.pcsgen3testsi(pcsgen3testsi),
				.pldoffcaldone(pldoffcaldone),
				.pcs8grxpolarity(pcs8grxpolarity),
				.pcsgen3extrain(pcsgen3extrain),
				.avmmwrite(avmmwrite),
				.pcspmaiftestso(pcspmaiftestso),
				.pld8gphystatus(pld8gphystatus),
				.pcs8gtxdeemph(pcs8gtxdeemph),
				.usermode(usermode),
				.pcs8gtestsi(pcs8gtestsi),
				.pcs8geidleinfersel(pcs8geidleinfersel),
				.pldpartialreconfigin(pldpartialreconfigin),
				.pcspcspmaifscanshiftn(pcspcspmaifscanshiftn),
				.pcs8gpldextraout(pcs8gpldextraout),
				.pcs10ghardreset(pcs10ghardreset),
				.pcs8grxstatus(pcs8grxstatus),
				.pld8grxpolarity(pld8grxpolarity),
				.usrrstsel(usrrstsel),
				.pcs8grefclkdig(pcs8grefclkdig),
				.pcspmaifhardreset(pcspmaifhardreset),
				.pldltr(pldltr),
				.pcsgen3testout(pcsgen3testout),
				.pldgen3masktxpll(pldgen3masktxpll),
				.pldrate(pldrate),
				.pcspmaiftestbusout(pcspmaiftestbusout),
				.pcsaggrefclkdig(pcsaggrefclkdig),
				.plniotri(plniotri),
				.pcs10gtestso(pcs10gtestso),
				.rstsel(rstsel),
				.emsipcomin(emsipcomin),
				.pld8grefclkdig(pld8grefclkdig),
				.pcspmaiftestsi(pcspmaiftestsi),
				.pldpartialreconfigout(pldpartialreconfigout),
				.pldoffcaldoneout(pldoffcaldoneout),
				.emsipcomspecialin(emsipcomspecialin),
				.pldgen3rxdeemph(pldgen3rxdeemph),
				.pldgen3rxeqctrl(pldgen3rxeqctrl),
				.pcs8gtxswing(pcs8gtxswing),
				.pcs8grxelecidle(pcs8grxelecidle),
				.pcsgen3currentcoeff(pcsgen3currentcoeff),
				.pldreservedout(pldreservedout),
				.pld8gprbsciden(pld8gprbsciden),
				.entest(entest),
				.pcs8grate(pcs8grate),
				.pcspcspmaifscanmoden(pcspcspmaifscanmoden),
				.pld8grefclkdig2(pld8grefclkdig2),
				.pcs8gtxelecidle(pcs8gtxelecidle),
				.asynchdatain(asynchdatain),
				.pcs8ghardresetn(pcs8ghardresetn),
				.avmmclk(avmmclk),
				.pld8gtxswing(pld8gtxswing),
				.avmmrstn(avmmrstn),
				.pld8gtxdetectrxloopback(pld8gtxdetectrxloopback),
				.emsipcomclkout(emsipcomclkout),
				.avmmbyteen(avmmbyteen),
				.pcsgen3pldltr(pcsgen3pldltr),
				.pcsgen3rxdeemph(pcsgen3rxdeemph),
				.pcs8grefclkdig2(pcs8grefclkdig2),
				.pcsgen3masktxpll(pcsgen3masktxpll),
				.pcs8gphystatus(pcs8gphystatus),
				.pldgen3currentrxpreset(pldgen3currentrxpreset),
				.pld8gtxelecidle(pld8gtxelecidle),
				.pmaclklow(pmaclklow),
				.pldoffcalen(pldoffcalen),
				.avmmreaddata(avmmreaddata),
				.pldclklow(pldclklow),
				.pld8grxelecidle(pld8grxelecidle),
				.pcsgen3currentrxpreset(pcsgen3currentrxpreset),
				.pcsaggtestsi(pcsaggtestsi),
				.pldfref(pldfref),
				.pcsgen3scanmoden(pcsgen3scanmoden),
				.pcs10gextrain(pcs10gextrain),
				.pcspcspmaifrefclkdig(pcspcspmaifrefclkdig),
				.pldhclkin(pldhclkin),
				.pld8gtxmargin(pld8gtxmargin),
				.pcsgen3extraout(pcsgen3extraout),
				.avmmaddress(avmmaddress),
				.nfrzdrv(nfrzdrv),
				.pcs10gtestdata(pcs10gtestdata),
				.pld10grefclkdig(pld10grefclkdig),
				.pcs8grxvalid(pcs8grxvalid),
				.pcsaggtestso(pcsaggtestso),
				.pcsgen3eidleinfersel(pcsgen3eidleinfersel),
				.pldscanmoden(pldscanmoden),
				.pldscanshiftn(pldscanshiftn),
				.pcs10ghardresetn(pcs10ghardresetn),
				.npor(npor),
				.pcsgen3rxeqctrl(pcsgen3rxeqctrl),
				.pcs8ghardreset(pcs8ghardreset),
				.pcs8gtestso(pcs8gtestso),
				.pcsgen3hardreset(pcsgen3hardreset),
				.pldeidleinfersel(pldeidleinfersel),
				.pcsgen3testso(pcsgen3testso),
				.avmmread(avmmread),
				.pcs8gprbsciden(pcs8gprbsciden),
				.pcs8gtxmargin(pcs8gtxmargin),
				.pldaggrefclkdig(pldaggrefclkdig),
				.blockselect(blockselect),
				.pcs10gtestsi(pcs10gtestsi),
				.frzreg(frzreg),
				.pcs8gpldextrain(pcs8gpldextrain),
				.pcs8gscanmoden(pcs8gscanmoden),
				.emsipcomout(emsipcomout),
				.pcs10grefclkdig(pcs10grefclkdig),
				.pldtestdata(pldtestdata),
				.pcs8gtxdetectrxloopback(pcs8gtxdetectrxloopback),
				.pld8gpowerdown(pld8gpowerdown),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_gen3_rx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_gen3_rx_pcs
#(
	parameter rmfifo_full_data = 5'b11111,      // Valid values: 5
	parameter rx_test_out_sel = "rx_test_out0",      // Valid values: rx_test_out0|rx_test_out1
	parameter reverse_lpbk = "rev_lpbk_en",      // Valid values: rev_lpbk_dis|rev_lpbk_en
	parameter mode = "gen3_func",      // Valid values: gen3_func|par_lpbk|disable_pcs
	parameter rmfifo_pfull = "rmfifo_pfull",      // Valid values: rmfifo_pfull
	parameter rx_ins_del_one_skip = "ins_del_one_skip_en",      // Valid values: ins_del_one_skip_dis|ins_del_one_skip_en
	parameter rx_force_balign = "en_force_balign",      // Valid values: en_force_balign|dis_force_balign
	parameter decoder = "enable_decoder",      // Valid values: bypass_decoder|enable_decoder
	parameter lpbk_force = "lpbk_frce_dis",      // Valid values: lpbk_frce_dis|lpbk_frce_en
	parameter rx_lane_num = "lane_0",      // Valid values: lane_0|lane_1|lane_2|lane_3|lane_4|lane_5|lane_6|lane_7|not_used
	parameter rx_pol_compl = "rx_pol_compl_dis",      // Valid values: rx_pol_compl_dis|rx_pol_compl_en
	parameter rmfifo_full = "rmfifo_full",      // Valid values: rmfifo_full
	parameter rate_match_fifo_latency = "regular_latency",      // Valid values: regular_latency|low_latency
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter rmfifo_pempty = "rmfifo_pempty",      // Valid values: rmfifo_pempty
	parameter descrambler = "enable_descrambler",      // Valid values: bypass_descrambler|enable_descrambler
	parameter block_sync_sm = "enable_blk_sync_sm",      // Valid values: disable_blk_sync_sm|enable_blk_sync_sm
	parameter rx_num_fixed_pat = "num_fixed_pat",      // Valid values: num_fixed_pat
	parameter rx_g3_dcbal = "g3_dcbal_en",      // Valid values: g3_dcbal_dis|g3_dcbal_en
	parameter rate_match_fifo = "enable_rm_fifo",      // Valid values: bypass_rm_fifo|enable_rm_fifo
	parameter tx_clk_sel = "tx_pma_clk",      // Valid values: disable_clk|dig_clk2_8g|tx_pma_clk
	parameter parallel_lpbk = "par_lpbk_dis",      // Valid values: par_lpbk_dis|par_lpbk_en
	parameter rmfifo_pempty_data = 5'b1000,      // Valid values: 5
	parameter rx_b4gb_par_lpbk = "b4gb_par_lpbk_dis",      // Valid values: b4gb_par_lpbk_dis|b4gb_par_lpbk_en
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engr_mode
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter block_sync = "enable_block_sync",      // Valid values: bypass_block_sync|enable_block_sync
	parameter descrambler_lfsr_check = "lfsr_chk_dis",      // Valid values: lfsr_chk_dis|lfsr_chk_en
	parameter rx_clk_sel = "rcvd_clk",      // Valid values: disable_clk|dig_clk1_8g|rcvd_clk
	parameter rmfifo_empty = "rmfifo_empty",      // Valid values: rmfifo_empty
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter rmfifo_pfull_data = 5'b10111,      // Valid values: 5
	parameter rx_num_fixed_pat_data = 4'b100,      // Valid values: 4
	parameter rmfifo_empty_data = 5'b1,      // Valid values: 5
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blkalgndint,
	output [ 0:0 ] blklockdint,
	output [ 0:0 ] blkstart,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkcompdeleteint,
	output [ 0:0 ] clkcompinsertint,
	output [ 0:0 ] clkcompoverflint,
	output [ 0:0 ] clkcompundflint,
	input  [ 31:0 ] datain,
	output [ 31:0 ] dataout,
	output [ 0:0 ] datavalid,
	output [ 0:0 ] eidetint,
	output [ 0:0 ] eipartialdetint,
	output [ 0:0 ] errdecodeint,
	input  [ 0:0 ] gen3clksel,
	input  [ 0:0 ] hardresetn,
	output [ 0:0 ] idetint,
	input  [ 0:0 ] inferredrxvalid,
	output [ 0:0 ] lpbkblkstart,
	output [ 33:0 ] lpbkdata,
	output [ 0:0 ] lpbkdatavalid,
	input  [ 0:0 ] lpbken,
	input  [ 35:0 ] parlpbkb4gbin,
	input  [ 31:0 ] parlpbkin,
	input  [ 0:0 ] pcsrst,
	input  [ 0:0 ] pldclk28gpcs,
	input  [ 0:0 ] rcvdclk,
	output [ 0:0 ] rcvlfsrchkint,
	input  [ 0:0 ] rxpolarity,
	input  [ 0:0 ] rxrstn,
	output [ 19:0 ] rxtestout,
	input  [ 0:0 ] scanmoden,
	input  [ 0:0 ] shutdownclk,
	output [ 0:0 ] skpdetint,
	output [ 1:0 ] synchdr,
	input  [ 0:0 ] syncsmen,
	input  [ 3:0 ] txdatakin,
	input  [ 0:0 ] txelecidle,
	input  [ 0:0 ] txpmaclk,
	input  [ 0:0 ] txpth
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_gen3_rx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_gen3_rx_pcs_encrypted_ES #(
				.rmfifo_full_data(rmfifo_full_data),
				.rx_test_out_sel(rx_test_out_sel),
				.reverse_lpbk(reverse_lpbk),
				.mode(mode),
				.rmfifo_pfull(rmfifo_pfull),
				.rx_ins_del_one_skip(rx_ins_del_one_skip),
				.rx_force_balign(rx_force_balign),
				.decoder(decoder),
				.lpbk_force(lpbk_force),
				.rx_lane_num(rx_lane_num),
				.rx_pol_compl(rx_pol_compl),
				.rmfifo_full(rmfifo_full),
				.rate_match_fifo_latency(rate_match_fifo_latency),
				.user_base_address(user_base_address),
				.rmfifo_pempty(rmfifo_pempty),
				.descrambler(descrambler),
				.block_sync_sm(block_sync_sm),
				.rx_num_fixed_pat(rx_num_fixed_pat),
				.rx_g3_dcbal(rx_g3_dcbal),
				.rate_match_fifo(rate_match_fifo),
				.tx_clk_sel(tx_clk_sel),
				.parallel_lpbk(parallel_lpbk),
				.rmfifo_pempty_data(rmfifo_pempty_data),
				.rx_b4gb_par_lpbk(rx_b4gb_par_lpbk),
				.sup_mode(sup_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.block_sync(block_sync),
				.descrambler_lfsr_check(descrambler_lfsr_check),
				.rx_clk_sel(rx_clk_sel),
				.rmfifo_empty(rmfifo_empty),
				.use_default_base_address(use_default_base_address),
				.rmfifo_pfull_data(rmfifo_pfull_data),
				.rx_num_fixed_pat_data(rx_num_fixed_pat_data),
				.rmfifo_empty_data(rmfifo_empty_data)
			) stratixv_hssi_gen3_rx_pcs_encrypted_ES_inst (
				.txpth(txpth),
				.avmmclk(avmmclk),
				.lpbkdatavalid(lpbkdatavalid),
				.rxtestout(rxtestout),
				.eipartialdetint(eipartialdetint),
				.lpbkdata(lpbkdata),
				.clkcompoverflint(clkcompoverflint),
				.rxrstn(rxrstn),
				.avmmrstn(avmmrstn),
				.eidetint(eidetint),
				.avmmbyteen(avmmbyteen),
				.rcvlfsrchkint(rcvlfsrchkint),
				.blklockdint(blklockdint),
				.lpbken(lpbken),
				.pcsrst(pcsrst),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.parlpbkb4gbin(parlpbkb4gbin),
				.blkstart(blkstart),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.idetint(idetint),
				.avmmaddress(avmmaddress),
				.parlpbkin(parlpbkin),
				.datain(datain),
				.clkcompinsertint(clkcompinsertint),
				.clkcompundflint(clkcompundflint),
				.gen3clksel(gen3clksel),
				.syncsmen(syncsmen),
				.dataout(dataout),
				.avmmread(avmmread),
				.shutdownclk(shutdownclk),
				.rxpolarity(rxpolarity),
				.blkalgndint(blkalgndint),
				.blockselect(blockselect),
				.skpdetint(skpdetint),
				.rcvdclk(rcvdclk),
				.txdatakin(txdatakin),
				.datavalid(datavalid),
				.inferredrxvalid(inferredrxvalid),
				.errdecodeint(errdecodeint),
				.clkcompdeleteint(clkcompdeleteint),
				.pldclk28gpcs(pldclk28gpcs),
				.synchdr(synchdr),
				.lpbkblkstart(lpbkblkstart),
				.txpmaclk(txpmaclk),
				.scanmoden(scanmoden),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_gen3_rx_pcs_encrypted #(
				.rmfifo_full_data(rmfifo_full_data),
				.rx_test_out_sel(rx_test_out_sel),
				.reverse_lpbk(reverse_lpbk),
				.mode(mode),
				.rmfifo_pfull(rmfifo_pfull),
				.rx_ins_del_one_skip(rx_ins_del_one_skip),
				.rx_force_balign(rx_force_balign),
				.decoder(decoder),
				.lpbk_force(lpbk_force),
				.rx_lane_num(rx_lane_num),
				.rx_pol_compl(rx_pol_compl),
				.rmfifo_full(rmfifo_full),
				.rate_match_fifo_latency(rate_match_fifo_latency),
				.user_base_address(user_base_address),
				.rmfifo_pempty(rmfifo_pempty),
				.descrambler(descrambler),
				.block_sync_sm(block_sync_sm),
				.rx_num_fixed_pat(rx_num_fixed_pat),
				.rx_g3_dcbal(rx_g3_dcbal),
				.rate_match_fifo(rate_match_fifo),
				.tx_clk_sel(tx_clk_sel),
				.parallel_lpbk(parallel_lpbk),
				.rmfifo_pempty_data(rmfifo_pempty_data),
				.rx_b4gb_par_lpbk(rx_b4gb_par_lpbk),
				.sup_mode(sup_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.block_sync(block_sync),
				.descrambler_lfsr_check(descrambler_lfsr_check),
				.rx_clk_sel(rx_clk_sel),
				.rmfifo_empty(rmfifo_empty),
				.use_default_base_address(use_default_base_address),
				.rmfifo_pfull_data(rmfifo_pfull_data),
				.rx_num_fixed_pat_data(rx_num_fixed_pat_data),
				.rmfifo_empty_data(rmfifo_empty_data)
			) stratixv_hssi_gen3_rx_pcs_encrypted_inst (
				.txpth(txpth),
				.avmmclk(avmmclk),
				.lpbkdatavalid(lpbkdatavalid),
				.rxtestout(rxtestout),
				.eipartialdetint(eipartialdetint),
				.lpbkdata(lpbkdata),
				.clkcompoverflint(clkcompoverflint),
				.rxrstn(rxrstn),
				.avmmrstn(avmmrstn),
				.eidetint(eidetint),
				.avmmbyteen(avmmbyteen),
				.rcvlfsrchkint(rcvlfsrchkint),
				.blklockdint(blklockdint),
				.lpbken(lpbken),
				.pcsrst(pcsrst),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.parlpbkb4gbin(parlpbkb4gbin),
				.blkstart(blkstart),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.idetint(idetint),
				.avmmaddress(avmmaddress),
				.parlpbkin(parlpbkin),
				.datain(datain),
				.clkcompinsertint(clkcompinsertint),
				.clkcompundflint(clkcompundflint),
				.gen3clksel(gen3clksel),
				.syncsmen(syncsmen),
				.dataout(dataout),
				.avmmread(avmmread),
				.shutdownclk(shutdownclk),
				.rxpolarity(rxpolarity),
				.blkalgndint(blkalgndint),
				.blockselect(blockselect),
				.skpdetint(skpdetint),
				.rcvdclk(rcvdclk),
				.txdatakin(txdatakin),
				.datavalid(datavalid),
				.inferredrxvalid(inferredrxvalid),
				.errdecodeint(errdecodeint),
				.clkcompdeleteint(clkcompdeleteint),
				.pldclk28gpcs(pldclk28gpcs),
				.synchdr(synchdr),
				.lpbkblkstart(lpbkblkstart),
				.txpmaclk(txpmaclk),
				.scanmoden(scanmoden),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_gen3_tx_pcs_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_gen3_tx_pcs
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter tx_lane_num = "lane_0",      // Valid values: lane_0|lane_1|lane_2|lane_3|lane_4|lane_5|lane_6|lane_7|not_used
	parameter reverse_lpbk = "rev_lpbk_en",      // Valid values: rev_lpbk_dis|rev_lpbk_en
	parameter mode = "gen3_func",      // Valid values: gen3_func|prbs|par_lpbk|disable_pcs
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter tx_pol_compl = "tx_pol_compl_dis",      // Valid values: tx_pol_compl_dis|tx_pol_compl_en
	parameter tx_clk_sel = "tx_pma_clk",      // Valid values: disable_clk|dig_clk1_8g|tx_pma_clk
	parameter tx_bitslip = "tx_bitslip_val",      // Valid values: tx_bitslip_val
	parameter encoder = "enable_encoder",      // Valid values: bypass_encoder|enable_encoder
	parameter prbs_generator = "prbs_gen_dis",      // Valid values: prbs_gen_dis|prbs_gen_en
	parameter tx_g3_dcbal = "tx_g3_dcbal_en",      // Valid values: tx_g3_dcbal_dis|tx_g3_dcbal_en
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engr_mode
	parameter scrambler = "enable_scrambler",      // Valid values: bypass_scrambler|enable_scrambler
	parameter tx_gbox_byp = "bypass_gbox",      // Valid values: bypass_gbox|enable_gbox
	parameter tx_bitslip_data = 5'b0,      // Valid values: 5
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	input  [ 0:0 ] blkstartin,
	output [ 0:0 ] blockselect,
	input  [ 31:0 ] datain,
	output [ 31:0 ] dataout,
	input  [ 0:0 ] datavalid,
	output [ 0:0 ] errencode,
	input  [ 0:0 ] gen3clksel,
	input  [ 0:0 ] hardresetn,
	input  [ 0:0 ] lpbkblkstart,
	input  [ 33:0 ] lpbkdatain,
	input  [ 0:0 ] lpbkdatavalid,
	input  [ 0:0 ] lpbken,
	output [ 35:0 ] parlpbkb4gbout,
	output [ 31:0 ] parlpbkout,
	input  [ 0:0 ] pcsrst,
	input  [ 0:0 ] scanmoden,
	input  [ 0:0 ] shutdownclk,
	input  [ 1:0 ] syncin,
	input  [ 0:0 ] txelecidle,
	input  [ 0:0 ] txpmaclk,
	input  [ 0:0 ] txpth,
	input  [ 0:0 ] txrstn,
	output [ 19:0 ] txtestout
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_gen3_tx_pcs : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_gen3_tx_pcs_encrypted_ES #(
				.user_base_address(user_base_address),
				.tx_lane_num(tx_lane_num),
				.reverse_lpbk(reverse_lpbk),
				.mode(mode),
				.use_default_base_address(use_default_base_address),
				.tx_pol_compl(tx_pol_compl),
				.tx_clk_sel(tx_clk_sel),
				.tx_bitslip(tx_bitslip),
				.encoder(encoder),
				.prbs_generator(prbs_generator),
				.tx_g3_dcbal(tx_g3_dcbal),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.scrambler(scrambler),
				.tx_gbox_byp(tx_gbox_byp),
				.tx_bitslip_data(tx_bitslip_data)
			) stratixv_hssi_gen3_tx_pcs_encrypted_ES_inst (
				.datain(datain),
				.txpth(txpth),
				.avmmclk(avmmclk),
				.lpbkdatavalid(lpbkdatavalid),
				.errencode(errencode),
				.gen3clksel(gen3clksel),
				.syncin(syncin),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.txtestout(txtestout),
				.dataout(dataout),
				.shutdownclk(shutdownclk),
				.avmmread(avmmread),
				.pcsrst(pcsrst),
				.lpbkdatain(lpbkdatain),
				.lpbken(lpbken),
				.blockselect(blockselect),
				.parlpbkb4gbout(parlpbkb4gbout),
				.avmmreaddata(avmmreaddata),
				.txrstn(txrstn),
				.blkstartin(blkstartin),
				.datavalid(datavalid),
				.avmmwrite(avmmwrite),
				.parlpbkout(parlpbkout),
				.txpmaclk(txpmaclk),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.lpbkblkstart(lpbkblkstart),
				.scanmoden(scanmoden),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_gen3_tx_pcs_encrypted #(
				.tx_lane_num(tx_lane_num),
				.reverse_lpbk(reverse_lpbk),
				.mode(mode),
				.tx_clk_sel(tx_clk_sel),
				.encoder(encoder),
				.prbs_generator(prbs_generator),
				.tx_g3_dcbal(tx_g3_dcbal),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.scrambler(scrambler),
				.tx_gbox_byp(tx_gbox_byp),
				.user_base_address(user_base_address),
				.tx_pol_compl(tx_pol_compl),
				.use_default_base_address(use_default_base_address),
				.tx_bitslip(tx_bitslip),
				.tx_bitslip_data(tx_bitslip_data)
			) stratixv_hssi_gen3_tx_pcs_encrypted_inst (
				.datain(datain),
				.txpth(txpth),
				.avmmclk(avmmclk),
				.lpbkdatavalid(lpbkdatavalid),
				.errencode(errencode),
				.gen3clksel(gen3clksel),
				.syncin(syncin),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.txtestout(txtestout),
				.dataout(dataout),
				.shutdownclk(shutdownclk),
				.avmmread(avmmread),
				.pcsrst(pcsrst),
				.lpbkdatain(lpbkdatain),
				.lpbken(lpbken),
				.blockselect(blockselect),
				.parlpbkb4gbout(parlpbkb4gbout),
				.avmmreaddata(avmmreaddata),
				.txrstn(txrstn),
				.blkstartin(blkstartin),
				.datavalid(datavalid),
				.avmmwrite(avmmwrite),
				.parlpbkout(parlpbkout),
				.txpmaclk(txpmaclk),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.lpbkblkstart(lpbkblkstart),
				.scanmoden(scanmoden),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pipe_gen1_2_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pipe_gen1_2
#(
	parameter rpre_emph_a_val = 6'b0,      // Valid values: 6
	parameter rpre_emph_d_val = 6'b0,      // Valid values: 6
	parameter rxdetect_bypass = "dis_rxdetect_bypass",      // Valid values: dis_rxdetect_bypass|en_rxdetect_bypass
	parameter pipe_byte_de_serializer_en = "dont_care_bds",      // Valid values: dis_bds|en_bds_by_2|dont_care_bds
	parameter rvod_sel_settings = 6'b0,      // Valid values: 6
	parameter elec_idle_delay_val = 3'b0,      // Valid values: 3
	parameter elecidle_delay = "elec_idle_delay",      // Valid values: elec_idle_delay
	parameter rvod_sel_c_val = 6'b0,      // Valid values: 6
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engineering_mode
	parameter rvod_sel_a_val = 6'b0,      // Valid values: 6
	parameter error_replace_pad = "replace_edb",      // Valid values: replace_edb|replace_pad
	parameter ind_error_reporting = "dis_ind_error_reporting",      // Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter phy_status_delay = "phystatus_delay",      // Valid values: phystatus_delay
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter rvod_sel_b_val = 6'b0,      // Valid values: 6
	parameter phystatus_delay_val = 3'b0,      // Valid values: 3
	parameter rvod_sel_d_val = 6'b0,      // Valid values: 6
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter phystatus_rst_toggle = "dis_phystatus_rst_toggle",      // Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter ctrl_plane_bonding_consumption = "individual",      // Valid values: individual|bundled_master|bundled_slave_below|bundled_slave_above
	parameter txswing = "dis_txswing",      // Valid values: dis_txswing|en_txswing
	parameter rx_pipe_enable = "dis_pipe_rx",      // Valid values: dis_pipe_rx|en_pipe_rx|en_pipe3_rx
	parameter prot_mode = "pipe_g1",      // Valid values: pipe_g1|pipe_g2|pipe_g3|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
	parameter rpre_emph_c_val = 6'b0,      // Valid values: 6
	parameter rvod_sel_e_val = 6'b0,      // Valid values: 6
	parameter rpre_emph_settings = 6'b0,      // Valid values: 6
	parameter hip_mode = "dis_hip",      // Valid values: dis_hip|en_hip
	parameter tx_pipe_enable = "dis_pipe_tx",      // Valid values: dis_pipe_tx|en_pipe_tx|en_pipe3_tx
	parameter rpre_emph_e_val = 6'b0,      // Valid values: 6
	parameter rpre_emph_b_val = 6'b0,      // Valid values: 6
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 17:0 ] currentcoeff,
	input  [ 0:0 ] pcieswitch,
	output [ 0:0 ] phystatus,
	input  [ 0:0 ] piperxclk,
	input  [ 0:0 ] pipetxclk,
	input  [ 0:0 ] polinvrx,
	output [ 0:0 ] polinvrxint,
	input  [ 1:0 ] powerdown,
	input  [ 0:0 ] powerstatetransitiondone,
	input  [ 0:0 ] powerstatetransitiondoneena,
	input  [ 0:0 ] refclkb,
	input  [ 0:0 ] refclkbreset,
	input  [ 0:0 ] revloopback,
	output [ 0:0 ] revloopbk,
	input  [ 0:0 ] revloopbkpcsgen3,
	input  [ 63:0 ] rxd,
	output [ 63:0 ] rxdch,
	input  [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxelecidle,
	input  [ 0:0 ] rxelectricalidle,
	output [ 0:0 ] rxelectricalidleout,
	input  [ 0:0 ] rxelectricalidlepcsgen3,
	input  [ 0:0 ] rxfound,
	input  [ 0:0 ] rxpipereset,
	input  [ 0:0 ] rxpolarity,
	input  [ 0:0 ] rxpolaritypcsgen3,
	output [ 2:0 ] rxstatus,
	output [ 0:0 ] rxvalid,
	input  [ 0:0 ] sigdetni,
	input  [ 0:0 ] speedchange,
	input  [ 0:0 ] speedchangechnldown,
	input  [ 0:0 ] speedchangechnlup,
	output [ 0:0 ] speedchangeout,
	output [ 43:0 ] txd,
	input  [ 43:0 ] txdch,
	input  [ 0:0 ] txdeemph,
	output [ 0:0 ] txdetectrx,
	input  [ 0:0 ] txdetectrxloopback,
	input  [ 0:0 ] txelecidlecomp,
	input  [ 0:0 ] txelecidlein,
	output [ 0:0 ] txelecidleout,
	input  [ 2:0 ] txmargin,
	input  [ 0:0 ] txpipereset,
	input  [ 0:0 ] txswingport
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pipe_gen1_2 : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pipe_gen1_2_encrypted_ES #(
				.rpre_emph_a_val(rpre_emph_a_val),
				.rpre_emph_d_val(rpre_emph_d_val),
				.rxdetect_bypass(rxdetect_bypass),
				.pipe_byte_de_serializer_en(pipe_byte_de_serializer_en),
				.rvod_sel_settings(rvod_sel_settings),
				.elec_idle_delay_val(elec_idle_delay_val),
				.elecidle_delay(elecidle_delay),
				.rvod_sel_c_val(rvod_sel_c_val),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.rvod_sel_a_val(rvod_sel_a_val),
				.error_replace_pad(error_replace_pad),
				.ind_error_reporting(ind_error_reporting),
				.phy_status_delay(phy_status_delay),
				.user_base_address(user_base_address),
				.rvod_sel_b_val(rvod_sel_b_val),
				.phystatus_delay_val(phystatus_delay_val),
				.rvod_sel_d_val(rvod_sel_d_val),
				.use_default_base_address(use_default_base_address),
				.phystatus_rst_toggle(phystatus_rst_toggle),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.txswing(txswing),
				.rx_pipe_enable(rx_pipe_enable),
				.prot_mode(prot_mode),
				.rpre_emph_c_val(rpre_emph_c_val),
				.rvod_sel_e_val(rvod_sel_e_val),
				.rpre_emph_settings(rpre_emph_settings),
				.hip_mode(hip_mode),
				.tx_pipe_enable(tx_pipe_enable),
				.rpre_emph_e_val(rpre_emph_e_val),
				.rpre_emph_b_val(rpre_emph_b_val)
			) stratixv_hssi_pipe_gen1_2_encrypted_ES_inst (
				.txelecidlecomp(txelecidlecomp),
				.pipetxclk(pipetxclk),
				.txdeemph(txdeemph),
				.pcieswitch(pcieswitch),
				.avmmclk(avmmclk),
				.speedchangechnldown(speedchangechnldown),
				.rxpolaritypcsgen3(rxpolaritypcsgen3),
				.rxstatus(rxstatus),
				.rxd(rxd),
				.avmmrstn(avmmrstn),
				.powerstatetransitiondoneena(powerstatetransitiondoneena),
				.avmmbyteen(avmmbyteen),
				.rxelectricalidle(rxelectricalidle),
				.txd(txd),
				.sigdetni(sigdetni),
				.currentcoeff(currentcoeff),
				.txdch(txdch),
				.txdetectrx(txdetectrx),
				.avmmreaddata(avmmreaddata),
				.speedchangechnlup(speedchangechnlup),
				.revloopbk(revloopbk),
				.avmmwrite(avmmwrite),
				.refclkb(refclkb),
				.rxdch(rxdch),
				.powerdown(powerdown),
				.polinvrx(polinvrx),
				.avmmaddress(avmmaddress),
				.powerstatetransitiondone(powerstatetransitiondone),
				.txpipereset(txpipereset),
				.rxelecidle(rxelecidle),
				.speedchangeout(speedchangeout),
				.rxelectricalidlepcsgen3(rxelectricalidlepcsgen3),
				.revloopback(revloopback),
				.rxvalid(rxvalid),
				.revloopbkpcsgen3(revloopbkpcsgen3),
				.rxpipereset(rxpipereset),
				.rxelectricalidleout(rxelectricalidleout),
				.speedchange(speedchange),
				.avmmread(avmmread),
				.rxfound(rxfound),
				.rxpolarity(rxpolarity),
				.txelecidleout(txelecidleout),
				.polinvrxint(polinvrxint),
				.blockselect(blockselect),
				.piperxclk(piperxclk),
				.rxdetectvalid(rxdetectvalid),
				.phystatus(phystatus),
				.txswingport(txswingport),
				.refclkbreset(refclkbreset),
				.txmargin(txmargin),
				.txelecidlein(txelecidlein),
				.txdetectrxloopback(txdetectrxloopback),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pipe_gen1_2_encrypted #(
				.rpre_emph_d_val(rpre_emph_d_val),
				.rxdetect_bypass(rxdetect_bypass),
				.rvod_sel_a_val(rvod_sel_a_val),
				.phy_status_delay(phy_status_delay),
				.user_base_address(user_base_address),
				.rvod_sel_b_val(rvod_sel_b_val),
				.rvod_sel_d_val(rvod_sel_d_val),
				.phystatus_rst_toggle(phystatus_rst_toggle),
				.txswing(txswing),
				.rvod_sel_e_val(rvod_sel_e_val),
				.rpre_emph_settings(rpre_emph_settings),
				.hip_mode(hip_mode),
				.rpre_emph_b_val(rpre_emph_b_val),
				.rpre_emph_a_val(rpre_emph_a_val),
				.pipe_byte_de_serializer_en(pipe_byte_de_serializer_en),
				.elec_idle_delay_val(elec_idle_delay_val),
				.rvod_sel_settings(rvod_sel_settings),
				.elecidle_delay(elecidle_delay),
				.rvod_sel_c_val(rvod_sel_c_val),
				.sup_mode(sup_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.error_replace_pad(error_replace_pad),
				.ind_error_reporting(ind_error_reporting),
				.phystatus_delay_val(phystatus_delay_val),
				.use_default_base_address(use_default_base_address),
				.ctrl_plane_bonding_consumption(ctrl_plane_bonding_consumption),
				.prot_mode(prot_mode),
				.rx_pipe_enable(rx_pipe_enable),
				.rpre_emph_c_val(rpre_emph_c_val),
				.tx_pipe_enable(tx_pipe_enable),
				.rpre_emph_e_val(rpre_emph_e_val)
			) stratixv_hssi_pipe_gen1_2_encrypted_inst (
				.txelecidlecomp(txelecidlecomp),
				.pipetxclk(pipetxclk),
				.txdeemph(txdeemph),
				.pcieswitch(pcieswitch),
				.avmmclk(avmmclk),
				.speedchangechnldown(speedchangechnldown),
				.rxpolaritypcsgen3(rxpolaritypcsgen3),
				.rxstatus(rxstatus),
				.rxd(rxd),
				.avmmrstn(avmmrstn),
				.powerstatetransitiondoneena(powerstatetransitiondoneena),
				.avmmbyteen(avmmbyteen),
				.rxelectricalidle(rxelectricalidle),
				.txd(txd),
				.sigdetni(sigdetni),
				.currentcoeff(currentcoeff),
				.txdch(txdch),
				.txdetectrx(txdetectrx),
				.avmmreaddata(avmmreaddata),
				.speedchangechnlup(speedchangechnlup),
				.revloopbk(revloopbk),
				.avmmwrite(avmmwrite),
				.refclkb(refclkb),
				.rxdch(rxdch),
				.powerdown(powerdown),
				.polinvrx(polinvrx),
				.avmmaddress(avmmaddress),
				.powerstatetransitiondone(powerstatetransitiondone),
				.txpipereset(txpipereset),
				.rxelecidle(rxelecidle),
				.speedchangeout(speedchangeout),
				.rxelectricalidlepcsgen3(rxelectricalidlepcsgen3),
				.revloopback(revloopback),
				.rxvalid(rxvalid),
				.revloopbkpcsgen3(revloopbkpcsgen3),
				.rxpipereset(rxpipereset),
				.rxelectricalidleout(rxelectricalidleout),
				.speedchange(speedchange),
				.avmmread(avmmread),
				.rxfound(rxfound),
				.rxpolarity(rxpolarity),
				.txelecidleout(txelecidleout),
				.polinvrxint(polinvrxint),
				.blockselect(blockselect),
				.piperxclk(piperxclk),
				.rxdetectvalid(rxdetectvalid),
				.phystatus(phystatus),
				.txswingport(txswingport),
				.refclkbreset(refclkbreset),
				.txmargin(txmargin),
				.txelecidlein(txelecidlein),
				.txdetectrxloopback(txdetectrxloopback),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pipe_gen3_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pipe_gen3
#(
	parameter ph_fifo_reg_mode = "phfifo_reg_mode_dis",      // Valid values: phfifo_reg_mode_dis|phfifo_reg_mode_en
	parameter phfifo_flush_wait_data = 6'b0,      // Valid values: 6
	parameter bypass_rx_preset_data = 3'b0,      // Valid values: 3
	parameter mode = "pipe_g1",      // Valid values: pipe_g1|pipe_g2|pipe_g3|par_lpbk|disable_pcs
	parameter test_out_sel = "disable",      // Valid values: tx_test_out|rx_test_out|pipe_test_out1|pipe_test_out2|pipe_test_out3|pipe_test_out4|pipe_ctrl_test_out1|pipe_ctrl_test_out2|pipe_ctrl_test_out3|disable
	parameter asn_enable = "dis_asn",      // Valid values: dis_asn|en_asn
	parameter ctrl_plane_bonding = "individual",      // Valid values: individual|ctrl_master|ctrl_slave_blw|ctrl_slave_abv
	parameter cp_dwn_mstr = "false",      // Valid values: false|true
	parameter rxvalid_mask = "rxvalid_mask_en",      // Valid values: rxvalid_mask_dis|rxvalid_mask_en
	parameter elecidle_delay_g3_data = 3'b0,      // Valid values: 3
	parameter phy_status_delay_g3_data = 3'b0,      // Valid values: 3
	parameter bypass_rx_detection_enable = "false",      // Valid values: false|true
	parameter wait_send_syncp_fbkp_data = 11'b11111010,      // Valid values: 11
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter wait_pipe_synchronizing = "wait_pipe_sync",      // Valid values: wait_pipe_sync
	parameter asn_clk_enable = "false",      // Valid values: false|true
	parameter pma_done_counter = "pma_done_count",      // Valid values: pma_done_count
	parameter inf_ei_enable = "dis_inf_ei",      // Valid values: dis_inf_ei|en_inf_ei
	parameter cid_enable = "en_cid_mode",      // Valid values: dis_cid_mode|en_cid_mode
	parameter phy_status_delay_g12 = "phy_status_delay_g12",      // Valid values: phy_status_delay_g12
	parameter pc_en_counter_data = 7'b110111,      // Valid values: 7
	parameter data_mask_count = "data_mask_count",      // Valid values: data_mask_count
	parameter data_mask_count_val = 10'b0,      // Valid values: 10
	parameter bypass_tx_coefficent_enable = "false",      // Valid values: false|true
	parameter wait_clk_on_off_timer_data = 4'b100,      // Valid values: 4
	parameter pc_rst_counter = "pc_rst_count",      // Valid values: pc_rst_count
	parameter phystatus_rst_toggle_g12 = "dis_phystatus_rst_toggle",      // Valid values: dis_phystatus_rst_toggle|en_phystatus_rst_toggle
	parameter wait_send_syncp_fbkp = "wait_send_syncp_fbkp",      // Valid values: wait_send_syncp_fbkp
	parameter elecidle_delay_g3 = "elecidle_delay_g3",      // Valid values: elecidle_delay_g3
	parameter sigdet_wait_counter_data = 8'b0,      // Valid values: 8
	parameter cp_up_mstr = "false",      // Valid values: false|true
	parameter pma_done_counter_data = 18'b0,      // Valid values: 18
	parameter test_mode_timers = "dis_test_mode_timers",      // Valid values: dis_test_mode_timers|en_test_mode_timers
	parameter pc_rst_counter_data = 5'b10111,      // Valid values: 5
	parameter cdr_control = "en_cdr_ctrl",      // Valid values: dis_cdr_ctrl|en_cdr_ctrl
	parameter phy_status_delay_g3 = "phy_status_delay_g3",      // Valid values: phy_status_delay_g3
	parameter bypass_rx_preset = "rx_preset_bypass",      // Valid values: rx_preset_bypass
	parameter bypass_tx_coefficent_data = 18'b0,      // Valid values: 18
	parameter bypass_pma_sw_done = "false",      // Valid values: false|true
	parameter bypass_send_syncp_fbkp = "false",      // Valid values: false|true
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter sup_mode = "user_mode",      // Valid values: user_mode|engr_mode
	parameter wait_pipe_synchronizing_data = 5'b10111,      // Valid values: 5
	parameter phy_status_delay_g12_data = 3'b0,      // Valid values: 3
	parameter free_run_clk_enable = "true",      // Valid values: false|true
	parameter phystatus_rst_toggle_g3 = "dis_phystatus_rst_toggle_g3",      // Valid values: dis_phystatus_rst_toggle_g3|en_phystatus_rst_toggle_g3
	parameter ind_error_reporting = "dis_ind_error_reporting",      // Valid values: dis_ind_error_reporting|en_ind_error_reporting
	parameter cp_cons_sel = "cp_cons_default",      // Valid values: cp_cons_master|cp_cons_slave_abv|cp_cons_slave_blw|cp_cons_default
	parameter bypass_tx_coefficent = "tx_coeff_bypass",      // Valid values: tx_coeff_bypass
	parameter phfifo_flush_wait = "phfifo_flush_wait",      // Valid values: phfifo_flush_wait
	parameter sigdet_wait_counter = "sigdet_wait_counter",      // Valid values: sigdet_wait_counter
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter pc_en_counter = "pc_en_count",      // Valid values: pc_en_count
	parameter rate_match_pad_insertion = "dis_rm_fifo_pad_ins",      // Valid values: dis_rm_fifo_pad_ins|en_rm_fifo_pad_ins
	parameter pipe_clk_sel = "func_clk",      // Valid values: disable_clk|dig_clk1_8g|func_clk
	parameter wait_clk_on_off_timer = "wait_clk_on_off_timer",      // Valid values: wait_clk_on_off_timer
	parameter bypass_rx_preset_enable = "false",      // Valid values: false|true
	parameter spd_chnge_g2_sel = "false",      // Valid values: false|true
	parameter parity_chk_ts1 = "en_ts1_parity_chk",      // Valid values: en_ts1_parity_chk|dis_ts1_parity_chk
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	input  [ 0:0 ] blkalgndint,
	output [ 0:0 ] blockselect,
	input  [ 10:0 ] bundlingindown,
	input  [ 10:0 ] bundlinginup,
	output [ 10:0 ] bundlingoutdown,
	output [ 10:0 ] bundlingoutup,
	input  [ 0:0 ] clkcompdeleteint,
	input  [ 0:0 ] clkcompinsertint,
	input  [ 0:0 ] clkcompoverflint,
	input  [ 0:0 ] clkcompundflint,
	input  [ 17:0 ] currentcoeff,
	input  [ 2:0 ] currentrxpreset,
	output [ 0:0 ] dispcbyte,
	input  [ 0:0 ] eidetint,
	input  [ 2:0 ] eidleinfersel,
	input  [ 0:0 ] eipartialdetint,
	input  [ 0:0 ] errdecodeint,
	input  [ 0:0 ] errencodeint,
	output [ 0:0 ] gen3clksel,
	output [ 0:0 ] gen3datasel,
	input  [ 0:0 ] hardresetn,
	input  [ 0:0 ] idetint,
	output [ 0:0 ] inferredrxvalidint,
	output [ 0:0 ] masktxpll,
	output [ 0:0 ] pcsrst,
	output [ 0:0 ] phystatus,
	input  [ 0:0 ] pldltr,
	input  [ 0:0 ] pllfixedclk,
	output [ 17:0 ] pmacurrentcoeff,
	output [ 2:0 ] pmacurrentrxpreset,
	output [ 0:0 ] pmaearlyeios,
	output [ 0:0 ] pmaltr,
	input  [ 1:0 ] pmapcieswdone,
	output [ 1:0 ] pmapcieswitch,
	input  [ 0:0 ] pmarxdetectvalid,
	output [ 0:0 ] pmarxdetpd,
	input  [ 0:0 ] pmarxfound,
	input  [ 0:0 ] pmasignaldet,
	output [ 0:0 ] pmatxdeemph,
	output [ 0:0 ] pmatxdetectrx,
	output [ 0:0 ] pmatxelecidle,
	output [ 2:0 ] pmatxmargin,
	output [ 0:0 ] pmatxswing,
	input  [ 1:0 ] powerdown,
	output [ 0:0 ] ppmcntrst8gpcsout,
	output [ 0:0 ] ppmeidleexit,
	input  [ 1:0 ] rate,
	input  [ 0:0 ] rcvdclk,
	input  [ 0:0 ] rcvlfsrchkint,
	output [ 0:0 ] resetpcprts,
	output [ 0:0 ] revlpbk8gpcsout,
	output [ 0:0 ] revlpbkint,
	input  [ 0:0 ] rrxdigclksel,
	input  [ 0:0 ] rrxgen3capen,
	input  [ 0:0 ] rtxdigclksel,
	input  [ 0:0 ] rtxgen3capen,
	output [ 3:0 ] rxblkstart,
	input  [ 0:0 ] rxblkstartint,
	input  [ 63:0 ] rxd8gpcsin,
	output [ 63:0 ] rxd8gpcsout,
	input  [ 31:0 ] rxdataint,
	input  [ 3:0 ] rxdatakint,
	output [ 3:0 ] rxdataskip,
	input  [ 0:0 ] rxdataskipint,
	output [ 0:0 ] rxelecidle,
	input  [ 0:0 ] rxelecidle8gpcsin,
	input  [ 0:0 ] rxpolarity,
	output [ 0:0 ] rxpolarity8gpcsout,
	output [ 0:0 ] rxpolarityint,
	input  [ 0:0 ] rxrstn,
	output [ 2:0 ] rxstatus,
	output [ 1:0 ] rxsynchdr,
	input  [ 1:0 ] rxsynchdrint,
	input  [ 19:0 ] rxtestout,
	input  [ 0:0 ] rxupdatefc,
	output [ 0:0 ] rxvalid,
	input  [ 0:0 ] scanmoden,
	output [ 0:0 ] shutdownclk,
	input  [ 0:0 ] speedchangeg2,
	output [ 18:0 ] testinfei,
	output [ 19:0 ] testout,
	input  [ 0:0 ] txblkstart,
	output [ 0:0 ] txblkstartint,
	input  [ 0:0 ] txcompliance,
	input  [ 31:0 ] txdata,
	output [ 31:0 ] txdataint,
	input  [ 3:0 ] txdatak,
	output [ 3:0 ] txdatakint,
	input  [ 0:0 ] txdataskip,
	output [ 0:0 ] txdataskipint,
	input  [ 0:0 ] txdeemph,
	input  [ 0:0 ] txdetectrxloopback,
	input  [ 0:0 ] txelecidle,
	input  [ 2:0 ] txmargin,
	input  [ 0:0 ] txpmaclk,
	output [ 0:0 ] txpmasyncp,
	input  [ 0:0 ] txpmasyncphip,
	input  [ 0:0 ] txrstn,
	input  [ 0:0 ] txswing,
	input  [ 1:0 ] txsynchdr,
	output [ 1:0 ] txsynchdrint
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pipe_gen3 : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pipe_gen3_encrypted_ES #(
				.ph_fifo_reg_mode(ph_fifo_reg_mode),
				.phfifo_flush_wait_data(phfifo_flush_wait_data),
				.bypass_rx_preset_data(bypass_rx_preset_data),
				.mode(mode),
				.test_out_sel(test_out_sel),
				.asn_enable(asn_enable),
				.ctrl_plane_bonding(ctrl_plane_bonding),
				.cp_dwn_mstr(cp_dwn_mstr),
				.rxvalid_mask(rxvalid_mask),
				.elecidle_delay_g3_data(elecidle_delay_g3_data),
				.phy_status_delay_g3_data(phy_status_delay_g3_data),
				.bypass_rx_detection_enable(bypass_rx_detection_enable),
				.wait_send_syncp_fbkp_data(wait_send_syncp_fbkp_data),
				.user_base_address(user_base_address),
				.wait_pipe_synchronizing(wait_pipe_synchronizing),
				.asn_clk_enable(asn_clk_enable),
				.pma_done_counter(pma_done_counter),
				.inf_ei_enable(inf_ei_enable),
				.cid_enable(cid_enable),
				.phy_status_delay_g12(phy_status_delay_g12),
				.pc_en_counter_data(pc_en_counter_data),
				.data_mask_count(data_mask_count),
				.data_mask_count_val(data_mask_count_val),
				.bypass_tx_coefficent_enable(bypass_tx_coefficent_enable),
				.wait_clk_on_off_timer_data(wait_clk_on_off_timer_data),
				.pc_rst_counter(pc_rst_counter),
				.phystatus_rst_toggle_g12(phystatus_rst_toggle_g12),
				.wait_send_syncp_fbkp(wait_send_syncp_fbkp),
				.elecidle_delay_g3(elecidle_delay_g3),
				.sigdet_wait_counter_data(sigdet_wait_counter_data),
				.cp_up_mstr(cp_up_mstr),
				.pma_done_counter_data(pma_done_counter_data),
				.test_mode_timers(test_mode_timers),
				.pc_rst_counter_data(pc_rst_counter_data),
				.cdr_control(cdr_control),
				.phy_status_delay_g3(phy_status_delay_g3),
				.bypass_rx_preset(bypass_rx_preset),
				.bypass_tx_coefficent_data(bypass_tx_coefficent_data),
				.bypass_pma_sw_done(bypass_pma_sw_done),
				.bypass_send_syncp_fbkp(bypass_send_syncp_fbkp),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.wait_pipe_synchronizing_data(wait_pipe_synchronizing_data),
				.phy_status_delay_g12_data(phy_status_delay_g12_data),
				.free_run_clk_enable(free_run_clk_enable),
				.phystatus_rst_toggle_g3(phystatus_rst_toggle_g3),
				.ind_error_reporting(ind_error_reporting),
				.cp_cons_sel(cp_cons_sel),
				.bypass_tx_coefficent(bypass_tx_coefficent),
				.phfifo_flush_wait(phfifo_flush_wait),
				.sigdet_wait_counter(sigdet_wait_counter),
				.use_default_base_address(use_default_base_address),
				.pc_en_counter(pc_en_counter),
				.rate_match_pad_insertion(rate_match_pad_insertion),
				.pipe_clk_sel(pipe_clk_sel),
				.wait_clk_on_off_timer(wait_clk_on_off_timer),
				.bypass_rx_preset_enable(bypass_rx_preset_enable),
				.spd_chnge_g2_sel(spd_chnge_g2_sel),
				.parity_chk_ts1(parity_chk_ts1)
			) stratixv_hssi_pipe_gen3_encrypted_ES_inst (
				.revlpbk8gpcsout(revlpbk8gpcsout),
				.rxdataskipint(rxdataskipint),
				.rxstatus(rxstatus),
				.clkcompoverflint(clkcompoverflint),
				.gen3datasel(gen3datasel),
				.rate(rate),
				.rxsynchdr(rxsynchdr),
				.rxblkstart(rxblkstart),
				.pmatxswing(pmatxswing),
				.pmatxelecidle(pmatxelecidle),
				.rcvlfsrchkint(rcvlfsrchkint),
				.inferredrxvalidint(inferredrxvalidint),
				.currentcoeff(currentcoeff),
				.bundlingindown(bundlingindown),
				.pmarxdetectvalid(pmarxdetectvalid),
				.txblkstartint(txblkstartint),
				.masktxpll(masktxpll),
				.txswing(txswing),
				.avmmwrite(avmmwrite),
				.dispcbyte(dispcbyte),
				.pllfixedclk(pllfixedclk),
				.pmaearlyeios(pmaearlyeios),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.rrxdigclksel(rrxdigclksel),
				.powerdown(powerdown),
				.idetint(idetint),
				.rxelecidle(rxelecidle),
				.clkcompinsertint(clkcompinsertint),
				.errencodeint(errencodeint),
				.rxdatakint(rxdatakint),
				.pldltr(pldltr),
				.rxsynchdrint(rxsynchdrint),
				.txpmasyncphip(txpmasyncphip),
				.txsynchdrint(txsynchdrint),
				.rxpolarity(rxpolarity),
				.rxd8gpcsin(rxd8gpcsin),
				.bundlinginup(bundlinginup),
				.speedchangeg2(speedchangeg2),
				.rxdataskip(rxdataskip),
				.bundlingoutdown(bundlingoutdown),
				.txdata(txdata),
				.txpmaclk(txpmaclk),
				.scanmoden(scanmoden),
				.txpmasyncp(txpmasyncp),
				.txdetectrxloopback(txdetectrxloopback),
				.txdataskip(txdataskip),
				.txblkstart(txblkstart),
				.testinfei(testinfei),
				.txdeemph(txdeemph),
				.avmmclk(avmmclk),
				.eipartialdetint(eipartialdetint),
				.pmasignaldet(pmasignaldet),
				.rxtestout(rxtestout),
				.revlpbkint(revlpbkint),
				.eidleinfersel(eidleinfersel),
				.rxdataint(rxdataint),
				.rxrstn(rxrstn),
				.avmmrstn(avmmrstn),
				.txcompliance(txcompliance),
				.avmmbyteen(avmmbyteen),
				.eidetint(eidetint),
				.pmatxmargin(pmatxmargin),
				.rxpolarity8gpcsout(rxpolarity8gpcsout),
				.testout(testout),
				.pcsrst(pcsrst),
				.pmarxdetpd(pmarxdetpd),
				.avmmreaddata(avmmreaddata),
				.txsynchdr(txsynchdr),
				.rxblkstartint(rxblkstartint),
				.pmapcieswdone(pmapcieswdone),
				.pmatxdetectrx(pmatxdetectrx),
				.avmmaddress(avmmaddress),
				.currentrxpreset(currentrxpreset),
				.rtxgen3capen(rtxgen3capen),
				.rxupdatefc(rxupdatefc),
				.txdatak(txdatak),
				.ppmeidleexit(ppmeidleexit),
				.gen3clksel(gen3clksel),
				.clkcompundflint(clkcompundflint),
				.txdatakint(txdatakint),
				.rxvalid(rxvalid),
				.rxd8gpcsout(rxd8gpcsout),
				.rtxdigclksel(rtxdigclksel),
				.pmatxdeemph(pmatxdeemph),
				.pmarxfound(pmarxfound),
				.rxpolarityint(rxpolarityint),
				.pmaltr(pmaltr),
				.shutdownclk(shutdownclk),
				.avmmread(avmmread),
				.rrxgen3capen(rrxgen3capen),
				.rxelecidle8gpcsin(rxelecidle8gpcsin),
				.blkalgndint(blkalgndint),
				.blockselect(blockselect),
				.rcvdclk(rcvdclk),
				.txrstn(txrstn),
				.pmacurrentrxpreset(pmacurrentrxpreset),
				.txdataint(txdataint),
				.errdecodeint(errdecodeint),
				.clkcompdeleteint(clkcompdeleteint),
				.resetpcprts(resetpcprts),
				.pmacurrentcoeff(pmacurrentcoeff),
				.phystatus(phystatus),
				.ppmcntrst8gpcsout(ppmcntrst8gpcsout),
				.pmapcieswitch(pmapcieswitch),
				.txdataskipint(txdataskipint),
				.txmargin(txmargin),
				.bundlingoutup(bundlingoutup),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pipe_gen3_encrypted #(
				.ph_fifo_reg_mode(ph_fifo_reg_mode),
				.phfifo_flush_wait_data(phfifo_flush_wait_data),
				.bypass_rx_preset_data(bypass_rx_preset_data),
				.mode(mode),
				.test_out_sel(test_out_sel),
				.asn_enable(asn_enable),
				.ctrl_plane_bonding(ctrl_plane_bonding),
				.cp_dwn_mstr(cp_dwn_mstr),
				.rxvalid_mask(rxvalid_mask),
				.elecidle_delay_g3_data(elecidle_delay_g3_data),
				.phy_status_delay_g3_data(phy_status_delay_g3_data),
				.bypass_rx_detection_enable(bypass_rx_detection_enable),
				.wait_send_syncp_fbkp_data(wait_send_syncp_fbkp_data),
				.user_base_address(user_base_address),
				.wait_pipe_synchronizing(wait_pipe_synchronizing),
				.asn_clk_enable(asn_clk_enable),
				.pma_done_counter(pma_done_counter),
				.inf_ei_enable(inf_ei_enable),
				.cid_enable(cid_enable),
				.phy_status_delay_g12(phy_status_delay_g12),
				.pc_en_counter_data(pc_en_counter_data),
				.data_mask_count(data_mask_count),
				.data_mask_count_val(data_mask_count_val),
				.bypass_tx_coefficent_enable(bypass_tx_coefficent_enable),
				.wait_clk_on_off_timer_data(wait_clk_on_off_timer_data),
				.pc_rst_counter(pc_rst_counter),
				.phystatus_rst_toggle_g12(phystatus_rst_toggle_g12),
				.wait_send_syncp_fbkp(wait_send_syncp_fbkp),
				.elecidle_delay_g3(elecidle_delay_g3),
				.sigdet_wait_counter_data(sigdet_wait_counter_data),
				.cp_up_mstr(cp_up_mstr),
				.pma_done_counter_data(pma_done_counter_data),
				.test_mode_timers(test_mode_timers),
				.pc_rst_counter_data(pc_rst_counter_data),
				.cdr_control(cdr_control),
				.phy_status_delay_g3(phy_status_delay_g3),
				.bypass_rx_preset(bypass_rx_preset),
				.bypass_tx_coefficent_data(bypass_tx_coefficent_data),
				.bypass_pma_sw_done(bypass_pma_sw_done),
				.bypass_send_syncp_fbkp(bypass_send_syncp_fbkp),
				.avmm_group_channel_index(avmm_group_channel_index),
				.sup_mode(sup_mode),
				.wait_pipe_synchronizing_data(wait_pipe_synchronizing_data),
				.phy_status_delay_g12_data(phy_status_delay_g12_data),
				.free_run_clk_enable(free_run_clk_enable),
				.phystatus_rst_toggle_g3(phystatus_rst_toggle_g3),
				.ind_error_reporting(ind_error_reporting),
				.cp_cons_sel(cp_cons_sel),
				.bypass_tx_coefficent(bypass_tx_coefficent),
				.phfifo_flush_wait(phfifo_flush_wait),
				.sigdet_wait_counter(sigdet_wait_counter),
				.use_default_base_address(use_default_base_address),
				.pc_en_counter(pc_en_counter),
				.rate_match_pad_insertion(rate_match_pad_insertion),
				.pipe_clk_sel(pipe_clk_sel),
				.wait_clk_on_off_timer(wait_clk_on_off_timer),
				.bypass_rx_preset_enable(bypass_rx_preset_enable),
				.spd_chnge_g2_sel(spd_chnge_g2_sel),
				.parity_chk_ts1(parity_chk_ts1)
			) stratixv_hssi_pipe_gen3_encrypted_inst (
				.revlpbk8gpcsout(revlpbk8gpcsout),
				.rxdataskipint(rxdataskipint),
				.rxstatus(rxstatus),
				.clkcompoverflint(clkcompoverflint),
				.gen3datasel(gen3datasel),
				.rate(rate),
				.rxsynchdr(rxsynchdr),
				.rxblkstart(rxblkstart),
				.pmatxswing(pmatxswing),
				.pmatxelecidle(pmatxelecidle),
				.rcvlfsrchkint(rcvlfsrchkint),
				.inferredrxvalidint(inferredrxvalidint),
				.currentcoeff(currentcoeff),
				.bundlingindown(bundlingindown),
				.pmarxdetectvalid(pmarxdetectvalid),
				.txblkstartint(txblkstartint),
				.masktxpll(masktxpll),
				.txswing(txswing),
				.avmmwrite(avmmwrite),
				.dispcbyte(dispcbyte),
				.pllfixedclk(pllfixedclk),
				.pmaearlyeios(pmaearlyeios),
				.txelecidle(txelecidle),
				.hardresetn(hardresetn),
				.rrxdigclksel(rrxdigclksel),
				.powerdown(powerdown),
				.idetint(idetint),
				.rxelecidle(rxelecidle),
				.clkcompinsertint(clkcompinsertint),
				.errencodeint(errencodeint),
				.rxdatakint(rxdatakint),
				.pldltr(pldltr),
				.rxsynchdrint(rxsynchdrint),
				.txpmasyncphip(txpmasyncphip),
				.txsynchdrint(txsynchdrint),
				.rxpolarity(rxpolarity),
				.rxd8gpcsin(rxd8gpcsin),
				.bundlinginup(bundlinginup),
				.speedchangeg2(speedchangeg2),
				.rxdataskip(rxdataskip),
				.bundlingoutdown(bundlingoutdown),
				.txdata(txdata),
				.txpmaclk(txpmaclk),
				.scanmoden(scanmoden),
				.txpmasyncp(txpmasyncp),
				.txdetectrxloopback(txdetectrxloopback),
				.txdataskip(txdataskip),
				.txblkstart(txblkstart),
				.testinfei(testinfei),
				.txdeemph(txdeemph),
				.avmmclk(avmmclk),
				.eipartialdetint(eipartialdetint),
				.pmasignaldet(pmasignaldet),
				.rxtestout(rxtestout),
				.revlpbkint(revlpbkint),
				.eidleinfersel(eidleinfersel),
				.rxdataint(rxdataint),
				.rxrstn(rxrstn),
				.avmmrstn(avmmrstn),
				.txcompliance(txcompliance),
				.avmmbyteen(avmmbyteen),
				.eidetint(eidetint),
				.pmatxmargin(pmatxmargin),
				.rxpolarity8gpcsout(rxpolarity8gpcsout),
				.testout(testout),
				.pcsrst(pcsrst),
				.pmarxdetpd(pmarxdetpd),
				.avmmreaddata(avmmreaddata),
				.txsynchdr(txsynchdr),
				.rxblkstartint(rxblkstartint),
				.pmapcieswdone(pmapcieswdone),
				.pmatxdetectrx(pmatxdetectrx),
				.avmmaddress(avmmaddress),
				.currentrxpreset(currentrxpreset),
				.rtxgen3capen(rtxgen3capen),
				.rxupdatefc(rxupdatefc),
				.txdatak(txdatak),
				.ppmeidleexit(ppmeidleexit),
				.gen3clksel(gen3clksel),
				.clkcompundflint(clkcompundflint),
				.txdatakint(txdatakint),
				.rxvalid(rxvalid),
				.rxd8gpcsout(rxd8gpcsout),
				.rtxdigclksel(rtxdigclksel),
				.pmatxdeemph(pmatxdeemph),
				.pmarxfound(pmarxfound),
				.rxpolarityint(rxpolarityint),
				.pmaltr(pmaltr),
				.shutdownclk(shutdownclk),
				.avmmread(avmmread),
				.rrxgen3capen(rrxgen3capen),
				.rxelecidle8gpcsin(rxelecidle8gpcsin),
				.blkalgndint(blkalgndint),
				.blockselect(blockselect),
				.rcvdclk(rcvdclk),
				.txrstn(txrstn),
				.pmacurrentrxpreset(pmacurrentrxpreset),
				.txdataint(txdataint),
				.errdecodeint(errdecodeint),
				.clkcompdeleteint(clkcompdeleteint),
				.resetpcprts(resetpcprts),
				.pmacurrentcoeff(pmacurrentcoeff),
				.phystatus(phystatus),
				.ppmcntrst8gpcsout(ppmcntrst8gpcsout),
				.pmapcieswitch(pmapcieswitch),
				.txdataskipint(txdataskipint),
				.txmargin(txmargin),
				.bundlingoutup(bundlingoutup),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_cdr_att_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_cdr_att
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
    parameter refclk_sel = "refclk", //Valid values: refclk|pldclkatt|refclkatt
	parameter bbpd_salatch_offset_ctrl_clk90 = "offset_0mv",      // Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter pd_l_counter = 1,      // Valid values: 1
	parameter rxpll_pd_bw_ctrl = 320,      // Valid values: 320|180|140|100
	parameter output_clock_frequency = "",      // Valid values: 
	parameter ripple_cap_ctrl = "none",      // Valid values: reserved_11|reserved_10|plus_2pf|none
	parameter reverse_serial_lpbk = "false",      // Valid values: false|true
	parameter ref_clk_div = -1,      // Valid values: 1|2|4|8
	parameter ignore_phslock = "false",      // Valid values: false|true
	parameter pd_charge_pump_current_ctrl = 5,      // Valid values: 5|10|20|30|40
	parameter bbpd_salatch_offset_ctrl_clk180 = "offset_0mv",      // Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk270 = "offset_0mv",      // Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter bbpd_salatch_offset_ctrl_clk0 = "offset_0mv",      // Valid values: offset_0mv|offset_delta1_left|offset_delta2_left|offset_delta3_left|offset_delta4_left|offset_delta5_left|offset_delta6_left|offset_delta7_left|offset_delta1_right|offset_delta2_right|offset_delta3_right|offset_delta4_right|offset_delta5_right|offset_delta6_right|offset_delta7_right
	parameter diag_rev_lpbk = "false",      // Valid values: false|true
	parameter replica_bias_ctrl = "true",      // Valid values: false|true
	parameter m_counter = -1,      // Valid values: 1|4|5|8|10|12|16|20|25|32|40|50
	parameter pfd_charge_pump_current_ctrl = 20,      // Valid values: 5|10|20|30|40|50|60|80|100|120|160|180|200|240|300|320|400
	parameter clklow_fref_to_ppm_div_sel = 4,      // Valid values: 1|2|4
	parameter reverse_loopback = "reverse_lpbk_cdr",      // Valid values: reverse_lpbk_cdr|reverse_lpbk_rx
	parameter charge_pump_current_test = "enable_ch_pump_normal",      // Valid values: enable_ch_pump_normal|enable_ch_pump_curr_test_up|enable_ch_pump_curr_test_down|disable_ch_pump_curr_test
	parameter cdr_atb_select = "atb_disable",      // Valid values: atb_disable|atb_sel_1|atb_sel_2|atb_sel_3|atb_sel_4|atb_sel_5|atb_sel_6|atb_sel_7|atb_sel_8|atb_sel_9|atb_sel_10|atb_sel_11|atb_sel_12|atb_sel_13|atb_sel_14|atb_sel_15
	parameter rxpll_pfd_bw_ctrl = 3200,      // Valid values: 1600|3200|6400|9600
	parameter powerdown = 1'b1,      // Valid values: 1
	parameter pfd_l_counter = 1,      // Valid values: 1|2
	parameter fast_lock_mode = "false",      // Valid values: false|true
	parameter regulator_volt_inc = "0",      // Valid values: 0|5|10|15|20|25|30|not_used
	parameter bypass_cp_rgla = "false",      // Valid values: false|true
	parameter fb_sel = "vcoclk",      // Valid values: vcoclk|extclk
	parameter force_vco_const = "v1p39",      // Valid values: v0p58|v0p64|v0p67|v0p70|v0p75|v0p81|v0p87|v0p93|v0p86|v0p96|v1p00|v1p04|v1p13|v1p22|v1p30|v1p39|v0p00
	parameter bbpd_salatch_sel = "normal",      // Valid values: sa_sel|normal
	parameter reference_clock_frequency = "",      // Valid values: 
	parameter hs_levshift_power_supply_setting = 1,      // Valid values: 0|1|2|3
	parameter ppmsel = "ppmsel_100",      // Valid values: ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
	parameter ppm_lock_sel = "pcs_ppm_lock",      // Valid values: pcs_ppm_lock|core_ppm_lock
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter cdr_or_eyeq_sel = "normal_cdr_path"	//Valid values: normal_cdr_path|eyeq_path
)
(
	output [ 0:0 ] ck0pd,
	output [ 0:0 ] ck180pd,
	output [ 0:0 ] ck270pd,
	output [ 0:0 ] ck90pd,
	output [ 0:0 ] clk270bout,
	output [ 0:0 ] clk90bout,
	output [ 0:0 ] clklow,
	input  [ 0:0 ] crurstb,
	output [ 0:0 ] devenadiv2p,
	output [ 0:0 ] devenbdiv2p,
	output [ 0:0 ] devenout,
	output [ 0:0 ] div2270,
	output [ 0:0 ] doddadiv2p,
	output [ 0:0 ] doddbdiv2p,
	output [ 0:0 ] doddout,
	output [ 0:0 ] fref,
	input  [ 0:0 ] ltd,
	input  [ 0:0 ] ltr,
	output [ 3:0 ] pdof,
	output [ 0:0 ] pfdmodelock,
	input  [ 0:0 ] ppmlock,
	input  [ 0:0 ] refclk,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] rxp,
	output [ 0:0 ] rxplllock,
	output [ 0:0 ] txrlpbk,
	input  [ 0:0 ] discdrreset,
	input  [ 0:0 ] pldclkatt,
	input  [ 0:0 ] refclkatt
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_cdr_att : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_cdr_att_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
                .refclk_sel(refclk_sel),
				.bbpd_salatch_offset_ctrl_clk90(bbpd_salatch_offset_ctrl_clk90),
				.pd_l_counter(pd_l_counter),
				.rxpll_pd_bw_ctrl(rxpll_pd_bw_ctrl),
				.output_clock_frequency(output_clock_frequency),
				.ripple_cap_ctrl(ripple_cap_ctrl),
				.reverse_serial_lpbk(reverse_serial_lpbk),
				.ref_clk_div(ref_clk_div),
				.ignore_phslock(ignore_phslock),
				.pd_charge_pump_current_ctrl(pd_charge_pump_current_ctrl),
				.bbpd_salatch_offset_ctrl_clk180(bbpd_salatch_offset_ctrl_clk180),
				.bbpd_salatch_offset_ctrl_clk270(bbpd_salatch_offset_ctrl_clk270),
				.bbpd_salatch_offset_ctrl_clk0(bbpd_salatch_offset_ctrl_clk0),
				.diag_rev_lpbk(diag_rev_lpbk),
				.replica_bias_ctrl(replica_bias_ctrl),
				.m_counter(m_counter),
				.pfd_charge_pump_current_ctrl(pfd_charge_pump_current_ctrl),
				.clklow_fref_to_ppm_div_sel(clklow_fref_to_ppm_div_sel),
				.reverse_loopback(reverse_loopback),
				.charge_pump_current_test(charge_pump_current_test),
				.cdr_atb_select(cdr_atb_select),
				.rxpll_pfd_bw_ctrl(rxpll_pfd_bw_ctrl),
				.powerdown(powerdown),
				.pfd_l_counter(pfd_l_counter),
				.fast_lock_mode(fast_lock_mode),
				.regulator_volt_inc(regulator_volt_inc),
				.bypass_cp_rgla(bypass_cp_rgla),
				.fb_sel(fb_sel),
				.force_vco_const(force_vco_const),
				.bbpd_salatch_sel(bbpd_salatch_sel),
				.reference_clock_frequency(reference_clock_frequency),
				.hs_levshift_power_supply_setting(hs_levshift_power_supply_setting)
			) stratixv_hssi_pma_cdr_att_encrypted_ES_inst (
				.fref(fref),
				.ck0pd(ck0pd),
				.ltd(ltd),
				.txrlpbk(txrlpbk),
				.clklow(clklow),
				.pfdmodelock(pfdmodelock),
				.doddbdiv2p(doddbdiv2p),
				.ltr(ltr),
				.doddadiv2p(doddadiv2p),
				.ck180pd(ck180pd),
				.devenadiv2p(devenadiv2p),
				.devenout(devenout),
				.devenbdiv2p(devenbdiv2p),
				.rstn(rstn),
				.rxplllock(rxplllock),
				.div2270(div2270),
				.crurstb(crurstb),
				.rxp(rxp),
				.ck270pd(ck270pd),
				.clk270bout(clk270bout),
				.refclk(refclk),
				.clk90bout(clk90bout),
				.ck90pd(ck90pd),
				.doddout(doddout),
				.ppmlock(ppmlock),
				.pdof(pdof)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_cdr_att_encrypted #(
                .enable_debug_info(enable_debug_info),
                .refclk_sel(refclk_sel),
				.pd_l_counter(pd_l_counter),
				.rxpll_pd_bw_ctrl(rxpll_pd_bw_ctrl),
				.ppmsel(ppmsel),
				.ppm_lock_sel(ppm_lock_sel),
				.ref_clk_div(ref_clk_div),
				.pd_charge_pump_current_ctrl(pd_charge_pump_current_ctrl),
				.bbpd_salatch_offset_ctrl_clk180(bbpd_salatch_offset_ctrl_clk180),
				.bbpd_salatch_offset_ctrl_clk270(bbpd_salatch_offset_ctrl_clk270),
				.bbpd_salatch_offset_ctrl_clk0(bbpd_salatch_offset_ctrl_clk0),
				.replica_bias_ctrl(replica_bias_ctrl),
				.charge_pump_current_test(charge_pump_current_test),
				.powerdown(powerdown),
				.pfd_l_counter(pfd_l_counter),
				.fast_lock_mode(fast_lock_mode),
				.regulator_volt_inc(regulator_volt_inc),
				.fb_sel(fb_sel),
				.hs_levshift_power_supply_setting(hs_levshift_power_supply_setting),
				.bbpd_salatch_sel(bbpd_salatch_sel),
				.reference_clock_frequency(reference_clock_frequency),
				.bbpd_salatch_offset_ctrl_clk90(bbpd_salatch_offset_ctrl_clk90),
				.output_clock_frequency(output_clock_frequency),
				.ripple_cap_ctrl(ripple_cap_ctrl),
				.ignore_phslock(ignore_phslock),
				.reverse_serial_lpbk(reverse_serial_lpbk),
				.diag_rev_lpbk(diag_rev_lpbk),
				.m_counter(m_counter),
				.pfd_charge_pump_current_ctrl(pfd_charge_pump_current_ctrl),
				.clklow_fref_to_ppm_div_sel(clklow_fref_to_ppm_div_sel),
				.cdr_atb_select(cdr_atb_select),
				.reverse_loopback(reverse_loopback),
				.rxpll_pfd_bw_ctrl(rxpll_pfd_bw_ctrl),
				.bypass_cp_rgla(bypass_cp_rgla),
				.force_vco_const(force_vco_const)
			) stratixv_hssi_pma_cdr_att_encrypted_inst (
				.fref(fref),
				.ck0pd(ck0pd),
				.pldclkatt(pldclkatt),
				.ltd(ltd),
				.txrlpbk(txrlpbk),
				.discdrreset(discdrreset),
				.clklow(clklow),
				.pfdmodelock(pfdmodelock),
				.doddbdiv2p(doddbdiv2p),
				.ltr(ltr),
				.doddadiv2p(doddadiv2p),
				.ck180pd(ck180pd),
				.devenadiv2p(devenadiv2p),
				.devenout(devenout),
				.devenbdiv2p(devenbdiv2p),
				.rstn(rstn),
				.rxplllock(rxplllock),
				.div2270(div2270),
				.crurstb(crurstb),
				.rxp(rxp),
				.ck270pd(ck270pd),
				.clk270bout(clk270bout),
				.refclk(refclk),
				.clk90bout(clk90bout),
				.ck90pd(ck90pd),
				.doddout(doddout),
				.ppmlock(ppmlock),
				.refclkatt(refclkatt),
				.pdof(pdof)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_deser_att_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_deser_att
#(
	parameter vcobypass = "clk_divrx",      // Valid values: clk_divrx|clklow|fref
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter serializer_clk_inv = "non_inv_clk"	//Valid values: non_inv_clk|inv_clk
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkdivrx,
	output [ 127:0 ] dataout,
	input  [ 0:0 ] devenadiv2n,
	input  [ 0:0 ] devenadiv2p,
	input  [ 0:0 ] devenbdiv2n,
	input  [ 0:0 ] devenbdiv2p,
	input  [ 0:0 ] div2270,
	input  [ 0:0 ] div2270n,
	input  [ 0:0 ] doddadiv2n,
	input  [ 0:0 ] doddadiv2p,
	input  [ 0:0 ] doddbdiv2n,
	input  [ 0:0 ] doddbdiv2p,
	output [ 0:0 ] observableasyncdata,
	output [ 0:0 ] observableintclk,
	input  [ 0:0 ] rstn
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_deser_att : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_deser_att_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.vcobypass(vcobypass)
			) stratixv_hssi_pma_deser_att_encrypted_ES_inst (
				.clkdivrx(clkdivrx),
				.avmmclk(avmmclk),
				.devenadiv2n(devenadiv2n),
				.div2270n(div2270n),
				.avmmrstn(avmmrstn),
				.devenbdiv2n(devenbdiv2n),
				.avmmbyteen(avmmbyteen),
				.doddbdiv2p(doddbdiv2p),
				.doddadiv2p(doddadiv2p),
				.devenadiv2p(devenadiv2p),
				.dataout(dataout),
				.rstn(rstn),
				.devenbdiv2p(devenbdiv2p),
				.avmmread(avmmread),
				.div2270(div2270),
				.doddadiv2n(doddadiv2n),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.doddbdiv2n(doddbdiv2n),
				.avmmwrite(avmmwrite),
				.observableintclk(observableintclk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_deser_att_encrypted #(
                .enable_debug_info(enable_debug_info),
				.vcobypass(vcobypass)
			) stratixv_hssi_pma_deser_att_encrypted_inst (
				.clkdivrx(clkdivrx),
				.avmmclk(avmmclk),
				.devenadiv2n(devenadiv2n),
				.div2270n(div2270n),
				.avmmrstn(avmmrstn),
				.devenbdiv2n(devenbdiv2n),
				.avmmbyteen(avmmbyteen),
				.doddbdiv2p(doddbdiv2p),
				.doddadiv2p(doddadiv2p),
				.devenadiv2p(devenadiv2p),
				.dataout(dataout),
				.rstn(rstn),
				.devenbdiv2p(devenbdiv2p),
				.avmmread(avmmread),
				.div2270(div2270),
				.doddadiv2n(doddadiv2n),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.doddbdiv2n(doddbdiv2n),
				.avmmwrite(avmmwrite),
				.observableintclk(observableintclk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_rx_att_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_rx_att
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter var_bulk1 = "eq1_var_bulk0",      // Valid values: eq1_var_bulk0|eq1_var_bulk1|eq1_var_bulk2|eq1_var_bulk3|eq1_var_bulk4|eq1_var_bulk5|eq1_var_bulk6|eq1_var_bulk7|eq1_var_bulk8|eq1_var_bulk9|eq1_var_bulk10|eq1_var_bulk11|eq1_var_bulk12|eq1_var_bulk13|eq1_var_bulk14|eq1_var_bulk15
	parameter vcm_pdnb = "lsb_lo_vcm_current",      // Valid values: lsb_lo_vcm_current|lsb_hi_vcm_current
	parameter offcomp_cmref = "off_comp_vcm0",      // Valid values: off_comp_vcm0|off_comp_vcm1|off_comp_vcm2|off_comp_vcm3
	parameter var_gate2 = "eq2_var_gate0",      // Valid values: eq2_var_gate0|eq2_var_gate1|eq2_var_gate2|eq2_var_gate3|eq2_var_gate4|eq2_var_gate5|eq2_var_gate6|eq2_var_gate7|eq2_var_gate8|eq2_var_gate9|eq2_var_gate10|eq2_var_gate11|eq2_var_gate12|eq2_var_gate13|eq2_var_gate14|eq2_var_gate15
	parameter var_bulk0 = "eq0_var_bulk0",      // Valid values: eq0_var_bulk0|eq0_var_bulk1|eq0_var_bulk2|eq0_var_bulk3|eq0_var_bulk4|eq0_var_bulk5|eq0_var_bulk6|eq0_var_bulk7|eq0_var_bulk8|eq0_var_bulk9|eq0_var_bulk10|eq0_var_bulk11|eq0_var_bulk12|eq0_var_bulk13|eq0_var_bulk14|eq0_var_bulk15
	parameter eq_bias_adj = "i_eqbias_def",      // Valid values: i_eqbias_def|i_eqbias_m33|i_eqbias_p33|i_eqbias_m20
	parameter atb_sel = "atb_off",      // Valid values: atb_off|atb_sel0|atb_sel1|atb_sel2|atb_sel3|atb_sel4|atb_sel5|atb_sel6|atb_sel7|atb_sel8|atb_sel9|atb_sel10|atb_sel11|atb_sel12|atb_sel13|atb_sel14|atb_sel15|atb_sel16|atb_sel17|atb_selunused2|atb_selunused3|atb_selunused4|atb_selunused5|atb_selunused6|atb_selunused7|atb_selunused8|atb_selunused9|atb_selunused10|atb_selunused11|atb_selunused12|atb_selunused13|atb_selunused14
	parameter eq1_dc_gain = "eq1_gain_min",      // Valid values: eq1_gain_min|eq1_gain_set1|eq1_gain_set2|eq1_gain_max
	parameter vcm_pup = "msb_lo_vcm_current",      // Valid values: msb_lo_vcm_current|msb_hi_vcm_current
	parameter off_filter_cap = "off_filt_cap0",      // Valid values: off_filt_cap0|off_filt_cap1
	parameter rx_pdb = "power_down_rx",      // Valid values: normal_rx_on|power_down_rx
	parameter var_gate1 = "eq1_var_gate0",      // Valid values: eq1_var_gate0|eq1_var_gate1|eq1_var_gate2|eq1_var_gate3|eq1_var_gate4|eq1_var_gate5|eq1_var_gate6|eq1_var_gate7|eq1_var_gate8|eq1_var_gate9|eq1_var_gate10|eq1_var_gate11|eq1_var_gate12|eq1_var_gate13|eq1_var_gate14|eq1_var_gate15
	parameter diag_rev_lpbk = "no_diag_rev_loopback",      // Valid values: no_diag_rev_loopback|diag_rev_loopback
	parameter eqz3_pd = "eqz3shrt_dis",      // Valid values: eqz3shrt_dis|eqz3shrt_en
	parameter eq2_dc_gain = "eq2_gain_min",      // Valid values: eq2_gain_min|eq2_gain_set1|eq2_gain_set2|eq2_gain_max
	parameter offcomp_igain = "off_comp_ig0",      // Valid values: off_comp_ig0|off_comp_ig1|off_comp_ig2|off_comp_ig3
	parameter var_bulk2 = "eq2_var_bulk0",      // Valid values: eq2_var_bulk0|eq2_var_bulk1|eq2_var_bulk2|eq2_var_bulk3|eq2_var_bulk4|eq2_var_bulk5|eq2_var_bulk6|eq2_var_bulk7|eq2_var_bulk8|eq2_var_bulk9|eq2_var_bulk10|eq2_var_bulk11|eq2_var_bulk12|eq2_var_bulk13|eq2_var_bulk14|eq2_var_bulk15
	parameter offset_correct = "offcorr_dis",      // Valid values: offcorr_dis|eq_stg1_pd|dig_corr_hold|eq1_pd_dcorr_en|only_acorr_en|dig_ana_corr_en
	parameter rload_shunt = "rld000",      // Valid values: rld000|rld001|rld002|rld003|rld004|rld005|rld006|rld007
	parameter rxterm_ctl = "rxterm_dis",      // Valid values: rxterm_dis|rxterm_en
	parameter rx_vcm = "vtt_0p7v",      // Valid values: vtt_0p8v|vtt_0p75v|vtt_0p7v|vtt_0p65v|vtt_0p6v|vtt_0p55v|vtt_0p5v|vtt_0p35v|vtt_vcmoff7|vtt_vcmoff6|vtt_vcmoff5|vtt_vcmoff4|vtt_vcmoff3|vtt_vcmoff2|vtt_vcmoff1|vtt_vcmoff0
	parameter off_filter_res = "off_filt_res0",      // Valid values: off_filt_res0|off_filt_res1|off_filt_res2|off_filt_res3
	parameter eq0_dc_gain = "eq0_gain_min",      // Valid values: eq0_gain_min|eq0_gain_set1|eq0_gain_set2|eq0_gain_max
	parameter rxterm_set = "def_rterm",      // Valid values: max_rterm|rterm_14|rterm_13|rterm_12|rterm_11|rterm_10|rterm_9|def_rterm|rterm_7|rterm_6|rterm_5|rterm_4|rterm_3|rterm_2|rterm_1|min_rterm
	parameter rzero_shunt = "rz0",      // Valid values: rz0|rz1
	parameter diag_loopbk_bias = "dlb_bw0",      // Valid values: dlb_bw0|dlb_bw_p33|dlb_bw_m33|dlb_bw3
	parameter var_gate0 = "eq0_var_gate0",      // Valid values: eq0_var_gate0|eq0_var_gate1|eq0_var_gate2|eq0_var_gate3|eq0_var_gate4|eq0_var_gate5|eq0_var_gate6|eq0_var_gate7|eq0_var_gate8|eq0_var_gate9|eq0_var_gate10|eq0_var_gate11|eq0_var_gate12|eq0_var_gate13|eq0_var_gate14|eq0_var_gate15
	parameter offset_cancellation_ctrl = "volt_0mv",      // Valid values: volt_0mv|minus_delta1|minus_delta2|minus_delta3|minus_delta4|minus_delta5|minus_delta6|minus_delta7|minus_delta8|minus_delta9|minus_delta10|minus_delta11|minus_delta12|minus_delta13|minus_delta14|minus_delta15|plus_delta1|plus_delta2|plus_delta3|plus_delta4|plus_delta5|plus_delta6|plus_delta7|plus_delta8|plus_delta9|plus_delta10|plus_delta11|plus_delta12|plus_delta13|plus_delta14|plus_delta15
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter eye_pdb_att = "power_down_eye",	//Valid values: normal_eye_on|power_down_eye
	parameter vert_threshold_att = "vert_0mv",	//Valid values: vert_0mv|vert_10mv|vert_20mv|vert_30mv|vert_40mv|vert_50mv|vert_60mv|vert_70mv|vert_80mv|vert_90mv|vert_100mv|vert_110mv|vert_120mv|vert_130mv|vert_140mv|vert_150mv|vert_160mv|vert_170mv|vert_180mv|vert_190mv|vert_200mv|vert_210mv|vert_220mv|vert_230mv|vert_240mv|vert_250mv|vert_260mv|vert_270mv|vert_280mv|vert_290mv|vert_300mv|vert_310mv|vert_320mv|vert_330mv|vert_340mv|vert_350mv|vert_360mv|vert_370mv|vert_380mv|vert_390mv|vert_400mv|vert_410mv|vert_420mv|vert_430mv|vert_440mv|vert_450mv|vert_460mv|vert_470mv|vert_480mv|vert_490mv|vert_500mv|vert_510mv|vert_520mv|vert_530mv|vert_540mv|vert_550mv|vert_560mv|vert_570mv|vert_580mv|vert_590mv|vert_600mv|vert_610mv|vert_620mv|vert_630mv
	parameter v_vert_threshold_scaling_att = "scale_plus_1p0",	//Valid values: scale_minus_0p6|scale_minus_0p7|scale_minus_0p8|scale_minus_1p0|scale_plus_0p6|scale_plus_0p7|scale_plus_0p8|scale_plus_1p0
	parameter phase_steps_sel_att = "step20",	//Valid values: step1|step2|step3|step4|step5|step6|step7|step8|step9|step10|step11|step12|step13|step14|step15|step16|step17|step18|step19|step20|step21|step22|step23|step24|step25|step26|step27|step28|step29|step30|step31|step32|step33|step34|step35|step36|step37|step38|step39|step40|step41|step42|step43|step44|step45|step46|step47|step48|step49|step50|step51|step52|step53|step54|step55|step56|step57|step58|step59|step60|step61|step62|step63|step64
	parameter bit_error_check_enable_att = "bit_err_chk_disable"	//Valid values: bit_err_chk_enable|bit_err_chk_disable
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] lpbkn,
	input  [ 0:0 ] lpbkp,
	input  [ 0:0 ] nonuserfrompmaux,
	input  [ 0:0 ] ocden,
	output [ 0:0 ] outnbidirout,
	output [ 0:0 ] outpbidirout,
	output [ 0:0 ] rdlpbkn,
	output [ 0:0 ] rdlpbkp,
	input  [ 0:0 ] rxnbidirin,
	input  [ 0:0 ] rxpbidirin,
	input  [ 0:0 ] slpbk
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_rx_att : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_rx_att_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.var_bulk1(var_bulk1),
				.vcm_pdnb(vcm_pdnb),
				.offcomp_cmref(offcomp_cmref),
				.var_gate2(var_gate2),
				.var_bulk0(var_bulk0),
				.eq_bias_adj(eq_bias_adj),
				.atb_sel(atb_sel),
				.eq1_dc_gain(eq1_dc_gain),
				.vcm_pup(vcm_pup),
				.off_filter_cap(off_filter_cap),
				.rx_pdb(rx_pdb),
				.var_gate1(var_gate1),
				.diag_rev_lpbk(diag_rev_lpbk),
				.eqz3_pd(eqz3_pd),
				.eq2_dc_gain(eq2_dc_gain),
				.offcomp_igain(offcomp_igain),
				.var_bulk2(var_bulk2),
				.offset_correct(offset_correct),
				.rload_shunt(rload_shunt),
				.rxterm_ctl(rxterm_ctl),
				.rx_vcm(rx_vcm),
				.off_filter_res(off_filter_res),
				.eq0_dc_gain(eq0_dc_gain),
				.rxterm_set(rxterm_set),
				.rzero_shunt(rzero_shunt),
				.diag_loopbk_bias(diag_loopbk_bias),
				.var_gate0(var_gate0),
				.offset_cancellation_ctrl(offset_cancellation_ctrl)
			) stratixv_hssi_pma_rx_att_encrypted_ES_inst (
				.rdlpbkp(rdlpbkp),
				.avmmclk(avmmclk),
				.rxnbidirin(rxnbidirin),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.outpbidirout(outpbidirout),
				.rdlpbkn(rdlpbkn),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.lpbkp(lpbkp),
				.avmmreaddata(avmmreaddata),
				.outnbidirout(outnbidirout),
				.lpbkn(lpbkn),
				.rxpbidirin(rxpbidirin),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata),
				.ocden(ocden)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_rx_att_encrypted #(
                .enable_debug_info(enable_debug_info),
				.var_bulk1(var_bulk1),
				.vcm_pdnb(vcm_pdnb),
				.offcomp_cmref(offcomp_cmref),
				.var_gate2(var_gate2),
				.var_bulk0(var_bulk0),
				.eq_bias_adj(eq_bias_adj),
				.atb_sel(atb_sel),
				.eq1_dc_gain(eq1_dc_gain),
				.vcm_pup(vcm_pup),
				.off_filter_cap(off_filter_cap),
				.rx_pdb(rx_pdb),
				.var_gate1(var_gate1),
				.diag_rev_lpbk(diag_rev_lpbk),
				.eqz3_pd(eqz3_pd),
				.eq2_dc_gain(eq2_dc_gain),
				.offcomp_igain(offcomp_igain),
				.var_bulk2(var_bulk2),
				.offset_correct(offset_correct),
				.rload_shunt(rload_shunt),
				.rxterm_ctl(rxterm_ctl),
				.rx_vcm(rx_vcm),
				.off_filter_res(off_filter_res),
				.eq0_dc_gain(eq0_dc_gain),
				.rxterm_set(rxterm_set),
				.rzero_shunt(rzero_shunt),
				.diag_loopbk_bias(diag_loopbk_bias),
				.var_gate0(var_gate0),
				.offset_cancellation_ctrl(offset_cancellation_ctrl)
			) stratixv_hssi_pma_rx_att_encrypted_inst (
				.rdlpbkp(rdlpbkp),
				.avmmclk(avmmclk),
				.rxnbidirin(rxnbidirin),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.outpbidirout(outpbidirout),
				.rdlpbkn(rdlpbkn),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.lpbkp(lpbkp),
				.avmmreaddata(avmmreaddata),
				.outnbidirout(outnbidirout),
				.lpbkn(lpbkn),
				.rxpbidirin(rxpbidirin),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata),
				.ocden(ocden)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_rx_buf_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_rx_buf
#(
	parameter sd_threshold = 0,      // Valid values: 0..7
	parameter vcm_sel = "vtt_0p70v",      // Valid values: vtt_0p80v|vtt_0p75v|vtt_0p70v|vtt_0p65v|vtt_0p60v|vtt_0p55v|vtt_0p50v|vtt_0p35v|vtt_pup_weak|vtt_pdn_weak|tristate1|vtt_pdn_strong|vtt_pup_strong|tristate2|tristate3|tristate4
	parameter vcm_current_add = "vcm_current_default",      // Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter qpi_enable = "false",      // Valid values: false|true
	parameter rx_sel_bias_source = "bias_vcmdrv",      // Valid values: bias_vcmdrv|bias_int
	parameter bypass_eqz_stages_234 = "all_stages_enabled",      // Valid values: all_stages_enabled|byypass_stages_234
	parameter cdr_clock_enable = "true",      // Valid values: false|true
	parameter term_sel = "int_100ohm",      // Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter sd_on = 16,      // Valid values: 0..16
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter rx_dc_gain = 0,      // Valid values: 0..4
	parameter diagnostic_loopback = "diag_lpbk_off",      // Valid values: diag_lpbk_on|diag_lpbk_off
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter offset_cal_pd = "eqz1_en",	//Valid values: eqz1_pd|eqz1_en
	parameter channel_number = 0,      // Valid values: 0..65
	parameter vccela_supply_voltage = "vccela_1p0v",      // Valid values: vccela_1p0v|vccela_0p85v
	parameter pdb_sd = "false",      // Valid values: false|true
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter pmos_gain_peak = "eqzp_en_peaking",      // Valid values: eqzp_dis_peaking|eqzp_en_peaking
	parameter sd_off = 0,      // Valid values: 0..29
	parameter input_vcm_sel = "high_vcm",      // Valid values: low_vcm|high_vcm
	parameter ct_equalizer_setting = 1,      // Valid values: 1..16
	parameter enable_rx_gainctrl_pciemode = "false",      // Valid values: false|true
	parameter eq_bw_sel = "bw_full_12p5",      // Valid values: bw_full_12p5|bw_half_6p5
	parameter cdrclk_to_cgb = "cdrclk_2cgb_dis",      // Valid values: cdrclk_2cgb_dis|cdrclk_2cgb_en
	parameter serial_loopback = "lpbkp_dis",      // Valid values: lpbkp_dis|lpbkp_en_sel_data_slew1|lpbkp_en_sel_data_slew2|lpbkp_en_sel_data_slew3|lpbkp_en_sel_data_slew4|lpbkp_en_sel_refclk|lpbkp_unused
	parameter dfe_pi_bw = "bw_10ghz",      // Valid values: bw_0p5ghz|bw_2p5ghz|bw_5ghz|bw_10ghz
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter adce_rgen_bw = "low_bw",      // Valid values: low_bw|med_low_bw|med_high_bw|high_bw
	parameter adce_hsf_hfbw = "full_bw",      // Valid values: full_bw|half_bw
	parameter monitor_bw_sel = "bw_1gbps_less",	//Valid values: bw_1gbps_less|bw_2_5gbps|bw_5gbps|bw_10gbps
	parameter adce_rambit_en = "adce_ram_disable",	//Valid values: adce_ram_disable|adce_ram_en
	parameter mode_adce = "power_down",	//Valid values: power_down|manual|one_time|continuous|power_down_2|manual_2|eq_one_time_rgen_manual|eq_continuous_rgen_manual|power_down_3
	parameter pcie = "pcie_disable",	//Valid values: pcie_disable|pcie_en
	parameter adce_rst = "adce_rst",	//Valid values: adce_rst|adce_not_rst
	parameter dfe_ibias = "dfe_ibias_from_bandgap",	//Valid values: dfe_ibias_from_bandgap|dfe_ibias_from_adce
	parameter dfe_adapt = "adpat_from_adce",	//Valid values: adpat_from_adce|adpat_from_dfe
	parameter adapt_sequence = "v_d_c_b_a",	//Valid values: d_c_b_v_a|d_c_v_b_a|d_v_c_b_a|v_d_c_b_a
	parameter lfclk = "lf_clk_divby8",	//Valid values: lf_bypass|lf_clk_divby2|lf_clk_divby4|lf_clk_divby8|lf_clk_divby16|lf_clk_divby32|lf_clk_divby64|lf_clk_div_disabled
	parameter hfclk = "hf_bypass",	//Valid values: hf_bypass|hf_clk_divby2|hf_clk_divby4|hf_clk_divby8|hf_clk_divby16|hf_clk_divby32|hf_clk_divby64|hf_clk_div_disabled
	parameter hsf_hx = "hsf_2ma",	//Valid values: hsf_2ma|hfs_4ma|hfs_reserved|hfs_6ma
	parameter dc_bw = "bw_6p6mhz",	//Valid values: bw_6p6mhz|bw_2p2mhz|bw_1p3mhz|bw_830khz
	parameter lpf_bw = "bw_205mhz",	//Valid values: bw_400mhz|bw_205mhz|bw_103mhz|bw_64mhz
	parameter lpf_gain = "gain_3db",	//Valid values: gain_3db|gain_4p5db|gain_reserve|gain_6db
	parameter hpf_bw = "bw_500mhz",	//Valid values: bw_200mhz|bw_500mhz|reserved_rf_hpf|bw_840mhz
	parameter rect_adj = "amp_full_leaker_full",	//Valid values: amp_full_leaker_full|amp_full_leaker_half|amp_half_leaker_half|amp_leaker_reserved
	parameter rgen_mode = "high_freq_mode",	//Valid values: high_freq_mode|med_high_mode|med_low_mode|low_freq_mode
	parameter rgen_vod_max = "rgen_max_vod_125mv",	//Valid values: rgen_max_vod_125mv|rgen_max_vod_250mv|rgen_max_vod_375mv|rgen_max_vod_500mv|rgen_max_vod_625mv|rgen_max_vod_750mv|rgen_max_vod_875mv|rgen_max_vod_1000mv
	parameter rgen_vod_int = "rgen_vod_int_125mv",	//Valid values: rgen_vod_int_125mv|rgen_vod_int_250mv|rgen_vod_int_375mv|rgen_vod_int_500mv|rgen_vod_int_625mv|rgen_vod_int_750mv|rgen_vod_int_875mv|rgen_vod_int_1000mv
	parameter rgen_vod_min = "rgen_min_vod_125mv",	//Valid values: rgen_min_vod_125mv|rgen_min_vod_250mv|rgen_min_vod_375mv|rgen_min_vod_500mv|rgen_min_vod_625mv|rgen_min_vod_750mv|rgen_min_vod_875mv|rgen_min_vod_1000mv
	parameter max_eqa = "max_eqa_125mv",	//Valid values: max_eqa_125mv|max_eqa_250mv|max_eqa_375mv|max_eqa_500mv|max_eqa_625mv|max_eqa_750mv|max_eqa_875mv|max_eqa_1000mv
	parameter max_eqb = "max_eqb_125mv",	//Valid values: max_eqb_125mv|max_eqb_250mv|max_eqb_375mv|max_eqb_500mv|max_eqb_625mv|max_eqb_750mv|max_eqb_875mv|max_eqb_1000mv
	parameter max_eqc = "max_eqc_125mv",	//Valid values: max_eqc_125mv|max_eqc_250mv|max_eqc_375mv|max_eqc_500mv|max_eqc_625mv|max_eqc_750mv|max_eqc_875mv|max_eqc_1000mv
	parameter max_eqd = "max_eqd_125mv",	//Valid values: max_eqd_125mv|max_eqd_250mv|max_eqd_375mv|max_eqd_500mv|max_eqd_625mv|max_eqd_750mv|max_eqd_875mv|max_eqd_1000mv
	parameter max_eqv = "max_eqv_125mv",	//Valid values: max_eqv_125mv|max_eqv_250mv|max_eqv_375mv|max_eqv_500mv|max_eqv_625mv|max_eqv_750mv|max_eqv_875mv|max_eqv_1000mv
	parameter min_eqctrl = "min_eqctrl_0",	//Valid values: min_eqctrl_0|min_eqctrl_125mv
	parameter lock_lf_ovd = "lock_lf_norm",	//Valid values: lock_lf_norm|lock_lf_ovd
	parameter lf_offset_step = "lfos_step1",	//Valid values: lfos_step0|lfos_step1|lfos_step2|lfos_step3
	parameter hf_offset_step = "hfos_step1",	//Valid values: hfos_step0|hfos_step1|hfos_step2|hfos_step3
	parameter lf_offset = "lf_minus_2mv",	//Valid values: lf_minus_2mv|lf_minus_4mv|lf_minus_6mv|lf_minus_8mv|lf_minus_10mv|lf_minus_12mv|lf_minus_14mv|lf_minus_16mv|lf_minus_18mv|lf_minus_20mv|lf_minus_22mv|lf_minus_24mv|lf_minus_26mv|lf_minus_28mv|lf_minus_30mv|lf_minus_32mv|lf_minus_34mv|lf_minus_36mv|lf_minus_38mv|lf_minus_40mv|lf_minus_42mv|lf_minus_44mv|lf_minus_46mv|lf_minus_48mv|lf_minus_50mv|lf_minus_52mv|lf_minus_54mv|lf_minus_56mv|lf_minus_58mv|lf_minus_60mv|lf_minus_90mv|lf_reserved_os|lf_plus_2mv|lf_plus_4mv|lf_plus_6mv|lf_plus_8mv|lf_plus_10mv|lf_plus_12mv|lf_plus_14mv|lf_plus_16mv|lf_plus_18mv|lf_plus_20mv|lf_plus_22mv|lf_plus_24mv|lf_plus_26mv|lf_plus_28mv|lf_plus_30mv|lf_plus_32mv|lf_plus_34mv|lf_plus_36mv|lf_plus_38mv|lf_plus_40mv|lf_plus_42mv|lf_plus_44mv|lf_plus_46mv|lf_plus_48mv|lf_plus_50mv|lf_plus_52mv|lf_plus_54mv|lf_plus_56mv|lf_plus_58mv|lf_plus_60mv|lf_plus_90mv|lf_0mv
	parameter hf_offset = "hf_0mv",	//Valid values: hf_minus_2mv|hf_minus_4mv|hf_minus_6mv|hf_minus_8mv|hf_minus_10mv|hf_minus_12mv|hf_minus_14mv|hf_minus_16mv|hf_minus_18mv|hf_minus_20mv|hf_minus_22mv|hf_minus_24mv|hf_minus_26mv|hf_minus_28mv|hf_minus_30mv|hf_minus_32mv|hf_minus_34mv|hf_minus_36mv|hf_minus_38mv|hf_minus_40mv|hf_minus_42mv|hf_minus_44mv|hf_minus_46mv|hf_minus_48mv|hf_minus_50mv|hf_minus_52mv|hf_minus_54mv|hf_minus_56mv|hf_minus_58mv|hf_minus_60mv|hf_minus_90mv|hf_reserved_os|hf_plus_2mv|hf_plus_4mv|hf_plus_6mv|hf_plus_8mv|hf_plus_10mv|hf_plus_12mv|hf_plus_14mv|hf_plus_16mv|hf_plus_18mv|hf_plus_20mv|hf_plus_22mv|hf_plus_24mv|hf_plus_26mv|hf_plus_28mv|hf_plus_30mv|hf_plus_32mv|hf_plus_34mv|hf_plus_36mv|hf_plus_38mv|hf_plus_40mv|hf_plus_42mv|hf_plus_44mv|hf_plus_46mv|hf_plus_48mv|hf_plus_50mv|hf_plus_52mv|hf_plus_54mv|hf_plus_56mv|hf_plus_58mv|hf_plus_60mv|hf_plus_90mv|hf_0mv
	parameter macro_hfclk_divide = "hf_macro_bypass",	//Valid values: hf_macro_divide_by_4|hf_macro_bypass|hf_macro_divide_by_2|hf_macro_divide_by_8|hf_macro_divide_by_16|hf_macro_divide_by_32|hf_macro_divide_by_64|hf_macro_clkout_disabled
	parameter macro_lfclk_divide = "lf_macro_bypass",	//Valid values: hf_macro_divide_by_4|lf_macro_bypass|lf_macro_divide_by_2|lf_macro_divide_by_8|lf_macro_divide_by_16|lf_macro_divide_by_32|lf_macro_divide_by_64|lf_macro_clkout_disabled
	parameter hfclk_duration_value = 4'b0,	//Valid values: 4
	parameter hfclk_duration = "hfclk_duration_val",	//Valid values: hfclk_duration_val
	parameter hfclk_edge_lock_value = 4'b0,	//Valid values: 4
	parameter hfclk_edge_lock = "hfclk_edge_lock_val",	//Valid values: hfclk_edge_lock_val
	parameter hfclk_lock_for_adapt_done_value = 16'b0,	//Valid values: 16
	parameter hfclk_lock_for_adapt_done = "hfclk_lock_for_adapt_done_val",	//Valid values: hfclk_lock_for_adapt_done_val
	parameter lfclk_duration_value = 4'b0,	//Valid values: 4
	parameter lfclk_duration = "lfclk_duration_val",	//Valid values: lfclk_duration_val
	parameter lfclk_edge_lock_value = 4'b0,	//Valid values: 4
	parameter lfclk_edge_lock = "lfclk_edge_lock_val",	//Valid values: lfclk_edge_lock_val
	parameter lfclk_lock_for_adapt_done_value = 16'b0,	//Valid values: 16
	parameter lfclk_lock_for_adapt_done = "lfclk_lock_for_adapt_done_val",	//Valid values: lfclk_lock_for_adapt_done_val
	parameter adce_atb = "atb_lst0",	//Valid values: atb_lst0|atb_lst1|atb_lst2|atb_lst3|atb_lst4|atb_lst5|atb_lst6|atb_lst7|atb_lst8|atb_lst9|atb_lst10|atb_lst11|atb_lst12|atb_lst13|atb_lst14|atb_lst15
	parameter adce_reserved = "reserved_default",	//Valid values: reserved_default
	parameter bias_rgen_enable = "ibias_from_ibp150u",	//Valid values: ibias_from_ibp150u|ibias_from_adce
	parameter level_1t = "off_1t",	//Valid values: off_1t|level1_1t|level2_1t|level3_1t|level4_1t|level5_1t|level6_1t|level7_1t|level8_1t|level9_1t|level10_1t|level11_1t|level12_1t|level13_1t|level14_1t|level15_1t
	parameter level_2t = "off_2t",	//Valid values: off_2t|level1_2t|level2_2t|level3_2t|level4_2t|level5_2t|level6_2t|level7_2t
	parameter level_3t = "off_3t",	//Valid values: off_3t|level1_3t|level2_3t|level3_3t|level4_3t|level5_3t|level6_3t|level7_3t
	parameter level_4t = "off_4t",	//Valid values: off_4t|level1_4t|level2_4t|level3_4t|level4_4t|level5_4t|level6_4t|level7_4t
	parameter level_5t = "off_5t",	//Valid values: off_5t|level1_5t|level2_5t|level3_5t
	parameter phase_steps_sel_dfe = "step1",	//Valid values: step1|step2|step3|step4|step5|step6|step7|step8|step9|step10|step11|step12|step13|step14|step15|step16|step17|step18|step19|step20|step21|step22|step23|step24|step25|step26|step27|step28|step29|step30|step31|step32|step33|step34|step35|step36|step37|step38|step39|step40|step41|step42|step43|step44|step45|step46|step47|step48|step49|step50|step51|step52|step53|step54|step55|step56|step57|step58|step59|step60|step61|step62|step63|step64
	parameter vco_phase_sel = "clk0",	//Valid values: clk0|clk90
	parameter clk_source_sel = "vco_clk",	//Valid values: vco_clk|pi_clk
	parameter polarity_2t = "negative_2t",	//Valid values: positive_2t|negative_2t
	parameter polarity_3t = "negative_3t",	//Valid values: positive_3t|negative_3t
	parameter polarity_4t = "negative_4t",	//Valid values: positive_4t|negative_4t
	parameter polarity_5t = "negative_5t",	//Valid values: positive_5t|negative_5t
	parameter offset_ev_level = "ev_left_level0",	//Valid values: ev_left_level0|ev_left_level1|ev_left_level2|ev_left_level3|ev_left_level4|ev_left_level5|ev_left_level6|ev_left_level7|ev_right_level0|ev_right_level1|ev_right_level2|ev_right_level3|ev_right_level4|ev_right_level5|ev_right_level6|ev_right_level7
	parameter offset_od_level = "od_left_level0",	//Valid values: od_left_level0|od_left_level1|od_left_level2|od_left_level3|od_left_level4|od_left_level5|od_left_level6|od_left_level7|od_right_level0|od_right_level1|od_right_level2|od_right_level3|od_right_level4|od_right_level5|od_right_level6|od_right_level7
	parameter offset_evh_level = "evh_left_level0",	//Valid values: evh_left_level0|evh_left_level1|evh_left_level2|evh_left_level3|evh_left_level4|evh_left_level5|evh_left_level6|evh_left_level7|evh_right_level0|evh_right_level1|evh_right_level2|evh_right_level3|evh_right_level4|evh_right_level5|evh_right_level6|evh_right_level7
	parameter offset_evl_level = "evl_left_level0",	//Valid values: evl_left_level0|evl_left_level1|evl_left_level2|evl_left_level3|evl_left_level4|evl_left_level5|evl_left_level6|evl_left_level7|evl_right_level0|evl_right_level1|evl_right_level2|evl_right_level3|evl_right_level4|evl_right_level5|evl_right_level6|evl_right_level7
	parameter offset_odh_level = "odh_left_level0",	//Valid values: odh_left_level0|odh_left_level1|odh_left_level2|odh_left_level3|odh_left_level4|odh_left_level5|odh_left_level6|odh_left_level7|odh_right_level0|odh_right_level1|odh_right_level2|odh_right_level3|odh_right_level4|odh_right_level5|odh_right_level6|odh_right_level7
	parameter offset_odl_level = "odl_left_level0",	//Valid values: odl_left_level0|odl_left_level1|odl_left_level2|odl_left_level3|odl_left_level4|odl_left_level5|odl_left_level6|odl_left_level7|odl_right_level0|odl_right_level1|odl_right_level2|odl_right_level3|odl_right_level4|odl_right_level5|odl_right_level6|odl_right_level7
	parameter offset_testmux = "testmux_off",	//Valid values: testmux_off|testmux_on_can|testmux_on_ck_cal
	parameter adapt_en = "adapt_disable",	//Valid values: adapt_disable|adapt_enable
	parameter adapt_bypass = "adapt_bypass_off",	//Valid values: adapt_bypass_off|adapt_bypass_on
	parameter speed_mode = "high_freq",	//Valid values: high_freq|low_freq
	parameter vref = "vref_level4",	//Valid values: vref_level1|vref_level2|vref_level3|vref_level4|vref_level5|vref_level6|vref_level7|vref_level8
	parameter atb = "atb_off",	//Valid values: atb_off|atb_sel1|atb_sel2|atb_sel3|atb_sel4|atb_sel5|atb_sel6|atb_sel7
	parameter pcnt1_bsel = "pcnt1_200",	//Valid values: pcnt1_64|pcnt1_100|pcnt1_200|pcnt1_400|pcnt1_800|pcnt1_1200|pcnt1_1600|pcnt1_2000|pcnt1_3bit|pcnt1_4bit|pcnt1_5bit|pcnt1_6bit
	parameter pcnt2_bsel = "pcnt2_200",	//Valid values: pcnt2_64|pcnt2_100|pcnt2_200|pcnt2_400|pcnt2_800|pcnt2_1200|pcnt2_1600|pcnt2_2000|pcnt2_3bit|pcnt2_4bit|pcnt2_5bit|pcnt2_6bit
	parameter pcnt3_bsel = "pcnt3_200",	//Valid values: pcnt3_64|pcnt3_100|pcnt3_200|pcnt3_400|pcnt3_800|pcnt3_1200|pcnt3_1600|pcnt3_2000|pcnt3_3bit|pcnt3_4bit|pcnt3_5bit|pcnt3_6bit
	parameter pcnt4_bsel = "pcnt4_200",	//Valid values: pcnt4_64|pcnt4_100|pcnt4_200|pcnt4_400|pcnt4_800|pcnt4_1200|pcnt4_1600|pcnt4_2000|pcnt4_3bit|pcnt4_4bit|pcnt4_5bit|pcnt4_6bit
	parameter pcnt5_bsel = "pcnt5_200",	//Valid values: pcnt5_64|pcnt5_100|pcnt5_200|pcnt5_400|pcnt5_800|pcnt5_1200|pcnt5_1600|pcnt5_2000|pcnt5_3bit|pcnt5_4bit|pcnt5_5bit|pcnt5_6bit
	parameter adapt_mode = "adapt_3tap",	//Valid values: adapt_5tap|adapt_4tap|adapt_3tap|adapt_1tap
	parameter adapt_vcm_op_en = "vcm_opamp_enable",	//Valid values: vcm_opamp_disable|vcm_opamp_enable
	parameter adapt_hold_en = "adapt_hold_disable",	//Valid values: adapt_hold_disable|adapt_hold_enable
	parameter adapt_limit_en = "adapt_limit_disable",	//Valid values: adapt_limit_disable|adapt_limit_enable
	parameter pdb_odi = "power_down_eye",	//Valid values: normal_eye_on|power_down_eye
	parameter vert_threshold = "vert_0mv",	//Valid values: vert_0mv|vert_10mv|vert_20mv|vert_30mv|vert_40mv|vert_50mv|vert_60mv|vert_70mv|vert_80mv|vert_90mv|vert_100mv|vert_110mv|vert_120mv|vert_130mv|vert_140mv|vert_150mv|vert_160mv|vert_170mv|vert_180mv|vert_190mv|vert_200mv|vert_210mv|vert_220mv|vert_230mv|vert_240mv|vert_250mv|vert_260mv|vert_270mv|vert_280mv|vert_290mv|vert_300mv|vert_310mv|vert_320mv|vert_330mv|vert_340mv|vert_350mv|vert_360mv|vert_370mv|vert_380mv|vert_390mv|vert_400mv|vert_410mv|vert_420mv|vert_430mv|vert_440mv|vert_450mv|vert_460mv|vert_470mv|vert_480mv|vert_490mv|vert_500mv|vert_510mv|vert_520mv|vert_530mv|vert_540mv|vert_550mv|vert_560mv|vert_570mv|vert_580mv|vert_590mv|vert_600mv|vert_610mv|vert_620mv|vert_630mv
	parameter v_vert_threshold_scaling = "scale_plus_0p8",	//Valid values: scale_minus_0p6|scale_minus_0p7|scale_minus_0p8|scale_minus_1p0|scale_plus_0p6|scale_plus_0p7|scale_plus_0p8|scale_plus_1p0
	parameter phase_steps_sel_odi = "step20",	//Valid values: step1|step2|step3|step4|step5|step6|step7|step8|step9|step10|step11|step12|step13|step14|step15|step16|step17|step18|step19|step20|step21|step22|step23|step24|step25|step26|step27|step28|step29|step30|step31|step32|step33|step34|step35|step36|step37|step38|step39|step40|step41|step42|step43|step44|step45|step46|step47|step48|step49|step50|step51|step52|step53|step54|step55|step56|step57|step58|step59|step60|step61|step62|step63|step64|dynamic_ctrl_step1|dynamic_ctrl_step2|dynamic_ctrl_step3|dynamic_ctrl_step4|dynamic_ctrl_step5|dynamic_ctrl_step6|dynamic_ctrl_step7|dynamic_ctrl_step8|dynamic_ctrl_step9|dynamic_ctrl_step10|dynamic_ctrl_step11|dynamic_ctrl_step12|dynamic_ctrl_step13|dynamic_ctrl_step14|dynamic_ctrl_step15|dynamic_ctrl_step16|dynamic_ctrl_step17|dynamic_ctrl_step18|dynamic_ctrl_step19|dynamic_ctrl_step20|dynamic_ctrl_step21|dynamic_ctrl_step22|dynamic_ctrl_step23|dynamic_ctrl_step24|dynamic_ctrl_step25|dynamic_ctrl_step26|dynamic_ctrl_step27|dynamic_ctrl_step28|dynamic_ctrl_step29|dynamic_ctrl_step30|dynamic_ctrl_step31|dynamic_ctrl_step32
	parameter bit_error_check_enable = "bit_err_chk_enable",	//Valid values: bit_err_chk_enable|bit_err_chk_disable
	parameter out_to_nxt_ch = "out_2_nxt_ch_off",	//Valid values: out_2_nxt_ch_on|out_2_nxt_ch_off
	parameter select_1d_eye = "sel_2d_eye",	//Valid values: sel_1d_eye|sel_2d_eye
	parameter rx_manual_mode = "eq_manual_1",	//Valid values: eq_manual_1|eq_manual_2|eq_manual_3|eq_manual_4|eq_manual_5|eq_manual_6|eq_manual_7|eq_manual_8|eq_manual_9|eq_manual_10|eq_manual_11|eq_manual_12|eq_manual_13|eq_manual_14|eq_manual_15|eq_manual_16
	parameter select_testbus = "select_testbus_a",	//Valid values: select_testbus_a|select_testbus_b|select_testbus_c|select_testbus_d|select_testbus_e|select_testbus_f|select_testbus_g|select_testbus_h|select_testbus_i|select_testbus_j|select_testbus_k|select_testbus_l|select_testbus_m|select_testbus_n|select_testbus_o|select_not_used_3
	parameter clk_sel = "refclk_or_cal_clk",	//Valid values: refclk_or_cal_clk|refclk_lc|pldclk|cal_clk
	parameter reverse_loopback = "reverse_lpbk_cdr",	//Valid values: reverse_lpbk_cdr|reverse_lpbk_rx
	parameter to_jitter_enable = "no_jitter_enable",	//Valid values: no_jitter_enable|jitter_enable
	parameter to_scale_jitter = "jitter_setting_000",	//Valid values: jitter_setting_000|jitter_setting_001|jitter_setting_010|jitter_setting_011|jitter_setting_100|jitter_setting_101|jitter_setting_110|jitter_setting_111
	parameter cal_eye_pdb = "eye_monitor_off",	//Valid values: eye_monitor_on|eye_monitor_off
	parameter cal_dfe_pdb = "dfe_monitor_off",	//Valid values: dfe_monitor_on|dfe_monitor_off
	parameter cal_offset_mode = "mode_independent",	//Valid values: mode_independent|mode_accumulation|mode_avg_accumulation|mode_accumulation_midsweep
	parameter cal_set_timer = "timer_fast",	//Valid values: timer_fast|timer_slow
	parameter cal_limit_sa_cap = "full_cap",	//Valid values: full_cap|limit_cap
	parameter cal_oneshot = "oneshot_off",	//Valid values: oneshot_on|oneshot_off
	parameter rx_dprio_sel = "rx_dprio_sel",	//Valid values: rx_dprio_sel|rx_calibration_sel
	parameter bbpd_dprio_sel = "bbpd_dprio_sel",	//Valid values: bbpd_dprio_sel|bbpd_calibration_sel
	parameter eye_dprio_sel = "eye_dprio_sel",	//Valid values: eye_dprio_sel|eye_calibration_sel
	parameter dfe_dprio_sel = "dfe_dprio_sel",	//Valid values: dfe_dprio_sel|dfe_calibration_sel
	parameter offset_cal_pd_top = "offset_enable",	//Valid values: offset_enable|offset_disable
	parameter offset_att_en = "enable_12g_cal",	//Valid values: enable_att_cal|enable_12g_cal
	parameter cal_status_sel = "status_reg1",	//Valid values: status_reg1|status_reg2|status_reg3|status_reg4|status_reg5|status_reg6|status_reg7|status_reg8
	parameter cal_limit_bbpd_sa_cal = "enable_4phase",	//Valid values: enable_2phase|enable_4phase
	parameter rx_det_pdb = "power_down",	//Valid values: power_down|power_up
	parameter counter_0 = "setting_0",	//Valid values: setting_0|setting_1
	parameter counter_1 = "setting_0",	//Valid values: setting_0|setting_1
	parameter counter_2 = "setting_0",	//Valid values: setting_0|setting_1
	parameter counter_3 = "setting_0",	//Valid values: setting_0|setting_1
	parameter pcie_qpi_sel = "pcie_mode",	//Valid values: pcie_mode|qpi_mode
	parameter rx_manual_mode_test = "eq_d2a_test_disable"	//Valid values: eq_d2a_test_disable|eq_d2a_test_enable
)
(
	input  [ 0:0 ] adaptcapture,
	output [ 0:0 ] adaptdone,
	input  [ 0:0 ] adcestandby,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] ck0sigdet,
	input  [ 0:0 ] datain,
	output [ 0:0 ] dataout,
	input  [ 4:0 ] eyemonitor,
	output [ 0:0 ] hardoccaldone,
	input  [ 0:0 ] hardoccalen,
	input  [ 0:0 ] lpbkn,
	input  [ 0:0 ] lpbkp,
	input  [ 0:0 ] nonuserfrompmaux,
	input  [ 0:0 ] occlk,
	output [ 0:0 ] rdlpbkn,
	output [ 0:0 ] rdlpbkp,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] rxqpipulldn,
	output [ 0:0 ] rxrefclk,
	output [ 0:0 ] sd,
	input  [ 0:0 ] slpbk,
	input  [ 0:0 ] vonlp,
	input  [ 0:0 ] voplp
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_rx_buf : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_rx_buf_encrypted_ES #(
				.sd_threshold(sd_threshold),
				.vcm_sel(vcm_sel),
				.vcm_current_add(vcm_current_add),
				.qpi_enable(qpi_enable),
				.rx_sel_bias_source(rx_sel_bias_source),
				.bypass_eqz_stages_234(bypass_eqz_stages_234),
				.cdr_clock_enable(cdr_clock_enable),
				.term_sel(term_sel),
				.sd_on(sd_on),
				.avmm_group_channel_index(avmm_group_channel_index),
				.rx_dc_gain(rx_dc_gain),
				.diagnostic_loopback(diagnostic_loopback),
				.user_base_address(user_base_address),
				.channel_number(channel_number),
				.vccela_supply_voltage(vccela_supply_voltage),
				.pdb_sd(pdb_sd),
				.use_default_base_address(use_default_base_address),
				.pmos_gain_peak(pmos_gain_peak),
				.sd_off(sd_off),
				.input_vcm_sel(input_vcm_sel),
				.ct_equalizer_setting(ct_equalizer_setting),
				.enable_rx_gainctrl_pciemode(enable_rx_gainctrl_pciemode),
				.eq_bw_sel(eq_bw_sel),
				.cdrclk_to_cgb(cdrclk_to_cgb),
				.serial_loopback(serial_loopback)
			) stratixv_hssi_pma_rx_buf_encrypted_ES_inst (
				.datain(datain),
				.rxrefclk(rxrefclk),
				.rdlpbkp(rdlpbkp),
				.avmmclk(avmmclk),
				.vonlp(vonlp),
				.hardoccaldone(hardoccaldone),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.rdlpbkn(rdlpbkn),
				.dataout(dataout),
				.avmmread(avmmread),
				.adcestandby(adcestandby),
				.rstn(rstn),
				.occlk(occlk),
				.adaptdone(adaptdone),
				.rxqpipulldn(rxqpipulldn),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.lpbkp(lpbkp),
				.lpbkn(lpbkn),
				.avmmwrite(avmmwrite),
				.hardoccalen(hardoccalen),
				.ck0sigdet(ck0sigdet),
				.slpbk(slpbk),
				.voplp(voplp),
				.eyemonitor(eyemonitor),
				.sd(sd),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata),
				.adaptcapture(adaptcapture)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_rx_buf_encrypted #(
				.sd_threshold(sd_threshold),
				.dfe_pi_bw(dfe_pi_bw),
				.vcm_sel(vcm_sel),
				.vcm_current_add(vcm_current_add),
				.qpi_enable(qpi_enable),
				.rx_sel_bias_source(rx_sel_bias_source),
				.bypass_eqz_stages_234(bypass_eqz_stages_234),
				.cdr_clock_enable(cdr_clock_enable),
				.term_sel(term_sel),
				.sd_on(sd_on),
				.avmm_group_channel_index(avmm_group_channel_index),
				.rx_dc_gain(rx_dc_gain),
				.diagnostic_loopback(diagnostic_loopback),
				.user_base_address(user_base_address),
				.offset_cal_pd(offset_cal_pd),
				.channel_number(channel_number),
				.vccela_supply_voltage(vccela_supply_voltage),
				.pdb_sd(pdb_sd),
				.adce_rgen_bw(adce_rgen_bw),
				.use_default_base_address(use_default_base_address),
				.pmos_gain_peak(pmos_gain_peak),
				.sd_off(sd_off),
				.input_vcm_sel(input_vcm_sel),
				.adce_hsf_hfbw(adce_hsf_hfbw),
				.ct_equalizer_setting(ct_equalizer_setting),
				.enable_rx_gainctrl_pciemode(enable_rx_gainctrl_pciemode),
				.eq_bw_sel(eq_bw_sel),
				.cdrclk_to_cgb(cdrclk_to_cgb),
				.serial_loopback(serial_loopback),
				.monitor_bw_sel(monitor_bw_sel)
			) stratixv_hssi_pma_rx_buf_encrypted_inst (
				.datain(datain),
				.rxrefclk(rxrefclk),
				.rdlpbkp(rdlpbkp),
				.avmmclk(avmmclk),
				.vonlp(vonlp),
				.hardoccaldone(hardoccaldone),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.rdlpbkn(rdlpbkn),
				.dataout(dataout),
				.avmmread(avmmread),
				.adcestandby(adcestandby),
				.rstn(rstn),
				.occlk(occlk),
				.adaptdone(adaptdone),
				.rxqpipulldn(rxqpipulldn),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.lpbkp(lpbkp),
				.lpbkn(lpbkn),
				.avmmwrite(avmmwrite),
				.hardoccalen(hardoccalen),
				.ck0sigdet(ck0sigdet),
				.slpbk(slpbk),
				.voplp(voplp),
				.eyemonitor(eyemonitor),
				.sd(sd),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata),
				.adaptcapture(adaptcapture)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_rx_deser_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_rx_deser
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter deser_div33_enable = "true",      // Valid values: true|false
	parameter channel_number = 0,      // Valid values: 0..65
	parameter vco_bypass = "vco_bypass_normal",      // Valid values: vco_bypass_normal|clklow_to_clkdivrx|fref_to_clkdivrx
	parameter mode = 8,      // Valid values: 8|10|16|20|32|40|64|80
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter auto_negotiation = "false",      // Valid values: false|true
	parameter clk_forward_only_mode = "false",      // Valid values: false|true
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter enable_bit_slip = "true",      // Valid values: false|true
	parameter sdclk_enable = "true",      // Valid values: false|true
	parameter pma_direct = "false",      // Valid values: false|true
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] bslip,
	input  [ 0:0 ] clk270b,
	output [ 0:0 ] clk33pcs,
	input  [ 0:0 ] clk90b,
	output [ 0:0 ] clkdivrx,
	output [ 0:0 ] clkdivrxrx,
	input  [ 0:0 ] clklow,
	input  [ 0:0 ] deven,
	input  [ 0:0 ] dodd,
	output [ 79:0 ] dout,
	input  [ 0:0 ] fref,
	output [ 0:0 ] pciel,
	output [ 0:0 ] pciem,
	input  [ 1:0 ] pciesw,
	input  [ 0:0 ] pfdmodelock,
	input  [ 0:0 ] rstn
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_rx_deser : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_rx_deser_encrypted_ES #(
				.user_base_address(user_base_address),
				.deser_div33_enable(deser_div33_enable),
				.channel_number(channel_number),
				.vco_bypass(vco_bypass),
				.mode(mode),
				.use_default_base_address(use_default_base_address),
				.auto_negotiation(auto_negotiation),
				.clk_forward_only_mode(clk_forward_only_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.enable_bit_slip(enable_bit_slip),
				.sdclk_enable(sdclk_enable)
			) stratixv_hssi_pma_rx_deser_encrypted_ES_inst (
				.fref(fref),
				.clkdivrx(clkdivrx),
				.clkdivrxrx(clkdivrxrx),
				.avmmclk(avmmclk),
				.deven(deven),
				.avmmrstn(avmmrstn),
				.clklow(clklow),
				.pfdmodelock(pfdmodelock),
				.avmmbyteen(avmmbyteen),
				.clk270b(clk270b),
				.avmmread(avmmread),
				.rstn(rstn),
				.bslip(bslip),
				.clk33pcs(clk33pcs),
				.pciesw(pciesw),
				.blockselect(blockselect),
				.pciem(pciem),
				.avmmreaddata(avmmreaddata),
				.clk90b(clk90b),
				.avmmwrite(avmmwrite),
				.pciel(pciel),
				.dodd(dodd),
				.dout(dout),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_rx_deser_encrypted #(
				.user_base_address(user_base_address),
				.deser_div33_enable(deser_div33_enable),
				.channel_number(channel_number),
				.vco_bypass(vco_bypass),
				.mode(mode),
				.use_default_base_address(use_default_base_address),
				.pma_direct(pma_direct),
				.auto_negotiation(auto_negotiation),
				.clk_forward_only_mode(clk_forward_only_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.enable_bit_slip(enable_bit_slip),
				.sdclk_enable(sdclk_enable)
			) stratixv_hssi_pma_rx_deser_encrypted_inst (
				.fref(fref),
				.clkdivrx(clkdivrx),
				.clkdivrxrx(clkdivrxrx),
				.avmmclk(avmmclk),
				.deven(deven),
				.avmmrstn(avmmrstn),
				.clklow(clklow),
				.pfdmodelock(pfdmodelock),
				.avmmbyteen(avmmbyteen),
				.clk270b(clk270b),
				.avmmread(avmmread),
				.rstn(rstn),
				.bslip(bslip),
				.clk33pcs(clk33pcs),
				.pciesw(pciesw),
				.blockselect(blockselect),
				.pciem(pciem),
				.avmmreaddata(avmmreaddata),
				.clk90b(clk90b),
				.avmmwrite(avmmwrite),
				.pciel(pciel),
				.dodd(dodd),
				.dout(dout),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_ser_att_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_ser_att
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter ser_loopback = "loopback_disable",      // Valid values: loopback_enable|loopback_disable
	parameter ser_pdb = "power_down",      // Valid values: power_down|power_up
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clk0,
	input  [ 0:0 ] clk180,
	output [ 0:0 ] clkdivtxtop,
	input  [ 127:0 ] datain,
	output [ 0:0 ] lbvon,
	output [ 0:0 ] lbvop,
	output [ 0:0 ] observableasyncdatain,
	output [ 0:0 ] observableintclk,
	output [ 0:0 ] observablesyncdatain,
	output [ 0:0 ] oe,
	output [ 0:0 ] oeb,
	output [ 0:0 ] oo,
	output [ 0:0 ] oob,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] slpbk
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_ser_att : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_ser_att_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.ser_loopback(ser_loopback),
				.ser_pdb(ser_pdb)
			) stratixv_hssi_pma_ser_att_encrypted_ES_inst (
				.datain(datain),
				.observableasyncdatain(observableasyncdatain),
				.lbvon(lbvon),
				.clk0(clk0),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.oe(oe),
				.avmmbyteen(avmmbyteen),
				.clk180(clk180),
				.oeb(oeb),
				.lbvop(lbvop),
				.rstn(rstn),
				.avmmread(avmmread),
				.observablesyncdatain(observablesyncdatain),
				.clkdivtxtop(clkdivtxtop),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.oob(oob),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.observableintclk(observableintclk),
				.oo(oo),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_ser_att_encrypted #(
                .enable_debug_info(enable_debug_info),
				.ser_loopback(ser_loopback),
				.ser_pdb(ser_pdb)
			) stratixv_hssi_pma_ser_att_encrypted_inst (
				.datain(datain),
				.observableasyncdatain(observableasyncdatain),
				.lbvon(lbvon),
				.clk0(clk0),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.oe(oe),
				.avmmbyteen(avmmbyteen),
				.clk180(clk180),
				.oeb(oeb),
				.lbvop(lbvop),
				.rstn(rstn),
				.avmmread(avmmread),
				.observablesyncdatain(observablesyncdatain),
				.clkdivtxtop(clkdivtxtop),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.oob(oob),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.observableintclk(observableintclk),
				.oo(oo),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_tx_att_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_att
#(
    parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only
	parameter main_driver_switch_en_2 = "enable_main_switch_2",      // Valid values: disable_main_switch_2|enable_main_switch_2
	parameter pre_emp_ctrl_post_tap_level = "fir_post_disabled",      // Valid values: fir_post_disabled|fir_post_p2ma|fir_post_p4ma|fir_post_p6ma|fir_post_p8ma|fir_post_1p0ma|fir_post_1p2ma|fir_post_1p4ma|fir_post_1p6ma|fir_post_1p8ma|fir_post_2p0ma|fir_post_2p2ma|fir_post_2p4ma|fir_post_2p6ma|fir_post_2p8ma|fir_post_3p0ma|fir_post_3p2ma|fir_post_3p4ma|fir_post_3p6ma|fir_post_3p8ma|fir_post_4p0ma|fir_post_4p2ma|fir_post_4p4ma|fir_post_4p6ma|fir_post_4p8ma|fir_post_5p0ma|fir_post_5p2ma|fir_post_5p4ma|fir_post_5p6ma|fir_post_5p8ma|fir_post_6p0ma|fir_post_6p2ma
	parameter post_tap_lowpass_filter_en_1 = "enable_lp_post_1",      // Valid values: disable_lp_post_1|enable_lp_post_1
	parameter main_tap_lowpass_filter_en_0 = "enable_lp_main_0",      // Valid values: disable_lp_main_0|enable_lp_main_0
	parameter clock_monitor = "disable_clk_mon",      // Valid values: disable_clk_mon|enable_clk_mon
	parameter main_driver_switch_en_1 = "enable_main_switch_1",      // Valid values: disable_main_switch_1|enable_main_switch_1
	parameter vcm_current_addl = "low_current",      // Valid values: low_current|high_current
	parameter post_driver_switch_en_0 = "disable_post_switch_0",      // Valid values: disable_post_switch_0|enable_post_switch_0
	parameter term_sel = "r_setting_7",      // Valid values: r_setting_1|r_setting_2|r_setting_3|r_setting_4|r_setting_5|r_setting_6|r_setting_7|r_setting_8|r_setting_9|r_setting_10|r_setting_11|r_setting_12|r_setting_13|r_setting_14|r_setting_15|r_setting_16
	parameter pre_driver_switch_en_0 = "disable_pre_switch_0",      // Valid values: disable_pre_switch_0|enable_pre_switch_0
	parameter rev_ser_lb_en = "disable_rev_ser_lb",      // Valid values: disable_rev_ser_lb|enable_rev_ser_lb
	parameter pre_tap_lowpass_filter_en_0 = "enable_lp_pre_0",      // Valid values: disable_lp_pre_0|enable_lp_pre_0
	parameter high_vccehtx = "volt_1p5v",      // Valid values: not_used|volt_1p5v
	parameter vod_ctrl_main_tap_level = "vod_0ma",      // Valid values: vod_0ma|vod_2ma|vod_4ma|vod_6ma|vod_8ma|vod_10ma
	parameter sig_inv_pre_tap = "non_inv_pre_tap",      // Valid values: non_inv_pre_tap|inv_pre_tap
	parameter main_tap_lowpass_filter_en_1 = "enable_lp_main_1",      // Valid values: disable_lp_main_1|enable_lp_main_1
	parameter lst = "atb_disabled",      // Valid values: atb_disabled|atb_1|atb_2|atb_3|atb_4|atb_5|atb_6|atb_7|atb_8|atb_9|atb_10|atb_11|atb_12|atb_13|atb_14|atb_15
	parameter pre_tap_lowpass_filter_en_1 = "enable_lp_pre_1",      // Valid values: disable_lp_pre_1|enable_lp_pre_1
	parameter post_driver_switch_en_1 = "disable_post_switch_1",      // Valid values: disable_post_switch_1|enable_post_switch_1
	parameter pre_driver_switch_en_1 = "disable_pre_switch_1",      // Valid values: disable_pre_switch_1|enable_pre_switch_1
	parameter tx_powerdown = "normal_tx_on",      // Valid values: normal_tx_on|power_down_tx
	parameter revlb_select = "sel_met_lb",      // Valid values: sel_met_lb|sel_rev_ser_lb
	parameter pre_emp_ctrl_pre_tap_level = "fir_pre_disabled",      // Valid values: fir_pre_disabled|fir_pre_p2ma|fir_pre_p4ma|fir_pre_p6ma|fir_pre_p8ma|fir_pre_1p0ma|fir_pre_1p2ma|fir_pre_1p4ma|fir_pre_1p6ma|fir_pre_1p8ma|fir_pre_2p0ma|fir_pre_2p2ma|fir_pre_2p4ma|fir_pre_2p6ma|fir_pre_2p8ma|fir_pre_3p0ma|fir_pre_3p2ma|fir_pre_3p4ma|fir_pre_3p6ma|fir_pre_3p8ma|fir_pre_4p0ma|fir_pre_4p2ma|fir_pre_4p4ma|fir_pre_4p6ma|fir_pre_4p8ma|fir_pre_5p0ma|fir_pre_5p2ma|fir_pre_5p4ma|fir_pre_5p6ma|fir_pre_5p8ma|fir_pre_6p0ma|fir_pre_6p2ma
	parameter post_tap_lowpass_filter_en_0 = "enable_lp_post_0",      // Valid values: disable_lp_post_0|enable_lp_post_0
	parameter main_driver_switch_en_3 = "disable_main_switch_3",      // Valid values: disable_main_switch_3|enable_main_switch_3
	parameter main_driver_switch_en_0 = "enable_main_switch_0",      // Valid values: disable_main_switch_0|enable_main_switch_0
	parameter common_mode_driver_sel = "volt_0p65v",      // Valid values: volt_0p80v|volt_0p75v|volt_0p70v|volt_0p65v|volt_0p60v|volt_0p55v|volt_0p50v|volt_0p35v|pull_up|pull_dn|tristated1|grounded|pull_up_to_vccela|tristated2|tristated3|tristated4
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter enable_icdr = "sel_metalic_lb",      // Valid values: sel_icdr|sel_metalic_lb
	parameter termination_en = "enable_termination"      // Valid values: tristate_termination|enable_termination
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clk270bout,
	input  [ 0:0 ] clk90bout,
	input  [ 0:0 ] devenbout,
	input  [ 0:0 ] devenout,
	input  [ 0:0 ] doddbout,
	input  [ 0:0 ] doddout,
	input  [ 0:0 ] nonuserfrompmaux,
	input  [ 0:0 ] oe,
	input  [ 0:0 ] oeb,
	input  [ 0:0 ] oo,
	input  [ 0:0 ] oob,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] rtxrlpbk,
	input  [ 0:0 ] rxrlpbkn,
	input  [ 0:0 ] rxrlpbkp,
	input  [ 0:0 ] vonbidirin,
	output [ 0:0 ] vonbidirout,
	input  [ 0:0 ] vopbidirin,
	output [ 0:0 ] vopbidirout
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_tx_att : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_tx_att_encrypted_ES #(
                .enable_debug_info(enable_debug_info),
				.main_driver_switch_en_2(main_driver_switch_en_2),
				.pre_emp_ctrl_post_tap_level(pre_emp_ctrl_post_tap_level),
				.post_tap_lowpass_filter_en_1(post_tap_lowpass_filter_en_1),
				.main_tap_lowpass_filter_en_0(main_tap_lowpass_filter_en_0),
				.clock_monitor(clock_monitor),
				.main_driver_switch_en_1(main_driver_switch_en_1),
				.vcm_current_addl(vcm_current_addl),
				.post_driver_switch_en_0(post_driver_switch_en_0),
				.term_sel(term_sel),
				.pre_driver_switch_en_0(pre_driver_switch_en_0),
				.rev_ser_lb_en(rev_ser_lb_en),
				.pre_tap_lowpass_filter_en_0(pre_tap_lowpass_filter_en_0),
				.high_vccehtx(high_vccehtx),
				.vod_ctrl_main_tap_level(vod_ctrl_main_tap_level),
				.sig_inv_pre_tap(sig_inv_pre_tap),
				.main_tap_lowpass_filter_en_1(main_tap_lowpass_filter_en_1),
				.lst(lst),
				.pre_tap_lowpass_filter_en_1(pre_tap_lowpass_filter_en_1),
				.post_driver_switch_en_1(post_driver_switch_en_1),
				.pre_driver_switch_en_1(pre_driver_switch_en_1),
				.tx_powerdown(tx_powerdown),
				.revlb_select(revlb_select),
				.pre_emp_ctrl_pre_tap_level(pre_emp_ctrl_pre_tap_level),
				.post_tap_lowpass_filter_en_0(post_tap_lowpass_filter_en_0),
				.main_driver_switch_en_3(main_driver_switch_en_3),
				.main_driver_switch_en_0(main_driver_switch_en_0),
				.common_mode_driver_sel(common_mode_driver_sel)
			) stratixv_hssi_pma_tx_att_encrypted_ES_inst (
				.devenbout(devenbout),
				.rxrlpbkn(rxrlpbkn),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.oe(oe),
				.avmmbyteen(avmmbyteen),
				.rxrlpbkp(rxrlpbkp),
				.nonuserfrompmaux(nonuserfrompmaux),
				.vonbidirin(vonbidirin),
				.oeb(oeb),
				.vonbidirout(vonbidirout),
				.rstn(rstn),
				.devenout(devenout),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.clk270bout(clk270bout),
				.oob(oob),
				.clk90bout(clk90bout),
				.rtxrlpbk(rtxrlpbk),
				.avmmwrite(avmmwrite),
				.doddbout(doddbout),
				.vopbidirin(vopbidirin),
				.oo(oo),
				.vopbidirout(vopbidirout),
				.doddout(doddout),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_tx_att_encrypted #(
                .enable_debug_info(enable_debug_info),
				.main_driver_switch_en_2(main_driver_switch_en_2),
				.pre_emp_ctrl_post_tap_level(pre_emp_ctrl_post_tap_level),
				.post_tap_lowpass_filter_en_1(post_tap_lowpass_filter_en_1),
				.main_tap_lowpass_filter_en_0(main_tap_lowpass_filter_en_0),
				.clock_monitor(clock_monitor),
				.main_driver_switch_en_1(main_driver_switch_en_1),
				.vcm_current_addl(vcm_current_addl),
				.post_driver_switch_en_0(post_driver_switch_en_0),
				.term_sel(term_sel),
				.pre_driver_switch_en_0(pre_driver_switch_en_0),
				.rev_ser_lb_en(rev_ser_lb_en),
				.pre_tap_lowpass_filter_en_0(pre_tap_lowpass_filter_en_0),
				.high_vccehtx(high_vccehtx),
				.vod_ctrl_main_tap_level(vod_ctrl_main_tap_level),
				.sig_inv_pre_tap(sig_inv_pre_tap),
				.main_tap_lowpass_filter_en_1(main_tap_lowpass_filter_en_1),
				.lst(lst),
				.pre_tap_lowpass_filter_en_1(pre_tap_lowpass_filter_en_1),
				.enable_icdr(enable_icdr),
				.post_driver_switch_en_1(post_driver_switch_en_1),
				.pre_driver_switch_en_1(pre_driver_switch_en_1),
				.termination_en(termination_en),
				.tx_powerdown(tx_powerdown),
				.revlb_select(revlb_select),
				.pre_emp_ctrl_pre_tap_level(pre_emp_ctrl_pre_tap_level),
				.post_tap_lowpass_filter_en_0(post_tap_lowpass_filter_en_0),
				.main_driver_switch_en_3(main_driver_switch_en_3),
				.main_driver_switch_en_0(main_driver_switch_en_0),
				.common_mode_driver_sel(common_mode_driver_sel)
			) stratixv_hssi_pma_tx_att_encrypted_inst (
				.devenbout(devenbout),
				.rxrlpbkn(rxrlpbkn),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.oe(oe),
				.avmmbyteen(avmmbyteen),
				.rxrlpbkp(rxrlpbkp),
				.nonuserfrompmaux(nonuserfrompmaux),
				.vonbidirin(vonbidirin),
				.oeb(oeb),
				.vonbidirout(vonbidirout),
				.rstn(rstn),
				.devenout(devenout),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.clk270bout(clk270bout),
				.oob(oob),
				.clk90bout(clk90bout),
				.rtxrlpbk(rtxrlpbk),
				.avmmwrite(avmmwrite),
				.doddbout(doddbout),
				.vopbidirin(vopbidirin),
				.oo(oo),
				.vopbidirout(vopbidirout),
				.doddout(doddout),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_tx_buf_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_buf
#(
	parameter pre_emp_switching_ctrl_2nd_post_tap = 0,      // Valid values: 0..15
	parameter rx_det_output_sel = "rx_det_pcie_out",      // Valid values: rx_det_qpi_out|rx_det_pcie_out
	parameter vcm_current_addl = "vcm_current_default",      // Valid values: vcm_current_default|vcm_current_1|vcm_current_2|vcm_current_3
	parameter term_sel = "int_100ohm",      // Valid values: int_150ohm|int_120ohm|int_100ohm|int_85ohm|ext_res
	parameter rx_det = 0,      // Valid values: 0..15
	parameter fir_coeff_ctrl_sel = "ram_ctl",      // Valid values: dynamic_ctl|ram_ctl
	parameter dft_sel = "disabled",      // Valid values: vod_en_lsb|vod_en_msb|po1_en|disabled|pre_en_po2_en
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter pre_emp_switching_ctrl_pre_tap = 0,      // Valid values: 0..15
	parameter vod_switching_ctrl_main_tap = 50,      // Valid values: 0..63
	parameter local_ib_ctl = "ib_29ohm",      // Valid values: ib_49ohm|ib_29ohm|ib_42ohm|ib_22ohm
	parameter sig_inv_pre_tap = "false",      // Valid values: false|true
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter driver_resolution_ctrl = "disabled",      // Valid values: offset_main|offset_po1|conbination1|disabled|offset_pre|conbination2|conbination3|conbination4|half_resolution|conbination5|conbination6|conbination7|conbination8|conbination9|conbination10|conbination11
	parameter channel_number = 0,      // Valid values: 0..65
	parameter vccela_supply_voltage = "vccela_1p0v",      // Valid values: vccela_1p0v|vccela_0p85v
	parameter vcm_ctrl_sel = "ram_ctl",      // Valid values: ram_ctl|dynamic_ctl
	parameter swing_boost = "not_boost",      // Valid values: not_boost|boost
	parameter qpi_en = "false",      // Valid values: false|true
	parameter vod_boost = "not_boost",      // Valid values: not_boost|boost
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter rx_det_pdb = "true",      // Valid values: false|true
	parameter sig_inv_2nd_tap = "false",      // Valid values: false|true
	parameter common_mode_driver_sel = "volt_0p65v",      // Valid values: volt_0p80v|volt_0p75v|volt_0p70v|volt_0p65v|volt_0p60v|volt_0p55v|volt_0p50v|volt_0p35v|pull_up|pull_dn|tristated1|grounded|pull_up_to_vccela|tristated2|tristated3|tristated4
	parameter pre_emp_switching_ctrl_1st_post_tap = 0,      // Valid values: 0..31
	parameter slew_rate_ctrl = 5,      // Valid values: 1..5
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter pre_emp_switching_ctrl_2nd_post_tap_analog_reconfig = 0,      // Valid values: 0..31
	parameter local_ib_en = "local_ib_en",      // Valid values: local_ib_dis|local_ib_en
	parameter pre_emp_switching_ctrl_pre_tap_analog_reconfig = 0,      // Valid values: 0..31
	parameter ser_att_buf_en = "disable"	//Valid values: disable|enable
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] datain,
	output [ 0:0 ] dataout,
	output [ 0:0 ] fixedclkout,
	input  [ 17:0 ] icoeff,
	input  [ 0:0 ] nonuserfrompmaux,
	input  [ 0:0 ] rxdetclk,
	output [ 0:0 ] rxdetectvalid,
	output [ 0:0 ] rxfound,
	input  [ 0:0 ] txdetrx,
	input  [ 0:0 ] txelecidl,
	input  [ 0:0 ] txqpipulldn,
	input  [ 0:0 ] txqpipullup,
	input  [ 0:0 ] vrlpbkn,
	input  [ 0:0 ] vrlpbkn1t,
	input  [ 0:0 ] vrlpbkp,
	input  [ 0:0 ] vrlpbkp1t
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_tx_buf : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_tx_buf_encrypted_ES #(
				.pre_emp_switching_ctrl_2nd_post_tap(pre_emp_switching_ctrl_2nd_post_tap),
				.rx_det_output_sel(rx_det_output_sel),
				.vcm_current_addl(vcm_current_addl),
				.term_sel(term_sel),
				.rx_det(rx_det),
				.fir_coeff_ctrl_sel(fir_coeff_ctrl_sel),
				.dft_sel(dft_sel),
				.avmm_group_channel_index(avmm_group_channel_index),
				.pre_emp_switching_ctrl_pre_tap(pre_emp_switching_ctrl_pre_tap),
				.vod_switching_ctrl_main_tap(vod_switching_ctrl_main_tap),
				.local_ib_ctl(local_ib_ctl),
				.sig_inv_pre_tap(sig_inv_pre_tap),
				.user_base_address(user_base_address),
				.driver_resolution_ctrl(driver_resolution_ctrl),
				.channel_number(channel_number),
				.vccela_supply_voltage(vccela_supply_voltage),
				.vcm_ctrl_sel(vcm_ctrl_sel),
				.swing_boost(swing_boost),
				.qpi_en(qpi_en),
				.vod_boost(vod_boost),
				.use_default_base_address(use_default_base_address),
				.rx_det_pdb(rx_det_pdb),
				.sig_inv_2nd_tap(sig_inv_2nd_tap),
				.common_mode_driver_sel(common_mode_driver_sel),
				.pre_emp_switching_ctrl_1st_post_tap(pre_emp_switching_ctrl_1st_post_tap),
				.slew_rate_ctrl(slew_rate_ctrl)
			) stratixv_hssi_pma_tx_buf_encrypted_ES_inst (
				.vrlpbkp(vrlpbkp),
				.txqpipulldn(txqpipulldn),
				.datain(datain),
				.txelecidl(txelecidl),
				.avmmclk(avmmclk),
				.vrlpbkn(vrlpbkn),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.fixedclkout(fixedclkout),
				.nonuserfrompmaux(nonuserfrompmaux),
				.dataout(dataout),
				.txqpipullup(txqpipullup),
				.icoeff(icoeff),
				.avmmread(avmmread),
				.rxdetclk(rxdetclk),
				.rxfound(rxfound),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.txdetrx(txdetrx),
				.vrlpbkn1t(vrlpbkn1t),
				.rxdetectvalid(rxdetectvalid),
				.avmmwrite(avmmwrite),
				.vrlpbkp1t(vrlpbkp1t),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_tx_buf_encrypted #(
				.pre_emp_switching_ctrl_2nd_post_tap(pre_emp_switching_ctrl_2nd_post_tap),
				.rx_det_output_sel(rx_det_output_sel),
				.vcm_current_addl(vcm_current_addl),
				.term_sel(term_sel),
				.rx_det(rx_det),
				.fir_coeff_ctrl_sel(fir_coeff_ctrl_sel),
				.dft_sel(dft_sel),
				.pre_emp_switching_ctrl_pre_tap(pre_emp_switching_ctrl_pre_tap),
				.avmm_group_channel_index(avmm_group_channel_index),
				.vod_switching_ctrl_main_tap(vod_switching_ctrl_main_tap),
				.local_ib_ctl(local_ib_ctl),
				.sig_inv_pre_tap(sig_inv_pre_tap),
				.user_base_address(user_base_address),
				.driver_resolution_ctrl(driver_resolution_ctrl),
				.channel_number(channel_number),
				.vccela_supply_voltage(vccela_supply_voltage),
				.pre_emp_switching_ctrl_2nd_post_tap_analog_reconfig(pre_emp_switching_ctrl_2nd_post_tap_analog_reconfig),
				.local_ib_en(local_ib_en),
				.vcm_ctrl_sel(vcm_ctrl_sel),
				.swing_boost(swing_boost),
				.qpi_en(qpi_en),
				.vod_boost(vod_boost),
				.use_default_base_address(use_default_base_address),
				.rx_det_pdb(rx_det_pdb),
				.pre_emp_switching_ctrl_pre_tap_analog_reconfig(pre_emp_switching_ctrl_pre_tap_analog_reconfig),
				.sig_inv_2nd_tap(sig_inv_2nd_tap),
				.common_mode_driver_sel(common_mode_driver_sel),
				.pre_emp_switching_ctrl_1st_post_tap(pre_emp_switching_ctrl_1st_post_tap),
				.slew_rate_ctrl(slew_rate_ctrl)
			) stratixv_hssi_pma_tx_buf_encrypted_inst (
				.vrlpbkp(vrlpbkp),
				.txqpipulldn(txqpipulldn),
				.datain(datain),
				.txelecidl(txelecidl),
				.avmmclk(avmmclk),
				.vrlpbkn(vrlpbkn),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.fixedclkout(fixedclkout),
				.nonuserfrompmaux(nonuserfrompmaux),
				.dataout(dataout),
				.txqpipullup(txqpipullup),
				.icoeff(icoeff),
				.avmmread(avmmread),
				.rxdetclk(rxdetclk),
				.rxfound(rxfound),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.txdetrx(txdetrx),
				.vrlpbkn1t(vrlpbkn1t),
				.rxdetectvalid(rxdetectvalid),
				.avmmwrite(avmmwrite),
				.vrlpbkp1t(vrlpbkp1t),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_tx_cgb_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_cgb
#(
	parameter x1_clock4_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter x1_div_m_sel = 1,      // Valid values: 1|2|4|8
	parameter mode = 8,      // Valid values: 8|10|16|20|32|40|64|80
	parameter x1_clock2_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter reset_scheme = "non_reset_bonding_scheme",      // Valid values: non_reset_bonding_scheme|reset_bonding_scheme
	parameter clk_mute = "disable_clockmute",      // Valid values: disable_clockmute|enable_clock_mute|enable_clock_mute_master_channel
	parameter data_rate = "",      // Valid values: 
	parameter cgb_iqclk_sel = "tristate",      // Valid values: cgb_x1_n_div|rx_output|tristate
	parameter x1_clock7_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter xn_clock_source_sel = "cgb_xn_unused",      // Valid values: xn_up|ch1_x6_dn|xn_dn|ch1_x6_up|cgb_x1_m_div|cgb_ht|cgb_xn_unused
	parameter pll_feedback = "non_pll_feedback",      // Valid values: non_pll_feedback|pll_feedback
	parameter x1_clock5_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter x1_clock_source_sel = "x1_clk_unused",      // Valid values: up_segmented|down_segmented|ffpll|ch1_txpll_t|ch1_txpll_b|same_ch_txpll|hfclk_xn_up|hfclk_ch1_x6_dn|hfclk_xn_dn|hfclk_ch1_x6_up|lcpll_top|lcpll_bottom|up_segmented_g2_ch1_txpll_b_g3|up_segmented_g2_same_ch_txpll_g3|up_segmented_g2_lcpll_top_g3|up_segmented_g2_lcpll_bottom_g3|down_segmented_g2_ch1_txpll_b_g3|down_segmented_g2_same_ch_txpll_g3|down_segmented_g2_lcpll_top_g3|down_segmented_g2_lcpll_bottom_g3|ch1_txpll_t_g2_ch1_txpll_b_g3|ch1_txpll_t_g2_same_ch_txpll_g3|ch1_txpll_t_g2_lcpll_top_g3|ch1_txpll_t_g2_lcpll_bottom_g3|ch1_txpll_b_g2_ch1_txpll_t_g3|ch1_txpll_b_g2_lcpll_top_g3|ch1_txpll_b_g2_lcpll_bottom_g3|hfclk_xn_up_g2_ch1_txpll_t_g3|hfclk_xn_up_g2_lcpll_top_g3|hfclk_xn_up_g2_lcpll_bottom_g3|hfclk_ch1_x6_dn_g2_ch1_txpll_t_g3|hfclk_ch1_x6_dn_g2_lcpll_top_g3|hfclk_ch1_x6_dn_g2_lcpll_bottom_g3|hfclk_xn_dn_g2_ch1_txpll_t_g3|hfclk_xn_dn_g2_lcpll_top_g3|hfclk_xn_dn_g2_lcpll_bottom_g3|hfclk_ch1_x6_up_g2_ch1_txpll_t_g3|hfclk_ch1_x6_up_g2_lcpll_top_g3|hfclk_ch1_x6_up_g2_lcpll_bottom_g3|same_ch_txpll_g2_ch1_txpll_t_g3|same_ch_txpll_g2_lcpll_top_g3|same_ch_txpll_g2_lcpll_bottom_g3|lcpll_top_g2_ch1_txpll_t_g3|lcpll_top_g2_ch1_txpll_b_g3|lcpll_top_g2_same_ch_txpll_g3|lcpll_top_g2_lcpll_bottom_g3|lcpll_bottom_g2_ch1_txpll_t_g3|lcpll_bottom_g2_ch1_txpll_b_g3|lcpll_bottom_g2_same_ch_txpll_g3|lcpll_bottom_g2_lcpll_top_g3|x1_clk_unused
	parameter channel_number = 0,      // Valid values: 0..255
	parameter tx_mux_power_down = "normal",      // Valid values: power_down|normal
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter x1_clock0_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter x1_clock1_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter auto_negotiation = "false",      // Valid values: false|true
	parameter pcie_g3_x8 = "non_pcie_g3_x8",      // Valid values: non_pcie_g3_x8|pcie_g3_x8
	parameter cgb_sync = "normal",      // Valid values: pcs_sync_rst|normal|sync_rst
	parameter x1_clock3_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter x1_clock6_logical_to_physical_mapping = "x1_clk_unused",      // Valid values: same_ch_txpll|ch1_txpll_t|ch1_txpll_b|lcpll_top|lcpll_bottom|ffpll|up_segmented|down_segmented|x1_clk_unused
	parameter pcie_rst = "normal_reset",      // Valid values: normal_reset|pcie_reset
	parameter silicon_rev = "reve",      // Valid values: reve|es
	parameter fref_vco_bypass = "normal_operation"      // Valid values: normal_operation|fref_bypass
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clkbcdr1b,
	input  [ 0:0 ] clkbcdr1t,
	input  [ 0:0 ] clkbcdrloc,
	input  [ 0:0 ] clkbdnseg,
	input  [ 0:0 ] clkbffpll,
	input  [ 0:0 ] clkblcb,
	input  [ 0:0 ] clkblct,
	input  [ 0:0 ] clkbupseg,
	input  [ 0:0 ] clkcdr1b,
	input  [ 0:0 ] clkcdr1t,
	input  [ 0:0 ] clkcdrloc,
	input  [ 0:0 ] clkdnseg,
	input  [ 0:0 ] clkffpll,
	input  [ 0:0 ] clklcb,
	input  [ 0:0 ] clklct,
	input  [ 0:0 ] clkupseg,
	output [ 0:0 ] cpulse,
	output [ 0:0 ] cpulseout,
	input  [ 0:0 ] cpulsex6dn,
	input  [ 0:0 ] cpulsex6up,
	input  [ 0:0 ] cpulsexndn,
	input  [ 0:0 ] cpulsexnup,
	output [ 0:0 ] hfclkn,
	output [ 0:0 ] hfclknout,
	input  [ 0:0 ] hfclknx6dn,
	input  [ 0:0 ] hfclknx6up,
	input  [ 0:0 ] hfclknxndn,
	input  [ 0:0 ] hfclknxnup,
	output [ 0:0 ] hfclkp,
	output [ 0:0 ] hfclkpout,
	input  [ 0:0 ] hfclkpx6dn,
	input  [ 0:0 ] hfclkpx6up,
	input  [ 0:0 ] hfclkpxndn,
	input  [ 0:0 ] hfclkpxnup,
	output [ 0:0 ] lfclkn,
	output [ 0:0 ] lfclknout,
	input  [ 0:0 ] lfclknx6dn,
	input  [ 0:0 ] lfclknx6up,
	input  [ 0:0 ] lfclknxndn,
	input  [ 0:0 ] lfclknxnup,
	output [ 0:0 ] lfclkp,
	output [ 0:0 ] lfclkpout,
	input  [ 0:0 ] lfclkpx6dn,
	input  [ 0:0 ] lfclkpx6up,
	input  [ 0:0 ] lfclkpxndn,
	input  [ 0:0 ] lfclkpxnup,
	output [ 0:0 ] pciefbclk,
	input  [ 1:0 ] pciesw,
	output [ 1:0 ] pcieswdone,
	output [ 0:0 ] pciesyncp,
	output [ 2:0 ] pclk,
	output [ 2:0 ] pclkout,
	input  [ 2:0 ] pclkx6dn,
	input  [ 2:0 ] pclkx6up,
	input  [ 2:0 ] pclkxndn,
	input  [ 2:0 ] pclkxnup,
	output [ 0:0 ] pllfbsw,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] rxclk,
	output [ 0:0 ] rxiqclk,
	input  [ 0:0 ] txpmasyncp,
	input  [ 0:0 ] fref,
	input  [ 0:0 ] pcs_rst_n
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_tx_cgb : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_tx_cgb_encrypted_ES #(
				.x1_clock4_logical_to_physical_mapping(x1_clock4_logical_to_physical_mapping),
				.x1_div_m_sel(x1_div_m_sel),
				.mode(mode),
				.x1_clock2_logical_to_physical_mapping(x1_clock2_logical_to_physical_mapping),
				.reset_scheme(reset_scheme),
				.clk_mute(clk_mute),
				.data_rate(data_rate),
				.cgb_iqclk_sel(cgb_iqclk_sel),
				.x1_clock7_logical_to_physical_mapping(x1_clock7_logical_to_physical_mapping),
				.avmm_group_channel_index(avmm_group_channel_index),
				.xn_clock_source_sel(xn_clock_source_sel),
				.pll_feedback(pll_feedback),
				.x1_clock5_logical_to_physical_mapping(x1_clock5_logical_to_physical_mapping),
				.user_base_address(user_base_address),
				.x1_clock_source_sel(x1_clock_source_sel),
				.channel_number(channel_number),
				.tx_mux_power_down(tx_mux_power_down),
				.use_default_base_address(use_default_base_address),
				.x1_clock0_logical_to_physical_mapping(x1_clock0_logical_to_physical_mapping),
				.x1_clock1_logical_to_physical_mapping(x1_clock1_logical_to_physical_mapping),
				.auto_negotiation(auto_negotiation),
				.pcie_g3_x8(pcie_g3_x8),
				.cgb_sync(cgb_sync),
				.x1_clock3_logical_to_physical_mapping(x1_clock3_logical_to_physical_mapping),
				.x1_clock6_logical_to_physical_mapping(x1_clock6_logical_to_physical_mapping)
			) stratixv_hssi_pma_tx_cgb_encrypted_ES_inst (
				.pclkx6dn(pclkx6dn),
				.pclk(pclk),
				.pciesyncp(pciesyncp),
				.pcieswdone(pcieswdone),
				.clkbdnseg(clkbdnseg),
				.pllfbsw(pllfbsw),
				.lfclkn(lfclkn),
				.clkdnseg(clkdnseg),
				.lfclknxnup(lfclknxnup),
				.hfclkpout(hfclkpout),
				.hfclkp(hfclkp),
				.hfclkpx6dn(hfclkpx6dn),
				.cpulsexndn(cpulsexndn),
				.pclkx6up(pclkx6up),
				.avmmwrite(avmmwrite),
				.clklct(clklct),
				.clkbupseg(clkbupseg),
				.rxclk(rxclk),
				.hfclkpxnup(hfclkpxnup),
				.lfclknx6up(lfclknx6up),
				.lfclkp(lfclkp),
				.lfclkpx6up(lfclkpx6up),
				.lfclknout(lfclknout),
				.lfclkpout(lfclkpout),
				.hfclkpxndn(hfclkpxndn),
				.hfclkpx6up(hfclkpx6up),
				.clkblct(clkblct),
				.clkbcdr1t(clkbcdr1t),
				.lfclkpxndn(lfclkpxndn),
				.cpulsexnup(cpulsexnup),
				.pclkout(pclkout),
				.hfclknxndn(hfclknxndn),
				.txpmasyncp(txpmasyncp),
				.pclkxndn(pclkxndn),
				.lfclknx6dn(lfclknx6dn),
				.clkbcdrloc(clkbcdrloc),
				.clkcdr1t(clkcdr1t),
				.clkupseg(clkupseg),
				.clklcb(clklcb),
				.avmmclk(avmmclk),
				.lfclkpxnup(lfclkpxnup),
				.avmmrstn(avmmrstn),
				.clkbcdr1b(clkbcdr1b),
				.lfclknxndn(lfclknxndn),
				.avmmbyteen(avmmbyteen),
				.clkcdrloc(clkcdrloc),
				.cpulseout(cpulseout),
				.hfclkn(hfclkn),
				.pciesw(pciesw),
				.pciefbclk(pciefbclk),
				.avmmreaddata(avmmreaddata),
				.clkbffpll(clkbffpll),
				.hfclknx6dn(hfclknx6dn),
				.hfclknx6up(hfclknx6up),
				.hfclknout(hfclknout),
				.clkcdr1b(clkcdr1b),
				.avmmaddress(avmmaddress),
				.clkffpll(clkffpll),
				.cpulsex6up(cpulsex6up),
				.cpulse(cpulse),
				.rxiqclk(rxiqclk),
				.cpulsex6dn(cpulsex6dn),
				.avmmread(avmmread),
				.rstn(rstn),
				.clkblcb(clkblcb),
				.blockselect(blockselect),
				.hfclknxnup(hfclknxnup),
				.pclkxnup(pclkxnup),
				.lfclkpx6dn(lfclkpx6dn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_tx_cgb_encrypted #(
				.x1_clock4_logical_to_physical_mapping(x1_clock4_logical_to_physical_mapping),
				.x1_div_m_sel(x1_div_m_sel),
				.mode(mode),
				.x1_clock2_logical_to_physical_mapping(x1_clock2_logical_to_physical_mapping),
				.reset_scheme(reset_scheme),
				.clk_mute(clk_mute),
				.data_rate(data_rate),
				.pcie_rst(pcie_rst),
				.cgb_iqclk_sel(cgb_iqclk_sel),
				.x1_clock7_logical_to_physical_mapping(x1_clock7_logical_to_physical_mapping),
				.avmm_group_channel_index(avmm_group_channel_index),
				.xn_clock_source_sel(xn_clock_source_sel),
				.pll_feedback(pll_feedback),
				.x1_clock5_logical_to_physical_mapping(x1_clock5_logical_to_physical_mapping),
				.user_base_address(user_base_address),
				.x1_clock_source_sel(x1_clock_source_sel),
				.channel_number(channel_number),
				.tx_mux_power_down(tx_mux_power_down),
				.use_default_base_address(use_default_base_address),
				.x1_clock0_logical_to_physical_mapping(x1_clock0_logical_to_physical_mapping),
				.fref_vco_bypass(fref_vco_bypass),
				.x1_clock1_logical_to_physical_mapping(x1_clock1_logical_to_physical_mapping),
				.auto_negotiation(auto_negotiation),
				.pcie_g3_x8(pcie_g3_x8),
				.cgb_sync(cgb_sync),
				.x1_clock3_logical_to_physical_mapping(x1_clock3_logical_to_physical_mapping),
				.x1_clock6_logical_to_physical_mapping(x1_clock6_logical_to_physical_mapping)
			) stratixv_hssi_pma_tx_cgb_encrypted_inst (
				.pclkx6dn(pclkx6dn),
				.pclk(pclk),
				.pciesyncp(pciesyncp),
				.pcieswdone(pcieswdone),
				.clkbdnseg(clkbdnseg),
				.pllfbsw(pllfbsw),
				.lfclkn(lfclkn),
				.clkdnseg(clkdnseg),
				.pcs_rst_n(pcs_rst_n),
				.lfclknxnup(lfclknxnup),
				.hfclkpout(hfclkpout),
				.hfclkp(hfclkp),
				.hfclkpx6dn(hfclkpx6dn),
				.cpulsexndn(cpulsexndn),
				.pclkx6up(pclkx6up),
				.avmmwrite(avmmwrite),
				.clklct(clklct),
				.fref(fref),
				.clkbupseg(clkbupseg),
				.rxclk(rxclk),
				.hfclkpxnup(hfclkpxnup),
				.lfclknx6up(lfclknx6up),
				.lfclkp(lfclkp),
				.lfclkpx6up(lfclkpx6up),
				.lfclknout(lfclknout),
				.lfclkpout(lfclkpout),
				.hfclkpxndn(hfclkpxndn),
				.hfclkpx6up(hfclkpx6up),
				.clkblct(clkblct),
				.clkbcdr1t(clkbcdr1t),
				.lfclkpxndn(lfclkpxndn),
				.cpulsexnup(cpulsexnup),
				.pclkout(pclkout),
				.hfclknxndn(hfclknxndn),
				.txpmasyncp(txpmasyncp),
				.pclkxndn(pclkxndn),
				.lfclknx6dn(lfclknx6dn),
				.clkbcdrloc(clkbcdrloc),
				.clkcdr1t(clkcdr1t),
				.clkupseg(clkupseg),
				.clklcb(clklcb),
				.avmmclk(avmmclk),
				.lfclkpxnup(lfclkpxnup),
				.avmmrstn(avmmrstn),
				.clkbcdr1b(clkbcdr1b),
				.lfclknxndn(lfclknxndn),
				.avmmbyteen(avmmbyteen),
				.clkcdrloc(clkcdrloc),
				.cpulseout(cpulseout),
				.hfclkn(hfclkn),
				.pciesw(pciesw),
				.pciefbclk(pciefbclk),
				.avmmreaddata(avmmreaddata),
				.clkbffpll(clkbffpll),
				.hfclknx6dn(hfclknx6dn),
				.hfclknx6up(hfclknx6up),
				.hfclknout(hfclknout),
				.clkcdr1b(clkcdr1b),
				.avmmaddress(avmmaddress),
				.clkffpll(clkffpll),
				.cpulsex6up(cpulsex6up),
				.cpulse(cpulse),
				.rxiqclk(rxiqclk),
				.cpulsex6dn(cpulsex6dn),
				.avmmread(avmmread),
				.rstn(rstn),
				.clkblcb(clkblcb),
				.blockselect(blockselect),
				.hfclknxnup(hfclknxnup),
				.pclkxnup(pclkxnup),
				.lfclkpx6dn(lfclkpx6dn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_tx_ser_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_tx_ser
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter channel_number = 0,      // Valid values: 0..65
	parameter clk_divtx_deskew = 0,      // Valid values: 0..15
	parameter mode = 8,      // Valid values: 8|10|16|20|32|40|64|80
	parameter pre_tap_en = "true",      // Valid values: false|true
	parameter ser_loopback = "false",      // Valid values: false|true
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter auto_negotiation = "false",      // Valid values: false|true
	parameter post_tap_2_en = "true",      // Valid values: false|true
	parameter clk_forward_only_mode = "false",      // Valid values: false|true
	parameter duty_cycle_tune = "duty_cycle3",	//Valid values: duty_cycle0|duty_cycle1|duty_cycle2|duty_cycle3|duty_cycle4|duty_cycle5|duty_cycle6|duty_cycle7
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter post_tap_1_en = "true",      // Valid values: false|true
	parameter pma_direct = "false",      // Valid values: false|true
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkdivtx,
	input  [ 0:0 ] cpulse,
	input  [ 79:0 ] datain,
	output [ 0:0 ] dataout,
	input  [ 0:0 ] hfclk,
	input  [ 0:0 ] hfclkn,
	output [ 0:0 ] lbvon,
	output [ 0:0 ] lbvop,
	input  [ 0:0 ] lfclk,
	input  [ 0:0 ] lfclkn,
	input  [ 1:0 ] pciesw,
	input  [ 0:0 ] pciesyncp,
	input  [ 2:0 ] pclk,
	output [ 0:0 ] preenout,
	input  [ 0:0 ] rstn,
	input  [ 0:0 ] slpbk
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_tx_ser : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_tx_ser_encrypted_ES #(
				.user_base_address(user_base_address),
				.channel_number(channel_number),
				.clk_divtx_deskew(clk_divtx_deskew),
				.mode(mode),
				.pre_tap_en(pre_tap_en),
				.ser_loopback(ser_loopback),
				.use_default_base_address(use_default_base_address),
				.auto_negotiation(auto_negotiation),
				.post_tap_2_en(post_tap_2_en),
				.clk_forward_only_mode(clk_forward_only_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.post_tap_1_en(post_tap_1_en)
			) stratixv_hssi_pma_tx_ser_encrypted_ES_inst (
				.datain(datain),
				.hfclk(hfclk),
				.lbvon(lbvon),
				.cpulse(cpulse),
				.avmmclk(avmmclk),
				.pclk(pclk),
				.pciesyncp(pciesyncp),
				.clkdivtx(clkdivtx),
				.avmmrstn(avmmrstn),
				.preenout(preenout),
				.lfclkn(lfclkn),
				.avmmbyteen(avmmbyteen),
				.lbvop(lbvop),
				.hfclkn(hfclkn),
				.dataout(dataout),
				.avmmread(avmmread),
				.rstn(rstn),
				.lfclk(lfclk),
				.pciesw(pciesw),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_tx_ser_encrypted #(
				.user_base_address(user_base_address),
				.channel_number(channel_number),
				.clk_divtx_deskew(clk_divtx_deskew),
				.mode(mode),
				.pre_tap_en(pre_tap_en),
				.ser_loopback(ser_loopback),
				.use_default_base_address(use_default_base_address),
				.pma_direct(pma_direct),
				.auto_negotiation(auto_negotiation),
				.post_tap_2_en(post_tap_2_en),
				.clk_forward_only_mode(clk_forward_only_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.post_tap_1_en(post_tap_1_en)
			) stratixv_hssi_pma_tx_ser_encrypted_inst (
				.datain(datain),
				.hfclk(hfclk),
				.lbvon(lbvon),
				.cpulse(cpulse),
				.avmmclk(avmmclk),
				.pclk(pclk),
				.pciesyncp(pciesyncp),
				.clkdivtx(clkdivtx),
				.avmmrstn(avmmrstn),
				.preenout(preenout),
				.lfclkn(lfclkn),
				.avmmbyteen(avmmbyteen),
				.lbvop(lbvop),
				.hfclkn(hfclkn),
				.dataout(dataout),
				.avmmread(avmmread),
				.rstn(rstn),
				.lfclk(lfclk),
				.pciesw(pciesw),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.slpbk(slpbk),
				.avmmaddress(avmmaddress),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_rx_pcs_pma_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_rx_pcs_pma_interface
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter prot_mode = "other_protocols",      // Valid values: other_protocols|cpri_8g
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter selectpcs = "eight_g_pcs",      // Valid values: eight_g_pcs|ten_g_pcs|pcie_gen3|default
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter clkslip_sel = "pld",      // Valid values: pld|slip_eight_g_pcs
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkoutto10gpcs,
	input  [ 0:0 ] clockinfrompma,
	output [ 0:0 ] clockoutto8gpcs,
	output [ 0:0 ] clockouttogen3pcs,
	input  [ 79:0 ] datainfrompma,
	output [ 79:0 ] dataoutto10gpcs,
	output [ 19:0 ] dataoutto8gpcs,
	output [ 31:0 ] dataouttogen3pcs,
	output [ 0:0 ] pcs10gclkdiv33txorrx,
	input  [ 0:0 ] pcs10grxclkiqout,
	output [ 0:0 ] pcs10gsignalok,
	input  [ 0:0 ] pcs8grxclkiqout,
	input  [ 0:0 ] pcs8grxclkslip,
	output [ 0:0 ] pcs8gsigdetni,
	input  [ 0:0 ] pcsemsiprxclkiqout,
	output [ 1:0 ] pcsgen3eyemonitorin,
	input  [ 7:0 ] pcsgen3eyemonitorout,
	output [ 0:0 ] pcsgen3pmasignaldet,
	input  [ 0:0 ] pldrxclkslip,
	input  [ 0:0 ] pldrxpmarstb,
	input  [ 0:0 ] pmaclkdiv33txorrxin,
	output [ 0:0 ] pmaclkdiv33txorrxout,
	input  [ 1:0 ] pmaeyemonitorin,
	output [ 7:0 ] pmaeyemonitorout,
	input  [ 4:0 ] pmareservedin,
	output [ 4:0 ] pmareservedout,
	output [ 0:0 ] pmarxclkout,
	output [ 0:0 ] pmarxclkslip,
	input  [ 0:0 ] pmarxpllphaselockin,
	output [ 0:0 ] pmarxpllphaselockout,
	output [ 0:0 ] pmarxpmarstb,
	input  [ 0:0 ] pmasigdet,
	input  [ 0:0 ] pmasignalok,
	output [ 0:0 ] reset
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_rx_pcs_pma_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_rx_pcs_pma_interface_encrypted_ES #(
				.user_base_address(user_base_address),
				.prot_mode(prot_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.clkslip_sel(clkslip_sel)
			) stratixv_hssi_rx_pcs_pma_interface_encrypted_ES_inst (
				.pmarxpllphaselockout(pmarxpllphaselockout),
				.pcsgen3eyemonitorin(pcsgen3eyemonitorin),
				.dataouttogen3pcs(dataouttogen3pcs),
				.pcs8gsigdetni(pcs8gsigdetni),
				.asynchdatain(asynchdatain),
				.avmmclk(avmmclk),
				.clkoutto10gpcs(clkoutto10gpcs),
				.clockoutto8gpcs(clockoutto8gpcs),
				.avmmrstn(avmmrstn),
				.pcs8grxclkslip(pcs8grxclkslip),
				.pmaeyemonitorin(pmaeyemonitorin),
				.avmmbyteen(avmmbyteen),
				.pmarxclkout(pmarxclkout),
				.pcs8grxclkiqout(pcs8grxclkiqout),
				.pmasigdet(pmasigdet),
				.clockinfrompma(clockinfrompma),
				.datainfrompma(datainfrompma),
				.dataoutto8gpcs(dataoutto8gpcs),
				.avmmreaddata(avmmreaddata),
				.pmareservedin(pmareservedin),
				.pmarxpmarstb(pmarxpmarstb),
				.dataoutto10gpcs(dataoutto10gpcs),
				.pmarxpllphaselockin(pmarxpllphaselockin),
				.avmmwrite(avmmwrite),
				.avmmaddress(avmmaddress),
				.pldrxpmarstb(pldrxpmarstb),
				.pmasignalok(pmasignalok),
				.clockouttogen3pcs(clockouttogen3pcs),
				.pmaeyemonitorout(pmaeyemonitorout),
				.pmaclkdiv33txorrxout(pmaclkdiv33txorrxout),
				.pldrxclkslip(pldrxclkslip),
				.pcs10gsignalok(pcs10gsignalok),
				.pcsgen3pmasignaldet(pcsgen3pmasignaldet),
				.reset(reset),
				.pcsemsiprxclkiqout(pcsemsiprxclkiqout),
				.pmarxclkslip(pmarxclkslip),
				.pcsgen3eyemonitorout(pcsgen3eyemonitorout),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.pcs10grxclkiqout(pcs10grxclkiqout),
				.pmareservedout(pmareservedout),
				.pmaclkdiv33txorrxin(pmaclkdiv33txorrxin),
				.pcs10gclkdiv33txorrx(pcs10gclkdiv33txorrx),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_rx_pcs_pma_interface_encrypted #(
				.user_base_address(user_base_address),
				.prot_mode(prot_mode),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.clkslip_sel(clkslip_sel)
			) stratixv_hssi_rx_pcs_pma_interface_encrypted_inst (
				.pmarxpllphaselockout(pmarxpllphaselockout),
				.pcsgen3eyemonitorin(pcsgen3eyemonitorin),
				.dataouttogen3pcs(dataouttogen3pcs),
				.pcs8gsigdetni(pcs8gsigdetni),
				.asynchdatain(asynchdatain),
				.avmmclk(avmmclk),
				.clkoutto10gpcs(clkoutto10gpcs),
				.clockoutto8gpcs(clockoutto8gpcs),
				.avmmrstn(avmmrstn),
				.pcs8grxclkslip(pcs8grxclkslip),
				.pmaeyemonitorin(pmaeyemonitorin),
				.avmmbyteen(avmmbyteen),
				.pmarxclkout(pmarxclkout),
				.pcs8grxclkiqout(pcs8grxclkiqout),
				.pmasigdet(pmasigdet),
				.clockinfrompma(clockinfrompma),
				.datainfrompma(datainfrompma),
				.dataoutto8gpcs(dataoutto8gpcs),
				.avmmreaddata(avmmreaddata),
				.pmareservedin(pmareservedin),
				.pmarxpmarstb(pmarxpmarstb),
				.dataoutto10gpcs(dataoutto10gpcs),
				.pmarxpllphaselockin(pmarxpllphaselockin),
				.avmmwrite(avmmwrite),
				.avmmaddress(avmmaddress),
				.pldrxpmarstb(pldrxpmarstb),
				.pmasignalok(pmasignalok),
				.clockouttogen3pcs(clockouttogen3pcs),
				.pmaeyemonitorout(pmaeyemonitorout),
				.pmaclkdiv33txorrxout(pmaclkdiv33txorrxout),
				.pldrxclkslip(pldrxclkslip),
				.pcs10gsignalok(pcs10gsignalok),
				.pcsgen3pmasignaldet(pcsgen3pmasignaldet),
				.reset(reset),
				.pcsemsiprxclkiqout(pcsemsiprxclkiqout),
				.pmarxclkslip(pmarxclkslip),
				.pcsgen3eyemonitorout(pcsgen3eyemonitorout),
				.avmmread(avmmread),
				.blockselect(blockselect),
				.pcs10grxclkiqout(pcs10grxclkiqout),
				.pmareservedout(pmareservedout),
				.pmaclkdiv33txorrxin(pmaclkdiv33txorrxin),
				.pcs10gclkdiv33txorrx(pcs10gclkdiv33txorrx),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_rx_pld_pcs_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_rx_pld_pcs_interface
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter data_source = "pld",      // Valid values: emsip|pld
	parameter is_10g_0ppm = "false",      // Valid values: false|true
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter selectpcs = "eight_g_pcs",      // Valid values: eight_g_pcs|ten_g_pcs|default
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter is_8g_0ppm = "false",      // Valid values: false|true
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clockinfrom10gpcs,
	input  [ 0:0 ] clockinfrom8gpcs,
	input  [ 63:0 ] datainfrom10gpcs,
	input  [ 63:0 ] datainfrom8gpcs,
	output [ 63:0 ] dataouttopld,
	input  [ 0:0 ] emsipenablediocsrrdydly,
	input  [ 2:0 ] emsiprxclkin,
	output [ 2:0 ] emsiprxclkout,
	input  [ 19:0 ] emsiprxin,
	output [ 128:0 ] emsiprxout,
	input  [ 12:0 ] emsiprxspecialin,
	output [ 15:0 ] emsiprxspecialout,
	output [ 0:0 ] pcs10grxalignclr,
	output [ 0:0 ] pcs10grxalignen,
	input  [ 0:0 ] pcs10grxalignval,
	output [ 0:0 ] pcs10grxbitslip,
	input  [ 0:0 ] pcs10grxblklock,
	output [ 0:0 ] pcs10grxclrbercount,
	output [ 0:0 ] pcs10grxclrerrblkcnt,
	input  [ 9:0 ] pcs10grxcontrol,
	input  [ 0:0 ] pcs10grxcrc32err,
	input  [ 0:0 ] pcs10grxdatavalid,
	input  [ 0:0 ] pcs10grxdiagerr,
	input  [ 1:0 ] pcs10grxdiagstatus,
	output [ 0:0 ] pcs10grxdispclr,
	input  [ 0:0 ] pcs10grxempty,
	input  [ 0:0 ] pcs10grxfifodel,
	input  [ 0:0 ] pcs10grxfifoinsert,
	input  [ 0:0 ] pcs10grxframelock,
	input  [ 0:0 ] pcs10grxhiber,
	input  [ 0:0 ] pcs10grxmfrmerr,
	input  [ 0:0 ] pcs10grxoflwerr,
	input  [ 0:0 ] pcs10grxpempty,
	input  [ 0:0 ] pcs10grxpfull,
	output [ 0:0 ] pcs10grxpldclk,
	output [ 0:0 ] pcs10grxpldrstn,
	input  [ 0:0 ] pcs10grxprbserr,
	output [ 0:0 ] pcs10grxprbserrclr,
	input  [ 0:0 ] pcs10grxpyldins,
	output [ 0:0 ] pcs10grxrden,
	input  [ 0:0 ] pcs10grxrdnegsts,
	input  [ 0:0 ] pcs10grxrdpossts,
	input  [ 0:0 ] pcs10grxrxframe,
	input  [ 0:0 ] pcs10grxscrmerr,
	input  [ 0:0 ] pcs10grxsherr,
	input  [ 0:0 ] pcs10grxskiperr,
	input  [ 0:0 ] pcs10grxskipins,
	input  [ 0:0 ] pcs10grxsyncerr,
	input  [ 3:0 ] pcs8ga1a2k1k2flag,
	output [ 0:0 ] pcs8ga1a2size,
	input  [ 0:0 ] pcs8galignstatus,
	input  [ 0:0 ] pcs8gbistdone,
	input  [ 0:0 ] pcs8gbisterr,
	output [ 0:0 ] pcs8gbitlocreven,
	output [ 0:0 ] pcs8gbitslip,
	input  [ 0:0 ] pcs8gbyteordflag,
	output [ 0:0 ] pcs8gbytereven,
	output [ 0:0 ] pcs8gbytordpld,
	output [ 0:0 ] pcs8gcmpfifourst,
	input  [ 0:0 ] pcs8gemptyrmf,
	input  [ 0:0 ] pcs8gemptyrx,
	output [ 0:0 ] pcs8gencdt,
	input  [ 0:0 ] pcs8gfullrmf,
	input  [ 0:0 ] pcs8gfullrx,
	output [ 0:0 ] pcs8gphfifourstrx,
	input  [ 0:0 ] pcs8gphystatus,
	output [ 0:0 ] pcs8gpldrxclk,
	output [ 0:0 ] pcs8gpolinvrx,
	output [ 0:0 ] pcs8grdenablermf,
	output [ 0:0 ] pcs8grdenablerx,
	input  [ 0:0 ] pcs8grlvlt,
	input  [ 3:0 ] pcs8grxblkstart,
	input  [ 3:0 ] pcs8grxdatavalid,
	input  [ 0:0 ] pcs8grxelecidle,
	input  [ 2:0 ] pcs8grxstatus,
	input  [ 1:0 ] pcs8grxsynchdr,
	output [ 0:0 ] pcs8grxurstpcs,
	input  [ 0:0 ] pcs8grxvalid,
	input  [ 0:0 ] pcs8gsignaldetectout,
	output [ 0:0 ] pcs8gsyncsmenoutput,
	input  [ 4:0 ] pcs8gwaboundary,
	output [ 0:0 ] pcs8gwrdisablerx,
	output [ 0:0 ] pcs8gwrenablermf,
	output [ 0:0 ] pcsgen3rxrst,
	output [ 0:0 ] pcsgen3rxrstn,
	output [ 0:0 ] pcsgen3rxupdatefc,
	output [ 0:0 ] pcsgen3syncsmen,
	input  [ 0:0 ] pld10grxalignclr,
	input  [ 0:0 ] pld10grxalignen,
	output [ 0:0 ] pld10grxalignval,
	input  [ 0:0 ] pld10grxbitslip,
	output [ 0:0 ] pld10grxblklock,
	output [ 0:0 ] pld10grxclkout,
	input  [ 0:0 ] pld10grxclrbercount,
	input  [ 0:0 ] pld10grxclrerrblkcnt,
	output [ 9:0 ] pld10grxcontrol,
	output [ 0:0 ] pld10grxcrc32err,
	output [ 0:0 ] pld10grxdatavalid,
	output [ 0:0 ] pld10grxdiagerr,
	output [ 1:0 ] pld10grxdiagstatus,
	input  [ 0:0 ] pld10grxdispclr,
	output [ 0:0 ] pld10grxempty,
	output [ 0:0 ] pld10grxfifodel,
	output [ 0:0 ] pld10grxfifoinsert,
	output [ 0:0 ] pld10grxframelock,
	output [ 0:0 ] pld10grxhiber,
	output [ 0:0 ] pld10grxmfrmerr,
	output [ 0:0 ] pld10grxoflwerr,
	output [ 0:0 ] pld10grxpempty,
	output [ 0:0 ] pld10grxpfull,
	input  [ 0:0 ] pld10grxpldclk,
	input  [ 0:0 ] pld10grxpldrstn,
	output [ 0:0 ] pld10grxprbserr,
	input  [ 0:0 ] pld10grxprbserrclr,
	output [ 0:0 ] pld10grxpyldins,
	input  [ 0:0 ] pld10grxrden,
	output [ 0:0 ] pld10grxrdnegsts,
	output [ 0:0 ] pld10grxrdpossts,
	output [ 0:0 ] pld10grxrxframe,
	output [ 0:0 ] pld10grxscrmerr,
	output [ 0:0 ] pld10grxsherr,
	output [ 0:0 ] pld10grxskiperr,
	output [ 0:0 ] pld10grxskipins,
	output [ 0:0 ] pld10grxsyncerr,
	output [ 3:0 ] pld8ga1a2k1k2flag,
	input  [ 0:0 ] pld8ga1a2size,
	output [ 0:0 ] pld8galignstatus,
	output [ 0:0 ] pld8gbistdone,
	output [ 0:0 ] pld8gbisterr,
	input  [ 0:0 ] pld8gbitlocreven,
	input  [ 0:0 ] pld8gbitslip,
	output [ 0:0 ] pld8gbyteordflag,
	input  [ 0:0 ] pld8gbytereven,
	input  [ 0:0 ] pld8gbytordpld,
	input  [ 0:0 ] pld8gcmpfifourstn,
	output [ 0:0 ] pld8gemptyrmf,
	output [ 0:0 ] pld8gemptyrx,
	input  [ 0:0 ] pld8gencdt,
	output [ 0:0 ] pld8gfullrmf,
	output [ 0:0 ] pld8gfullrx,
	input  [ 0:0 ] pld8gphfifourstrxn,
	input  [ 0:0 ] pld8gpldrxclk,
	input  [ 0:0 ] pld8gpolinvrx,
	input  [ 0:0 ] pld8grdenablermf,
	input  [ 0:0 ] pld8grdenablerx,
	output [ 0:0 ] pld8grlvlt,
	output [ 3:0 ] pld8grxblkstart,
	output [ 0:0 ] pld8grxclkout,
	output [ 3:0 ] pld8grxdatavalid,
	output [ 1:0 ] pld8grxsynchdr,
	input  [ 0:0 ] pld8grxurstpcsn,
	output [ 0:0 ] pld8gsignaldetectout,
	input  [ 0:0 ] pld8gsyncsmeninput,
	output [ 4:0 ] pld8gwaboundary,
	input  [ 0:0 ] pld8gwrdisablerx,
	input  [ 0:0 ] pld8gwrenablermf,
	output [ 0:0 ] pldclkdiv33txorrx,
	input  [ 0:0 ] pldgen3rxrstn,
	input  [ 0:0 ] pldgen3rxupdatefc,
	input  [ 0:0 ] pldrxclkslipin,
	output [ 0:0 ] pldrxclkslipout,
	output [ 0:0 ] pldrxiqclkout,
	input  [ 0:0 ] pldrxpmarstbin,
	output [ 0:0 ] pldrxpmarstbout,
	input  [ 0:0 ] pmaclkdiv33txorrx,
	input  [ 0:0 ] pmarxplllock,
	output [ 0:0 ] reset,
	input  [ 0:0 ] rstsel,
	input  [ 0:0 ] usrrstsel
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_rx_pld_pcs_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_rx_pld_pcs_interface_encrypted_ES #(
				.user_base_address(user_base_address),
				.data_source(data_source),
				.is_10g_0ppm(is_10g_0ppm),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.is_8g_0ppm(is_8g_0ppm)
			) stratixv_hssi_rx_pld_pcs_interface_encrypted_ES_inst (
				.pcs8gbytordpld(pcs8gbytordpld),
				.pld10grxalignval(pld10grxalignval),
				.pldrxclkslipin(pldrxclkslipin),
				.pcs8gphfifourstrx(pcs8gphfifourstrx),
				.pld8grxclkout(pld8grxclkout),
				.pcs10grxhiber(pcs10grxhiber),
				.pcs8gencdt(pcs8gencdt),
				.pld10grxskiperr(pld10grxskiperr),
				.pcsgen3rxrst(pcsgen3rxrst),
				.pcs8gbisterr(pcs8gbisterr),
				.pld10grxmfrmerr(pld10grxmfrmerr),
				.pldrxpmarstbin(pldrxpmarstbin),
				.pcs8grdenablerx(pcs8grdenablerx),
				.pld10grxrdpossts(pld10grxrdpossts),
				.pcsgen3rxrstn(pcsgen3rxrstn),
				.avmmwrite(avmmwrite),
				.pld10grxprbserrclr(pld10grxprbserrclr),
				.pld10grxframelock(pld10grxframelock),
				.pcs8gemptyrmf(pcs8gemptyrmf),
				.pcs10grxcontrol(pcs10grxcontrol),
				.pcs10grxskipins(pcs10grxskipins),
				.pld10grxempty(pld10grxempty),
				.pcs10grxdatavalid(pcs10grxdatavalid),
				.pld8ga1a2k1k2flag(pld8ga1a2k1k2flag),
				.pld8gbytereven(pld8gbytereven),
				.pld8gsyncsmeninput(pld8gsyncsmeninput),
				.pcs8gwrenablermf(pcs8gwrenablermf),
				.pcs8gpolinvrx(pcs8gpolinvrx),
				.pcs10grxcrc32err(pcs10grxcrc32err),
				.pld10grxclrerrblkcnt(pld10grxclrerrblkcnt),
				.pld8gbytordpld(pld8gbytordpld),
				.pld10grxfifoinsert(pld10grxfifoinsert),
				.pcs8grxsynchdr(pcs8grxsynchdr),
				.pld8grlvlt(pld8grlvlt),
				.pcs10grxclrbercount(pcs10grxclrbercount),
				.pld8gbyteordflag(pld8gbyteordflag),
				.pld10grxpldrstn(pld10grxpldrstn),
				.pld8gfullrmf(pld8gfullrmf),
				.pcs8gcmpfifourst(pcs8gcmpfifourst),
				.pcs10grxskiperr(pcs10grxskiperr),
				.asynchdatain(asynchdatain),
				.pld8grxurstpcsn(pld8grxurstpcsn),
				.emsiprxspecialin(emsiprxspecialin),
				.emsiprxout(emsiprxout),
				.pld10grxalignclr(pld10grxalignclr),
				.pcs8gbitslip(pcs8gbitslip),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.emsiprxclkin(emsiprxclkin),
				.pld10grxblklock(pld10grxblklock),
				.pcs10grxpldrstn(pcs10grxpldrstn),
				.pcs10grxclrerrblkcnt(pcs10grxclrerrblkcnt),
				.pcs8gbytereven(pcs8gbytereven),
				.pcs8gphystatus(pcs8gphystatus),
				.avmmreaddata(avmmreaddata),
				.pld8gwrenablermf(pld8gwrenablermf),
				.pldclkdiv33txorrx(pldclkdiv33txorrx),
				.pld10grxfifodel(pld10grxfifodel),
				.pcs10grxblklock(pcs10grxblklock),
				.pld10grxrdnegsts(pld10grxrdnegsts),
				.avmmaddress(avmmaddress),
				.pld8gbistdone(pld8gbistdone),
				.pld8galignstatus(pld8galignstatus),
				.pldgen3rxupdatefc(pldgen3rxupdatefc),
				.datainfrom10gpcs(datainfrom10gpcs),
				.pld10grxbitslip(pld10grxbitslip),
				.emsiprxspecialout(emsiprxspecialout),
				.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
				.pcs10grxrdpossts(pcs10grxrdpossts),
				.pld8grxblkstart(pld8grxblkstart),
				.pcs8gwaboundary(pcs8gwaboundary),
				.pcs8grlvlt(pcs8grlvlt),
				.pld8gphfifourstrxn(pld8gphfifourstrxn),
				.pld10grxpyldins(pld10grxpyldins),
				.pcs10grxempty(pcs10grxempty),
				.avmmread(avmmread),
				.pcs8grdenablermf(pcs8grdenablermf),
				.pcs10grxprbserrclr(pcs10grxprbserrclr),
				.pldgen3rxrstn(pldgen3rxrstn),
				.pcs8gbitlocreven(pcs8gbitlocreven),
				.pld10grxskipins(pld10grxskipins),
				.pld8gemptyrx(pld8gemptyrx),
				.pld10grxclkout(pld10grxclkout),
				.pcsgen3rxupdatefc(pcsgen3rxupdatefc),
				.pcs10grxoflwerr(pcs10grxoflwerr),
				.pld8gsignaldetectout(pld8gsignaldetectout),
				.pcs10grxframelock(pcs10grxframelock),
				.pld8gwaboundary(pld8gwaboundary),
				.dataouttopld(dataouttopld),
				.pld10grxdiagerr(pld10grxdiagerr),
				.pcs8gbistdone(pcs8gbistdone),
				.pld8gemptyrmf(pld8gemptyrmf),
				.pld10grxsyncerr(pld10grxsyncerr),
				.pld10grxpempty(pld10grxpempty),
				.pld10grxsherr(pld10grxsherr),
				.pcs8galignstatus(pcs8galignstatus),
				.pcs10grxmfrmerr(pcs10grxmfrmerr),
				.pcs8gfullrx(pcs8gfullrx),
				.pld10grxdispclr(pld10grxdispclr),
				.pld10grxoflwerr(pld10grxoflwerr),
				.pcs10grxprbserr(pcs10grxprbserr),
				.pld10grxrden(pld10grxrden),
				.pcs10grxsherr(pcs10grxsherr),
				.pcs8gfullrmf(pcs8gfullrmf),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.pcs8grxblkstart(pcs8grxblkstart),
				.pcs8ga1a2size(pcs8ga1a2size),
				.pldrxclkslipout(pldrxclkslipout),
				.pld10grxdatavalid(pld10grxdatavalid),
				.pcs8ga1a2k1k2flag(pcs8ga1a2k1k2flag),
				.emsiprxin(emsiprxin),
				.pld8gfullrx(pld8gfullrx),
				.pld8gbisterr(pld8gbisterr),
				.pcs10grxalignval(pcs10grxalignval),
				.clockinfrom8gpcs(clockinfrom8gpcs),
				.pld8gbitslip(pld8gbitslip),
				.pld10grxpfull(pld10grxpfull),
				.pcs8grxstatus(pcs8grxstatus),
				.pcs10grxfifoinsert(pcs10grxfifoinsert),
				.usrrstsel(usrrstsel),
				.pld8gwrdisablerx(pld8gwrdisablerx),
				.pcs10grxdispclr(pcs10grxdispclr),
				.rstsel(rstsel),
				.pcs10grxdiagerr(pcs10grxdiagerr),
				.pcs10grxpldclk(pcs10grxpldclk),
				.pld8grxdatavalid(pld8grxdatavalid),
				.pld8gpldrxclk(pld8gpldrxclk),
				.pld8grdenablerx(pld8grdenablerx),
				.pcs10grxalignclr(pcs10grxalignclr),
				.pcs8grxelecidle(pcs8grxelecidle),
				.pcs8gsyncsmenoutput(pcs8gsyncsmenoutput),
				.pld10grxprbserr(pld10grxprbserr),
				.emsiprxclkout(emsiprxclkout),
				.pld10grxcontrol(pld10grxcontrol),
				.pld8gbitlocreven(pld8gbitlocreven),
				.pld10grxclrbercount(pld10grxclrbercount),
				.pcs10grxpempty(pcs10grxpempty),
				.pldrxiqclkout(pldrxiqclkout),
				.avmmclk(avmmclk),
				.pld8grxsynchdr(pld8grxsynchdr),
				.pld10grxpldclk(pld10grxpldclk),
				.pld10grxrxframe(pld10grxrxframe),
				.pcs10grxpyldins(pcs10grxpyldins),
				.pcs10grxbitslip(pcs10grxbitslip),
				.pcs8grxurstpcs(pcs8grxurstpcs),
				.pld8gencdt(pld8gencdt),
				.pld8grdenablermf(pld8grdenablermf),
				.pld10grxcrc32err(pld10grxcrc32err),
				.pld8gpolinvrx(pld8gpolinvrx),
				.pld10grxhiber(pld10grxhiber),
				.pld10grxscrmerr(pld10grxscrmerr),
				.pcs8gemptyrx(pcs8gemptyrx),
				.pcs8gbyteordflag(pcs8gbyteordflag),
				.pcs10grxpfull(pcs10grxpfull),
				.pcs8gsignaldetectout(pcs8gsignaldetectout),
				.pld10grxdiagstatus(pld10grxdiagstatus),
				.pcs8grxvalid(pcs8grxvalid),
				.pcs10grxrxframe(pcs10grxrxframe),
				.pld10grxalignen(pld10grxalignen),
				.pcs8grxdatavalid(pcs8grxdatavalid),
				.pcs8gpldrxclk(pcs8gpldrxclk),
				.pmarxplllock(pmarxplllock),
				.reset(reset),
				.pcs10grxfifodel(pcs10grxfifodel),
				.pldrxpmarstbout(pldrxpmarstbout),
				.pcsgen3syncsmen(pcsgen3syncsmen),
				.datainfrom8gpcs(datainfrom8gpcs),
				.pcs10grxalignen(pcs10grxalignen),
				.pcs10grxrden(pcs10grxrden),
				.pld8ga1a2size(pld8ga1a2size),
				.pcs10grxrdnegsts(pcs10grxrdnegsts),
				.pcs8gwrdisablerx(pcs8gwrdisablerx),
				.blockselect(blockselect),
				.pcs10grxsyncerr(pcs10grxsyncerr),
				.pcs10grxscrmerr(pcs10grxscrmerr),
				.pcs10grxdiagstatus(pcs10grxdiagstatus),
				.clockinfrom10gpcs(clockinfrom10gpcs),
				.pld8gcmpfifourstn(pld8gcmpfifourstn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_rx_pld_pcs_interface_encrypted #(
				.user_base_address(user_base_address),
				.data_source(data_source),
				.is_10g_0ppm(is_10g_0ppm),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address),
				.is_8g_0ppm(is_8g_0ppm)
			) stratixv_hssi_rx_pld_pcs_interface_encrypted_inst (
				.pcs8gbytordpld(pcs8gbytordpld),
				.pld10grxalignval(pld10grxalignval),
				.pldrxclkslipin(pldrxclkslipin),
				.pcs8gphfifourstrx(pcs8gphfifourstrx),
				.pld8grxclkout(pld8grxclkout),
				.pcs10grxhiber(pcs10grxhiber),
				.pcs8gencdt(pcs8gencdt),
				.pld10grxskiperr(pld10grxskiperr),
				.pcsgen3rxrst(pcsgen3rxrst),
				.pcs8gbisterr(pcs8gbisterr),
				.pld10grxmfrmerr(pld10grxmfrmerr),
				.pldrxpmarstbin(pldrxpmarstbin),
				.pcs8grdenablerx(pcs8grdenablerx),
				.pld10grxrdpossts(pld10grxrdpossts),
				.pcsgen3rxrstn(pcsgen3rxrstn),
				.avmmwrite(avmmwrite),
				.pld10grxprbserrclr(pld10grxprbserrclr),
				.pld10grxframelock(pld10grxframelock),
				.pcs8gemptyrmf(pcs8gemptyrmf),
				.pcs10grxcontrol(pcs10grxcontrol),
				.pcs10grxskipins(pcs10grxskipins),
				.pld10grxempty(pld10grxempty),
				.pcs10grxdatavalid(pcs10grxdatavalid),
				.pld8ga1a2k1k2flag(pld8ga1a2k1k2flag),
				.pld8gbytereven(pld8gbytereven),
				.pld8gsyncsmeninput(pld8gsyncsmeninput),
				.pcs8gwrenablermf(pcs8gwrenablermf),
				.pcs8gpolinvrx(pcs8gpolinvrx),
				.pcs10grxcrc32err(pcs10grxcrc32err),
				.pld10grxclrerrblkcnt(pld10grxclrerrblkcnt),
				.pld8gbytordpld(pld8gbytordpld),
				.pld10grxfifoinsert(pld10grxfifoinsert),
				.pcs8grxsynchdr(pcs8grxsynchdr),
				.pld8grlvlt(pld8grlvlt),
				.pcs10grxclrbercount(pcs10grxclrbercount),
				.pld8gbyteordflag(pld8gbyteordflag),
				.pld10grxpldrstn(pld10grxpldrstn),
				.pld8gfullrmf(pld8gfullrmf),
				.pcs8gcmpfifourst(pcs8gcmpfifourst),
				.pcs10grxskiperr(pcs10grxskiperr),
				.asynchdatain(asynchdatain),
				.pld8grxurstpcsn(pld8grxurstpcsn),
				.emsiprxspecialin(emsiprxspecialin),
				.emsiprxout(emsiprxout),
				.pld10grxalignclr(pld10grxalignclr),
				.pcs8gbitslip(pcs8gbitslip),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.emsiprxclkin(emsiprxclkin),
				.pld10grxblklock(pld10grxblklock),
				.pcs10grxpldrstn(pcs10grxpldrstn),
				.pcs10grxclrerrblkcnt(pcs10grxclrerrblkcnt),
				.pcs8gbytereven(pcs8gbytereven),
				.pcs8gphystatus(pcs8gphystatus),
				.avmmreaddata(avmmreaddata),
				.pld8gwrenablermf(pld8gwrenablermf),
				.pldclkdiv33txorrx(pldclkdiv33txorrx),
				.pld10grxfifodel(pld10grxfifodel),
				.pcs10grxblklock(pcs10grxblklock),
				.pld10grxrdnegsts(pld10grxrdnegsts),
				.avmmaddress(avmmaddress),
				.pld8gbistdone(pld8gbistdone),
				.pld8galignstatus(pld8galignstatus),
				.pldgen3rxupdatefc(pldgen3rxupdatefc),
				.datainfrom10gpcs(datainfrom10gpcs),
				.pld10grxbitslip(pld10grxbitslip),
				.emsiprxspecialout(emsiprxspecialout),
				.pmaclkdiv33txorrx(pmaclkdiv33txorrx),
				.pcs10grxrdpossts(pcs10grxrdpossts),
				.pld8grxblkstart(pld8grxblkstart),
				.pcs8gwaboundary(pcs8gwaboundary),
				.pcs8grlvlt(pcs8grlvlt),
				.pld8gphfifourstrxn(pld8gphfifourstrxn),
				.pld10grxpyldins(pld10grxpyldins),
				.pcs10grxempty(pcs10grxempty),
				.avmmread(avmmread),
				.pcs8grdenablermf(pcs8grdenablermf),
				.pcs10grxprbserrclr(pcs10grxprbserrclr),
				.pldgen3rxrstn(pldgen3rxrstn),
				.pcs8gbitlocreven(pcs8gbitlocreven),
				.pld10grxskipins(pld10grxskipins),
				.pld8gemptyrx(pld8gemptyrx),
				.pld10grxclkout(pld10grxclkout),
				.pcsgen3rxupdatefc(pcsgen3rxupdatefc),
				.pcs10grxoflwerr(pcs10grxoflwerr),
				.pld8gsignaldetectout(pld8gsignaldetectout),
				.pcs10grxframelock(pcs10grxframelock),
				.pld8gwaboundary(pld8gwaboundary),
				.dataouttopld(dataouttopld),
				.pld10grxdiagerr(pld10grxdiagerr),
				.pcs8gbistdone(pcs8gbistdone),
				.pld8gemptyrmf(pld8gemptyrmf),
				.pld10grxsyncerr(pld10grxsyncerr),
				.pld10grxpempty(pld10grxpempty),
				.pld10grxsherr(pld10grxsherr),
				.pcs8galignstatus(pcs8galignstatus),
				.pcs10grxmfrmerr(pcs10grxmfrmerr),
				.pcs8gfullrx(pcs8gfullrx),
				.pld10grxdispclr(pld10grxdispclr),
				.pld10grxoflwerr(pld10grxoflwerr),
				.pcs10grxprbserr(pcs10grxprbserr),
				.pld10grxrden(pld10grxrden),
				.pcs10grxsherr(pcs10grxsherr),
				.pcs8gfullrmf(pcs8gfullrmf),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.pcs8grxblkstart(pcs8grxblkstart),
				.pcs8ga1a2size(pcs8ga1a2size),
				.pldrxclkslipout(pldrxclkslipout),
				.pld10grxdatavalid(pld10grxdatavalid),
				.pcs8ga1a2k1k2flag(pcs8ga1a2k1k2flag),
				.emsiprxin(emsiprxin),
				.pld8gfullrx(pld8gfullrx),
				.pld8gbisterr(pld8gbisterr),
				.pcs10grxalignval(pcs10grxalignval),
				.clockinfrom8gpcs(clockinfrom8gpcs),
				.pld8gbitslip(pld8gbitslip),
				.pld10grxpfull(pld10grxpfull),
				.pcs8grxstatus(pcs8grxstatus),
				.pcs10grxfifoinsert(pcs10grxfifoinsert),
				.usrrstsel(usrrstsel),
				.pld8gwrdisablerx(pld8gwrdisablerx),
				.pcs10grxdispclr(pcs10grxdispclr),
				.rstsel(rstsel),
				.pcs10grxdiagerr(pcs10grxdiagerr),
				.pcs10grxpldclk(pcs10grxpldclk),
				.pld8grxdatavalid(pld8grxdatavalid),
				.pld8gpldrxclk(pld8gpldrxclk),
				.pld8grdenablerx(pld8grdenablerx),
				.pcs10grxalignclr(pcs10grxalignclr),
				.pcs8grxelecidle(pcs8grxelecidle),
				.pcs8gsyncsmenoutput(pcs8gsyncsmenoutput),
				.pld10grxprbserr(pld10grxprbserr),
				.emsiprxclkout(emsiprxclkout),
				.pld10grxcontrol(pld10grxcontrol),
				.pld8gbitlocreven(pld8gbitlocreven),
				.pld10grxclrbercount(pld10grxclrbercount),
				.pcs10grxpempty(pcs10grxpempty),
				.pldrxiqclkout(pldrxiqclkout),
				.avmmclk(avmmclk),
				.pld8grxsynchdr(pld8grxsynchdr),
				.pld10grxpldclk(pld10grxpldclk),
				.pld10grxrxframe(pld10grxrxframe),
				.pcs10grxpyldins(pcs10grxpyldins),
				.pcs10grxbitslip(pcs10grxbitslip),
				.pcs8grxurstpcs(pcs8grxurstpcs),
				.pld8gencdt(pld8gencdt),
				.pld8grdenablermf(pld8grdenablermf),
				.pld10grxcrc32err(pld10grxcrc32err),
				.pld8gpolinvrx(pld8gpolinvrx),
				.pld10grxhiber(pld10grxhiber),
				.pld10grxscrmerr(pld10grxscrmerr),
				.pcs8gemptyrx(pcs8gemptyrx),
				.pcs8gbyteordflag(pcs8gbyteordflag),
				.pcs10grxpfull(pcs10grxpfull),
				.pcs8gsignaldetectout(pcs8gsignaldetectout),
				.pld10grxdiagstatus(pld10grxdiagstatus),
				.pcs8grxvalid(pcs8grxvalid),
				.pcs10grxrxframe(pcs10grxrxframe),
				.pld10grxalignen(pld10grxalignen),
				.pcs8grxdatavalid(pcs8grxdatavalid),
				.pcs8gpldrxclk(pcs8gpldrxclk),
				.pmarxplllock(pmarxplllock),
				.reset(reset),
				.pcs10grxfifodel(pcs10grxfifodel),
				.pldrxpmarstbout(pldrxpmarstbout),
				.pcsgen3syncsmen(pcsgen3syncsmen),
				.datainfrom8gpcs(datainfrom8gpcs),
				.pcs10grxalignen(pcs10grxalignen),
				.pcs10grxrden(pcs10grxrden),
				.pld8ga1a2size(pld8ga1a2size),
				.pcs10grxrdnegsts(pcs10grxrdnegsts),
				.pcs8gwrdisablerx(pcs8gwrdisablerx),
				.blockselect(blockselect),
				.pcs10grxsyncerr(pcs10grxsyncerr),
				.pcs10grxscrmerr(pcs10grxscrmerr),
				.pcs10grxdiagstatus(pcs10grxdiagstatus),
				.clockinfrom10gpcs(clockinfrom10gpcs),
				.pld8gcmpfifourstn(pld8gcmpfifourstn),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_tx_pcs_pma_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_tx_pcs_pma_interface
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter selectpcs = "eight_g_pcs",      // Valid values: eight_g_pcs|ten_g_pcs|pcie_gen3|default
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clockinfrompma,
	output [ 0:0 ] clockoutto10gpcs,
	output [ 0:0 ] clockoutto8gpcs,
	input  [ 79:0 ] datainfrom10gpcs,
	input  [ 19:0 ] datainfrom8gpcs,
	input  [ 31:0 ] datainfromgen3pcs,
	output [ 79:0 ] dataouttopma,
	output [ 0:0 ] pcs10gclkdiv33lc,
	input  [ 0:0 ] pcs10gtxclkiqout,
	input  [ 0:0 ] pcs8gtxclkiqout,
	input  [ 0:0 ] pcsemsiptxclkiqout,
	input  [ 0:0 ] pcsgen3gen3datasel,
	input  [ 0:0 ] pldtxpmasyncpfbkp,
	input  [ 0:0 ] pmaclkdiv33lcin,
	output [ 0:0 ] pmaclkdiv33lcout,
	input  [ 0:0 ] pmarxfreqtxcmuplllockin,
	output [ 0:0 ] pmarxfreqtxcmuplllockout,
	output [ 0:0 ] pmatxclkout,
	input  [ 0:0 ] pmatxlcplllockin,
	output [ 0:0 ] pmatxlcplllockout,
	output [ 0:0 ] pmatxpmasyncpfbkp,
	output [ 0:0 ] reset
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_tx_pcs_pma_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_tx_pcs_pma_interface_encrypted_ES #(
				.user_base_address(user_base_address),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address)
			) stratixv_hssi_tx_pcs_pma_interface_encrypted_ES_inst (
				.pmaclkdiv33lcout(pmaclkdiv33lcout),
				.asynchdatain(asynchdatain),
				.pmatxclkout(pmatxclkout),
				.avmmclk(avmmclk),
				.clockoutto8gpcs(clockoutto8gpcs),
				.datainfromgen3pcs(datainfromgen3pcs),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.pldtxpmasyncpfbkp(pldtxpmasyncpfbkp),
				.pmarxfreqtxcmuplllockout(pmarxfreqtxcmuplllockout),
				.clockinfrompma(clockinfrompma),
				.pmatxlcplllockout(pmatxlcplllockout),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.avmmaddress(avmmaddress),
				.datainfrom10gpcs(datainfrom10gpcs),
				.pcs10gtxclkiqout(pcs10gtxclkiqout),
				.reset(reset),
				.datainfrom8gpcs(datainfrom8gpcs),
				.pmaclkdiv33lcin(pmaclkdiv33lcin),
				.avmmread(avmmread),
				.pmatxlcplllockin(pmatxlcplllockin),
				.dataouttopma(dataouttopma),
				.pmatxpmasyncpfbkp(pmatxpmasyncpfbkp),
				.blockselect(blockselect),
				.pmarxfreqtxcmuplllockin(pmarxfreqtxcmuplllockin),
				.pcs10gclkdiv33lc(pcs10gclkdiv33lc),
				.pcs8gtxclkiqout(pcs8gtxclkiqout),
				.pcsemsiptxclkiqout(pcsemsiptxclkiqout),
				.pcsgen3gen3datasel(pcsgen3gen3datasel),
				.clockoutto10gpcs(clockoutto10gpcs),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_tx_pcs_pma_interface_encrypted #(
				.user_base_address(user_base_address),
				.avmm_group_channel_index(avmm_group_channel_index),
				.selectpcs(selectpcs),
				.use_default_base_address(use_default_base_address)
			) stratixv_hssi_tx_pcs_pma_interface_encrypted_inst (
				.pmaclkdiv33lcout(pmaclkdiv33lcout),
				.asynchdatain(asynchdatain),
				.pmatxclkout(pmatxclkout),
				.avmmclk(avmmclk),
				.clockoutto8gpcs(clockoutto8gpcs),
				.datainfromgen3pcs(datainfromgen3pcs),
				.avmmrstn(avmmrstn),
				.avmmbyteen(avmmbyteen),
				.pldtxpmasyncpfbkp(pldtxpmasyncpfbkp),
				.pmarxfreqtxcmuplllockout(pmarxfreqtxcmuplllockout),
				.clockinfrompma(clockinfrompma),
				.pmatxlcplllockout(pmatxlcplllockout),
				.avmmreaddata(avmmreaddata),
				.avmmwrite(avmmwrite),
				.avmmaddress(avmmaddress),
				.datainfrom10gpcs(datainfrom10gpcs),
				.pcs10gtxclkiqout(pcs10gtxclkiqout),
				.reset(reset),
				.datainfrom8gpcs(datainfrom8gpcs),
				.pmaclkdiv33lcin(pmaclkdiv33lcin),
				.avmmread(avmmread),
				.pmatxlcplllockin(pmatxlcplllockin),
				.dataouttopma(dataouttopma),
				.pmatxpmasyncpfbkp(pmatxpmasyncpfbkp),
				.blockselect(blockselect),
				.pmarxfreqtxcmuplllockin(pmarxfreqtxcmuplllockin),
				.pcs10gclkdiv33lc(pcs10gclkdiv33lc),
				.pcs8gtxclkiqout(pcs8gtxclkiqout),
				.pcsemsiptxclkiqout(pcsemsiptxclkiqout),
				.pcsgen3gen3datasel(pcsgen3gen3datasel),
				.clockoutto10gpcs(clockoutto10gpcs),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_tx_pld_pcs_interface_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_tx_pld_pcs_interface
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter data_source = "pld",      // Valid values: emsip|pld
	parameter is_10g_0ppm = "false",      // Valid values: false|true
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter is_8g_0ppm = "false",      // Valid values: false|true
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	output [ 0:0 ] asynchdatain,
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] clockinfrom10gpcs,
	input  [ 0:0 ] clockinfrom8gpcs,
	input  [ 63:0 ] datainfrompld,
	output [ 63:0 ] dataoutto10gpcs,
	output [ 43:0 ] dataoutto8gpcs,
	input  [ 0:0 ] emsipenablediocsrrdydly,
	input  [ 2:0 ] emsippcstxclkin,
	output [ 2:0 ] emsippcstxclkout,
	input  [ 103:0 ] emsiptxin,
	output [ 11:0 ] emsiptxout,
	input  [ 12:0 ] emsiptxspecialin,
	output [ 15:0 ] emsiptxspecialout,
	output [ 6:0 ] pcs10gtxbitslip,
	output [ 0:0 ] pcs10gtxbursten,
	input  [ 0:0 ] pcs10gtxburstenexe,
	output [ 8:0 ] pcs10gtxcontrol,
	output [ 0:0 ] pcs10gtxdatavalid,
	output [ 1:0 ] pcs10gtxdiagstatus,
	input  [ 0:0 ] pcs10gtxempty,
	input  [ 0:0 ] pcs10gtxfifodel,
	input  [ 0:0 ] pcs10gtxfifoinsert,
	input  [ 0:0 ] pcs10gtxframe,
	input  [ 0:0 ] pcs10gtxfull,
	input  [ 0:0 ] pcs10gtxpempty,
	input  [ 0:0 ] pcs10gtxpfull,
	output [ 0:0 ] pcs10gtxpldclk,
	output [ 0:0 ] pcs10gtxpldrstn,
	output [ 0:0 ] pcs10gtxwordslip,
	input  [ 0:0 ] pcs10gtxwordslipexe,
	input  [ 0:0 ] pcs8gemptytx,
	input  [ 0:0 ] pcs8gfulltx,
	output [ 0:0 ] pcs8gphfifoursttx,
	output [ 0:0 ] pcs8gpldtxclk,
	output [ 0:0 ] pcs8gpolinvtx,
	output [ 0:0 ] pcs8grddisabletx,
	output [ 0:0 ] pcs8grevloopbk,
	output [ 3:0 ] pcs8gtxblkstart,
	output [ 4:0 ] pcs8gtxboundarysel,
	output [ 3:0 ] pcs8gtxdatavalid,
	output [ 1:0 ] pcs8gtxsynchdr,
	output [ 0:0 ] pcs8gtxurstpcs,
	output [ 0:0 ] pcs8gwrenabletx,
	output [ 0:0 ] pcsgen3txrst,
	output [ 0:0 ] pcsgen3txrstn,
	input  [ 6:0 ] pld10gtxbitslip,
	input  [ 0:0 ] pld10gtxbursten,
	output [ 0:0 ] pld10gtxburstenexe,
	output [ 0:0 ] pld10gtxclkout,
	input  [ 8:0 ] pld10gtxcontrol,
	input  [ 0:0 ] pld10gtxdatavalid,
	input  [ 1:0 ] pld10gtxdiagstatus,
	output [ 0:0 ] pld10gtxempty,
	output [ 0:0 ] pld10gtxfifodel,
	output [ 0:0 ] pld10gtxfifoinsert,
	output [ 0:0 ] pld10gtxframe,
	output [ 0:0 ] pld10gtxfull,
	output [ 0:0 ] pld10gtxpempty,
	output [ 0:0 ] pld10gtxpfull,
	input  [ 0:0 ] pld10gtxpldclk,
	input  [ 0:0 ] pld10gtxpldrstn,
	input  [ 0:0 ] pld10gtxwordslip,
	output [ 0:0 ] pld10gtxwordslipexe,
	output [ 0:0 ] pld8gemptytx,
	output [ 0:0 ] pld8gfulltx,
	input  [ 0:0 ] pld8gphfifoursttxn,
	input  [ 0:0 ] pld8gpldtxclk,
	input  [ 0:0 ] pld8gpolinvtx,
	input  [ 0:0 ] pld8grddisabletx,
	input  [ 0:0 ] pld8grevloopbk,
	input  [ 3:0 ] pld8gtxblkstart,
	input  [ 4:0 ] pld8gtxboundarysel,
	output [ 0:0 ] pld8gtxclkout,
	input  [ 3:0 ] pld8gtxdatavalid,
	input  [ 1:0 ] pld8gtxsynchdr,
	input  [ 0:0 ] pld8gtxurstpcsn,
	input  [ 0:0 ] pld8gwrenabletx,
	output [ 0:0 ] pldclkdiv33lc,
	input  [ 0:0 ] pldgen3txrstn,
	output [ 0:0 ] pldlccmurstbout,
	output [ 0:0 ] pldtxiqclkout,
	output [ 0:0 ] pldtxpmasyncpfbkpout,
	input  [ 0:0 ] pmaclkdiv33lc,
	input  [ 0:0 ] pmatxcmuplllock,
	input  [ 0:0 ] pmatxlcplllock,
	output [ 0:0 ] reset,
	input  [ 0:0 ] rstsel,
	input  [ 0:0 ] usrrstsel
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_tx_pld_pcs_interface : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_tx_pld_pcs_interface_encrypted_ES #(
				.user_base_address(user_base_address),
				.data_source(data_source),
				.is_10g_0ppm(is_10g_0ppm),
				.avmm_group_channel_index(avmm_group_channel_index),
				.use_default_base_address(use_default_base_address),
				.is_8g_0ppm(is_8g_0ppm)
			) stratixv_hssi_tx_pld_pcs_interface_encrypted_ES_inst (
				.pld10gtxpfull(pld10gtxpfull),
				.pcs8gpolinvtx(pcs8gpolinvtx),
				.pmatxlcplllock(pmatxlcplllock),
				.pldgen3txrstn(pldgen3txrstn),
				.pcs10gtxwordslip(pcs10gtxwordslip),
				.pcs10gtxempty(pcs10gtxempty),
				.pldtxiqclkout(pldtxiqclkout),
				.pld10gtxbitslip(pld10gtxbitslip),
				.pld10gtxfifoinsert(pld10gtxfifoinsert),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.dataoutto8gpcs(dataoutto8gpcs),
				.pcs8gtxblkstart(pcs8gtxblkstart),
				.avmmwrite(avmmwrite),
				.pld8gphfifoursttxn(pld8gphfifoursttxn),
				.pld10gtxfifodel(pld10gtxfifodel),
				.clockinfrom8gpcs(clockinfrom8gpcs),
				.pcs10gtxdiagstatus(pcs10gtxdiagstatus),
				.pld10gtxcontrol(pld10gtxcontrol),
				.pcs10gtxpldrstn(pcs10gtxpldrstn),
				.pld10gtxempty(pld10gtxempty),
				.usrrstsel(usrrstsel),
				.pcs8gpldtxclk(pcs8gpldtxclk),
				.pld10gtxfull(pld10gtxfull),
				.pcs10gtxcontrol(pcs10gtxcontrol),
				.pcs10gtxdatavalid(pcs10gtxdatavalid),
				.emsiptxin(emsiptxin),
				.pld10gtxframe(pld10gtxframe),
				.rstsel(rstsel),
				.pcs8gtxboundarysel(pcs8gtxboundarysel),
				.pcs10gtxbitslip(pcs10gtxbitslip),
				.emsiptxspecialout(emsiptxspecialout),
				.pcs8gwrenabletx(pcs8gwrenabletx),
				.pcs8gtxurstpcs(pcs8gtxurstpcs),
				.pcs8grevloopbk(pcs8grevloopbk),
				.pld10gtxpldclk(pld10gtxpldclk),
				.pld8gtxsynchdr(pld8gtxsynchdr),
				.pcsgen3txrstn(pcsgen3txrstn),
				.emsippcstxclkin(emsippcstxclkin),
				.pcs8gphfifoursttx(pcs8gphfifoursttx),
				.pld8grevloopbk(pld8grevloopbk),
				.asynchdatain(asynchdatain),
				.avmmclk(avmmclk),
				.pcs10gtxwordslipexe(pcs10gtxwordslipexe),
				.pldlccmurstbout(pldlccmurstbout),
				.pld10gtxdatavalid(pld10gtxdatavalid),
				.pld8grddisabletx(pld8grddisabletx),
				.avmmrstn(avmmrstn),
				.pcsgen3txrst(pcsgen3txrst),
				.pcs10gtxfifoinsert(pcs10gtxfifoinsert),
				.pld8gwrenabletx(pld8gwrenabletx),
				.avmmbyteen(avmmbyteen),
				.pldclkdiv33lc(pldclkdiv33lc),
				.pcs10gtxpldclk(pcs10gtxpldclk),
				.pcs8grddisabletx(pcs8grddisabletx),
				.pcs8gtxsynchdr(pcs8gtxsynchdr),
				.pld8gtxurstpcsn(pld8gtxurstpcsn),
				.pmatxcmuplllock(pmatxcmuplllock),
				.pld8gemptytx(pld8gemptytx),
				.pcs10gtxpempty(pcs10gtxpempty),
				.pld8gtxdatavalid(pld8gtxdatavalid),
				.avmmreaddata(avmmreaddata),
				.emsippcstxclkout(emsippcstxclkout),
				.pldtxpmasyncpfbkpout(pldtxpmasyncpfbkpout),
				.dataoutto10gpcs(dataoutto10gpcs),
				.pld8gtxblkstart(pld8gtxblkstart),
				.emsiptxout(emsiptxout),
				.pcs10gtxburstenexe(pcs10gtxburstenexe),
				.pld10gtxwordslip(pld10gtxwordslip),
				.pcs8gfulltx(pcs8gfulltx),
				.pld8gtxclkout(pld8gtxclkout),
				.emsiptxspecialin(emsiptxspecialin),
				.avmmaddress(avmmaddress),
				.pld10gtxpldrstn(pld10gtxpldrstn),
				.pld8gtxboundarysel(pld8gtxboundarysel),
				.pld8gpldtxclk(pld8gpldtxclk),
				.pcs10gtxframe(pcs10gtxframe),
				.reset(reset),
				.datainfrompld(datainfrompld),
				.pcs10gtxbursten(pcs10gtxbursten),
				.pcs10gtxpfull(pcs10gtxpfull),
				.pld10gtxbursten(pld10gtxbursten),
				.pcs8gemptytx(pcs8gemptytx),
				.avmmread(avmmread),
				.pld10gtxpempty(pld10gtxpempty),
				.pcs10gtxfull(pcs10gtxfull),
				.pld10gtxwordslipexe(pld10gtxwordslipexe),
				.pcs10gtxfifodel(pcs10gtxfifodel),
				.pld8gpolinvtx(pld8gpolinvtx),
				.blockselect(blockselect),
				.pmaclkdiv33lc(pmaclkdiv33lc),
				.pld8gfulltx(pld8gfulltx),
				.pld10gtxdiagstatus(pld10gtxdiagstatus),
				.pld10gtxclkout(pld10gtxclkout),
				.clockinfrom10gpcs(clockinfrom10gpcs),
				.pld10gtxburstenexe(pld10gtxburstenexe),
				.pcs8gtxdatavalid(pcs8gtxdatavalid),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_tx_pld_pcs_interface_encrypted #(
				.user_base_address(user_base_address),
				.data_source(data_source),
				.is_10g_0ppm(is_10g_0ppm),
				.avmm_group_channel_index(avmm_group_channel_index),
				.use_default_base_address(use_default_base_address),
				.is_8g_0ppm(is_8g_0ppm)
			) stratixv_hssi_tx_pld_pcs_interface_encrypted_inst (
				.pld10gtxpfull(pld10gtxpfull),
				.pcs8gpolinvtx(pcs8gpolinvtx),
				.pmatxlcplllock(pmatxlcplllock),
				.pldgen3txrstn(pldgen3txrstn),
				.pcs10gtxwordslip(pcs10gtxwordslip),
				.pcs10gtxempty(pcs10gtxempty),
				.pldtxiqclkout(pldtxiqclkout),
				.pld10gtxbitslip(pld10gtxbitslip),
				.pld10gtxfifoinsert(pld10gtxfifoinsert),
				.emsipenablediocsrrdydly(emsipenablediocsrrdydly),
				.dataoutto8gpcs(dataoutto8gpcs),
				.pcs8gtxblkstart(pcs8gtxblkstart),
				.avmmwrite(avmmwrite),
				.pld8gphfifoursttxn(pld8gphfifoursttxn),
				.pld10gtxfifodel(pld10gtxfifodel),
				.clockinfrom8gpcs(clockinfrom8gpcs),
				.pcs10gtxdiagstatus(pcs10gtxdiagstatus),
				.pld10gtxcontrol(pld10gtxcontrol),
				.pcs10gtxpldrstn(pcs10gtxpldrstn),
				.pld10gtxempty(pld10gtxempty),
				.usrrstsel(usrrstsel),
				.pcs8gpldtxclk(pcs8gpldtxclk),
				.pld10gtxfull(pld10gtxfull),
				.pcs10gtxcontrol(pcs10gtxcontrol),
				.pcs10gtxdatavalid(pcs10gtxdatavalid),
				.emsiptxin(emsiptxin),
				.pld10gtxframe(pld10gtxframe),
				.rstsel(rstsel),
				.pcs8gtxboundarysel(pcs8gtxboundarysel),
				.pcs10gtxbitslip(pcs10gtxbitslip),
				.emsiptxspecialout(emsiptxspecialout),
				.pcs8gwrenabletx(pcs8gwrenabletx),
				.pcs8gtxurstpcs(pcs8gtxurstpcs),
				.pcs8grevloopbk(pcs8grevloopbk),
				.pld10gtxpldclk(pld10gtxpldclk),
				.pld8gtxsynchdr(pld8gtxsynchdr),
				.pcsgen3txrstn(pcsgen3txrstn),
				.emsippcstxclkin(emsippcstxclkin),
				.pcs8gphfifoursttx(pcs8gphfifoursttx),
				.pld8grevloopbk(pld8grevloopbk),
				.asynchdatain(asynchdatain),
				.avmmclk(avmmclk),
				.pcs10gtxwordslipexe(pcs10gtxwordslipexe),
				.pldlccmurstbout(pldlccmurstbout),
				.pld10gtxdatavalid(pld10gtxdatavalid),
				.pld8grddisabletx(pld8grddisabletx),
				.avmmrstn(avmmrstn),
				.pcsgen3txrst(pcsgen3txrst),
				.pcs10gtxfifoinsert(pcs10gtxfifoinsert),
				.pld8gwrenabletx(pld8gwrenabletx),
				.avmmbyteen(avmmbyteen),
				.pldclkdiv33lc(pldclkdiv33lc),
				.pcs10gtxpldclk(pcs10gtxpldclk),
				.pcs8grddisabletx(pcs8grddisabletx),
				.pcs8gtxsynchdr(pcs8gtxsynchdr),
				.pld8gtxurstpcsn(pld8gtxurstpcsn),
				.pmatxcmuplllock(pmatxcmuplllock),
				.pld8gemptytx(pld8gemptytx),
				.pcs10gtxpempty(pcs10gtxpempty),
				.pld8gtxdatavalid(pld8gtxdatavalid),
				.avmmreaddata(avmmreaddata),
				.emsippcstxclkout(emsippcstxclkout),
				.pldtxpmasyncpfbkpout(pldtxpmasyncpfbkpout),
				.dataoutto10gpcs(dataoutto10gpcs),
				.pld8gtxblkstart(pld8gtxblkstart),
				.emsiptxout(emsiptxout),
				.pcs10gtxburstenexe(pcs10gtxburstenexe),
				.pld10gtxwordslip(pld10gtxwordslip),
				.pcs8gfulltx(pcs8gfulltx),
				.pld8gtxclkout(pld8gtxclkout),
				.emsiptxspecialin(emsiptxspecialin),
				.avmmaddress(avmmaddress),
				.pld10gtxpldrstn(pld10gtxpldrstn),
				.pld8gtxboundarysel(pld8gtxboundarysel),
				.pld8gpldtxclk(pld8gpldtxclk),
				.pcs10gtxframe(pcs10gtxframe),
				.reset(reset),
				.datainfrompld(datainfrompld),
				.pcs10gtxbursten(pcs10gtxbursten),
				.pcs10gtxpfull(pcs10gtxpfull),
				.pld10gtxbursten(pld10gtxbursten),
				.pcs8gemptytx(pcs8gemptytx),
				.avmmread(avmmread),
				.pld10gtxpempty(pld10gtxpempty),
				.pcs10gtxfull(pcs10gtxfull),
				.pld10gtxwordslipexe(pld10gtxwordslipexe),
				.pcs10gtxfifodel(pcs10gtxfifodel),
				.pld8gpolinvtx(pld8gpolinvtx),
				.blockselect(blockselect),
				.pmaclkdiv33lc(pmaclkdiv33lc),
				.pld8gfulltx(pld8gfulltx),
				.pld10gtxdiagstatus(pld10gtxdiagstatus),
				.pld10gtxclkout(pld10gtxclkout),
				.clockinfrom10gpcs(clockinfrom10gpcs),
				.pld10gtxburstenexe(pld10gtxburstenexe),
				.pcs8gtxdatavalid(pcs8gtxdatavalid),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_refclk_divider_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_refclk_divider
#(
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter divide_by = 1,      // Valid values: 1|2
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter refclk_coupling_termination = "cdb_cdr_refclk_coupling_oct_normal_100_ohm_oct",      // Valid values: dc_coupling_external_termination|dc_coupling_100_ohm_oct|normal_100_ohm_oct|unused
	parameter enabled = "false",      // Valid values: true|false
	parameter reference_clock_frequency = "",      // Valid values: 
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] nonuserfrompmaux,
	input  [ 0:0 ] refclkin,
	output [ 0:0 ] refclkout
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_refclk_divider : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_refclk_divider_encrypted_ES #(
				.user_base_address(user_base_address),
				.divide_by(divide_by),
				.avmm_group_channel_index(avmm_group_channel_index),
				.use_default_base_address(use_default_base_address),
				.refclk_coupling_termination(refclk_coupling_termination),
				.enabled(enabled),
				.reference_clock_frequency(reference_clock_frequency)
			) stratixv_hssi_refclk_divider_encrypted_ES_inst (
				.refclkin(refclkin),
				.refclkout(refclkout),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.avmmwrite(avmmwrite),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.avmmaddress(avmmaddress),
				.avmmread(avmmread),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_refclk_divider_encrypted #(
				.user_base_address(user_base_address),
				.divide_by(divide_by),
				.avmm_group_channel_index(avmm_group_channel_index),
				.use_default_base_address(use_default_base_address),
				.refclk_coupling_termination(refclk_coupling_termination),
				.enabled(enabled),
				.reference_clock_frequency(reference_clock_frequency)
			) stratixv_hssi_refclk_divider_encrypted_inst (
				.refclkin(refclkin),
				.refclkout(refclkout),
				.blockselect(blockselect),
				.avmmreaddata(avmmreaddata),
				.avmmclk(avmmclk),
				.avmmrstn(avmmrstn),
				.avmmwrite(avmmwrite),
				.avmmbyteen(avmmbyteen),
				.nonuserfrompmaux(nonuserfrompmaux),
				.avmmaddress(avmmaddress),
				.avmmread(avmmread),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : stratixv_hssi_pma_cdr_refclk_select_mux_wrapper_multirev.v
// --------------------------------------------------------------------


`timescale 1 ps/1 ps
module stratixv_hssi_pma_cdr_refclk_select_mux
#(
	parameter inclk20_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk3_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk23_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk8_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk17_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk6_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk10_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk24_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk18_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk14_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter refclk_select = "ref_iqclk0",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk
	parameter user_base_address = 0,      // Valid values: 0..2047
	parameter inclk21_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk16_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk25_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk9_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk5_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter reference_clock_frequency = "",      // Valid values: 
	parameter inclk2_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter mux_type = "cdr_refclk_select_mux",      // Valid values: cdr_refclk_select_mux|lc_refclk_select_mux
	parameter avmm_group_channel_index = 0,      // Valid values: 0..2
	parameter inclk13_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter channel_number = 0,      // Valid values: 
	parameter inclk15_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk0_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk12_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter use_default_base_address = "true",      // Valid values: false|true
	parameter inclk4_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk7_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk1_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk22_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk19_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter inclk11_logical_to_physical_mapping = "unused",      // Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|pld_clk|cal_clk|unused
	parameter silicon_rev = "reve"      // Valid values: reve|es
)
(
	input  [ 0:0 ] refclklc,    //not supported
	input  [ 0:0 ] occalen,     //not supported
	input  [ 10:0 ] avmmaddress,
	input  [ 1:0 ] avmmbyteen,
	input  [ 0:0 ] avmmclk,
	input  [ 0:0 ] avmmread,
	output [ 15:0 ] avmmreaddata,
	input  [ 0:0 ] avmmrstn,
	input  [ 0:0 ] avmmwrite,
	input  [ 15:0 ] avmmwritedata,
	output [ 0:0 ] blockselect,
	input  [ 0:0 ] calclk,
	output [ 0:0 ] clkout,
	input  [ 0:0 ] ffplloutbot,
	input  [ 0:0 ] ffpllouttop,
	input  [ 0:0 ] pldclk,
	input  [ 0:0 ] refiqclk0,
	input  [ 0:0 ] refiqclk1,
	input  [ 0:0 ] refiqclk10,
	input  [ 0:0 ] refiqclk2,
	input  [ 0:0 ] refiqclk3,
	input  [ 0:0 ] refiqclk4,
	input  [ 0:0 ] refiqclk5,
	input  [ 0:0 ] refiqclk6,
	input  [ 0:0 ] refiqclk7,
	input  [ 0:0 ] refiqclk8,
	input  [ 0:0 ] refiqclk9,
	input  [ 0:0 ] rxiqclk0,
	input  [ 0:0 ] rxiqclk1,
	input  [ 0:0 ] rxiqclk10,
	input  [ 0:0 ] rxiqclk2,
	input  [ 0:0 ] rxiqclk3,
	input  [ 0:0 ] rxiqclk4,
	input  [ 0:0 ] rxiqclk5,
	input  [ 0:0 ] rxiqclk6,
	input  [ 0:0 ] rxiqclk7,
	input  [ 0:0 ] rxiqclk8,
	input  [ 0:0 ] rxiqclk9
);


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_cdr_refclk_select_mux : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end


	generate
		if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		begin
			stratixv_hssi_pma_cdr_refclk_select_mux_encrypted_ES #(
				.inclk20_logical_to_physical_mapping(inclk20_logical_to_physical_mapping),
				.inclk3_logical_to_physical_mapping(inclk3_logical_to_physical_mapping),
				.inclk23_logical_to_physical_mapping(inclk23_logical_to_physical_mapping),
				.inclk8_logical_to_physical_mapping(inclk8_logical_to_physical_mapping),
				.inclk17_logical_to_physical_mapping(inclk17_logical_to_physical_mapping),
				.inclk6_logical_to_physical_mapping(inclk6_logical_to_physical_mapping),
				.inclk10_logical_to_physical_mapping(inclk10_logical_to_physical_mapping),
				.inclk24_logical_to_physical_mapping(inclk24_logical_to_physical_mapping),
				.inclk18_logical_to_physical_mapping(inclk18_logical_to_physical_mapping),
				.inclk14_logical_to_physical_mapping(inclk14_logical_to_physical_mapping),
				.refclk_select(refclk_select),
				.user_base_address(user_base_address),
				.inclk21_logical_to_physical_mapping(inclk21_logical_to_physical_mapping),
				.inclk16_logical_to_physical_mapping(inclk16_logical_to_physical_mapping),
				.inclk25_logical_to_physical_mapping(inclk25_logical_to_physical_mapping),
				.inclk9_logical_to_physical_mapping(inclk9_logical_to_physical_mapping),
				.inclk5_logical_to_physical_mapping(inclk5_logical_to_physical_mapping),
				.reference_clock_frequency(reference_clock_frequency),
				.inclk2_logical_to_physical_mapping(inclk2_logical_to_physical_mapping),
				.mux_type(mux_type),
				.avmm_group_channel_index(avmm_group_channel_index),
				.inclk13_logical_to_physical_mapping(inclk13_logical_to_physical_mapping),
				.channel_number(channel_number),
				.inclk15_logical_to_physical_mapping(inclk15_logical_to_physical_mapping),
				.inclk0_logical_to_physical_mapping(inclk0_logical_to_physical_mapping),
				.inclk12_logical_to_physical_mapping(inclk12_logical_to_physical_mapping),
				.use_default_base_address(use_default_base_address),
				.inclk4_logical_to_physical_mapping(inclk4_logical_to_physical_mapping),
				.inclk7_logical_to_physical_mapping(inclk7_logical_to_physical_mapping),
				.inclk1_logical_to_physical_mapping(inclk1_logical_to_physical_mapping),
				.inclk22_logical_to_physical_mapping(inclk22_logical_to_physical_mapping),
				.inclk19_logical_to_physical_mapping(inclk19_logical_to_physical_mapping),
				.inclk11_logical_to_physical_mapping(inclk11_logical_to_physical_mapping)
			) stratixv_hssi_pma_cdr_refclk_select_mux_encrypted_ES_inst (
				.refclklc(refclklc),
				.occalen(occalen),
				.refiqclk2(refiqclk2),
				.rxiqclk7(rxiqclk7),
				.refiqclk10(refiqclk10),
				.avmmclk(avmmclk),
				.rxiqclk4(rxiqclk4),
				.avmmrstn(avmmrstn),
				.rxiqclk8(rxiqclk8),
				.rxiqclk5(rxiqclk5),
				.avmmbyteen(avmmbyteen),
				.refiqclk4(refiqclk4),
				.rxiqclk6(rxiqclk6),
				.avmmreaddata(avmmreaddata),
				.rxiqclk1(rxiqclk1),
				.avmmwrite(avmmwrite),
				.rxiqclk10(rxiqclk10),
				.refiqclk6(refiqclk6),
				.rxiqclk0(rxiqclk0),
				.refiqclk0(refiqclk0),
				.avmmaddress(avmmaddress),
				.clkout(clkout),
				.ffplloutbot(ffplloutbot),
				.refiqclk3(refiqclk3),
				.refiqclk8(refiqclk8),
				.avmmread(avmmread),
				.refiqclk1(refiqclk1),
				.refiqclk7(refiqclk7),
				.blockselect(blockselect),
				.calclk(calclk),
				.rxiqclk9(rxiqclk9),
				.rxiqclk3(rxiqclk3),
				.refiqclk5(refiqclk5),
				.refiqclk9(refiqclk9),
				.rxiqclk2(rxiqclk2),
				.pldclk(pldclk),
				.ffpllouttop(ffpllouttop),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate ES
		else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		begin
			stratixv_hssi_pma_cdr_refclk_select_mux_encrypted #(
				.inclk20_logical_to_physical_mapping(inclk20_logical_to_physical_mapping),
				.inclk3_logical_to_physical_mapping(inclk3_logical_to_physical_mapping),
				.inclk23_logical_to_physical_mapping(inclk23_logical_to_physical_mapping),
				.inclk8_logical_to_physical_mapping(inclk8_logical_to_physical_mapping),
				.inclk17_logical_to_physical_mapping(inclk17_logical_to_physical_mapping),
				.inclk6_logical_to_physical_mapping(inclk6_logical_to_physical_mapping),
				.inclk10_logical_to_physical_mapping(inclk10_logical_to_physical_mapping),
				.inclk24_logical_to_physical_mapping(inclk24_logical_to_physical_mapping),
				.inclk18_logical_to_physical_mapping(inclk18_logical_to_physical_mapping),
				.inclk14_logical_to_physical_mapping(inclk14_logical_to_physical_mapping),
				.refclk_select(refclk_select),
				.user_base_address(user_base_address),
				.inclk21_logical_to_physical_mapping(inclk21_logical_to_physical_mapping),
				.inclk16_logical_to_physical_mapping(inclk16_logical_to_physical_mapping),
				.inclk25_logical_to_physical_mapping(inclk25_logical_to_physical_mapping),
				.inclk9_logical_to_physical_mapping(inclk9_logical_to_physical_mapping),
				.inclk5_logical_to_physical_mapping(inclk5_logical_to_physical_mapping),
				.reference_clock_frequency(reference_clock_frequency),
				.inclk2_logical_to_physical_mapping(inclk2_logical_to_physical_mapping),
				.mux_type(mux_type),
				.avmm_group_channel_index(avmm_group_channel_index),
				.inclk13_logical_to_physical_mapping(inclk13_logical_to_physical_mapping),
				.channel_number(channel_number),
				.inclk15_logical_to_physical_mapping(inclk15_logical_to_physical_mapping),
				.inclk0_logical_to_physical_mapping(inclk0_logical_to_physical_mapping),
				.inclk12_logical_to_physical_mapping(inclk12_logical_to_physical_mapping),
				.use_default_base_address(use_default_base_address),
				.inclk4_logical_to_physical_mapping(inclk4_logical_to_physical_mapping),
				.inclk7_logical_to_physical_mapping(inclk7_logical_to_physical_mapping),
				.inclk1_logical_to_physical_mapping(inclk1_logical_to_physical_mapping),
				.inclk22_logical_to_physical_mapping(inclk22_logical_to_physical_mapping),
				.inclk19_logical_to_physical_mapping(inclk19_logical_to_physical_mapping),
				.inclk11_logical_to_physical_mapping(inclk11_logical_to_physical_mapping)
			) stratixv_hssi_pma_cdr_refclk_select_mux_encrypted_inst (
				.refclklc(refclklc),
				.occalen(occalen),
				.refiqclk2(refiqclk2),
				.rxiqclk7(rxiqclk7),
				.refiqclk10(refiqclk10),
				.avmmclk(avmmclk),
				.rxiqclk4(rxiqclk4),
				.avmmrstn(avmmrstn),
				.rxiqclk8(rxiqclk8),
				.rxiqclk5(rxiqclk5),
				.avmmbyteen(avmmbyteen),
				.refiqclk4(refiqclk4),
				.rxiqclk6(rxiqclk6),
				.avmmreaddata(avmmreaddata),
				.rxiqclk1(rxiqclk1),
				.avmmwrite(avmmwrite),
				.rxiqclk10(rxiqclk10),
				.refiqclk6(refiqclk6),
				.rxiqclk0(rxiqclk0),
				.refiqclk0(refiqclk0),
				.avmmaddress(avmmaddress),
				.clkout(clkout),
				.ffplloutbot(ffplloutbot),
				.refiqclk3(refiqclk3),
				.refiqclk8(refiqclk8),
				.avmmread(avmmread),
				.refiqclk1(refiqclk1),
				.refiqclk7(refiqclk7),
				.blockselect(blockselect),
				.calclk(calclk),
				.rxiqclk9(rxiqclk9),
				.rxiqclk3(rxiqclk3),
				.refiqclk5(refiqclk5),
				.refiqclk9(refiqclk9),
				.rxiqclk2(rxiqclk2),
				.pldclk(pldclk),
				.ffpllouttop(ffpllouttop),
				.avmmwritedata(avmmwritedata)
			);
		end // if generate REVE
	endgenerate
endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_hssi_pma_lc_refclk_select_mux_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps
module stratixv_hssi_pma_lc_refclk_select_mux
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter silicon_rev = "reve",	//Valid values: reve|es
	parameter refclk_select = "ref_iqclk0",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10
	parameter channel_number = 0,	//Valid values: 
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter avmm_group_channel_index = 1,	////Valid values: 1 - The parameter for this mux only exists in channel 1 of a triplet.
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address = 0,	//Valid values: 0..2047
	parameter inclk0_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk1_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk2_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk3_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk4_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk5_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk6_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk7_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk8_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk9_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk10_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk11_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk12_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk13_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk14_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk15_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk16_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk17_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk18_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk19_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk20_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk21_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk22_logical_to_physical_mapping = "unused",	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
	parameter inclk23_logical_to_physical_mapping = "unused"	//Valid values: ffpllout_top|ffpllout_bot|ref_iqclk0|ref_iqclk1|ref_iqclk2|ref_iqclk3|ref_iqclk4|ref_iqclk5|ref_iqclk6|ref_iqclk7|ref_iqclk8|ref_iqclk9|ref_iqclk10|rx_iqclk0|rx_iqclk1|rx_iqclk2|rx_iqclk3|rx_iqclk4|rx_iqclk5|rx_iqclk6|rx_iqclk7|rx_iqclk8|rx_iqclk9|rx_iqclk10|unused
)
(
//input and output port declaration
	input [ 10:0 ] avmmaddress,
	input [ 1:0 ] avmmbyteen,
	input [ 0:0 ] avmmrstn,
	input [ 0:0 ] avmmclk,
	input [ 0:0 ] avmmread,
	input [ 0:0 ] avmmwrite,
	input [ 15:0 ] avmmwritedata,
	input [ 0:0 ] ffplloutbot,
	input [ 0:0 ] ffpllouttop,
	input [ 0:0 ] refiqclk0,
	input [ 0:0 ] refiqclk1,
	input [ 0:0 ] refiqclk10,
	input [ 0:0 ] refiqclk2,
	input [ 0:0 ] refiqclk3,
	input [ 0:0 ] refiqclk4,
	input [ 0:0 ] refiqclk5,
	input [ 0:0 ] refiqclk6,
	input [ 0:0 ] refiqclk7,
	input [ 0:0 ] refiqclk8,
	input [ 0:0 ] refiqclk9,
	input [ 0:0 ] rxiqclk0,
	input [ 0:0 ] rxiqclk1,
	input [ 0:0 ] rxiqclk10,
	input [ 0:0 ] rxiqclk2,
	input [ 0:0 ] rxiqclk3,
	input [ 0:0 ] rxiqclk4,
	input [ 0:0 ] rxiqclk5,
	input [ 0:0 ] rxiqclk6,
	input [ 0:0 ] rxiqclk7,
	input [ 0:0 ] rxiqclk8,
	input [ 0:0 ] rxiqclk9,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 0:0 ] clkout
); 

	stratixv_hssi_pma_lc_refclk_select_mux_encrypted 
	#(
		.enable_debug_info(enable_debug_info),

		.silicon_rev(silicon_rev),
		.refclk_select(refclk_select),
		.channel_number(channel_number),
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
		.inclk13_logical_to_physical_mapping(inclk13_logical_to_physical_mapping),
		.inclk14_logical_to_physical_mapping(inclk14_logical_to_physical_mapping),
		.inclk15_logical_to_physical_mapping(inclk15_logical_to_physical_mapping),
		.inclk16_logical_to_physical_mapping(inclk16_logical_to_physical_mapping),
		.inclk17_logical_to_physical_mapping(inclk17_logical_to_physical_mapping),
		.inclk18_logical_to_physical_mapping(inclk18_logical_to_physical_mapping),
		.inclk19_logical_to_physical_mapping(inclk19_logical_to_physical_mapping),
		.inclk20_logical_to_physical_mapping(inclk20_logical_to_physical_mapping),
		.inclk21_logical_to_physical_mapping(inclk21_logical_to_physical_mapping),
		.inclk22_logical_to_physical_mapping(inclk22_logical_to_physical_mapping),
		.inclk23_logical_to_physical_mapping(inclk23_logical_to_physical_mapping)

	)
	stratixv_hssi_pma_lc_refclk_select_mux_encrypted_inst	(
		.avmmaddress(avmmaddress),
		.avmmbyteen(avmmbyteen),
		.avmmrstn(avmmrstn),
		.avmmclk(avmmclk),
		.avmmread(avmmread),
		.avmmwrite(avmmwrite),
		.avmmwritedata(avmmwritedata),
		.ffplloutbot(ffplloutbot),
		.ffpllouttop(ffpllouttop),
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
		.avmmreaddata(avmmreaddata),
		.blockselect(blockselect),
		.clkout(clkout)
	);


endmodule
// --------------------------------------------------------------------
// This is auto-generated HSSI Simulation Atom Model Encryption Wrapper
// Module Name : ./sim_model_wrappers//stratixv_lc_pll_wrapper.v
// --------------------------------------------------------------------

`timescale 1 ps/1 ps

//`define USE_ICD_LC_MODEL
module stratixv_atx_pll
#(
	// parameter declaration and default value assignemnt
	parameter enable_debug_info = "false",	//Valid values: false|true; this is simulation-only parameter, for debug purpose only

	parameter avmm_group_channel_index = 0,	//Valid values: 0..2
	parameter enabled_for_reconfig = "false",	//Valid values: false|true
        parameter sim_use_fast_model = "true",
	parameter output_clock_frequency = "",	//Valid values: 
	parameter reference_clock_frequency = "",	//Valid values: 
	parameter silicon_rev = "reve",	//Valid values: reve|es
	parameter use_default_base_address = "true",	//Valid values: false|true
	parameter user_base_address0 = 0,	//Valid values: 0..2047
	parameter user_base_address1 = 0,	//Valid values: 0..2047
	parameter user_base_address2 = 0,	//Valid values: 0..2047
	parameter ac_cap = "disable_ac_cap",	//Valid values: disable_ac_cap|enable_ac_cap
	parameter cp_current_ctrl = 0,	//Valid values: 0|5|10|20|30|40|50|60|80|100|120|160|180|200|240|300|320|400
	parameter cp_current_test = "enable_ch_pump_normal",	//Valid values: enable_ch_pump_normal|enable_ch_pump_curr_test_up|enable_ch_pump_curr_test_down|disable_ch_pump_curr_test
	parameter cp_hs_levshift_power_supply_setting = 1,	//Valid values: 0|1|2|3
	parameter cp_replica_bias_ctrl = "disable_replica_bias_ctrl",	//Valid values: enable_replica_bias_ctrl|disable_replica_bias_ctrl
	parameter cp_rgla_bypass = "false",	//Valid values: false|true
	parameter cp_rgla_volt_inc = "boost_30pct",	//Valid values: boost_0pct|boost_5_pct|boost_10pct|boost_15pct|boost_20pct|boost_25pct|boost_30pct|not_used_boost
	parameter fbclk_sel = "vcoclk",	//Valid values: vcoclk|extclk|fbext_ctrla|fbext_ctrla_inv|fbext_ctrlb|fbext_ctrlb_inv
	parameter l_counter = -1,	//Valid values: 0|2|4|8
	parameter lc_cmu_pdb = "false",	//Valid values: false|true
	parameter lc_div33_pdb = "false",	//Valid values: false|true
	parameter lcpll_atb_select = "atb_disable",	//Valid values: atb_disable|atb_sel_1|atb_sel_2|atb_sel_3|atb_sel_4|atb_sel_5|atb_sel_6|atb_sel_7|atb_sel_8|atb_sel_9|atb_sel_10|atb_sel_11|atb_sel_12|atb_sel_13|atb_sel_14|atb_sel_15|atb_sel_16|atb_sel_17|atb_sel_18|atb_sel_19|atb_sel_20|atb_sel_21|atb_sel_22|atb_sel_23|atb_sel_24|atb_sel_25|atb_sel_26|atb_sel_27|atb_sel_28|atb_sel_29|atb_sel_30|atb_sel_31
	parameter lcpll_d2a_sel = "volt_1p02v",	//Valid values: volt_0p26v|volt_0p51v|volt_0p77v|volt_1p02v|volt_1p23v|volt_1p53v|volt_1p8v|off
	parameter lcpll_hclk_driver_enable = "driver_off",	//Valid values: driver_off|driver_on
	parameter lcvco_gear_sel = "high_gear",	//Valid values: high_gear|low_gear
	parameter lcvco_sel = "high_freq_14g",	//Valid values: high_freq_14g|low_freq_8g
	parameter lpf_ripple_cap_ctrl = "none",	//Valid values: reserved_11|reserved_10|plus_2pf|none
	parameter lpf_rxpll_pfd_bw_ctrl = 0,	//Valid values: 0|1600|2000|2400|3000|3400|4000|5000|5400
	parameter m_counter = -1,	//Valid values: 0|1|4|5|8|10|12|16|20|25|32|40|50
	parameter ref_clk_div = -1,	//Valid values: 0|1|2|4|8
	parameter refclk_sel = "refclk",	//Valid values: iqclk|refclk|pldclk|dcd_cal_clk
	parameter sel_buf14g = "disable_buf14g",	//Valid values: enable_buf14g|disable_buf14g
	parameter sel_buf8g = "enable_buf8g",	//Valid values: enable_buf8g|disable_buf8g
	parameter vco_over_range_ref = "vco_over_range_off",	//Valid values: vco_over_range_off|vco_over_range_ref_1|vco_over_range_ref_2|vco_over_range_ref_3
	parameter vco_under_range_ref = "vco_under_range_off",	//Valid values: vco_under_range_off|vco_under_range_ref_1|vco_under_range_ref_2|vco_under_range_ref_3
	parameter vreg1_lcvco_volt_inc = "volt_1p1v",	//Valid values: volt_0p8v|volt_0p9v|volt_1p0v|volt_1p1v|volt_1p2v|volt_1p3v|volt_1p4v|volt_1p5v
	parameter vreg1_vccehlow = "normal_operation",	//Valid values: normal_operation|lower_vcceh
	parameter vreg2_lcpll_volt_sel = "vreg2_volt_setting0",	//Valid values: vreg2_volt_setting0|vreg2_volt_setting1|vreg2_volt_setting2|vreg2_volt_setting3|vreg2_volt_setting4|vreg2_volt_setting5|vreg2_volt_setting6|vreg2_volt_setting7
	parameter vreg3_lcpll_volt_sel = "vreg3_volt_setting0"	//Valid values: vreg3_volt_setting0|vreg3_volt_setting1|vreg3_volt_setting2|vreg3_volt_setting3|vreg3_volt_setting4|vreg3_volt_setting5|vreg3_volt_setting6|vreg3_volt_setting7
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
	input [ 31:0 ] ch0rcsrlc,
	input [ 31:0 ] ch1rcsrlc,
	input [ 31:0 ] ch2rcsrlc,
	input [ 0:0 ] cmurstn,
	input [ 0:0 ] cmurstnlpf,
	input [ 0:0 ] extfbclk,
	input [ 0:0 ] fixedclklc,
	input [ 0:0 ] iqclklc,
	input [ 0:0 ] pldclklc,
	input [ 0:0 ] pllfbswblc,
	input [ 0:0 ] pllfbswtlc,
	input [ 0:0 ] refclklc,
	output [ 15:0 ] avmmreaddata,
	output [ 0:0 ] blockselect,
	output [ 1:0 ] ch0lctestout,
	output [ 1:0 ] ch1lctestout,
	output [ 1:0 ] ch2lctestout,
	output [ 0:0 ] clk010g,
	output [ 0:0 ] clk025g,
	output [ 0:0 ] clk18010g,
	output [ 0:0 ] clk18025g,
	output [ 0:0 ] clk33cmu,
	output [ 0:0 ] clklowcmu,
	output [ 0:0 ] frefcmu,
	output [ 0:0 ] iqclkatt,
	output [ 0:0 ] pfdmodelockcmu,
	output [ 0:0 ] pldclkatt,
	output [ 0:0 ] refclkatt,
	output [ 0:0 ] txpllhclk
); 


	`ifdef FORCE_SV_HSSI_ES_SIM_MODEL
	localparam silicon_rev_local = "es";
	`else
	`ifdef FORCE_SV_HSSI_REVE_SIM_MODEL
	localparam silicon_rev_local = "reve";
	`else
	localparam silicon_rev_local = silicon_rev;
	`endif
	`endif


	initial
	begin
		$display("module stratixv_hssi_pma_rx_buf : simulation model silicon_rev = \"%s\"", silicon_rev_local);
	end
	
	generate
	    // Currently we are using the same model for both ES and Production.
		//if ((silicon_rev_local == "es") || (silicon_rev_local == "ES"))
		//begin
			// Currently there is no support for LC PLL simulation with ES Si.
		//end // if generate ES
		//else if ((silicon_rev_local == "reve") || (silicon_rev_local == "REVE"))
		//begin
			stratixv_atx_pll_encrypted 
			#(
				.enable_debug_info(enable_debug_info),

				.avmm_group_channel_index(avmm_group_channel_index),
				.enabled_for_reconfig(enabled_for_reconfig),
                                .sim_use_fast_model(sim_use_fast_model),
				.output_clock_frequency(output_clock_frequency),
				.reference_clock_frequency(reference_clock_frequency),
				.silicon_rev(silicon_rev),
				.use_default_base_address(use_default_base_address),
				.user_base_address0(user_base_address0),
				.user_base_address1(user_base_address1),
				.user_base_address2(user_base_address2),
				.ac_cap(ac_cap),
				.cp_current_ctrl(cp_current_ctrl),
				.cp_current_test(cp_current_test),
				.cp_hs_levshift_power_supply_setting(cp_hs_levshift_power_supply_setting),
				.cp_replica_bias_ctrl(cp_replica_bias_ctrl),
				.cp_rgla_bypass(cp_rgla_bypass),
				.cp_rgla_volt_inc(cp_rgla_volt_inc),
				.fbclk_sel(fbclk_sel),
				.l_counter(l_counter),
				.lc_cmu_pdb(lc_cmu_pdb),
				.lc_div33_pdb(lc_div33_pdb),
				.lcpll_atb_select(lcpll_atb_select),
				.lcpll_d2a_sel(lcpll_d2a_sel),
				.lcpll_hclk_driver_enable(lcpll_hclk_driver_enable),
				.lcvco_gear_sel(lcvco_gear_sel),
				.lcvco_sel(lcvco_sel),
				.lpf_ripple_cap_ctrl(lpf_ripple_cap_ctrl),
				.lpf_rxpll_pfd_bw_ctrl(lpf_rxpll_pfd_bw_ctrl),
				.m_counter(m_counter),
				.ref_clk_div(ref_clk_div),
				.refclk_sel(refclk_sel),
				.sel_buf14g(sel_buf14g),
				.sel_buf8g(sel_buf8g),
				.vco_over_range_ref(vco_over_range_ref),
				.vco_under_range_ref(vco_under_range_ref),
				.vreg1_lcvco_volt_inc(vreg1_lcvco_volt_inc),
				.vreg1_vccehlow(vreg1_vccehlow),
				.vreg2_lcpll_volt_sel(vreg2_lcpll_volt_sel),
				.vreg3_lcpll_volt_sel(vreg3_lcpll_volt_sel)

			)
			stratixv_atx_pll_encrypted_inst	(
				.avmmaddress(avmmaddress),
				.avmmbyteen(avmmbyteen),
				.avmmclk(avmmclk),
				.avmmread(avmmread),
				.avmmrstn(avmmrstn),
				.avmmwrite(avmmwrite),
				.avmmwritedata(avmmwritedata),
				.ch0rcsrlc(ch0rcsrlc),
				.ch1rcsrlc(ch1rcsrlc),
				.ch2rcsrlc(ch2rcsrlc),
				.cmurstn(cmurstn),
				.cmurstnlpf(cmurstnlpf),
				.extfbclk(extfbclk),
				.fixedclklc(fixedclklc),
				.iqclklc(iqclklc),
				.pldclklc(pldclklc),
				.pllfbswblc(pllfbswblc),
				.pllfbswtlc(pllfbswtlc),
				.refclklc(refclklc),
				.avmmreaddata(avmmreaddata),
				.blockselect(blockselect),
				.ch0lctestout(ch0lctestout),
				.ch1lctestout(ch1lctestout),
				.ch2lctestout(ch2lctestout),
				.clk010g(clk010g),
				.clk025g(clk025g),
				.clk18010g(clk18010g),
				.clk18025g(clk18025g),
				.clk33cmu(clk33cmu),
				.clklowcmu(clklowcmu),
				.frefcmu(frefcmu),
				.iqclkatt(iqclkatt),
				.pfdmodelockcmu(pfdmodelockcmu),
				.pldclkatt(pldclkatt),
				.refclkatt(refclkatt),
				.txpllhclk(txpllhclk)
			);
		//end // if generate REVE
	endgenerate

endmodule

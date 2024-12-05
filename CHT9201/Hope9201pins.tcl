# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II 64-Bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version
# File: C:\Users\22186\Desktop\My_FPGA_Project\01_LED\LED_WATER.tcl
# Generated on: Mon Nov 04 15:35:43 2024

package require ::quartus::project
set_location_assignment	PIN_14 	-to	clk
#set_location_assignment	PIN_41 	-to	rst_n

#--------------------MCU Parallel Comunicate----------------------#
set_location_assignment	PIN_100	-to	DB[0]
set_location_assignment	PIN_99	-to	DB[1]
set_location_assignment	PIN_98	-to	DB[2]
set_location_assignment	PIN_97	-to	DB[3]
set_location_assignment	PIN_96	-to	DB[4]
set_location_assignment	PIN_95	-to	DB[5]
set_location_assignment	PIN_92	-to	DB[6]
set_location_assignment	PIN_91	-to	DB[7]
set_location_assignment PIN_89  -to ALE
set_location_assignment PIN_87  -to RD
set_location_assignment PIN_86  -to WR
set_location_assignment PIN_85  -to BUSY
set_location_assignment PIN_84  -to INT

#--------------------DAC0800--DDS--------------------------------#
set_location_assignment PIN_75  -to sine_out[0]
set_location_assignment PIN_74  -to sine_out[1]
set_location_assignment PIN_73  -to sine_out[2]
set_location_assignment PIN_72  -to sine_out[3]
set_location_assignment PIN_71  -to sine_out[4]
set_location_assignment PIN_70  -to sine_out[5]
set_location_assignment PIN_69  -to sine_out[6]
set_location_assignment PIN_68  -to sine_out[7]

set_location_assignment PIN_67  -to PHASE-C

#--------------------ADC7606------------------------------------#
set_location_assignment PIN_29 -to ad_data[0]
set_location_assignment PIN_28 -to ad_data[1]
set_location_assignment PIN_27 -to ad_data[2]
set_location_assignment PIN_26 -to ad_data[3]
set_location_assignment PIN_18 -to ad_data[4]
set_location_assignment PIN_17 -to ad_data[5]
set_location_assignment PIN_16 -to ad_data[6]
set_location_assignment PIN_15 -to ad_data[7]
set_location_assignment PIN_8  -to ad_data[8]
set_location_assignment PIN_7  -to ad_data[9]
set_location_assignment PIN_6  -to ad_data[10]
set_location_assignment PIN_5  -to ad_data[11]
set_location_assignment PIN_4  -to ad_data[12]
set_location_assignment PIN_3  -to ad_data[13]
set_location_assignment PIN_2  -to ad_data[14]
set_location_assignment PIN_1  -to ad_data[15]

set_location_assignment PIN_30 -to ad_first_data
set_location_assignment PIN_33 -to ad_busy
set_location_assignment PIN_34 -to ad_cs
set_location_assignment PIN_35 -to ad_rd
set_location_assignment PIN_36 -to ad_reset
set_location_assignment PIN_38 -to ad_convstb
set_location_assignment PIN_40 -to ad_convsta
set_location_assignment PIN_41 -to ad_range
set_location_assignment PIN_47 -to ad_stby
set_location_assignment PIN_48 -to ad_os[2]
set_location_assignment PIN_49 -to ad_os[1]
set_location_assignment PIN_50 -to ad_os[0]
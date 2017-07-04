## Generated SDC file "riscv_cache_top.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Full Version"

## DATE    "Mon Jun 12 13:01:51 2017"

##
## DEVICE  "EP4CGX150DF31C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clk} -period 40.000 -waveform { 0.000 20.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  1.000 [get_ports {altera_reserved_tdi}]
set_input_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  1.000 [get_ports {altera_reserved_tms}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.ack}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[0][31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][16]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][17]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][18]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][19]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][20]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][21]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][22]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][23]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][24]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][25]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][26]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][27]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][28]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][29]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][30]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_res.data[1][31]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {rst}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {altera_reserved_tck}]  1.000 [get_ports {altera_reserved_tdo}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {fl_complete}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.addr[11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.cs}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[0][31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][7]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][8]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][9]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][10]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][11]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][12]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][13]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][14]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][15]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][16]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][17]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][18]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][19]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][20]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][21]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][22]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][23]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][24]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][25]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][26]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][27]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][28]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][29]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][30]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.data[1][31]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  1.000 [get_ports {mem_req.rw}]


#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 
set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


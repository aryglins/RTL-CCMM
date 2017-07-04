vlib work
vdel -all -lib work
vlib work

vcom -f compile_questa_vhdl_win.f
vlog -f compile_questa_sv_win.f

vsim -t ns -L altera_mf -L altera -L altera_mf_ver \
-L altera_ver -novopt work.cache_tb_sim

run 1ns
add wave -position insertpoint -divider "INTERFACE" \
sim:/cache_tb_sim/clk \
sim:/cache_tb_sim/rst \
sim:/cache_tb_sim/proc_req \
sim:/cache_tb_sim/proc_res \
sim:/cache_tb_sim/mem_req \
sim:/cache_tb_sim/mem_res

add wave -position insertpoint -divider "INTERFACE" \
sim:/cache_tb_sim/cache1/state \
sim:/cache_tb_sim/cache1/tag_buf \
sim:/cache_tb_sim/cache1/line_buf \
sim:/cache_tb_sim/cache1/offset_buf \
sim:/cache_tb_sim/cache1/addr_tag \
sim:/cache_tb_sim/cache1/addr_line \
sim:/cache_tb_sim/cache1/addr_offset \
sim:/cache_tb_sim/cache1/hit_array \
sim:/cache_tb_sim/cache1/miss 


run 20ns


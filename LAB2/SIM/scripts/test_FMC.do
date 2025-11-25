
vlib work
vmap work work

vcom -work ./work ../src/regn.vhd
vcom -work ./work ../src/RF.vhd
vcom -work ./work ../src/FMC_CU.vhd
vcom -work ./work ../src/FMC_DP.vhd
vcom -work ./work ../src/FMC.vhd

vcom -work ./work ../tb/tb_FMC.vhd


vsim work.tb_FMC -voptargs=+acc

add wave -noupdate -divider "Testbench"
add wave -noupdate tb_FMC/*


add wave -noupdate -divider "Datapath Internals"
add wave -noupdate tb_FMC/DUT/DP_inst/*

add wave -noupdate -divider "Control Unit"
add wave -noupdate tb_FMC/DUT/CU_inst/*

run 4 us
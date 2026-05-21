

vlib work
vmap work work

vcom -work ./work ../src/regn.vhd
vcom -work ./work ../src/RF.vhd
vcom -work ./work ../src/FMC_CU.vhd
vcom -work ./work ../src/FMC_DP.vhd
vcom -work ./work ../src/FMC.vhd

vcom -work ./work ../tb/tb_FMC_CU.vhd


vsim work.tb_FMC_CU -voptargs=+acc
add wave *
run 4 us
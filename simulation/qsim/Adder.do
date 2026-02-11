onerror {quit -f}
vlib work
vlog -work work Adder.vo
vlog -work work Adder.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.FloatingPointMultiplier_vlg_vec_tst
vcd file -direction Adder.msim.vcd
vcd add -internal FloatingPointMultiplier_vlg_vec_tst/*
vcd add -internal FloatingPointMultiplier_vlg_vec_tst/i1/*
add wave /*
run -all

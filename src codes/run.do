vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
coverage save FIFO.ucdb -onexit -du FIFO
add wave /FIFO_top/FIFOif/*
run -all
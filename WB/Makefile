
questa: questa_build_tb questa_sim


questa_build_tb : 
	vlog top.sv

questa_sim:
	vsim -c top -do "run -a; q"

questa_clean:
	rm -rf work transcript

vivado: vivado_build_tb vivado_sim

vivado_build_tb:
	xvlog -sv top.sv
	xelab top -relax -s top -debug wave -timescale 1ns/1ps


vivado_sim:
	xsim  top -runall

vivado_clean:
	rm -rf xsim.dir webtalk* xelab* xvlog* xsim* *.log *.vcd *.wdb

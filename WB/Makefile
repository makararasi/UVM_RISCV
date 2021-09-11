


vivado: vivado_build_tb vivado_sim

vivado_build_tb:
	xvlog -sv top.sv
	xelab top -relax -s top -debug wave -timescale 1ns/1ps


vivado_sim:
	xsim  top -runall

vivado_clean:
	rm -rf xsim.dir webtalk* xelab* xvlog* xsim* *.log *.vcd *.wdb

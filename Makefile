#################################################################
# Simluation targets (Verilator)
#################################################################

%.out:
	verilator tb/$*_tb.sv -Irtl --timing --binary --Mdir build
	./build/V$*_tb

#################################################################
# Loading designs onto Tang Nano 20K FPGA board (FOSS toolchain)
#################################################################

%.load: build/%.fs
	openFPGALoader -b tangnano20k build/$*.fs

build/%.fs: build/%-pnr.json | build
	gowin_pack -c -d GW2A-18C -o build/$*.fs build/$*-pnr.json

build/%-pnr.json: build/%-synth.json | build
	nextpnr-himbaechel --json build/$*-synth.json --write build/$*-pnr.json --device GW2AR-LV18QN88C8/I7 --vopt family=GW2A-18C --vopt cst=cst/tangnano20k.cst

build/%-synth.json: rtl/%.v | build
	yosys -p "read_verilog rtl/*.v; hierarchy -top $*; synth_gowin -json build/$*-synth.json"

#################################################################
# Misc targets
#################################################################

build:
	mkdir -p $@

clean:
	rm -rf build

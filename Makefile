%.out:
	verilator tb/$*_tb.sv -Irtl --timing --binary --Mdir build
	./build/V$*_tb

clean:
	rm -rf build

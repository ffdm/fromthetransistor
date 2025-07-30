%.out:
	verilator tb/$*_tb.sv -Irtl --binary --Mdir build
	./build/V$*

clean:
	rm -rf build

# From the Transistor to the Web Browser

My implementation of the George Hotz course. His timelines are unrealistic and have been removed. This project is just for fun, so will probably take me a few years. I will try to only use free and open-source tools for design and development (though physical hardware will not be free).

## Section 1: Intro: Cheating our way past the transistor
- This section could easily be modified to not cheat our way past the transistor and use open-source physical design tools like OpenLane.
- In the future, if TinyTapeout gets their s*** together, the chip could be fabbed and used for subsequent sections instead of an FPGA.

Toolchain:
- Verilator: verilog simulation (fast and can simulate large designs)
- FPGA (undecided, will use synthesis tool that comes with board)
  
## Section 2: Bringup: What language is hardware coded in?
- Blinking an LED(Verilog, 10) -- Your first little program! Getting the simulator working. Learning Verilog.
- Building a UART(Verilog, 100) -- An intro chapter to Verilog, copy a real UART, introducing the concept of MMIO, though the serial port may be semihosting. Serial test echo program and led control.

## Section 3: Processor: What is a processor anyway?
- Coding an assembler(Python, 500) -- Straightforward and boring, write in python. Happens in parallel with the CPU building. Teaches you ARM assembly. Initially outputs just binary files, but changed when you write a linker.
- Building a ARM7 CPU(Verilog, 1500) -- Break this into subchapters. A simple pipeline to start, decode, fetch, execute. How much BRAM do we have? We need at least 1MB, DDR would be hard I think, maybe an SRAM. Simulatable and synthesizable.
- Coding a bootrom(Assembler, 40) -- This allows code download into RAM over the serial port, and is baked into the FPGA image. Cute test programs run on this.

## Section 4: Compiler: A “high” level language
- Building a C compiler(Haskell, 2000) -- A bit more interesting, cover the basics of compiler design. Write in haskell. Write a parser. Break this into subchapters. Outputs ARM assembly.
- Building a linker(Python, 300) -- If you are clever, this should take a day. Output elf files. Use for testing with QEMU, semihosting.
- libc + malloc(C, 500) -- The gateway to more complicated programs. libc is only half here, things like memcpy and memset and printf, but no syscall wrappers.
- Building an ethernet controller(Verilog, 200) -- Talk to a real PHY, consider carefully MMIO design.
- Writing a bootloader(C, 300) -- Write ethernet program to boot kernel over UDP. First thing written in C. Maybe don’t redownload over serial each time and embed in FPGA image.

## Section 5: Operating System: Software we take for granted
- Building an MMU(Verilog, 1000) -- ARM9ish, explain TLBs and other fun things. Maybe also a memory controller, depending on how the FPGA is, then add the init code to your bootloader.
- Building an operating system(C, 2500) -- UNIXish, only user space threads. (open, read, write, close), (fork, execve, wait, sleep, exit), (mmap, munmap, mprotect). Consider the debug interface you are using, ranging from printf to perhaps a gdbremote stub into kernel. Break into subchapters.
- Talking to an SD card(Verilog, 150) -- The last hardware you have to do. And a driver
- FAT(C, 300) -- A real filesystem, I think fat is the simplest
- init, shell, download, cat, ls, rm(C, 250) -- Your first user space programs.

## Section 6: Browser: Coming online
- Building a TCP stack(C, 500) -- Probably coded in the kernel, integrate the ethernet driver into the kernel. Add support for networking syscalls to kernel. (send, recv, bind, connect)
- telnetd, the power of being multiprocess(C, 50) --  Written in C, user can connect multiple times with telnet. Really just a bind shell.
- Space saving dynamic linking(C, 300) -- Because we can, explain how dynamic linker is just a user space program. Changes to linker required.
- So about that web(C, 500+) -- A “nice” text based web browser, using ANSI and terminal niceness. Dynamically linked and nice, nice as you want.

## Section 7: Physical: Running on real hardware
- Talking to an FPGA(C, 200) -- A little code for the USB MCU to bitbang JTAG.
- Building an FPGA board -- Board design, FPGA BGA reflow, FPGA flash, a 50mhz clock, a USB JTAG port and flasher(no special hardware, a little cypress usb mcu to do jtag), a few leds, a reset button, a serial port(USB-FTDI) also powering via USB, an sd card, expansion connector(ide cable?), and an ethernet port. Optional, expansion board, host USB port, NTSC TV out, an ISA port, and PS/2 connector on the board to taunt you. We provide a toaster oven and a multimeter thermometer to do reflow. 
- Bringup -- Compiling and downloading the Verilog for the board

# FireOS
	This is a personal project into the development of a Bootloader, Kernel and an Operating System called fireOS	

	For those who might want to build and run this OS on a physical machine. 
		1. First you must have a running linux machine and a bootable drive(this can be a USB Stick or whatever you prefer).
		2. With the linux machine up and running install nasm with the command "sudo apt install nasm".
		3. nasm is an assembler, assemble boot.asm to a binary file using the command "nasm -f bin ./boot.asm -o ./boot.bin"

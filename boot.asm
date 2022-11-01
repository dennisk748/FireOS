ORG 0
BITS 16

_start:
    jmp short start
    nop

    times 33 db 0

start:
    jmp 0x7c0:step1

step1:
    cli ; disable interrupts, so that any iterrupts do not mess with this process
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts
    
    ; Prepairing to read from harddisk and writing into memory at buffer
    mov ah, 2 ; Read sector command
    mov al, 1 ; NUmber of sectors to read
    mov ch, 0 ; Cylinder low eight bits 
    mov cl, 2 ; Read secor 2
    mov dh, 0 ; Head number
    mov bx, buffer
    int 0x13 ; the interrupt provided by the BIOS to do operations on the hard disk
    jc error ; If carry flag is set we jump to error and print the error message and then go into an infinite loop at where it is


    mov si, buffer
    call print

    jmp $

error:
    mov si, error_message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .end
    call print_char
    jmp .loop
.end:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

error_message: db 'Failed to load data from hard disk', 0

times 510-($ - $$) db 0 ; fill remaining bytes with 0 upto the 512 bytes
dw 0xAA55

buffer:


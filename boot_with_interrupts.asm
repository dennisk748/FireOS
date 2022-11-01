ORG 0
BITS 16

_start:
    jmp short start
    nop

    times 33 db 0

start:
    jmp 0x7c0:step1

handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

handle_one:
    mov ah, 0eh
    mov al, 'V'
    mov bx, 0x00
    int 0x10
    iret

step1:
    cli ; disable interrupts, so that any iterrupts do not mess with this process
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; enable interrupts

    ; Interrupts are basically subroutines that are called with numbers instead of labels
    ; Each interrupt is made up of four bytes(the offset(2 bytes),the segment(2 bytes))
    ; Here we change the vector interrupt table to point to our implementation of handle zero

    mov word[ss:0x00], handle_zero 
    mov word[ss:0x02], 0x7c0

    ; When we call an interrupt subroutine like below the segment is multiplied by 16.(0x7c0 * 16) + offset(handle zero)
    ; This calls the divide by zero exception. Uncomment the line below to see this in action
    ; int 0 
    ; We can also achieve the same result by trying to divide by a zero, uncomment the two lines below to see this in action.
    ; mov ax, 0x00
    ; div ax

    ; Setting up interrupt one
    ; Visit osdev.org/exceptions to learn more about the various interrupts
    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    int 1

    mov si, message ; Move the address of message into the si register.
    call print ; Calls the print subroutine
    jmp $ ; Initiates an infinite jump to this same address

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
    int 0x10 ; This interrupt is provided by the bios to print characers to the screen
    ret

message: db 'Hello World, So this is like my First Operating System!', 0

times 510-($ - $$) db 0 ; fill remaining bytes with 0 upto the 512 bytes
dw 0xAA55


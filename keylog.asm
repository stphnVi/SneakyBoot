bits 16
org 0x7c00

_start:
    mov ah, 0x00        ; Function 00h de INT 1Ah -set video mode
    mov al, 0x13        ; grafic mode 13h (320x200 pix, 256 colors)
    int 0x10            ; call a la BIOS
    call random
    


random:
    mov ah, 0x00        ; Function 00h -get sistem Time
    int 0x1A            ; Call BIOS
    mov ax, dx          ; dx use Time as seed

    xor dx, dx          
    mov cx, 180          ; max num rows (0-199)
    div cx              ; Divide AX por 25,
    mov [row], dx  

    mov ax, dx        
    xor dx, dx          
    mov cx, 300          ; max num columns (0-319)
    div cx              
    mov [column], dx  
    ret

wait_key:
    mov ah, 0x00    ; Read key
    int 0x16        ; Call BIOS to read the key

row:
    db 0

column:
    db 0

times 510 - ($ - $$) db 0
dw 0xAA55              

; nasm boot.asm
; qemu-system-i386 boot

; or

; nasm -f bin boot.asm -o boot.bin
; qemu-system-i386 -drive format=raw,file=boot.bin
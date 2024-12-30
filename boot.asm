org 0x7c00             

%define SECTOR_AMOUNT 0x4 ; Número de sectores a leer (ajusta si es necesario)

jmp short start        ; Salta al inicio del bootloader

start:
    cli                 ; Deshabilita las interrupciones
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, 0x6ef0      ; Establece el puntero de pila
    sti                 ; Habilita las interrupciones

    ; Cargar keylog.asm desde el disco a la dirección 0x8000
    mov bx, 0x8000      ; Dirección donde se cargará keylog.asm
    mov al, SECTOR_AMOUNT  ; Número de sectores a leer
    mov ch, 0           ; Cilindro
    mov dh, 0           ; Cabeza
    mov cl, 2           ; Sector de inicio
    mov ah, 0x02        ; Función 0x02: leer sectores
    int 0x13            ; Llama a la BIOS para leer sectores

    ; Salta a la dirección 0x8000 donde se cargó keylog.asm
    jmp 0x8000


times 510 - ($ - $$) db 0  ; Rellenar hasta 512 bytes
dw 0xAA55                 ; Firma majika

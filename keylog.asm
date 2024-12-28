bits 16
org 0x7c00


_start:
    
    ;call clean_screen

    mov ah, 0x00        ; Function 00h de INT 1Ah -set video mode
    mov al, 0x13        ; grafic mode 13h (320x200 pix, 256 colors)
    int 0x10            ; call a la BIOS 
    mov si, 0x1000      ; pos imagen
    mov cx, 0 

    call draw_pix
    
draw_row:
    mov dx, 0               ; X = 0 (columna)
    
draw_pix:
    ; Leer un píxel de la imagen (1 byte = color)
    mov al, [si]            ; Cargar el color del píxel
    mov ah, 0x0C            ; Función BIOS para dibujar píxeles
    mov bh, 0               ; Página de video (0)
    mov bl, al              ; Color del píxel
    mov cx, dx              ; Posición X
    mov dx, cx              ; Posición Y

    ; Llamar a la interrupción BIOS para dibujar el píxel
    int 0x10                ; Dibujar el píxel

    ; Incrementar la posición X y la dirección de la imagen

    add dx, 1                  ; Moverse a la siguiente columna (pixel)
    add si, 1                  ; Avanzar al siguiente píxel de la imagen
    cmp dx, 320             ; if 320 pix?
    jl draw_pix           ; seguir dibujando 

    ; else
    xor dx, dx              ; limpia
    inc cx                  ; Avanzar una fila
    cmp cx, 200             ; if 200 filas?
    jl draw_row             ; no, seguir con la siguiente fila

clean_screen:
    mov ah, 0x0C        
    mov al, 0x00        
    mov cx, 0           ; initial left screeen
    mov dx, 0           ; initial rigth screen
    mov bx, 320*200     ; total pix
    ret

wait_key:
    mov ah, 0x00    ; Read key
    int 0x16        ; Call BIOS to read the key
    ;cmp al, 'j'     ; compare


times 510 - ($ - $$) db 0 
dw 0xAA55              


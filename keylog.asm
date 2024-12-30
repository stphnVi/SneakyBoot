org 0x8000  ; Dirección donde se cargará el código


mov si, hello  
print:
    mov ah, 0x0e  ; Función para imprimir un carácter en modo texto
    mov al, [si]   
    int 0x10       ; Llamar a la BIOS

    inc si         
    cmp byte [si], 0  
    jne print      ; loop

jmp $   

hello:
    db "Hello, World!", 0  ; El mensaje a mostrar

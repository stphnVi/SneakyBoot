ASM=nasm
ASMFLAGS=-f bin
BOOT_BIN=boot.bin
KEYLOG_BIN=keylog.bin
IMG=disk.img
IMG_Bin=image.bin  # Asegúrate de que este archivo es la imagen convertida a binario
QEMU=qemu-system-x86_64
QEMUFLAGS=-drive file=$(IMG),format=raw
USB_DEVICE=/dev/sda  # Reemplazar 'sda' por el dispositivo correcto

SECTOR_AMOUNT=0x4   # Número de sectores a leer para keylog.asm
IMAGE_SECTORS=0x2   # Ajusta este valor según el tamaño de la imagen

all: $(IMG)

# Crear la imagen de disco  
$(IMG): $(BOOT_BIN) $(KEYLOG_BIN)
	# Escribir el bootloader en el primer sector de la imagen 
	dd if=$(BOOT_BIN) of=$(IMG) bs=512 seek=0
	# Escribir la imagen BMP (Imagen binaria) a partir de $(IMG_Bin) en el siguiente sector
	dd if=$(IMG_Bin) of=$(IMG) bs=512 seek=1
	# Escribir keylog.asm en los siguientes sectores
	dd if=$(KEYLOG_BIN) of=$(IMG) bs=512 seek=$(IMAGE_SECTORS)

# Compilar boot.asm
$(BOOT_BIN): boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o $(BOOT_BIN)

# Compilar keylog.asm
$(KEYLOG_BIN): keylog.asm
	$(ASM) $(ASMFLAGS) keylog.asm -o $(KEYLOG_BIN)

# Copiar el bootloader y keylog al dispositivo USB
install_usb: $(BOOT_BIN) $(KEYLOG_BIN)
	# Escribir el bootloader en el primer sector del USB
	sudo dd if=$(BOOT_BIN) of=$(USB_DEVICE) bs=512 seek=0
	# Escribir keylog.asm en los siguientes sectores del USB
	sudo dd if=$(KEYLOG_BIN) of=$(USB_DEVICE) bs=512 seek=1
	# Escribir la imagen BMP (en formato binario) en el USB
	sudo dd if=$(IMG_Bin) of=$(USB_DEVICE) bs=512 seek=2

# Ejecutar el sistema en QEMU
run: $(IMG)
	$(QEMU) $(QEMUFLAGS)

# Limpiar archivos generados
clean:
	rm -f $(BOOT_BIN) $(KEYLOG_BIN) $(IMG)

# make            
# make install_usb 
# make run        
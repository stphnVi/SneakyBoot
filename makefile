ASM=nasm
ASMFLAGS=-f bin
BOOT_BIN=boot.bin
KEYLOG_BIN=keylog.bin
IMG=disk.img
QEMU=qemu-system-x86_64
QEMUFLAGS=-drive file=$(IMG),format=raw

SECTOR_AMOUNT=0x4   # Número de sectores a leer para keylog.asm
IMAGE_SECTORS=0x2   # Ajusta este valor según el tamaño de la imagen

all: $(IMG)

# Crear la imagen de disco  
$(IMG): $(BOOT_BIN) $(KEYLOG_BIN)
	dd if=$(BOOT_BIN) of=$(IMG) bs=512 seek=0
	dd if=$(KEYLOG_BIN) of=$(IMG) bs=512 seek=1

# Compilar 
$(BOOT_BIN): boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o $(BOOT_BIN)

$(KEYLOG_BIN): keylog.asm
	$(ASM) $(ASMFLAGS) keylog.asm -o $(KEYLOG_BIN)


run: $(IMG)
	$(QEMU) $(QEMUFLAGS)

clean:
	rm -f $(BOOT_BIN) $(KEYLOG_BIN) $(IMG)


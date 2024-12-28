ASM=nasm
ASMFLAGS=-f bin
BOOT_BIN=boot.bin
KEYLOG_BIN=keylog.bin
IMG=disk.img
QEMU=qemu-system-x86_64
QEMUFLAGS=-drive file=$(IMG),format=raw
USB_DEVICE=/dev/sda  # Reemplazar 'sda, ver con lsblk

# Objetivos
all: $(IMG)

# Crear la imagen de disco 
$(IMG): $(BOOT_BIN) $(KEYLOG_BIN)
# Escribir el bootloader en el primer sector de la imagen del disco (dd command)
	dd if=$(BOOT_BIN) of=$(IMG) bs=512 seek=0
# Escribir keylog.asm en los siguientes sectores
	dd if=$(KEYLOG_BIN) of=$(IMG) bs=512 seek=1

# Compilar boot.asm y keylog.am 
$(BOOT_BIN): boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o $(BOOT_BIN)

$(KEYLOG_BIN): keylog.asm
	$(ASM) $(ASMFLAGS) keylog.asm -o $(KEYLOG_BIN)

# Copiar el bootloader y keylog al dispositivo USB
install_usb: $(BOOT_BIN) $(KEYLOG_BIN)
# bootloader - USB
	sudo dd if=$(BOOT_BIN) of=$(USB_DEVICE) bs=512 seek=0
# keylog.asm - USB 
	sudo dd if=$(KEYLOG_BIN) of=$(USB_DEVICE) bs=512 seek=1

# Ejecutar el sistema en QEMU
run: $(IMG)
	$(QEMU) $(QEMUFLAGS)

clean:
	rm -f $(BOOT_BIN) $(KEYLOG_BIN) $(IMG)

from PIL import Image
import struct

file_in = "test.png"
file_bin = "../image.bin" 

# Abrir la imagen
img = Image.open(file_in)

# Si la imagen tiene un canal (RGBA), se convierte a RGB
if len(img.split()) == 4:
    r, g, b, a = img.split()
    img = Image.merge("RGB", (r, g, b))


pixels = img.tobytes()  
with open(file_bin, "wb") as f:
    f.write(pixels)

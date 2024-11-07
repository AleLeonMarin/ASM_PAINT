import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image
import numpy as np

palette = [
    (0, 0, 0),
    (0, 0, 255),
    (0, 255, 0),
    (0, 255, 255),
    (255, 0, 0),
    (255, 0, 255),
    (165, 42, 42),
    (192, 192, 192),
    (128, 128, 128),
    (173, 216, 230),
    (144, 238, 144),
    (135, 206, 250),
    (240, 128, 128),
    (255, 182, 193),
    (255, 255, 0),
    (255, 255, 255)
]

def closest_color(rgb):
    r, g, b = rgb
    color_diffs = []
    for i, color in enumerate(palette):
        cr, cg, cb = color
        color_diff = np.sqrt((r - cr)**2 + (g - cg)**2 + (b - cb)**2)
        color_diffs.append((color_diff, i))
    return min(color_diffs, key=lambda x: x[0])[1]

def convert_image_to_text(input_image_path, output_text_path):
    try:
        img = Image.open(input_image_path).convert('RGB')
        img = img.resize((64, 64))

        with open(output_text_path, 'w') as f:
            for y in range(img.height):
                for x in range(img.width):
                    pixel_value = img.getpixel((x, y))
                    closest_color_idx = closest_color(pixel_value)
                    hex_value = format(closest_color_idx, 'X')
                    f.write(hex_value)
                f.write('@\n')

            f.write('%\n')
        messagebox.showinfo("Conversión Exitosa", f"Imagen convertida y guardada en: {output_text_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

def convert_text_to_bmp(input_text_path, output_image_path, width=64, height=64):
    try:
        img = Image.new('RGB', (width, height))
        with open(input_text_path, 'r') as f:
            y = 0
            for line in f:
                if line.strip() == '%':
                    break
                x = 0
                for char in line.strip().split('@')[0]:
                    if char in '0123456789ABCDEF':
                        color_idx = int(char, 16)
                        img.putpixel((x, y), palette[color_idx])
                    x += 1
                y += 1
        img.save(output_image_path)
        messagebox.showinfo("Restauración Exitosa", f"Imagen restaurada y guardada en: {output_image_path}")
    except Exception as e:
        messagebox.showerror("Error", f"Se produjo un error: {e}")

def select_file():
    file_path = filedialog.askopenfilename(
        title="Selecciona una imagen",
        filetypes=[("Archivos de imagen", "*.png;*.jpg;*.bmp"), ("Todos los archivos", "*.*")]
    )
    return file_path

def save_text_file():
    text_path = filedialog.asksaveasfilename(
        defaultextension=".txt",
        filetypes=[("Texto", "*.txt")],
        title="Guardar archivo de texto"
    )
    return text_path

def save_image_file():
    image_path = filedialog.asksaveasfilename(
        defaultextension=".bmp",
        filetypes=[("Imágenes BMP", "*.bmp")],
        title="Guardar imagen BMP"
    )
    return image_path

def main():
    root = tk.Tk()
    root.withdraw()

    input_image_path = select_file()
    if not input_image_path:
        return

    output_text_path = save_text_file()
    if not output_text_path:
        return

    convert_image_to_text(input_image_path, output_text_path)

    output_image_path = save_image_file()
    if not output_image_path:
        return

    convert_text_to_bmp(output_text_path, output_image_path)

if __name__ == "__main__":
    main()

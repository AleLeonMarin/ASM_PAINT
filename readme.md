# ASM PAINT

**ASM PAINT** is a simplified version of the popular drawing tool, Paint, designed in assembly language for the x86 16-bit architecture. This project emulates the basic functionalities of Paint within a DOS environment, using **DOSBox** for CPU emulation and **ASM Helper** (a tool provided by the instructor) to assist with development in assembly.

## Project Overview

The **ASM PAINT** project replicates basic features of painting software, allowing users to draw on a simple graphical interface. Developing this in assembly represents a challenge, especially in implementing basic graphics and controls in a 16-bit environment.

Additionally, a Python application was developed to convert BMP images to text format. This tool enables the conversion of bitmap images into ASCII text, making them compatible with the constraints of the x86 16-bit environment and allowing easier integration into ASM PAINT.

## Tools Used

- **ASM x86 16-bit**: Assembly language for developing the application.
- **Python**: Used for the BMP-to-text conversion tool.
- **Pillow** and **NumPy**: Python libraries required for image processing in the BMP-to-text converter.
- **DOSBox**: CPU emulator used to run and test the code in an environment simulating a 16-bit x86 processor.
- **ASM Helper**: Tool provided by the instructor to facilitate development and debugging in assembly.

## Setup and Installation

1. **Install DOSBox**  
   Download and install DOSBox from [dosbox.com](https://www.dosbox.com/).

2. **Configure ASM Helper**  
   Follow the instructor's instructions to install and configure ASM Helper along with DOSBox.

3. **Run the BMP to Text Converter (Python)**
   - Ensure that Python is installed on your machine. You can download it from [python.org](https://www.python.org/).
   - Install the required Python libraries:
     - **Pillow** for image processing:
       ```bash
       pip install pillow
       ```
     - **NumPy** for numerical operations:
       ```bash
       pip install numpy
       ```
   - Run the BMP-to-text conversion script on your BMP images to prepare them for use in **ASM PAINT**.

4. **Run the ASM PAINT Application**
   - Ensure the **ASM PAINT** files are in an accessible directory.
   - Use DOSBox to navigate to the project directory and run the assembly program.

## Contributors

- **Developers**:
  - Alejandro León Marín
  - Justin Méndez Mena
- **Instructor**:
  - Dr. Elvis Rojas Ramírez

---

This README provides a clear introduction to the project, necessary tools, and setup guide, making it easy for new users and contributors to understand and run the **ASM PAINT** project.

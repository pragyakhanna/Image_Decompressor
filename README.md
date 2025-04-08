# FPGA Image Decompressor (.mic18 Format)

Hardware implementation of a real-time image decompressor using VHDL on the Altera DE2-115 FPGA. Built for the COE3DQ5 course at McMaster University, this system reconstructs compressed `.mic18` images and displays them via VGA.

## Features

- Hardware pipeline for image decompression:
  - RGB → YUV color space conversion
  - Downsampling, 2D DCT/IDCT
  - Quantization & dequantization
  - Prefix-coded lossless decoding
- Real-time VGA display from FPGA
- Fixed-point arithmetic for hardware efficiency
- UART + SRAM for data input and intermediate storage

## Tools & Tech

- VHDL, ModelSim
- Altera DE2-115 FPGA
- UART, SRAM, VGA
- Fixed-point signal processing

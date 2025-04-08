# activate waveform simulation

view wave

# format signal names in waveform

configure wave -signalnamewidth 1
configure wave -timeline 0
configure wave -timelineunits us

# add signals to waveform

add wave -divider -height 20 {Top-level signals}
add wave -bin UUT/CLOCK_50_I
add wave -bin UUT/resetn
add wave UUT/top_state
add wave -uns UUT/UART_timer

add wave -divider -height 10 {SRAM signals}
add wave -uns UUT/SRAM_address
add wave -hex UUT/SRAM_write_data
add wave -bin UUT/SRAM_we_n
add wave -hex UUT/SRAM_read_data

add wave -divider -height 10 {VGA signals}
add wave -bin UUT/VGA_unit/VGA_HSYNC_O
add wave -bin UUT/VGA_unit/VGA_VSYNC_O
add wave -uns UUT/VGA_unit/pixel_X_pos
add wave -uns UUT/VGA_unit/pixel_Y_pos
add wave -hex UUT/VGA_unit/VGA_red
add wave -hex UUT/VGA_unit/VGA_green
add wave -hex UUT/VGA_unit/VGA_blue

add wave -hex UUT/M1_unit/M1_state

add wave -hex UUT/M1_unit/multiresult1
add wave -hex UUT/M1_unit/multiresult2
add wave -hex UUT/M1_unit/multiresult3

add wave -hex UUT/M1_unit/v1
add wave -hex UUT/M1_unit/v2
add wave -hex UUT/M1_unit/v3

add wave -hex UUT/M1_unit/V_buffer_for_prime

add wave -hex UUT/M1_unit/U_buffer_for_prime

#add wave -hex UUT/M1_unit/V_prime_odd
#add wave -hex UUT/M1_unit/R_even
#add wave -hex UUT/M1_unit/G_even
#add wave -hex UUT/M1_unit/B_even
#add wave -hex UUT/M1_unit/R_odd
#dd wave -hex UUT/M1_unit/G_odd
#add wave -hex UUT/M1_unit/B_odd
add wave -hex UUT/M1_unit/Y_count
add wave -hex UUT/M1_unit/UV_count
#add wave -hex UUT/M1_unit/multireg1
#add wave -hex UUT/M1_unit/multireg2
#add wave -hex UUT/M1_unit/multireg3
add wave -hex UUT/M1_unit/lead_out_counter
add wave -hex UUT/M1_unit/U_buffer
add wave -hex UUT/M1_unit/V_buffer

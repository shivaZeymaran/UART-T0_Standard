onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Khaki -height 20 -label clk /uart_tb/clk_tb
add wave -noupdate -color Goldenrod -height 25 -label nrst /uart_tb/nrst_tb
add wave -noupdate -color Sienna -height 25 -label baud /uart_tb/baud_tb
add wave -noupdate -divider -height 20 Transmitter
add wave -noupdate -color Cyan -height 22 -label {Start bit} /uart_tb/t_start_bit_tb
add wave -noupdate -color {Medium Slate Blue} -height 22 -label data_in /uart_tb/t_data_in_tb
add wave -noupdate -color {Medium Sea Green} -height 22 -label t_data_reg /uart_tb/UUT_T/t_data_reg
add wave -noupdate -color Pink -height 22 -label t_state /uart_tb/UUT_T/t_state
add wave -noupdate -color Violet -height 22 -label t_next_state /uart_tb/UUT_T/t_next_state
add wave -noupdate -color White -height 22 -label t_tick_counter /uart_tb/UUT_T/t_tick_counter
add wave -noupdate -color {Medium Blue} -label t_data_out /uart_tb/t_data_out_tb
add wave -noupdate -color Plum -label r_state /uart_tb/UUT_T/r_state
add wave -noupdate -color Orchid -label r_data_reg /uart_tb/UUT_T/r_data_reg
add wave -noupdate -divider -height 20 IO
add wave -noupdate -color White -label t_mode /uart_tb/UUT_T/uart_mode
add wave -noupdate -color Yellow -height 22 -label I/O /uart_tb/io_tb
add wave -noupdate -color White -label r_mode /uart_tb/UUT_R/uart_mode
add wave -noupdate -divider -height 20 Receiver
add wave -noupdate -color {Medium Sea Green} -height 22 -label r_data_reg /uart_tb/UUT_R/r_data_reg
add wave -noupdate -color Pink -height 22 -label r_state /uart_tb/UUT_R/r_state
add wave -noupdate -color Violet -height 22 -label r_next_state /uart_tb/UUT_R/r_next_state
add wave -noupdate -color {Medium Slate Blue} -height 22 -label data_out /uart_tb/r_data_out_tb
add wave -noupdate -color Cyan -height 22 -label data_ready /uart_tb/r_data_ready_tb
add wave -noupdate -color Coral -height 22 -label {calculated parity} /uart_tb/UUT_R/comb_reciever/parity_val
add wave -noupdate -color Coral -height 22 -label {received parity} /uart_tb/UUT_R/comb_reciever/parity_chk
add wave -noupdate -color White -height 22 -label r_tick_counter /uart_tb/UUT_R/r_tick_counter
add wave -noupdate -color Cyan -label {Start bit} /uart_tb/r_start_bit_tb
add wave -noupdate -color {Medium Blue} -label data_in /uart_tb/r_data_in_tb
add wave -noupdate -color Plum -label t_state /uart_tb/UUT_R/t_state
add wave -noupdate -color Magenta -label t_data_reg /uart_tb/UUT_R/t_data_reg
TreeUpdate [SetDefaultTree]
configure wave -namecolwidth 257
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1029721 ps} {1846130 ps}

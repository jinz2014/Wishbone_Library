onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testbnch/clk_i
add wave -noupdate -radix hexadecimal /testbnch/rst_i
add wave -noupdate -radix hexadecimal /testbnch/dmode
add wave -noupdate -radix hexadecimal /testbnch/ia
add wave -noupdate -radix hexadecimal /testbnch/id
add wave -noupdate -radix hexadecimal /testbnch/ack_i
add wave -noupdate -radix hexadecimal /testbnch/dat_i
add wave -noupdate -radix hexadecimal /testbnch/adr_o
add wave -noupdate -radix hexadecimal /testbnch/dat_o
add wave -noupdate /testbnch/cyc_o
add wave -noupdate -radix hexadecimal /testbnch/stb_o
add wave -noupdate /testbnch/stb_o
add wave -noupdate -radix hexadecimal /testbnch/we_o
add wave -noupdate -radix hexadecimal /testbnch/adr_o_vlog
add wave -noupdate -radix hexadecimal /testbnch/dat_o_vlog
add wave -noupdate -radix hexadecimal /testbnch/cyc_o_vlog
add wave -noupdate -radix hexadecimal /testbnch/stb_o_vlog
add wave -noupdate -radix hexadecimal /testbnch/we_o_vlog
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3579 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 50
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1135 ns} {4782 ns}

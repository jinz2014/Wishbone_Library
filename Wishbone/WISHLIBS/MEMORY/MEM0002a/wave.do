onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testbnch/clk_i
add wave -noupdate -radix hexadecimal /testbnch/adr_i
add wave -noupdate -radix hexadecimal /testbnch/we_i
add wave -noupdate -radix hexadecimal /testbnch/dat_i
add wave -noupdate -radix hexadecimal /testbnch/stb_i
add wave -noupdate -radix hexadecimal /testbnch/ack_o
add wave -noupdate -radix hexadecimal /testbnch/dat_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2334 ns} 0}
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
WaveRestoreZoom {1613 ns} {2694 ns}

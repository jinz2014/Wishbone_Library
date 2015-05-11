onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /testbnch/tbench/extclk
add wave -noupdate -radix hexadecimal /testbnch/tbench/exttst
add wave -noupdate -radix hexadecimal /testbnch/tbench/clk
add wave -noupdate -radix hexadecimal /testbnch/tbench/rst
add wave -noupdate -radix hexadecimal /testbnch/tbench/ack
add wave -noupdate -radix hexadecimal /testbnch/tbench/adr
add wave -noupdate -radix hexadecimal /testbnch/tbench/stb
add wave -noupdate -radix hexadecimal /testbnch/tbench/we
add wave -noupdate -radix hexadecimal /testbnch/tbench/estb
add wave -noupdate -radix hexadecimal /testbnch/tbench/eack
add wave -noupdate -radix hexadecimal /testbnch/tbench/eadr
add wave -noupdate -radix hexadecimal /testbnch/tbench/edwr
add wave -noupdate -radix hexadecimal /testbnch/tbench/edrd
add wave -noupdate -radix hexadecimal /testbnch/tbench/ewe
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {645 ns} 0}
configure wave -namecolwidth 209
configure wave -valuecolwidth 200
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
WaveRestoreZoom {0 ns} {2450 ns}

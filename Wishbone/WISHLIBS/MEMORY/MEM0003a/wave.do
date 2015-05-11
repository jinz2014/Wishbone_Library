onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TESTBNCH/CLK_I
add wave -noupdate -radix unsigned /TESTBNCH/i
add wave -noupdate /TESTBNCH/STB_I
add wave -noupdate /TESTBNCH/WE_I
add wave -noupdate /TESTBNCH/ACK_O
add wave -noupdate /TESTBNCH/ADR_I
add wave -noupdate -radix unsigned /TESTBNCH/DAT_I
add wave -noupdate -radix unsigned /TESTBNCH/DAT_O
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14755 ns} 0}
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
WaveRestoreZoom {14654 ns} {15431 ns}

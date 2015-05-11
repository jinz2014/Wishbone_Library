onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbnch/clk
add wave -noupdate /testbnch/rst
add wave -noupdate /testbnch/comcyc
add wave -noupdate /testbnch/cyc0
add wave -noupdate /testbnch/cyc1
add wave -noupdate /testbnch/cyc2
add wave -noupdate /testbnch/cyc3
add wave -noupdate /testbnch/gnt0
add wave -noupdate /testbnch/gnt1
add wave -noupdate /testbnch/gnt2
add wave -noupdate /testbnch/gnt3
add wave -noupdate /testbnch/gnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28072 ns} 0}
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
WaveRestoreZoom {28050 ns} {29050 ns}

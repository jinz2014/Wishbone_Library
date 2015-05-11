onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbnch/extclk
add wave -noupdate /testbnch/exttst
add wave -noupdate /testbnch/clk_o
add wave -noupdate /testbnch/rst_o
add wave -noupdate /testbnch/clk_o_vlog
add wave -noupdate /testbnch/rst_o_vlog
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {201 ns} 0}
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
WaveRestoreZoom {0 ns} {1382 ns}

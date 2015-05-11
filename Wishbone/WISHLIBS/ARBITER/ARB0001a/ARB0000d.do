onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbnch/tbench/RST
add wave -noupdate /testbnch/tbench/CLK
add wave -noupdate /testbnch/tbench/BEG
add wave -noupdate /testbnch/tbench/COMCYC
add wave -noupdate /testbnch/tbench/CYC0
add wave -noupdate /testbnch/tbench/CYC1
add wave -noupdate /testbnch/tbench/CYC2
add wave -noupdate /testbnch/tbench/CYC3
add wave -noupdate /testbnch/tbench/GNT
add wave -noupdate /testbnch/tbench/GNT0
add wave -noupdate /testbnch/tbench/GNT1
add wave -noupdate /testbnch/tbench/GNT2
add wave -noupdate /testbnch/tbench/GNT3
add wave -noupdate /testbnch/tbench/LCOMCYC
add wave -noupdate /testbnch/tbench/LGNT
add wave -noupdate /testbnch/tbench/LGNT0
add wave -noupdate /testbnch/tbench/LGNT1
add wave -noupdate /testbnch/tbench/LGNT2
add wave -noupdate /testbnch/tbench/LGNT3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {486 ns} 0}
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
WaveRestoreZoom {0 ns} {2981 ns}

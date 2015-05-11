onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/CLK_I
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/RST_I
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/ACK_I
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/CYC_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/DAT_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/DAT_I
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/ADR_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/SEL_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/STB_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/WE_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/DMODE
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/IA
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/ID
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/INC
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/INP
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/LADR_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/LBDAT
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/LDAT_O
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/SAS
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/TC
add wave -noupdate -radix hexadecimal /TESTBNCH/ICN/u01/WE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1449866 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1065472 ps} {2194222 ps}

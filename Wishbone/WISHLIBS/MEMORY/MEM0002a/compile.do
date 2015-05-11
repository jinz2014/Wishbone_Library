if {[file exists work]} {
   vdel -lib work -all
 }

 vlib work
 
 vmap -c work work

vcom -reportprogress 300 -work work TESTBNCH.VHD
vcom -reportprogress 300 -work work MEM0002a.VHD

vsim -t ns -voptargs=+acc work.TESTBNCH


if {[file exists wave.do]} {
  do wave.do
}

run -a
quit -f


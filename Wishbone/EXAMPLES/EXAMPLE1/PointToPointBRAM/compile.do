quit -sim

if {[file exists work]} {
   vdel -lib work -all
 }

vlib work
 
vmap -c work work

set SIM_LIB "-L /usr/local/3rdparty/mentor/xilinx_libs/xilinxcorelib_ver"

vlog -work work *.v
vcom -reportprogress 300 -work work ICN0001b.VHD


eval vsim -t ns $SIM_LIB -voptargs=+acc work.TESTBNCH


if {[file exists wave.do]} {
  do wave.do
}

run -a
#quit -f


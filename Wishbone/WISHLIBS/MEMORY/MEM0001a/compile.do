if {[file exists work]} {
   vdel -lib work -all
 }

vlib work
 
vmap -c work work
vmap xilinxcorelib "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib"

set SIM_LIB "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib_ver"

vcom -reportprogress 300 -work work TESTBNCH.VHD
vcom -reportprogress 300 -work work MEM0001a.VHD
vcom -reportprogress 300 -work work ram08x32.vhd

vsim -t ns -L $SIM_LIB -voptargs=+acc work.TESTBNCH


if {[file exists wave.do]} {
  do wave.do
}

run -a


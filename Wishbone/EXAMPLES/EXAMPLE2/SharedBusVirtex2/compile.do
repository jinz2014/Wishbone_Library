quit -sim

if {[file exists work]} {
   vdel -lib work -all
 }

vlib work
 
vmap -c work work
vmap xilinxcorelib "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib"

set SIM_LIB "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib_ver"
set SIM_LIB "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib_ver"
set WBVHDLIB "C:/Users/Jin/Desktop/Courses/CSCE611/Wishbone/WBVHDLIB"

vcom -reportprogress 300 -work work *.VHD
vcom -reportprogress 300 -work work "$WBVHDLIB/WISHLIBS/MEMORY/MEM0001a/ram08x32.vhd"


vsim -t ns -L $SIM_LIB -voptargs=+acc work.TESTBNCH


if {[file exists wave.do]} {
  do wave.do
}

run -a
#quit -f


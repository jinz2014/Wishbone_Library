quit -sim

if {[file exists work]} {
   vdel -lib work -all
 }

vlib work
 
vmap -c work work
vmap xilinxcorelib "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib"
vmap unisim "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/unisim"

set XilinxCoreLib "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/xilinxcorelib_ver"
set UNISIMS "C:/Xilinx/12.1/ISE_DS/ISE/SIM_LIB/unisims_ver"

#vcom -reportprogress 300 -work work TESTBNCH.VHD
vlog -work work TESTBNCH.v
vlog -work work MEM0003a.v
vlog -work work bram08x32.v

vsim -t ns -L $XilinxCoreLib -L $UNISIMS -voptargs=+acc work.TESTBNCH


if {[file exists wave.do]} {
  do wave.do
}

run -a


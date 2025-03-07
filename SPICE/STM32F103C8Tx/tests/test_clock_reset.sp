* STM32F103 Clock and Reset Test - Super Simple Version
.include ../models/stm32_clock.sp
.include ../models/stm32_reset.sp
.include ../models/stm32_power.sp

* Power supplies
V1 VDD 0 PWL(0 0 1m 3.3)
V2 VDDA 0 3.3
V3 VSS 0 0

* HSE Clock (1kHz for testing)
VHSE HSE 0 PULSE(0 3.3 0 10u 10u 480u 1000u)

* Reset input (active low pulse at 2ms)
VNRST NRST 0 PWL(0 3.3 2m 3.3 2.1m 0 2.2m 3.3)

* Circuit instances
X1 VDD VSS VDDA VSS VDD_INT VOK POR_n VDDA_INT STM32F103_POWER
X2 HSE VSS SYSCLK PLL_CLK HCLK PCLK1 PCLK2 STM32F103_CLOCK
X3 NRST POR_n VSS SYS_RST STM32F103_RESET

* Analysis commands
.tran 10u 10m uic

.control
set filetype=ascii
set wr_vecnames
set numdgt=7
set units=degrees

* Run simulation
tran 10u 10m uic

* Create new plot windows with titles
set plotwinsize=1000
set xbrushwidth=2

setplot tran1
set title="STM32F103 Clock and Reset Simulation"

* Plot in separate windows
plot v(hse) v(sysclk) v(pll_clk) title "Clock Signals" xlabel "Time" ylabel "Voltage"
plot v(hclk) v(pclk1) v(pclk2) title "Bus Clocks" xlabel "Time" ylabel "Voltage"
plot v(nrst) v(por_n) v(sys_rst) title "Reset Signals" xlabel "Time" ylabel "Voltage"

* Print some values
print v(hse) v(sysclk) v(pll_clk) > clock_signals.txt
print v(hclk) v(pclk1) v(pclk2) > bus_clocks.txt
print v(nrst) v(por_n) v(sys_rst) > reset_signals.txt

echo "Simulation completed - check the plot windows"
.endc

.end 
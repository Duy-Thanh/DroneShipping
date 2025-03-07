* STM32F103 Clock and Reset Test - Basic Version
.include ../models/stm32_clock.sp
.include ../models/stm32_reset.sp
.include ../models/stm32_power.sp

* Power supplies
V1 VDD 0 PWL(0 0 1m 3.3)
V2 VDDA 0 3.3
V3 VSS 0 0

* HSE Clock (100kHz for initial testing)
VHSE HSE 0 PULSE(0 3.3 0 100n 100n 4.8u 10u)

* Reset input (active low pulse at 2ms)
VNRST NRST 0 PWL(0 3.3 2m 3.3 2.1m 0 2.2m 3.3)

* Circuit instances
X1 VDD VSS VDDA VSS VDD_INT VOK POR_n VDDA_INT STM32F103_POWER
X2 HSE VSS SYSCLK PLL_CLK HCLK PCLK1 PCLK2 STM32F103_CLOCK
X3 NRST POR_n VSS SYS_RST STM32F103_RESET

* Analysis
.control
set filetype=ascii
set wr_vecnames
set numdgt=7

* Run simulation
tran 100n 100u uic
run

* Save vectors first
let vhse = v(hse)
let vsysclk = v(sysclk)
let vpll = v(pll_clk)
let vhclk = v(hclk)
let vpclk1 = v(pclk1)
let vpclk2 = v(pclk2)
let vnrst = v(nrst)
let vpor = v(por_n)
let vsysrst = v(sys_rst)

* Plot using saved vectors
plot vhse vsysclk vpll title 'Clock Signals'
plot vhclk vpclk1 vpclk2 title 'Bus Clocks'
plot vnrst vpor vsysrst title 'Reset Signals'

* Save data
wrdata clock_reset_test.txt vhse vsysclk vpll vhclk vpclk1 vpclk2 vnrst vpor vsysrst

echo "\nSimulation completed"
.endc

.end 
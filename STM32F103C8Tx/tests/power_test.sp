* STM32F103 Power System Test
.include ../models/stm32_power.sp

* Test circuit
V1 VDD 0 PWL(0 0 1u 3.3)            ; Power supply ramp
V2 VDDA 0 3.3
V3 VSS 0 0
V4 VSSA 0 0

* Create internal nodes
.GLOBAL VDD_INT VOK POR_n VDDA_INT

* Instance with all required nodes
X1 VDD VSS VDDA VSSA VDD_INT VOK POR_n VDDA_INT STM32F103_POWER

* Analysis commands
.control
set filetype=ascii
set wr_vecnames
tran 0.1u 10u uic                   ; Transient analysis
wrdata power_test.txt v(VDD) v(VDD_INT) v(VOK) v(POR_n) i(V1)
plot v(VDD) v(VDD_INT) v(VOK) v(POR_n)
.endc

.end
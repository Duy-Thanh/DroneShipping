* STM32F103 Power System Model - Enhanced Version
.SUBCKT STM32F103_POWER VDD VSS VDDA VSSA VDD_INT VOK POR_n VDDA_INT

* Power monitoring with realistic filtering
RVDD1 VDD VDD_INT 1
CVDD1 VDD_INT VSS 4.7u
RVDD2 VDD_INT VSS 100k

* Voltage monitor with hysteresis
BVOK VOK VSS V=v(vdd_int)>2.7 ? (v(vdd_int)>2.5 ? 3.3 : v(vok)) : 0
RVOK VOK VSS 10k
CVOK VOK VSS 100p

* Power-on reset with delay
BPOR POR_n VSS V=v(vok)>3.0 ? (time>20u ? 3.3 : 0) : 0
RPOR POR_n VSS 10k
CPOR POR_n VSS 1n

* Analog power with filtering
RVDDA VDDA VDDA_INT 1
CVDDA VDDA_INT VSSA 4.7u
RVDDA2 VDDA_INT VSSA 100k

* Current consumption model with startup
IVDD VDD VSS PWL(
+ 0    0
+ 0.1u -5m     ; Initial surge
+ 1u   -20m    ; Startup
+ 10u  -15m    ; Normal operation
+ 20u  -10m    ; Settled
+ 100u -10m)   ; Steady state

.ENDS

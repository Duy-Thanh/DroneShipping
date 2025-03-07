* STM32F103 Power System Model - Hardware Version
.SUBCKT STM32F103_POWER VDD VSS VDDA VSSA VDD_INT VOK POR_n VDDA_INT

* Power monitoring (based on datasheet specs)
RVDD1 VDD VDD_INT 0.5      ; Lower resistance for better regulation
CVDD1 VDD_INT VSS 100n     ; Internal decoupling (typical for IC)
CVDD2 VDD VSS 100n         ; On-chip decoupling
RVDD2 VDD_INT VSS 1Meg     ; Leakage current path

* Voltage monitor (STM32 specs)
* VOK triggers: 2.7V rising, 2.5V falling (with hysteresis)
BVOK VOK VSS V=v(vdd_int)>2.7 ? (v(vdd_int)>2.5 ? 3.3 : v(vok)) : 0
RVOK VOK VSS 50k
CVOK VOK VSS 10p          ; Fast response time

* Power-on reset (per datasheet)
* POR releases after 1.5ms typical at room temp
BPOR POR_n VSS V=v(vok)>3.0 ? (time>1.5m ? 3.3 : 0) : 0
RPOR POR_n VSS 50k
CPOR POR_n VSS 10p

* Analog power (typical for ADC/DAC)
RVDDA VDDA VDDA_INT 0.5
CVDDA VDDA_INT VSSA 100n
RVDDA2 VDDA_INT VSSA 1Meg

* Current consumption from datasheet:
* - Run mode: 36mA @ 72MHz
* - Sleep: 13mA
* - Stop: 42µA
* - Standby: 2µA
IVDD VDD VSS PWL(
+ 0     0
+ 0.1u  -50m    ; Initial surge (power-on spike)
+ 1u    -100m   ; Startup current (higher during init)
+ 2m    -36m    ; Normal run mode @ 72MHz
+ 3m    -13m    ; Sleep mode
+ 4m    -42u    ; Stop mode
+ 5m    -2u)    ; Standby mode

.ENDS

* STM32F103 Power System Model
*
* This model describes the power system of the STM32F103 microcontroller.
* It includes the power supply, the power distribution network, and the
* power consumption of the microcontroller.
*

.SUBCKT STM32F103_POWER VDD VSS VDDA VSSA VDD_INT VOK POR_n VDDA_INT

* Internal voltage nodes
.NODESET V(VDD_INT)=0
.NODESET V(POR_n)=0

* Power supply monitoring
EVDD VDD_INT 0 VDD VSS 1
BVMON VOK 0 V=V(VDD,VSS)>2.0 && V(VDD,VSS)<3.6

* Power-on Test circuit (POR)
CPOR POR_n 0 100n
RPOR POR_n 0 100k
BPOR POR_n 0 V=V(VOK)>0.5 ? 3.3 : 0

* Current consumption model (simplified)
IVDD VDD VSS PWL(0 0
+ 1u 20mA           ; Startup current
+ 2u 40mA           ; Peak current
+ 3u 20mA)          ; Running current

* Analog power domain
RVDDA VDDA VDDA_INT 10
CVDDA VDDA_INT 0 100n

.ENDS

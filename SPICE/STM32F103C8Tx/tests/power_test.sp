* STM32F103 Power System Test - Hardware Version
.include ../models/stm32_power.sp

* Power supplies with realistic ramp
V1 VDD 0 PWL(0 0 1m 3.3)    ; 1ms power ramp (typical for regulators)
V2 VDDA 0 3.3
V3 VSS 0 0
V4 VSSA 0 0

* Circuit instance
X1 VDD VSS VDDA VSSA VDD_INT VOK POR_n VDDA_INT STM32F103_POWER

* Analysis commands
.control
set filetype=ascii
set wr_vecnames
set numdgt=7

* Run longer simulation to see power modes
tran 0.1u 6m uic

* Save data
wrdata power_test.txt time v(vdd) v(vdd_int) v(vok) v(por_n) i(v1) v(vdda_int)

* Measure startup timing
meas tran t_vdd_ok WHEN v(vdd_int)=2.7 RISE=1
meas tran t_vok_high WHEN v(vok)=3.0 RISE=1
meas tran t_por_high WHEN v(por_n)=3.0 RISE=1

* Measure current in different modes
meas tran i_run AVG i(v1) FROM=2m TO=3m
meas tran i_sleep AVG i(v1) FROM=3m TO=4m
meas tran i_stop AVG i(v1) FROM=4m TO=5m
meas tran i_standby AVG i(v1) FROM=5m TO=6m

* Plot with longer timebase
plot v(vdd) v(vdd_int) v(vdda_int) title 'Power Supply Voltages'
plot v(vok) v(por_n) title 'Control Signals'
plot i(v1) title 'Power Consumption'
.endc

.end
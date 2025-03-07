* STM32F103 Power System Test - Full Version
.include ../models/stm32_power.sp

* Power supplies
V1 VDD 0 PWL(0 0 10u 3.3)
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

* Run simulation
tran 0.1u 500u uic

* Save data for analysis
wrdata power_test.txt time v(vdd) v(vdd_int) v(vok) v(por_n) i(v1) v(vdda_int)

* Display key timing points
meas tran t_vdd_ok WHEN v(vdd_int)=2.7 RISE=1
meas tran t_vok_high WHEN v(vok)=3.0 RISE=1
meas tran t_por_high WHEN v(por_n)=3.0 RISE=1

* Check voltage levels
meas tran vdd_min MIN v(vdd_int) FROM=100u TO=500u
meas tran vdd_max MAX v(vdd_int) FROM=100u TO=500u
meas tran vdd_ripple PP v(vdd_int) FROM=100u TO=500u

* Print results
echo "\nPower Sequence Timing:"
print t_vdd_ok t_vok_high t_por_high

echo "\nVoltage Regulation:"
print vdd_min vdd_max vdd_ripple

* Plot results
plot v(vdd) v(vdd_int) v(vdda_int) title 'Power Supply Voltages'
plot v(vok) v(por_n) title 'Control Signals'
plot i(v1) title 'Power Consumption'
.endc

.end
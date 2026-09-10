v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 50 -340 90 -340 {
lab=#net1}
N 130 -420 130 -370 {
lab=#net2}
N 130 -340 230 -340 {
lab=#net3}
N 130 -310 130 -240 {
lab=#net4}
N 230 -340 250 -340 {lab=#net3}
N 180 -460 200 -460 {lab=#net2}
N 130 -460 130 -430 {lab=#net2}
N 130 -460 180 -460 {lab=#net2}
N 130 -430 130 -420 {lab=#net2}
C {devices/code_shown.sym} 20 -90 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 300 -380 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save all
dc Vg 0 3.3 0.01
write PMOS_testbench.raw
.endc
"}
C {vsource.sym} 50 -310 0 0 {name=Vg value=3 savecurrent=false}
C {vsource.sym} 130 -210 0 0 {name=Vd value=0 savecurrent=false}
C {gnd.sym} 50 -280 0 0 {name=l1 lab=0}
C {gnd.sym} 130 -180 0 0 {name=l2 lab=0}
C {vsource.sym} 250 -310 0 0 {name=Vb value=3.3 savecurrent=false}
C {gnd.sym} 250 -280 0 0 {name=l3 lab=0}
C {vsource.sym} 200 -430 0 0 {name=Vs value=3.3 savecurrent=false}
C {gnd.sym} 200 -400 0 0 {name=l4 lab=0}
C {pdks/gf180mcuD/libs.tech/xschem/gf180mcu_fd_pr/pfet_03v3.sym} 110 -340 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}

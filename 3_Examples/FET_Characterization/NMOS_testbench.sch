v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 70 -370 110 -370 {
lab=#net1}
N 150 -450 150 -400 {
lab=#net2}
N 150 -370 250 -370 {
lab=#net3}
N 150 -340 150 -270 {
lab=#net4}
N 250 -370 270 -370 {lab=#net3}
N 200 -490 220 -490 {lab=#net2}
N 150 -490 150 -460 {lab=#net2}
N 150 -490 200 -490 {lab=#net2}
N 150 -460 150 -450 {lab=#net2}
C {devices/code_shown.sym} 40 -120 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 320 -410 0 0 {name=NGSPICE only_toplevel=true
value="
.control
save all
dc Vg 0 3.3 0.01
write NMOS_testbench.raw
.endc
"}
C {gf180mcu_fd_pr/nfet_03v3.sym} 130 -370 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {vsource.sym} 70 -340 0 0 {name=Vg value=3 savecurrent=false}
C {vsource.sym} 150 -240 0 0 {name=Vs value=0 savecurrent=false}
C {gnd.sym} 70 -310 0 0 {name=l1 lab=0}
C {gnd.sym} 150 -210 0 0 {name=l2 lab=0}
C {vsource.sym} 270 -340 0 0 {name=Vb value=0 savecurrent=false}
C {gnd.sym} 270 -310 0 0 {name=l3 lab=0}
C {vsource.sym} 220 -460 0 0 {name=Vd value=3.3 savecurrent=false}
C {gnd.sym} 220 -430 0 0 {name=l4 lab=0}

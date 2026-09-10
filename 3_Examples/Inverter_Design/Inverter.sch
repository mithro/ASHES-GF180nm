v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 410 -270 {}
N 350 -240 350 -200 {lab=Z}
N 280 -270 310 -270 {lab=I}
N 280 -270 280 -170 {lab=I}
N 280 -170 310 -170 {lab=I}
N 350 -140 350 -100 {lab=GND}
N 350 -340 350 -300 {lab=VDD}
N 350 -220 460 -220 {lab=Z}
N 240 -220 280 -220 {lab=I}
C {pdks/gf180mcuD/libs.tech/xschem/gf180mcu_fd_pr/nfet_03v3.sym} 330 -170 0 0 {name=M1
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
model=nfet_03v3
spiceprefix=X
}
C {pdks/gf180mcuD/libs.tech/xschem/gf180mcu_fd_pr/pfet_03v3.sym} 330 -270 0 0 {name=M2
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
C {ipin.sym} 240 -220 0 0 {name=p1 lab=I}
C {opin.sym} 460 -220 0 0 {name=p2 lab=Z}
C {ipin.sym} 350 -340 0 0 {name=p3 lab=VDD}
C {ipin.sym} 350 -100 0 0 {name=p4 lab=GND}

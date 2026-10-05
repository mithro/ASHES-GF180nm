# ASHES-GF180nm: ICE Lab test chip

Open-source analog and floating-gate standard cells for the GlobalFoundries
GF180MCU process, and the test chip that carries the first of them to silicon.
The work comes from the
[Integrated Computational Electronics (ICE) Lab](https://hasler.ece.gatech.edu/)
at Georgia Tech, led by Jennifer Hasler. The commits in this repository are by
Luke Hanks.

The chip holds eight test structures: three charge pumps, a 4×2 array of
indirectly programmed floating gates, two floating-gate transconductance
amplifiers, a floating-gate characterization cell, NFET and PFET
characterization cells, and a winner-take-all cell.

Why it is useful:

- Floating gates store an analog value without power, which makes analog
  circuits programmable after fabrication. The lab has built programmable
  analog standard cell libraries on this idea in 130 nm and 65 nm CMOS, and
  has shown floating-gate transistors in a 16 nm FinFET process.
- GF180MCU has an open PDK, so the cells and the measurements can be shared
  in full. No published floating-gate measurements for GF180MCU were found
  when this was written.
- The chip measures the pieces a floating-gate library needs first: how
  injection and tunneling behave, what programming voltages the on-chip pumps
  reach, and how the plain transistors compare with their models.
- The repository includes a cell library for the lab's
  [ASHES](https://github.com/GTIceLab/ashes) synthesis tool, which builds
  analog systems from standard cells.

## Status

| Item | State |
|---|---|
| Shuttle | [wafer.space](https://wafer.space/) GF180MCU Run 2, shuttle ID G802, project `0000` "ICELab Test Chip" in the [ws-run2 project list](https://github.com/wafer-space/ws-run2) |
| Layout | Final layout committed on 15 July 2026 |
| Silicon | Expected back in November 2026 |
| Measurements | None yet. Expected values in this repository come from simulation. |

Two connections in the layout need checking before the silicon is tested.
Both were found by netlist extraction and have not been confirmed by the
designers:

| Structure | Finding | Details |
|---|---|---|
| Transconductance amplifiers | `VINJ` does not reach a pad, and pad 24 is unconnected. | [OTA&nbsp;README](1_Design/GF180_cells/2TA/README.md#known-layout-issue) |
| Winner-take-all cell | The shared node `Vmid` does not connect to the four channels. | [WTA&nbsp;README](2_Tools/lib/gds/README.md#known-layout-issue) |

## The chip

![Die layout with the eight test structures numbered and the two bare pads marked B](docs/img/die_annotated.png)

*Chip layout before metal fill. The numbers match the [index](#index). `B`
marks the two bare pads.*

| Property | Value |
|---|---|
| Process | [GF180MCU](https://gf180mcu-pdk.readthedocs.io/), `gf180mcuD` PDK variant |
| Slot | `1x0p5` |
| Die size | 3932 µm × 2531 µm |
| Top cell | `chip_top` |
| Pads | 72: 54 analog, 2 bare, 8 ground (`dvss`), 8 pad ring supply (`dvdd`) |
| Chip layout | [`chip_top_prefill.gds`](1_Design/Tapeouts/WaferSpaceShuttleRun2/TrueFinalGds/chip_top_prefill.gds) before metal fill, [`chip_top.gds`](1_Design/Tapeouts/WaferSpaceShuttleRun2/TrueFinalGds/chip_top.gds) with metal fill |

![Pad map: 72 pads numbered counterclockwise from the lower left, each labelled with the test structure port it connects to](docs/img/pad_map.png)

*Pad map. Pad 1 is at the lower left and the numbers run counterclockwise. The
tables are in [`docs/pad-map.md`](docs/pad-map.md).*

## Index

| # | Structure | Layout cell | Size (µm) | Origin (µm) | Full details |
|---|---|---|---|---|---|
| 1 | [Injection charge pump](#charge-pumps)[^1] | `InjectionSchottkyPump` | 95.8&nbsp;×&nbsp;118.5 | 780,&nbsp;938 | [`2_Tools/lib/gds/FinalPumps/`](2_Tools/lib/gds/FinalPumps/README.md), [`1_Design/GF180_cells/InjectionSchottyPump/`](1_Design/GF180_cells/InjectionSchottyPump/README.md) |
| 2 | [HV charge pump](#charge-pumps)[^2] | `HVSchottkyPump` | 150.0&nbsp;×&nbsp;118.5 | 780,&nbsp;1343 | [`2_Tools/lib/gds/FinalPumps/`](2_Tools/lib/gds/FinalPumps/README.md) |
| 3 | [Tunneling charge pump](#charge-pumps)[^3] | `TunnelingSchottkyPump` | 95.8&nbsp;×&nbsp;118.5 | 780,&nbsp;1509 | [`2_Tools/lib/gds/FinalPumps/`](2_Tools/lib/gds/FinalPumps/README.md) |
| 4 | [Floating-gate array](#floating-gate-array)[^4] | `gf180_4x2_Indirect` | 37.0&nbsp;×&nbsp;11.1 | 1621,&nbsp;1966 | [`1_Design/GF180_cells/4x2_Indirect/`](1_Design/GF180_cells/4x2_Indirect/README.md) |
| 5 | [Transconductance amplifiers](#transconductance-amplifiers)[^5] | `gf180_2TA_1FG_Strong` | 39.1&nbsp;×&nbsp;12.0 | 2984,&nbsp;1931 | [`1_Design/GF180_cells/2TA/`](1_Design/GF180_cells/2TA/README.md) |
| 6 | [Floating-gate characterization cell](#floating-gate-characterization-cell)[^6] | `gf180_FG_Characterization` | 11.3&nbsp;×&nbsp;33.9 | 3316,&nbsp;635 | [`1_Design/GF180_cells/FGCharacterization/`](1_Design/GF180_cells/FGCharacterization/README.md) |
| 7 | [FET characterization cells](#fet-characterization-cells)[^7] | `3PFET`, `3NFET` | 17.7&nbsp;×&nbsp;10.6, 17.4&nbsp;×&nbsp;11.4 | 1043,&nbsp;659 and 1074,&nbsp;659 | [`1_Design/GF180_cells/Ike/`](1_Design/GF180_cells/Ike/README.md) |
| 8 | [Winner-take-all cell](#winner-take-all-cell)[^8] | `WTA` | 9.6&nbsp;×&nbsp;28.2 | 2229,&nbsp;721 | [`2_Tools/lib/gds/`](2_Tools/lib/gds/README.md#winner-take-all-cell) |

Size is the bounding box of the cell as placed in `chip_top`, and origin is its
lower-left corner.

Other documents:

| Document | Contents |
|---|---|
| [`docs/pad-map.md`](docs/pad-map.md) | Every pad, what it connects to, and what to know before bonding. |
| [`docs/sim/README.md`](docs/sim/README.md) | Testbenches and simulated results. |
| [`docs/netlists/`](docs/netlists) | Netlists extracted from the layouts. |
| [`docs/references.md`](docs/references.md) | Reading list for every structure. |
| [`docs/repository.md`](docs/repository.md) | Directory guide, GDS files, how to view the layout, design flow. |
| [`docs/updating-images.md`](docs/updating-images.md) | How to regenerate the pictures in these documents. |
| [`1_Design/GF180_cells/NonOvCLKGen/`](1_Design/GF180_cells/NonOvCLKGen/README.md) | The clock generator used by each charge pump. |

## Charge pumps

Three Dickson charge pumps built from Schottky diodes and 3.2 pF MIM
capacitors. They generate the voltages above the supply that floating-gate
programming needs. They are named for hot-electron injection,
Fowler-Nordheim tunneling and high voltage (HV). Each pump has its own
non-overlapping clock generator.

<table>
  <tr>
    <td width="33%"><img src="docs/img/injection_pump.png" alt="Injection charge pump layout: three MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>1. Injection pump, 2 stages</em></td>
    <td width="33%"><img src="docs/img/hv_pump.png" alt="HV charge pump layout: five MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>2. HV pump, 4 stages</em></td>
    <td width="33%"><img src="docs/img/tunneling_pump.png" alt="Tunneling charge pump layout: four MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>3. Tunneling pump, 3 stages</em></td>
  </tr>
</table>

![Injection charge pump schematic: three Schottky diodes in series from Vin_w to Vout_e, with pump capacitors on PHI1_w and PHI2_w and an output capacitor to GND_w](docs/img/sch_injection_pump.svg)

| Pump | Clock pad | Output pad | Simulated output at 3.3 V (V) | Simulated output at 5 V (V) |
|---|---|---|---|---|
| Injection | 69 | 70 | 9.2 | 14.2 |
| Tunneling | 65 | 64 | 12.2 | 18.9 |
| HV | 66 | 67 (bare) | 15.2 | 23.6 |

| Topic | Summary |
|---|---|
| Bonding | All three share the input on pad 68, the clock generator supply on pad 63 and ground. |
| Test | Apply the supply and input, drive one clock pad with a square wave, and measure the output with a high-impedance instrument. |
| Expected | The table gives the unloaded output with the input and clock amplitude equal to the supply, at 10 MHz. A 10 MΩ probe lowers it by 0.2 V to 2.6 V. |

![Simulated start-up of the three pumps at VDD = 5 V and 10 MHz](docs/img/sim_pump_startup.png)

Full details: [FinalPumps&nbsp;README](2_Tools/lib/gds/FinalPumps/README.md),
[injection pump design files](1_Design/GF180_cells/InjectionSchottyPump/README.md),
[clock generator](1_Design/GF180_cells/NonOvCLKGen/README.md).

Reading: M. Hooper, M. Kucic, P. Hasler, "Integration of High Voltage
Charge-Pumps in a Submicron Standard CMOS Process for Programming Analog
Floating-Gate Circuits," ISCAS 2005,
[doi:10.1109/ISCAS.2005.1464540](https://doi.org/10.1109/ISCAS.2005.1464540).
B. Rumberg, D. W. Graham, M. M. Navidi, "A Regulated Charge Pump for Tunneling
Floating-Gate Transistors," IEEE TCAS-I, 2017,
[doi:10.1109/TCSI.2016.2613080](https://doi.org/10.1109/TCSI.2016.2613080).
J. F. Dickson, IEEE JSSC, 1976,
[doi:10.1109/JSSC.1976.1050739](https://doi.org/10.1109/JSSC.1976.1050739).
[More](docs/references.md#charge-pumps).

## Floating-gate array

A 4×2 array of indirectly programmed floating-gate pFETs. Each cell has one
floating gate shared by a program pFET and a run pFET, so a cell can be
programmed while the run pFET stays connected to its circuit.

![4x2 floating-gate array layout](docs/img/fg_4x2_indirect.png)

| Topic | Summary |
|---|---|
| Bonding | Pads 43 to 60 on the top side. `VTUN` is on bare pad 46 and both `VINJ` columns are on pad 49. Rows 0 and 1 share their drain pads with the OTA. |
| Test | Read each cell by sweeping its gate line and measuring the run pFET current, then tunnel and inject and read again. |
| Expected | Not recorded yet. Programming voltages and rates for this process are what the chip is meant to measure. |

Full details: [floating-gate array&nbsp;README](1_Design/GF180_cells/4x2_Indirect/README.md).

Reading: D. W. Graham, E. Farquhar, B. Degnan, C. Gordon, P. Hasler, "Indirect
Programming of Floating-Gate Transistors," IEEE TCAS-I, 2007,
[doi:10.1109/TCSI.2007.895521](https://doi.org/10.1109/TCSI.2007.895521).
[More](docs/references.md#indirectly-programmed-floating-gate-array).

## Transconductance amplifiers

Two operational transconductance amplifiers (OTAs) with floating-gate
programming. A `PROG` pad switches between programming and normal operation.

![Layout of the two transconductance amplifiers](docs/img/ta_2x_fg.png)

![Schematic of the two transconductance amplifiers and their floating-gate programming circuits](docs/img/sch_ota.svg)

| Topic | Summary |
|---|---|
| Bonding | Inputs on pads 11, 12, 17 and 18 (shared with the WTA), outputs on pads 34 and 37, `PROG` on pad 38, programming lines shared with the FG array. |
| Test | Sweep the differential input and measure the output, before and after programming the floating gates. |
| Expected | Not recorded yet. |
| Known issue | `VINJ` does not reach a pad in the layout. |

Full details: [OTA&nbsp;README](1_Design/GF180_cells/2TA/README.md).

Reading: R. Chawla, F. Adil, G. Serrano, P. E. Hasler, "Programmable Gm-C
Filters Using Floating-Gate Operational Transconductance Amplifiers," IEEE
TCAS-I, 2007,
[doi:10.1109/TCSI.2006.887473](https://doi.org/10.1109/TCSI.2006.887473).
[More](docs/references.md#floating-gate-transconductance-amplifiers).

## Floating-gate characterization cell

One floating-gate pFET with its source, drain, well, tunneling capacitor and two
coupling capacitors on separate pads, and an amplifier that reads the
floating-gate voltage.

<table>
  <tr>
    <td width="25%" align="center"><img src="docs/img/fg_characterization.png" alt="Floating-gate characterization cell layout"/></td>
    <td><img src="docs/img/sch_fg_characterization.svg" alt="Floating-gate characterization cell schematic"/></td>
  </tr>
</table>

| Topic | Summary |
|---|---|
| Bonding | Pads 22, 23 and 27 to 33, with `VTUN` on bare pad 46. |
| Test | Sweep the gate capacitor for the pFET curve, read the floating-gate voltage through the amplifier, and record how both move with tunneling and injection pulses. |
| Expected | Not recorded yet. These measurements are the purpose of the cell. |

Full details: [FG characterization&nbsp;README](1_Design/GF180_cells/FGCharacterization/README.md).

Reading: P. Hasler, A. Basu, S. Koziol, "Above Threshold pFET Injection Modeling
intended for Programming Floating-Gate Systems," ISCAS 2007,
[doi:10.1109/ISCAS.2007.378709](https://doi.org/10.1109/ISCAS.2007.378709).
[More](docs/references.md#floating-gate-characterization).

## FET characterization cells

Three NFETs and three PFETs, all 3.3 V devices with a 0.28 µm gate length and
widths of 0.5 µm, 5 µm and 50 µm.

![PFET (left) and NFET (right) characterization layout](docs/img/fets.png)

| Topic | Summary |
|---|---|
| Bonding | Pads 1 to 4 and 7 to 10 on the bottom side. All six share one gate pad and one source pad, and each has its own drain pad. |
| Test | Sweep the gate and the drain with a source-measure unit. Stay within 3.3 V. |
| Expected | At 3.3 V on gate and drain the model gives 0.27 mA, 2.5 mA and 25 mA for the NFETs and 0.13 mA, 1.2 mA and 12.5 mA for the PFETs. |

![Simulated drain current against gate voltage on a log scale for the three NFETs and three PFETs](docs/img/sim_fets.png)

Full details: [FET characterization&nbsp;README](1_Design/GF180_cells/Ike/README.md).

Reading: C. C. Enz, F. Krummenacher, E. A. Vittoz, "An analytical MOS transistor
model valid in all regions of operation and dedicated to low-voltage and
low-current applications," 1995,
[doi:10.1007/BF01239381](https://doi.org/10.1007/BF01239381).
[More](docs/references.md#fet-characterization).

## Winner-take-all cell

A four-input winner-take-all circuit with nine NFETs: the channel with the
largest input current should take the whole bias current.

<img src="docs/img/wta.png" alt="Winner-take-all cell layout" width="30%"/>

| Topic | Summary |
|---|---|
| Bonding | Inputs on pads 11, 12, 17 and 18 (shared with the OTA), outputs on pads 13 to 16, bias on pad 21. |
| Test | Source a current into each input and measure which output carries the bias current. |
| Expected | Not recorded yet. |
| Known issue | The shared node does not connect to the four channels in the layout, so the cell is not expected to work as drawn. |

Full details: [WTA&nbsp;README](2_Tools/lib/gds/README.md#winner-take-all-cell).

Reading: S. Ramakrishnan, J. Hasler, "Vector-Matrix Multiply and
Winner-Take-All as an Analog Classifier," IEEE TVLSI, 2014,
[doi:10.1109/TVLSI.2013.2245351](https://doi.org/10.1109/TVLSI.2013.2245351).
J. Lazzaro, S. Ryckebusch, M. A. Mahowald, C. A. Mead, "Winner-Take-All Networks
of O(N) Complexity," NIPS 1988,
[PDF](https://papers.nips.cc/paper/1988/file/a8f15eda80c50adb0e71943adc8015cf-Paper.pdf).
[More](docs/references.md#winner-take-all).

## License

This repository is licensed under the Apache License, Version 2.0. See
[`LICENSE`](LICENSE).

## Citing

No paper describes this chip yet. To cite the repository:

```bibtex
@misc{ashes_gf180nm,
  author       = {{Georgia Tech Integrated Computational Electronics Lab}},
  title        = {{ASHES-GF180nm}: {ICE} {Lab} test chip and analog standard cells for {GF180MCU}},
  year         = {2026},
  howpublished = {\url{https://github.com/GTIceLab/ASHES-GF180nm}},
  note         = {wafer.space GF180MCU Run 2, project 0000}
}
```

For the ASHES tool and the standard cell approach, cite:

- A. Ige, L. Yang, H. Yang, J. Hasler, C. Hao, "Analog System High-Level
  Synthesis for Energy-Efficient Reconfigurable Computing," Journal of Low
  Power Electronics and Applications, vol. 13, no. 4, art. 58, 2023.
  [doi:10.3390/jlpea13040058](https://doi.org/10.3390/jlpea13040058)
- J. Hasler, P. R. Ayyappan, A. Ige, P. Mathews, "A 130nm CMOS Programmable
  Analog Standard Cell Library," IEEE Trans. Circuits and Systems I, vol. 71,
  no. 6, pp. 2497-2510, 2024.
  [doi:10.1109/TCSI.2024.3355070](https://doi.org/10.1109/TCSI.2024.3355070)

More in [`docs/references.md`](docs/references.md#programmable-analog-standard-cells-and-ashes).

## Acknowledgements

- [wafer.space](https://wafer.space/) for the GF180MCU Run 2 shuttle.
- GlobalFoundries and Google for the open
  [GF180MCU PDK](https://github.com/google/gf180mcu-pdk).
- The authors of the open-source tools used for the design:
  [xschem](https://xschem.sourceforge.io/),
  [ngspice](https://ngspice.sourceforge.io/),
  [Magic](http://opencircuitdesign.com/magic/) and
  [KLayout](https://www.klayout.de/).

[^1]: Marked 1 on the die image. Two-stage Dickson charge pump with Schottky diodes.
[^2]: Marked 2 on the die image. Four-stage pump. Its output goes to a bare pad.
[^3]: Marked 3 on the die image. Three-stage pump.
[^4]: Marked 4 on the die image. 4×2 array of indirectly programmed floating-gate pFETs.
[^5]: Marked 5 on the die image. Two floating-gate OTAs.
[^6]: Marked 6 on the die image. One floating-gate pFET with all terminals on pads.
[^7]: Marked 7 on the die image. The PFET cell is on the left and the NFET cell on the right.
[^8]: Marked 8 on the die image. Four-input winner-take-all cell.

# ASHES-GF180nm: ICE Lab Test Chip

Design files for the
[Integrated Computational Electronics (ICE) Lab](https://github.com/GTIceLab)
test chip on the [wafer.space](https://wafer.space/) GF180MCU Run 2 shuttle, and
the open-source analog and floating-gate standard cells it is built from. The chip is
project `0000`, "ICELab Test Chip", in the
[wafer-space/ws-run2](https://github.com/wafer-space/ws-run2) project list.

| Property | Value |
|---|---|
| Shuttle | wafer.space GF180MCU Run 2 (shuttle ID G802) |
| Project code | `0000` |
| Process | [GF180MCU](https://github.com/google/gf180mcu-pdk), `gf180mcuD` PDK variant |
| Slot | `1x0p5` |
| Die size | 3932 µm × 2531 µm |
| Top cell | `chip_top` |
| Pads | 72: 54 analog, 2 bare, 8 supply (`dvdd`), 8 ground (`dvss`) |
| Chip layout | [`1_Design/Tapeouts/WaferSpaceShuttleRun2/TrueFinalGds/`](1_Design/Tapeouts/WaferSpaceShuttleRun2/TrueFinalGds) |

![Die layout with the eight test structures numbered and the two bare pads marked B](docs/img/die_annotated.png)

*Rendered with KLayout from `chip_top_prefill.gds`. This is the layout before
metal fill, which would otherwise hide the structures. The numbers match the
table below. `B` marks the two bare pads.*

## Test structures

The chip carries eight test structures. Size and origin are the bounding box and
lower-left corner of each cell as placed in `chip_top`.

| # | Structure | Layout cell | Size (µm) | Origin (µm) | Source |
|---|---|---|---|---|---|
| 1 | Injection charge pump | `InjectionSchottkyPump` | 95.8 × 118.5 | 780, 938 | [`1_Design/GF180_cells/InjectionSchottyPump/`](1_Design/GF180_cells/InjectionSchottyPump) |
| 2 | High-voltage (HV) charge pump | `HVSchottkyPump` | 150.0 × 118.5 | 780, 1343 | [`2_Tools/lib/gds/FinalPumps/`](2_Tools/lib/gds/FinalPumps) |
| 3 | Tunneling charge pump | `TunnelingSchottkyPump` | 95.8 × 118.5 | 780, 1509 | [`2_Tools/lib/gds/FinalPumps/`](2_Tools/lib/gds/FinalPumps) |
| 4 | Floating-gate (FG) array | `gf180_4x2_Indirect` | 37.0 × 11.1 | 1621, 1966 | [`1_Design/GF180_cells/4x2_Indirect/`](1_Design/GF180_cells/4x2_Indirect) |
| 5 | Transconductance amplifiers (OTA) | `gf180_2TA_1FG_Strong` | 39.1 × 12.0 | 2984, 1931 | [`1_Design/GF180_cells/2TA/`](1_Design/GF180_cells/2TA) |
| 6 | Floating-gate characterization (FG char) | `gf180_FG_Characterization` | 11.3 × 33.9 | 3316, 635 | [`1_Design/GF180_cells/FGCharacterization/`](1_Design/GF180_cells/FGCharacterization) |
| 7 | PFET and NFET characterization | `3PFET`, `3NFET` | 17.7 × 10.6, 17.4 × 11.4 | 1043, 659 and 1074, 659 | [`1_Design/GF180_cells/Ike/`](1_Design/GF180_cells/Ike) |
| 8 | Winner-take-all (WTA) | `WTA` | 9.6 × 28.2 | 2229, 721 | [`2_Tools/lib/gds/WTA.gds`](2_Tools/lib/gds/WTA.gds) |

| # | Contents |
|---|---|
| 1 | Two-stage Dickson charge pump with Schottky diodes and three 40 µm × 40 µm MIM capacitors. |
| 2 | Schottky diode charge pump with five MIM capacitors. Its output goes to a bare pad. |
| 3 | Schottky diode charge pump with four MIM capacitors. |
| 4 | 4×2 array of indirectly programmed floating gates. |
| 5 | Two transconductance amplifiers with floating-gate programming. |
| 6 | Single floating-gate test cell. |
| 7 | Three PFETs and three NFETs in small, medium and large sizes. All six share one gate pad and one source pad, and each has its own drain pad. |
| 8 | Four-input winner-take-all cell. |

Injection and tunneling are the two mechanisms used to program a floating gate,
and `VINJ` and `VTUN` are the matching supply pins on the floating-gate cells.
On this chip the pump outputs and the `VINJ` and `VTUN` pins go to separate
pads.

Each pump has its own copy of `NonOvCLKGen`, a NOR-based two-phase
non-overlapping clock generator (47.1 µm × 8.7 µm) built from
`gf180mcu_fd_sc_mcu7t5v0` standard cells. The source is in
[`1_Design/GF180_cells/NonOvCLKGen/`](1_Design/GF180_cells/NonOvCLKGen).

<table>
  <tr>
    <td width="33%"><img src="docs/img/injection_pump.png" alt="Injection charge pump layout: three MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>1. Injection charge pump, clock generator at left</em></td>
    <td width="33%"><img src="docs/img/hv_pump.png" alt="HV charge pump layout: five MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>2. HV charge pump, clock generator at left</em></td>
    <td width="33%"><img src="docs/img/tunneling_pump.png" alt="Tunneling charge pump layout: four MIM capacitors around the Schottky diodes, clock generator at left"/><br/><em>3. Tunneling charge pump, clock generator at left</em></td>
  </tr>
  <tr>
    <td><img src="docs/img/fg_4x2_indirect.png" alt="4x2 floating-gate array layout"/><br/><em>4. FG array</em></td>
    <td><img src="docs/img/ta_2x_fg.png" alt="Layout of the two transconductance amplifiers"/><br/><em>5. OTA</em></td>
    <td><img src="docs/img/fets.png" alt="PFET and NFET characterization layout"/><br/><em>7. PFETs (left) and NFETs (right)</em></td>
  </tr>
  <tr>
    <td align="center"><img src="docs/img/fg_characterization.png" alt="Floating-gate characterization cell layout" width="60%"/><br/><em>6. FG char</em></td>
    <td align="center"><img src="docs/img/wta.png" alt="Winner-take-all cell layout" width="60%"/><br/><em>8. WTA</em></td>
    <td></td>
  </tr>
</table>

### Schematics

Three of the cells on the chip have a drawn xschem schematic in this
repository. `NonOvCLKGen.sch` holds its circuit as a SPICE netlist, and the
other cells have layout only.

![Injection charge pump schematic: three Schottky diodes in series from Vin_w to Vout_e, with pump capacitors on PHI1_w and PHI2_w and an output capacitor to GND_w](docs/img/sch_injection_pump.svg)

*1. Injection charge pump, from
[`InjectionSchottkyPump.sch`](1_Design/GF180_cells/InjectionSchottyPump/InjectionSchottkyPump.sch).*

![Schematic of the two transconductance amplifiers and their floating-gate programming circuits](docs/img/sch_ota.svg)

*5. OTA, from
[`gf180_2TA_1FG_Strong.sch`](1_Design/GF180_cells/2TA/gf180_2TA_1FG_Strong.sch).*

![Floating-gate characterization cell schematic](docs/img/sch_fg_characterization.svg)

*6. FG char, from
[`gf180_FG_Characterization.sch`](1_Design/GF180_cells/FGCharacterization/gf180_FG_Characterization.sch).*

### Cell ports

Port names are copied from the text labels in each layout cell, including
their mixed case and bus brackets.

| Layout cell | Ports | Supply |
|---|---|---|
| `InjectionSchottkyPump` | `Vin_w`, `PHI1_w`, `PHI2_w`, `Stage1_out`, `Stage2_out`, `Vout_e` | `GND_w` |
| `HVSchottkyPump`, `TunnelingSchottkyPump` | `Vin_w`, `PHI1_w`, `PHI2_w`, `Vout_e` | `GND_w` |
| `NonOvCLKGen` | `CLK_IN`, `PHI1_out`, `PHI2_out` | `VDD`, `GND` |
| `gf180_4x2_Indirect` | `Vd_P[0:3]`, `Vd_R[0:3]`, `Vg[0:1]`, `Vs[0:1]`, `Vsel[0:1]`, `VINJ[0:1]`, `VTUN` | |
| `gf180_2TA_1FG_Strong` | `VIN1_PLUS`, `VIN1_MINUS`, `VIN2_PLUS`, `VIN2_MINUS`, `Vout1`, `Vout2`, `VD_P[0:1]`, `VD_R[0:1]`, `Vg[0:1]`, `Vsel[0:1]`, `RUN`, `PROG`, `VINJ`, `VTUN` | `VDD`, `GND` |
| `gf180_FG_Characterization` | `Vgate`, `Vpoly`, `Vlarge`, `Vref`, `V2`, `Vs`, `Vd`, `Vout`, `VINJ`, `VTUN` | `VDD`, `GND` |
| `3PFET` | `Vg`, `Vs`, `Vd_Small`, `Vd_Med`, `Vd_Large` | `VDD` |
| `3NFET` | `Vg`, `Vs`, `Vd_Small`, `Vd_Med`, `Vd_Large` | `GND` |
| `WTA` | `Vin<0:3>`, `Bias<0:3>`, `Vbias`, `Vmid` | `GND` |

## Pad map

![Pad map: 72 pads numbered counterclockwise from the lower left, each labelled with the test structure port it connects to](docs/img/pad_map.png)

The pad ring fills a wafer.space `1x0p5` slot. Each side has two `dvdd` and two
`dvss` pads. The other 56 positions hold 54 analog pads
(`gf180mcu_fd_io__asig_5p0`) and 2 bare pads (`gf180mcu_fd_io__bare`,
75.3 µm × 350.0 µm). The pad labels in the GDS keep the names from the
wafer.space project template, such as `clk_PAD` and `bidir_PAD[0]`.

This map was extracted from `chip_top_prefill.gds` by tracing connectivity
through the metal and via layers. It has not been checked against a schematic or
against silicon, so confirm a connection in the layout before you rely on it.

Points to know before probing or bonding:

| Topic | Detail |
|---|---|
| Ground | The cell `GND` ports connect to a ring that runs along the inside edge of the pad ring. |
| Core supply | Pad 63 (`analog_PAD[0]`) carries `VDD` for the clock generators, the clock buffers, the OTA, the FG char cell and the PFET cell. |
| Bare pads | Pad 46 carries `VTUN` for the FG array and the OTA. Pad 67 carries the HV pump output. |
| Shared pads | The WTA inputs share pads 11, 12, 17 and 18 with the OTA inputs. The OTA shares pads 27 and 30 with the FG char cell, and pads 46 and 51 to 54 with the FG array. |
| Pump clocks | Each pump clock pad drives an `inv_1` and an `inv_4` standard cell in series, then the `CLK_IN` of that pump's clock generator. |
| OTA `RUN` | Driven from pad 38 (`PROG`) through an `inv_4` cell. |
| Not traced | No labelled port was found on pads 23 and 24. The OTA `VINJ` port, the FG char `VINJ` and `VTUN` ports (labelled on the n-well layer) and the injection pump `Stage1_out` and `Stage2_out` nodes were not traced to a pad. |

Pad numbers start at the lower-left corner and run counterclockwise.

<details>
<summary>Bottom side, left to right (pads 1 to 24)</summary>

| Pad | Label in GDS | Pad cell | Connects to |
|---|---|---|---|
| 1 | `clk_PAD` | Analog | PFET `Vd_Small` |
| 2 | `rst_n_PAD` | Analog | PFET `Vd_Med` |
| 3 | `bidir_PAD[0]` | Analog | PFET `Vd_Large` |
| 4 | `bidir_PAD[1]` | Analog | NFET `Vs`, PFET `Vs` |
| 5 | `VSS` | Ground | Pad ring ground |
| 6 | `VDD` | Supply | Pad ring supply |
| 7 | `bidir_PAD[2]` | Analog | NFET `Vg`, PFET `Vg` |
| 8 | `bidir_PAD[3]` | Analog | NFET `Vd_Large` |
| 9 | `bidir_PAD[4]` | Analog | NFET `Vd_Med` |
| 10 | `bidir_PAD[5]` | Analog | NFET `Vd_Small` |
| 11 | `bidir_PAD[6]` | Analog | WTA `Vin<0>`, OTA `VIN1_MINUS` |
| 12 | `bidir_PAD[7]` | Analog | WTA `Vin<1>`, OTA `VIN1_PLUS` |
| 13 | `bidir_PAD[8]` | Analog | WTA `Bias<1>` |
| 14 | `bidir_PAD[9]` | Analog | WTA `Bias<0>` |
| 15 | `bidir_PAD[10]` | Analog | WTA `Bias<3>` |
| 16 | `bidir_PAD[11]` | Analog | WTA `Bias<2>` |
| 17 | `bidir_PAD[12]` | Analog | WTA `Vin<2>`, OTA `VIN2_PLUS` |
| 18 | `bidir_PAD[13]` | Analog | WTA `Vin<3>`, OTA `VIN2_MINUS` |
| 19 | `VSS` | Ground | Pad ring ground |
| 20 | `VDD` | Supply | Pad ring supply |
| 21 | `bidir_PAD[14]` | Analog | WTA `Vbias` |
| 22 | `bidir_PAD[15]` | Analog | FG char `Vout` |
| 23 | `bidir_PAD[16]` | Analog | No labelled port found |
| 24 | `bidir_PAD[17]` | Analog | No labelled port found |

</details>

<details>
<summary>Right side, bottom to top (pads 25 to 36)</summary>

| Pad | Label in GDS | Pad cell | Connects to |
|---|---|---|---|
| 25 | `VSS` | Ground | Pad ring ground |
| 26 | `VDD` | Supply | Pad ring supply |
| 27 | `bidir_PAD[18]` | Analog | OTA `Vg[0]`, FG char `Vpoly` |
| 28 | `bidir_PAD[19]` | Analog | FG char `Vd` |
| 29 | `bidir_PAD[20]` | Analog | FG char `Vs` |
| 30 | `bidir_PAD[21]` | Analog | OTA `Vg[1]`, FG char `Vgate` |
| 31 | `bidir_PAD[22]` | Analog | FG char `Vref` |
| 32 | `bidir_PAD[23]` | Analog | FG char `Vlarge` |
| 33 | `bidir_PAD[24]` | Analog | FG char `V2` |
| 34 | `bidir_PAD[25]` | Analog | OTA `Vout1` |
| 35 | `VSS` | Ground | Pad ring ground |
| 36 | `VDD` | Supply | Pad ring supply |

</details>

<details>
<summary>Top side, right to left (pads 37 to 60)</summary>

| Pad | Label in GDS | Pad cell | Connects to |
|---|---|---|---|
| 37 | `bidir_PAD[26]` | Analog | OTA `Vout2` |
| 38 | `bidir_PAD[27]` | Analog | OTA `PROG` |
| 39 | `bidir_PAD[28]` | Analog | OTA `Vsel[1]` |
| 40 | `bidir_PAD[29]` | Analog | OTA `Vsel[0]` |
| 41 | `VDD` | Supply | Pad ring supply |
| 42 | `VSS` | Ground | Pad ring ground |
| 43 | `bidir_PAD[30]` | Analog | FG array `Vs[1]` |
| 44 | `bidir_PAD[31]` | Analog | FG array `Vsel[1]` |
| 45 | `bidir_PAD[32]` | Analog | FG array `Vg[1]` |
| 46 | `bidir_PAD[33]` | Bare | FG array `VTUN`, OTA `VTUN` |
| 47 | `bidir_PAD[34]` | Analog | FG array `Vg[0]` |
| 48 | `bidir_PAD[35]` | Analog | FG array `Vsel[0]` |
| 49 | `bidir_PAD[36]` | Analog | FG array `VINJ[0]`, `VINJ[1]` |
| 50 | `bidir_PAD[37]` | Analog | FG array `Vs[0]` |
| 51 | `bidir_PAD[38]` | Analog | FG array `Vd_P[0]`, OTA `VD_P[0]` |
| 52 | `bidir_PAD[39]` | Analog | FG array `Vd_R[0]`, OTA `VD_R[0]` |
| 53 | `bidir_PAD[40]` | Analog | FG array `Vd_R[1]`, OTA `VD_R[1]` |
| 54 | `bidir_PAD[41]` | Analog | FG array `Vd_P[1]`, OTA `VD_P[1]` |
| 55 | `VDD` | Supply | Pad ring supply |
| 56 | `VSS` | Ground | Pad ring ground |
| 57 | `bidir_PAD[42]` | Analog | FG array `Vd_P[2]` |
| 58 | `bidir_PAD[43]` | Analog | FG array `Vd_R[2]` |
| 59 | `bidir_PAD[44]` | Analog | FG array `Vd_R[3]` |
| 60 | `bidir_PAD[45]` | Analog | FG array `Vd_P[3]` |

</details>

<details>
<summary>Left side, top to bottom (pads 61 to 72)</summary>

| Pad | Label in GDS | Pad cell | Connects to |
|---|---|---|---|
| 61 | `VDD` | Supply | Pad ring supply |
| 62 | `VSS` | Ground | Pad ring ground |
| 63 | `analog_PAD[0]` | Analog | Core VDD |
| 64 | `analog_PAD[1]` | Analog | Tunneling pump Vout_e |
| 65 | `analog_PAD[2]` | Analog | Tunneling pump clock |
| 66 | `analog_PAD[3]` | Analog | HV pump clock |
| 67 | `input_PAD[0]` | Bare | HV pump Vout_e |
| 68 | `input_PAD[1]` | Analog | Vin_w of all three pumps |
| 69 | `input_PAD[2]` | Analog | Injection pump clock |
| 70 | `input_PAD[3]` | Analog | Injection pump Vout_e |
| 71 | `VDD` | Supply | Pad ring supply |
| 72 | `VSS` | Ground | Pad ring ground |

</details>

## Viewing the layout

1. Install [KLayout](https://www.klayout.de/).
2. Clone this repository. The chip-level GDS files total about 490 MB.
3. Download the layer properties file
   [`gf180mcu.lyp`](https://github.com/wafer-space/ws-run2/blob/main/lyp/gf180mcu.lyp)
   from the ws-run2 repository.
4. Open the pre-fill layout with the layer properties applied:

   ```sh
   klayout -l gf180mcu.lyp 1_Design/Tapeouts/WaferSpaceShuttleRun2/TrueFinalGds/chip_top_prefill.gds
   ```

The test structures are small compared with the die. Use the origin column in
the [test structures](#test-structures) table to find them.

## Repository layout

| Path | Contents |
|---|---|
| [`1_Design/GF180_cells/`](1_Design/GF180_cells) | Cell design files. Most cells have a GDS and a KLayout DRC report (`.lyrdb`). Some also have an xschem schematic (`.sch`), a Magic layout (`.mag`) or LVS runs. |
| [`1_Design/Tapeouts/WaferSpaceShuttleRun2/`](1_Design/Tapeouts/WaferSpaceShuttleRun2) | Chip-level GDS for the shuttle. See the table below. |
| [`2_Tools/lib/`](2_Tools/lib) | Cell library for the [ASHES](https://github.com/GTIceLab/ashes) flow: Python cell definitions, cell GDS, the GF180MCU layer map and the technology LEF. |
| [`2_Tools/run_syn/`](2_Tools/run_syn) | A small ASHES placement and Qrouter routing experiment with two Schottky diodes and a tunneling charge pump. |
| [`3_Examples/`](3_Examples) | Onboarding examples for new team members. |
| [`docs/img/`](docs/img) | Images used in this README. |

### Chip-level GDS files

| File under `1_Design/Tapeouts/WaferSpaceShuttleRun2/` | Contents |
|---|---|
| `TrueFinalGds/chip_top_prefill.gds` | Chip layout before metal fill. |
| `TrueFinalGds/chip_top.gds` | Chip layout with metal fill. |
| `TrueFinalGds/chip_top_filled.gds` | Chip layout with metal fill, from a different fill run. |
| `FinalGds/chip_top.gds` | Earlier chip layout, before metal fill. |
| `FinalGds/circuit_noframe.gds` | Test structures and routing without the pad ring. |
| `PrecheckTesting/chip_top_test.gds` | Pad ring with no test structures. |

The two filled files hold the same cells but different fill shapes. The
repository does not record which one was submitted. Backup copies
(`chip_top_prefillbackup.gds`, `ICELAB_final_backup.gds`) are not listed.

### Not on this chip

These files under `1_Design/GF180_cells/` are not part of `chip_top`:

- `HVPump/`, `InjectionChargePump/` and `TunnelingChargePump/`: earlier charge
  pump designs.
- `hh_model_v5.mag`: a layout that uses the FG array and MIM capacitors.
- `Chip_Top/chip_top.gds`: an empty pad ring for the `0p5x1` slot.

### Examples

| Example | Contents |
|---|---|
| [`3_Examples/FET_Characterization/`](3_Examples/FET_Characterization) | xschem and ngspice testbenches that sweep the gate voltage of an NFET and a PFET. |
| [`3_Examples/Inverter_Design/`](3_Examples/Inverter_Design) | Schematic and symbol for an inverter. |
| [`3_Examples/Understanding_4x2_Indirect/`](3_Examples/Understanding_4x2_Indirect) | Magic layout of the FG array to study. |

The first two examples use the 3.3 V devices (`nfet_03v3`, `pfet_03v3`). The
schematics for the cells on the chip use the 5 V and 6 V devices (`nfet_05v0`,
`nfet_06v0`, `pfet_06v0`).

## Design flow

| Step | Tool | Files in this repository |
|---|---|---|
| Schematic capture | [xschem](https://xschem.sourceforge.io/) | `.sch`, `.sym` |
| Simulation | [ngspice](https://ngspice.sourceforge.io/) with the `gf180mcuD` models | `*_TB.sch`, `*_testbench.sch` |
| Layout | [Magic](http://opencircuitdesign.com/magic/), `gf180mcuD` tech | `.mag` |
| DRC and LVS | KLayout with the GF180MCU rule decks | `.lyrdb`, `lvs_run_*/` |
| Place and route experiments | [ASHES](https://github.com/GTIceLab/ashes) and [Qrouter](http://opencircuitdesign.com/qrouter/) | `2_Tools/` |
| Chip assembly, metal fill and precheck | Not recorded in this repository | GDS under `1_Design/Tapeouts/` |

These files contain absolute paths from the original author's machine
(`/home/luha/...`). Change them to your own PDK and checkout paths before you
run them:

- `1_Design/GF180_cells/InjectionSchottyPump/InjectionSchottkyPump.spice`
- `1_Design/GF180_cells/NonOvCLKGen/NonOvCLKGen.spice`
- `1_Design/GF180_cells/NonOvCLKGen/design/NonOvCLKGen.sch`
- `1_Design/GF180_cells/NonOvCLKGen/design/NonOvCLKGen_xschem.spice`
- `1_Design/GF180_cells/NonOvCLKGen/design/NonOvCLKGen_TB.sch`
- `1_Design/GF180_cells/TunnelingChargePump/TunnelingChargePump_TB.sch`
- `2_Tools/run_syn/pd/qrouter_params.tcl`

## Related projects

- [GTIceLab/ashes](https://github.com/GTIceLab/ashes): Analog Synthesis for High
  Level Systems, a tool for programming FPAAs and generating layout from a
  programmable analog standard cell library.
- [GTIceLab/ASHES-IHP130nm](https://github.com/GTIceLab/ASHES-IHP130nm): standard
  cells for the IHP 130 nm process.
- [wafer-space/ws-run2](https://github.com/wafer-space/ws-run2): the full Run 2
  reticle and the list of public projects on it.

## License

This repository is licensed under the Apache License, Version 2.0. See
[`LICENSE`](LICENSE).

# Transconductance amplifiers

`gf180_2TA_1FG_Strong` holds two operational transconductance amplifiers (OTAs)
with floating-gate programming. An OTA turns a differential input voltage into
an output current. Floating gates let the bias and offset of each amplifier be
programmed after fabrication and kept without power.

For an overview of the chip see the [top-level&nbsp;README](../../../README.md).

## Transconductance amplifiers

| Item | Value |
|---|---|
| Layout cell | `gf180_2TA_1FG_Strong` |
| Size (µm) | 39.1&nbsp;×&nbsp;12.0 |
| Origin in `chip_top` (µm) | 2984,&nbsp;1931 |
| Devices in the schematic | 34 `pfet_06v0`, 16 `nfet_05v0` |

![Layout of the two transconductance amplifiers](../../../docs/img/ta_2x_fg.png)

![Schematic of the two transconductance amplifiers and their floating-gate programming circuits](../../../docs/img/sch_ota.svg)

### Files

| File | Contents |
|---|---|
| [`gf180_2TA_1FG_Strong.sch`](gf180_2TA_1FG_Strong.sch) | xschem schematic. |
| [`gf180_2TA_1FG_Strong.gds`](gf180_2TA_1FG_Strong.gds) | Layout. Matches the cell placed in `chip_top`. |
| [`gf180_2TA_1FG_Strong.lyrdb`](gf180_2TA_1FG_Strong.lyrdb) | KLayout DRC report. |
| [`gf180_2TA_1FG_Strong.mag`](gf180_2TA_1FG_Strong.mag) | Magic layout. |
| [`gf180_2TA_1FG_Strong_magic.gds`](gf180_2TA_1FG_Strong_magic.gds) | GDS written by Magic. Differs from the cell placed in `chip_top`. |

### Ports

| Group | Ports |
|---|---|
| Amplifier 1 | `VIN1_PLUS`, `VIN1_MINUS`, `Vout1` |
| Amplifier 2 | `VIN2_PLUS`, `VIN2_MINUS`, `Vout2` |
| Floating-gate programming | `VD_P[0:1]`, `VD_R[0:1]`, `Vg[0:1]`, `Vsel[0:1]`, `VINJ`, `VTUN` |
| Mode | `PROG`, `RUN` |
| Supply | `VDD`, `GND` |

The programming ports have the same names and roles as in the
[floating-gate array](../4x2_Indirect/README.md#circuit). `PROG` and `RUN`
switch the cell between programming and normal operation. In `chip_top`, `RUN`
is driven from the `PROG` pad through an inverter, so only `PROG` is bonded
out.

### Bonding

| Port | Pad | Label in GDS | Shared with |
|---|---|---|---|
| `VIN1_MINUS` | 11 | `bidir_PAD[6]` | WTA `Vin<0>` |
| `VIN1_PLUS` | 12 | `bidir_PAD[7]` | WTA `Vin<1>` |
| `VIN2_PLUS` | 17 | `bidir_PAD[12]` | WTA `Vin<2>` |
| `VIN2_MINUS` | 18 | `bidir_PAD[13]` | WTA `Vin<3>` |
| `Vg[0]` | 27 | `bidir_PAD[18]` | FG char `Vpoly` |
| `Vg[1]` | 30 | `bidir_PAD[21]` | FG char `Vgate` |
| `Vout1` | 34 | `bidir_PAD[25]` | |
| `Vout2` | 37 | `bidir_PAD[26]` | |
| `PROG` | 38 | `bidir_PAD[27]` | |
| `Vsel[1]` | 39 | `bidir_PAD[28]` | |
| `Vsel[0]` | 40 | `bidir_PAD[29]` | |
| `VTUN` | 46 (bare) | `bidir_PAD[33]` | FG array `VTUN`, FG char `VTUN` |
| `VD_P[0]` | 51 | `bidir_PAD[38]` | FG array `Vd_P[0]` |
| `VD_R[0]` | 52 | `bidir_PAD[39]` | FG array `Vd_R[0]` |
| `VD_R[1]` | 53 | `bidir_PAD[40]` | FG array `Vd_R[1]` |
| `VD_P[1]` | 54 | `bidir_PAD[41]` | FG array `Vd_P[1]` |
| `VDD` | 63 | `analog_PAD[0]` | Core supply |
| `GND` | 5, 19, 25, 35, 42, 56, 62, 72 | `VSS` | Every cell |
| `RUN` | none | | Inverse of `PROG` |
| `VINJ` | none | | See below |

### Known layout issue

`VINJ` does not reach a pad. In the netlist extracted from `chip_top`, the
`VINJ` net stays inside the cell. It is the n-well of most of the pFETs and
the source of the select pFETs, so those wells are not tied to a supply pad.
Pad 24 (`bidir_PAD[17]`), next to the FG char `VINJ` pad, has no connection to
any structure.

The effect on normal operation and on injection programming has not been
analyzed.

This comes from layout extraction with the GF180MCU KLayout LVS deck and has not
been confirmed by the designers or on silicon.

### How to test

The measurements this structure is built for:

| Measurement | Method |
|---|---|
| Transfer curve | With `PROG` low, so that `RUN` is high, sweep the differential input of one amplifier around a common-mode voltage and measure the output current into a fixed voltage, or the output voltage into a known load. |
| Programmed bias | Program the floating gates as for the [floating-gate array](../4x2_Indirect/README.md#how-to-test), then repeat the transfer curve. The transconductance and offset should move with the stored charge. |
| Retention | Repeat the transfer curve after a power cycle. |

Things to check first:

- The amplifier inputs share pads with the WTA inputs.
- `VTUN`, `VD_P` and `VD_R` are shared with the FG array.
- Because of the `VINJ` issue above, measured behavior may differ from the
  schematic.

### Expected results

There is no testbench for this cell and the repository records no target
transconductance, bias current or offset. The floating-gate nodes in
[`gf180_2TA_1FG_Strong.sch`](gf180_2TA_1FG_Strong.sch) have no DC path, so a
simulation needs an assumed voltage on each floating gate.

## References

See [`docs/references.md`](../../../docs/references.md#floating-gate-transconductance-amplifiers).
Start with Chawla, Adil, Serrano and Hasler, "Programmable Gm-C Filters Using
Floating-Gate Operational Transconductance Amplifiers" (2007).

# Floating-gate characterization cell

`gf180_FG_Characterization` is a single floating-gate pFET with every terminal
brought out, plus a small amplifier that reads the floating-gate voltage. It is
there to measure how injection, tunneling and capacitive coupling behave in
GF180MCU, which the floating-gate cells on this chip and in the
[ASHES](https://github.com/GTIceLab/ashes) library depend on.

For an overview of the chip see the [top-level&nbsp;README](../../../README.md).

## Floating-gate characterization cell

| Item | Value |
|---|---|
| Layout cell | `gf180_FG_Characterization` |
| Size (µm) | 11.3&nbsp;×&nbsp;33.9 as placed |
| Origin in `chip_top` (µm) | 3316,&nbsp;635 |
| Devices | 8 `pfet_06v0`, 5 `nfet_06v0` |

![Floating-gate characterization cell layout](../../../docs/img/fg_characterization.png)

![Floating-gate characterization cell schematic](../../../docs/img/sch_fg_characterization.svg)

### Files

| File | Contents |
|---|---|
| [`gf180_FG_Characterization.sch`](gf180_FG_Characterization.sch) | xschem schematic. |
| [`gf180_FG_Characterization_magic.gds`](gf180_FG_Characterization_magic.gds) | Layout. Matches the cell placed in `chip_top`. |
| [`gf180_FG_Characterization_magic.lyrdb`](gf180_FG_Characterization_magic.lyrdb) | KLayout DRC report. |

### Circuit

Sizes come from layout extraction of the chip. The schematic names are in
brackets.

| Device | W / L (µm) | Connection |
|---|---|---|
| Floating-gate pFET (`XM1`) | 2 / 1 | Gate on the floating gate, source `Vs`, drain `Vd`, n-well `VINJ`. |
| Tunneling capacitor (`XM2`) | 0.45 / 0.55 | pFET capacitor between `VTUN` and the floating gate. |
| Gate capacitor (`XM3`) | 7.35 / 1.65 | pFET capacitor between `Vgate` and the floating gate. |
| Large capacitor (`XM4`) | 21.7 / 2.45 | pFET capacitor between `Vlarge` and the floating gate. |
| Readout amplifier | 2 / 1 each | nFET differential pair with the floating gate on one input and `V2` on the other, tail current set by `Vref`, pFET mirror loads, output `Vout`. |

By gate area, the large capacitor is 4.4 times the gate capacitor and about 215
times the tunneling capacitor.

`Vpoly` is a port in the layout but connects to no device in the extracted
netlist. In the schematic it is marked as not connected.

### Bonding

| Port | Pad | Label in GDS | Shared with |
|---|---|---|---|
| `Vout` | 22 | `bidir_PAD[15]` | |
| `VINJ` | 23 | `bidir_PAD[16]` | |
| `Vpoly` | 27 | `bidir_PAD[18]` | OTA `Vg[0]` |
| `Vd` | 28 | `bidir_PAD[19]` | |
| `Vs` | 29 | `bidir_PAD[20]` | |
| `Vgate` | 30 | `bidir_PAD[21]` | OTA `Vg[1]` |
| `Vref` | 31 | `bidir_PAD[22]` | |
| `Vlarge` | 32 | `bidir_PAD[23]` | |
| `V2` | 33 | `bidir_PAD[24]` | |
| `VTUN` | 46 (bare) | `bidir_PAD[33]` | FG array `VTUN`, OTA `VTUN` |
| `VDD` | 63 | `analog_PAD[0]` | Core supply |
| `GND` | 5, 19, 25, 35, 42, 56, 62, 72 | `VSS` | Every cell |

The `VINJ` and `VTUN` labels in this cell are on the n-well layer. `VINJ` is
the n-well of the floating-gate pFET and of the amplifier's pFETs.

### How to test

| Measurement | Method |
|---|---|
| Gate sweep | Bias `Vs` and `Vd`, sweep `Vgate` and record the pFET current. Repeat with `Vlarge` to compare the two coupling capacitors. |
| Floating-gate voltage | Bias the amplifier with `Vref`, sweep `V2` and find where `Vout` switches. That value of `V2` tracks the floating-gate voltage. |
| Coupling ratio | Step `Vgate` or `Vlarge` and record the change in floating-gate voltage from the amplifier. |
| Tunneling | Pulse `VTUN` high and record the shift in the gate sweep against pulse voltage and length. |
| Injection | Raise `Vs` and `VINJ` above `Vd` so the pFET has a large source-to-drain voltage, and record the shift in the gate sweep against that voltage, the channel current and time. |

Things to check first:

- `VTUN` is shared with the FG array and the OTA, so tunneling here changes
  their floating gates too.
- `Vgate` and `Vpoly` share pads with the OTA gate lines.
- `VINJ` is on a standard analog pad, which may clamp near the pad ring supply.
  See [`docs/pad-map.md`](../../../docs/pad-map.md#things-to-know-before-probing-or-bonding).

### Expected results

There is no testbench for this cell, and the repository records no expected
injection or tunneling rates. These measurements are what the cell is meant to
supply.

## References

See [`docs/references.md`](../../../docs/references.md#floating-gate-characterization).
Start with Hasler, Basu and Koziol (2007) for pFET injection and Lenzlinger and
Snow (1969) for tunneling.

# FET characterization cells

Two cells with plain transistors: three NFETs in `3NFET` and three PFETs in
`3PFET`. They give measured current-voltage curves for the process, to compare
with the PDK models and to extract device parameters for the lab's circuit
design.

For an overview of the chip see the [top-level&nbsp;README](../../../README.md).

| Structure | Layout cell | Size (µm) | Origin in `chip_top` (µm) |
|---|---|---|---|
| [NFET cell](#nfet-cell) | `3NFET` | 17.4&nbsp;×&nbsp;11.4 | 1074,&nbsp;659 |
| [PFET cell](#pfet-cell) | `3PFET` | 17.7&nbsp;×&nbsp;10.6 | 1043,&nbsp;659 |

![PFET (left) and NFET (right) characterization layout](../../../docs/img/fets.png)

All six transistors are 3.3 V devices with a 0.28 µm gate length. Keep every
terminal within 3.3 V of the others. The two cells share their gate pad and
their source pad.

## NFET cell

| File | Contents |
|---|---|
| [`3NFETs.gds`](3NFETs.gds) | Layout. Matches the cell placed in `chip_top`. |
| [`3NFETs.lyrdb`](3NFETs.lyrdb) | KLayout DRC report. |
| [`drc.mag`](drc.mag) | Magic layout with a `GND` label. |
| [`docs/netlists/3NFET.cir`](../../../docs/netlists/3NFET.cir) | Extracted netlist. |

| Device | Model | W (µm) | L (µm) | Fingers | Drain pad |
|---|---|---|---|---|---|
| Small | `nfet_03v3` | 0.5 | 0.28 | 1 | 10 (`bidir_PAD[5]`) |
| Med | `nfet_03v3` | 5 | 0.28 | 1 | 9 (`bidir_PAD[4]`) |
| Large | `nfet_03v3` | 50 | 0.28 | 10 | 8 (`bidir_PAD[3]`) |

The bulk is the substrate, on the `GND` net.

## PFET cell

| File | Contents |
|---|---|
| [`3PFETs.gds`](3PFETs.gds) | Layout. Matches the cell placed in `chip_top`. |
| [`3PFETs.lyrdb`](3PFETs.lyrdb) | KLayout DRC report. |
| [`pdrc.mag`](pdrc.mag) | Magic layout with a `VDD` label. |
| [`docs/netlists/3PFET.cir`](../../../docs/netlists/3PFET.cir) | Extracted netlist. |

| Device | Model | W (µm) | L (µm) | Fingers | Drain pad |
|---|---|---|---|---|---|
| Small | `pfet_03v3` | 0.5 | 0.28 | 1 | 1 (`clk_PAD`) |
| Med | `pfet_03v3` | 5 | 0.28 | 1 | 2 (`rst_n_PAD`) |
| Large | `pfet_03v3` | 50 | 0.28 | 10 | 3 (`bidir_PAD[0]`) |

The n-well is on the cell's `VDD` port, which is the core supply on pad 63.

## Bonding

| Signal | Pad | Label in GDS |
|---|---|---|
| Source of all six FETs (`Vs`) | 4 | `bidir_PAD[1]` |
| Gate of all six FETs (`Vg`) | 7 | `bidir_PAD[2]` |
| PFET n-well (`VDD`) | 63 | `analog_PAD[0]` |
| NFET bulk (`GND`) | 5, 19, 25, 35, 42, 56, 62, 72 | `VSS` |

Pads 1 to 4 and 7 to 10 are on the bottom side of the die, at the left.

## How to test

Use a source-measure unit on the drain pad of the device under test.

| Measurement | NFET | PFET |
|---|---|---|
| Source pad 4 | 0 V | 3.3 V |
| Core supply pad 63 | 0 V to 3.3 V | 3.3 V, so the n-well is at the source voltage |
| Gate sweep on pad 7 | 0 V to 3.3 V | 3.3 V to 0 V |
| Drain pad | 0.1 V for the linear region, 3.3 V for saturation | 3.2 V for the linear region, 0 V for saturation |
| Drain sweep | Step the gate, sweep the drain from 0 V to 3.3 V | Step the gate, sweep the drain from 3.3 V to 0 V |

Because the gate and source pads are shared, the other cell sees the same
voltages. With the settings above the transistors of the other cell are off.
Leave their drain pads open or hold them at the source voltage.

Pad 63 also powers the clock generators, the OTA and the FG char cell, so those
draw current from the same supply during a PFET measurement.

## Expected results

Simulated with the typical corner of the open GF180MCU models. Currents are
magnitudes with 3.3 V on the gate (Vgs for the NFETs, Vsg for the PFETs).

| Device | W (µm) | Current at 0.1 V drain bias (A) | Current at 3.3 V drain bias (A) |
|---|---|---|---|
| NFET Small | 0.5 | 3.16e-5 | 2.71e-4 |
| NFET Med | 5 | 3.05e-4 | 2.55e-3 |
| NFET Large | 50 | 3.05e-3 | 2.54e-2 |
| PFET Small | 0.5 | 1.07e-5 | 1.27e-4 |
| PFET Med | 5 | 1.09e-4 | 1.25e-3 |
| PFET Large | 50 | 1.10e-3 | 1.25e-2 |

![Simulated drain current against gate voltage on a log scale for the three NFETs and three PFETs](../../../docs/img/sim_fets.png)

The Large devices carry 12 mA to 25 mA at full gate drive. Allow for the
resistance of the pad, bond wire and probe when comparing with the model.

## Simulating

[`docs/sim/tb_fets.spice`](../../../docs/sim/tb_fets.spice) produces the curves
above. The full sweeps are in
[`docs/sim/results/`](../../../docs/sim/results). See
[`docs/sim/README.md`](../../../docs/sim/README.md).

## References

See [`docs/references.md`](../../../docs/references.md#fet-characterization).

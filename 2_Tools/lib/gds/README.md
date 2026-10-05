# ASHES cell library layouts

GDS files for the [ASHES](https://github.com/GTIceLab/ashes) cell library. One
cell here, the winner-take-all cell, is on the test chip. The final charge pump
layouts are in [`FinalPumps/`](FinalPumps/README.md).

For an overview of the chip see the [top-level&nbsp;README](../../../README.md).

| Structure | Files | On the chip |
|---|---|---|
| [Winner-take-all cell](#winner-take-all-cell) | [`WTA.gds`](WTA.gds), [`WTA.lyrdb`](WTA.lyrdb) | Yes |
| [Charge pumps, final](FinalPumps/README.md) | [`FinalPumps/`](FinalPumps) | Yes |
| [Charge pumps, earlier versions](#earlier-charge-pump-layouts) | [`HVSchottkyPump.gds`](HVSchottkyPump.gds), [`InjectionSchottkyPump.gds`](InjectionSchottkyPump.gds), [`TunnelingSchottkyPump.gds`](TunnelingSchottkyPump.gds), [`TunnelingChargePump.gds`](TunnelingChargePump.gds) | No |
| [Schottky diode](#schottky-diode) | [`SchottkyDiode.gds`](SchottkyDiode.gds) | No |
| [Pad ring parts](#pad-ring-parts) | [`Frame_Top.gds`](Frame_Top.gds), [`gf180mcu_fd_io__bare.gds`](gf180mcu_fd_io__bare.gds) | Bare pad only |

## Winner-take-all cell

A four-input winner-take-all (WTA) circuit in the style of Lazzaro et al.: each
channel takes an input current, and the channel with the largest input should
take all of a shared bias current.

| Item | Value |
|---|---|
| Layout | [`WTA.gds`](WTA.gds). Matches the cell placed in `chip_top`. |
| DRC report | [`WTA.lyrdb`](WTA.lyrdb) |
| Extracted netlist | [`docs/netlists/WTA.cir`](../../../docs/netlists/WTA.cir) |
| Size (µm) | 9.6&nbsp;×&nbsp;28.2 as placed |
| Origin in `chip_top` (µm) | 2229,&nbsp;721 |
| Ports | `Vin<0:3>`, `Bias<0:3>`, `Vbias`, `Vmid`, `GND` |

There is no schematic for this cell in the repository.

![Winner-take-all cell layout](../../../docs/img/wta.png)

### Circuit

The extracted netlist has nine `nfet_06v0` devices:

| Device | Count | W / L (µm) | Drain | Gate | Source |
|---|---|---|---|---|---|
| Input transistor | 4 | 3.25 / 2 | `Vin<i>` | channel node *i* | `GND` |
| Output transistor | 4 | 5 / 1.5 | `Bias<i>` | `Vin<i>` | channel node *i* |
| Bias transistor | 1 | 1.5 / 1 | `Vmid` | `Vbias` | `GND` |

In the classic circuit the four channel nodes are one shared node, and the bias
transistor sinks the shared current from it.

### Known layout issue

In the extracted netlist the four channel nodes are four separate nets, and
none of them connects to `Vmid`. The `Vmid` wire on Metal2 reaches only the
drain of the bias transistor. `Vmid` also has no pad. As drawn, the channels
are not coupled to each other or to the bias current, so the cell is not
expected to show winner-take-all behavior.

This comes from layout extraction with the GF180MCU KLayout LVS deck and has not
been confirmed by the designers or on silicon.

### Bonding

| Port | Pad | Label in GDS | Shared with |
|---|---|---|---|
| `Vin<0>` | 11 | `bidir_PAD[6]` | OTA `VIN1_MINUS` |
| `Vin<1>` | 12 | `bidir_PAD[7]` | OTA `VIN1_PLUS` |
| `Bias<1>` | 13 | `bidir_PAD[8]` | |
| `Bias<0>` | 14 | `bidir_PAD[9]` | |
| `Bias<3>` | 15 | `bidir_PAD[10]` | |
| `Bias<2>` | 16 | `bidir_PAD[11]` | |
| `Vin<2>` | 17 | `bidir_PAD[12]` | OTA `VIN2_PLUS` |
| `Vin<3>` | 18 | `bidir_PAD[13]` | OTA `VIN2_MINUS` |
| `Vbias` | 21 | `bidir_PAD[14]` | |
| `GND` | 5, 19, 25, 35, 42, 56, 62, 72 | `VSS` | Every cell |

### How to test

The intended test of a WTA cell is:

1. Set the bias current with `Vbias`.
2. Hold each `Bias<i>` output at a fixed voltage and measure the current into
   it.
3. Source a current into each `Vin<i>`, sweep one of them, and record which
   output carries the bias current.

Because of the layout issue above:

- Expect no steady current in the `Bias<i>` outputs. Each output transistor has
  its source on a channel node with no path to ground.
- The gate of each input transistor is on the same channel node, so the input
  current depends on leakage onto that node.
- The bias transistor cannot be observed, because `Vmid` has no pad.

Record what is seen rather than comparing with a model.

There is no testbench and there are no expected values for this cell.

### References

See [`docs/references.md`](../../../docs/references.md#winner-take-all).

## Earlier charge pump layouts

| File | Contents |
|---|---|
| [`HVSchottkyPump.gds`](HVSchottkyPump.gds), [`HVSchottkyPump.lyrdb`](HVSchottkyPump.lyrdb) | HV pump. Differs from the cell placed in `chip_top`. |
| [`InjectionSchottkyPump.gds`](InjectionSchottkyPump.gds) | Injection pump. Differs from the cell placed in `chip_top`. |
| [`TunnelingSchottkyPump.gds`](TunnelingSchottkyPump.gds), [`TunnelingSchottkyPump.lyrdb`](TunnelingSchottkyPump.lyrdb) | Tunneling pump. Differs from the cell placed in `chip_top`. |
| [`TunnelingChargePump.gds`](TunnelingChargePump.gds) | Earlier tunneling pump with its own clock generator. Identical to [`1_Design/GF180_cells/TunnelingChargePump/TunnelingChargePump.gds`](../../../1_Design/GF180_cells/TunnelingChargePump/TunnelingChargePump.gds). |
| [`TunnelingChargePump_output.txt`](TunnelingChargePump_output.txt) | Cell and label listing of that file. |

Use the layouts in [`FinalPumps/`](FinalPumps/README.md) for anything that
should match the chip.

## Schottky diode

| File | Contents |
|---|---|
| [`SchottkyDiode.gds`](SchottkyDiode.gds) | Schottky diode cell with ports `Anode_n`, `Cathode_s` and `GND_e`. |
| [`SchottkyDiode_output.txt`](SchottkyDiode_output.txt) | Cell and label listing of that file. |

This cell and the earlier tunneling pump are the two cells defined in
[`2_Tools/lib/class_lib_GF180.py`](../class_lib_GF180.py) and placed by the
routing experiment in [`2_Tools/run_syn/chip.py`](../../run_syn/chip.py).

## Pad ring parts

| File | Contents |
|---|---|
| [`Frame_Top.gds`](Frame_Top.gds) | Part of a pad ring: the top edge of a `0p5x1` slot with the wafer.space logo and marker cells. |
| [`gf180mcu_fd_io__bare.gds`](gf180mcu_fd_io__bare.gds) | Bare pad cell. The chip uses it for pads 46 and 67. |

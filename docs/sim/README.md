# Simulations

ngspice testbenches that give the expected behavior of the test structures, for
comparison with measurements on silicon. They cover the three charge pumps, the
clock generator and the FET characterization cells. The floating-gate cells and
the winner-take-all cell have no testbench yet.

All results use the typical corner of the open GF180MCU models at 27 °C. They
do not include pad, bond wire or probe parasitics, apart from a 10 pF load on
each pump output.

## Files

| File | Contents |
|---|---|
| [`models.spice`](models.spice) | Model and standard cell includes. |
| [`clock.spice`](clock.spice) | Clock path of a pump: pad buffer, non-overlapping clock generator and output drivers. |
| [`pumps.spice`](pumps.spice) | The three charge pumps, from the extracted netlists in [`../netlists/`](../netlists). |
| [`tb_clkgen.spice`](tb_clkgen.spice) | Clock phase timing with the injection pump as load. |
| [`tb_pump.spice.in`](tb_pump.spice.in) | Template for one pump operating point. |
| [`tb_fets.spice`](tb_fets.spice) | Drain current against gate voltage for the six FETs. |
| [`run_sims.py`](run_sims.py) | Runs every testbench and collects the results. |
| [`results/pumps.csv`](results/pumps.csv) | Pump output voltage and ripple for every operating point. |
| [`results/clkgen.json`](results/clkgen.json) | Clock phase timing. |
| [`results/`](results) `fets_*.txt` | FET sweeps: gate voltage and drain current for the Small, Med and Large device. |

## Running

1. Install [ngspice](https://ngspice.sourceforge.io/) and the `gf180mcuD` PDK,
   for example by cloning [wafer-space/gf180mcu](https://github.com/wafer-space/gf180mcu).
2. Link the PDK into this directory:

   ```sh
   ln -s /path/to/gf180mcu/gf180mcuD docs/sim/pdk
   ```

3. Run the testbenches:

   ```sh
   cd docs/sim
   python3 run_sims.py
   ```

The pump sweep takes about 20 minutes. To run one testbench by hand, use
`ngspice -b tb_clkgen.spice` or `ngspice -b tb_fets.spice`.

## Charge pumps

The pump netlists come from layout extraction. Each is a Dickson charge pump:

| Pump | Stages | Schottky diode cells | MIM capacitors |
|---|---|---|---|
| Injection | 2 | 3 | 3 |
| Tunneling | 3 | 4 | 4 |
| HV | 4 | 5 | 5 |

Each diode cell holds five Schottky diodes in parallel, each 0.72 µm² in area.
Each capacitor is 40 µm × 40 µm, about 3.2 pF.

The testbench ties `Vin_w` to `VDD`, drives the clock pad with a square wave of
amplitude `VDD`, and loads the output with 10 pF. The table gives the output
voltage averaged over the last 20 of 300 clock cycles.

| Pump | VDD (V) | Clock (MHz) | Output, no load (V) | Output, 10 MΩ load (V) |
|---|---|---|---|---|
| Injection | 3.3 | 1 | 9.30 | 8.62 |
| Injection | 3.3 | 10 | 9.20 | 8.96 |
| Injection | 5.0 | 1 | 14.27 | 13.35 |
| Injection | 5.0 | 10 | 14.24 | 13.98 |
| Tunneling | 3.3 | 1 | 12.35 | 11.16 |
| Tunneling | 3.3 | 10 | 12.20 | 11.88 |
| Tunneling | 5.0 | 1 | 18.94 | 17.27 |
| Tunneling | 5.0 | 10 | 18.91 | 18.56 |
| HV | 3.3 | 1 | 15.39 | 13.57 |
| HV | 3.3 | 10 | 15.19 | 14.79 |
| HV | 5.0 | 1 | 23.63 | 21.00 |
| HV | 5.0 | 10 | 23.57 | 23.11 |

![Simulated start-up of the three pumps at VDD = 5 V and 10 MHz: the injection pump settles at 14.2 V, the tunneling pump at 18.9 V and the HV pump at 23.6 V](../img/sim_pump_startup.png)

A first-order check: an unloaded Dickson pump with N stages gives about
Vin + N × Vclk − (N + 1) × Vd. With Vin = Vclk = 5 V and a Schottky drop of about
0.25 V, that is 14.3 V, 19.0 V and 23.8 V for N = 2, 3 and 4.

Limits of these numbers:

- The MIM capacitor model has no breakdown. Its model file says the capacitor is
  usable up to 6 V across it, and the later stages and the output capacitor see
  more than that in these simulations.
- The `sc_diode` model has a reverse breakdown voltage of 17 V.
- The analog pads on the injection and tunneling pump outputs may clamp the
  output. See [the pad map](../pad-map.md#things-to-know-before-probing-or-bonding).
- The schematic
  [`InjectionSchottkyPump.sch`](../../1_Design/GF180_cells/InjectionSchottyPump/InjectionSchottkyPump.sch)
  draws each diode as four 0.62 µm × 2 µm diodes. The layout extraction gives
  five diodes of 0.72 µm² each. The testbench uses the extracted values.

## Clock generator

[`tb_clkgen.spice`](tb_clkgen.spice) drives the injection pump from a 1 MHz
clock at VDD = 5 V and measures the gap between the two phases at 2.5 V.

| Transition | Gap (ns) |
|---|---|
| `PHI1` falls, then `PHI2` rises | 0.41 |
| `PHI2` falls, then `PHI1` rises | 0.58 |

![Simulated clock phases around both transitions: each phase falls before the other rises](../img/sim_clkgen.png)

## FET characterization cells

[`tb_fets.spice`](tb_fets.spice) sweeps the gate of the three NFETs and the
three PFETs. Layout extraction gives all six as 3.3 V devices with
L = 0.28 µm. The Large device is ten fingers of 5 µm.

| Device | W (µm) | Current at 0.1 V drain bias (A) | Current at 3.3 V drain bias (A) |
|---|---|---|---|
| NFET Small | 0.5 | 3.16e-5 | 2.71e-4 |
| NFET Med | 5 | 3.05e-4 | 2.55e-3 |
| NFET Large | 50 | 3.05e-3 | 2.54e-2 |
| PFET Small | 0.5 | 1.07e-5 | 1.27e-4 |
| PFET Med | 5 | 1.09e-4 | 1.25e-3 |
| PFET Large | 50 | 1.10e-3 | 1.25e-2 |

Currents are magnitudes with 3.3 V on the gate (Vgs for the NFETs, Vsg for the
PFETs).

![Simulated drain current against gate voltage on a log scale for the three NFETs and three PFETs](../img/sim_fets.png)

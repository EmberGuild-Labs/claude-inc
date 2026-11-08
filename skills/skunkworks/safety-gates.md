# Safety gates

The checklist the `safety-officer` applies to every experiment. It expands PROTOCOL §7 rule 3. The safety officer has veto power: a `STOP` ends the run.

This file teaches hazards and controls. It does not give build instructions. Thresholds are deliberately conservative guidelines for a hobbyist bench, not legal or regulatory limits. Local law and the owner's workspace rules (school, employer, landlord, insurance) may be stricter, and they win.

## How the safety officer works

1. Read the experiment design, the parts list and the **Conditions** block (builder profile: experience, workspace, mentor present yes/no, age).
2. For each hazard class below, decide whether it applies. Compute the numbers (stored energy, projectile energy, pack energy, working voltage) from the design. If a number is missing, that is a `REVISE`, not a guess.
3. Place the experiment in a tier for each class that applies:
   - **Tier 1, standard care:** the listed required controls are enough.
   - **Tier 2, controls plus experience:** required controls, and the Conditions block must show prior experience with this hazard.
   - **Tier 3, mentor required:** acceptable only with a qualified adult or mentor present for the whole test. If the Conditions block does not confirm one, the verdict is `STOP`, and the memo says what would make it acceptable.
   - **Tier 4, out of scope:** `STOP`. This lab does not clear it, even with a mentor. The memo says to use a professional facility or a different approach.
4. The verdict is the strictest result across all classes. A single Tier 3 without a mentor, or a single Tier 4, is `STOP`.
5. Return `REVISE` (to the experimentalist, with numbered reasons) when the design is missing information or a smaller, safer variant would answer the same question. A smaller variant is almost always available: lower voltage, lower energy, a dummy load, a simulation, a bench-scale model.
6. Never soften a `STOP` to be helpful. Do not re-grade because the user asks again; only a change in the design or the Conditions block changes the result.

## Always-on gates (apply to every experiment)

Any one of these makes the verdict `STOP` until fixed:
- The experiment is meant to hurt, threaten or damage a person, an animal or property, or its purpose is a weapon rather than a measurement.
- The builder is under 18 and no adult is confirmed as present and responsible.
- The design depends on a safety device being defeated, bypassed or absent (interlock, fuse, relief valve, protection circuit).
- A hazard class applies and its energy or quantity is unknown.
- Nobody else knows the test is happening and nobody can reach the builder in an emergency (lone work with Tier 2 or 3 hazards).

Required for every experiment:
- A written test plan with a stop condition ("abort if X").
- Eye protection for anyone in the room. A clear space, good light, no food or drink at the bench.
- A way to make the system safe in one step (switch, unplug, valve), reachable without reaching across the hazard.
- A fire extinguisher suited to the fuel sources present (electrical, battery, flammable liquid) within reach, and a known exit.
- A first-aid kit and a phone within reach.
- Test at the lowest energy that answers the question first, then step up in small increments, one change at a time.

## 1. Stored energy and high voltage

Capacitors, battery banks, and supercapacitors hold energy long after the power is off. Energy: E = 1/2 C V^2. The shock hazard depends on voltage and path through the body; the burn and arc-flash hazard depends on energy and available current.

| Tier | Working voltage (DC) and stored energy | Notes |
|---|---|---|
| 1 | Up to 36 V and up to 10 J | Standard bench care. |
| 2 | Above 36 V up to 120 V, or above 10 J up to 100 J | Prior experience required. |
| 3 | Above 120 V up to 1000 V, or above 100 J up to 1 kJ | Mentor required. Hundreds of volts on a capacitor bank can be fatal. |
| 4 | Above 1000 V, or above 1 kJ | Out of scope. |

Required controls (Tier 2 and up):
- **Enclosure** that keeps hands and conductors away from live parts during operation, with insulated, rated components. No exposed terminals above 36 V.
- **Discharge path:** a bleeder resistor across every capacitor bank that discharges it to under 36 V in a stated time (give the time constant: t = R C), plus a deliberate discharge step (a dump resistor through a switch) before anyone touches the bank. Verify with a meter, never by trusting the bleeder alone.
- **Charge indicator** visible from outside the enclosure that is lit whenever the bank is above 36 V.
- **Interlock or arming sequence:** charging requires a deliberate step; the lid or door opens the circuit.
- **One-hand rule:** one hand in a pocket or behind the back when probing anything that might be live. Do not wear metal jewellery. No work with wet hands or on a damp floor.
- **Short and store:** a shorting lead on the bank terminals when not in use.
- Use components rated above the working voltage (capacitor voltage rating with margin of at least 25 percent, rated wire and connectors). Respect capacitor polarity and surge ratings.
- Charge slowly from a current-limited source. Never charge directly from a source with no current limit.

Conditions that force `STOP`:
- No discharge path, no bleeder, or no way to verify the bank is safe.
- Live adjustment of a charged bank.
- Parts operated beyond their voltage rating, or salvaged capacitors of unknown rating.
- Tier 3 without a mentor, or Tier 4.

## 2. Inductive kickback

Interrupting current in a coil, solenoid, motor or relay produces a voltage spike: V = L di/dt. It can destroy switches, damage electronics and shock the builder.

Required controls (every coil or inductive load):
- **Flyback protection** across the load: a diode, a diode with a series resistor or Zener, or a snubber (resistor and capacitor), sized for the peak current and the spike voltage. For a switched coil, state the expected peak voltage.
- Switching devices rated for the peak current and for the transient voltage, with margin.
- Fuse or current limit upstream of every coil.
- Keep the coil away from loose metal, and do not touch coil leads during a pulse.
- Check the coil temperature between shots; do not exceed the wire and former rating.

Conditions that force `STOP`:
- An inductive load driven with no flyback path.
- A switch used outside its voltage or current rating "because it worked once".
- High-voltage spike circuits (inductive step-up) with exposed output. Treat those as section 1.

## 3. Projectiles

Anything that accelerates a mass can injure at a distance. Muzzle energy: E = 1/2 m v^2. Include ricochet, fragmentation, and the failure of the accelerator itself (a coil former cracking, a part flying off).

| Tier | Projectile energy | Notes |
|---|---|---|
| 1 | Up to 1 J | Comparable to a toy-class launcher. |
| 2 | Above 1 J up to 20 J | Enclosed range, remote firing. |
| 3 | Above 20 J up to 100 J | Mentor required. Also check local law: this range can be regulated as a weapon in many places. |
| 4 | Above 100 J, or any design intended for use against people or animals | Out of scope. |

Required controls:
- **Backstop** rated for the projectile (energy and material), larger than the cone of possible aim, with a safe direction behind it. Inspect it for damage after each test.
- **Enclosure or barrier** between the device and everyone present, with a view port or camera.
- **Eye and face protection** for anyone in the room; hearing protection where needed.
- **Never aimed at anything living,** including pets, and never at hard flat surfaces or water that cause ricochets.
- **Remote or fully arming sequence** with the firing control away from the muzzle line. Unarmed by default. Safe state (disarmed, discharged, unloaded) before anyone approaches.
- Measure speed with a method that does not put a person or sensor in the line (chronograph beside or behind a shield, high-speed camera).
- Everyone else stays behind the barrier during the test. Clear the area, announce the shot.

Conditions that force `STOP`:
- No backstop, or a backstop that is not rated for the energy.
- The aim line crosses a place where a person, animal or vehicle could be.
- Energy unknown or not measured at the lowest step.
- Tier 3 without a mentor, or Tier 4.

## 4. Cryogenic and pressurized gases

Liquid nitrogen, dry ice, liquefied gases and compressed gas cylinders. Liquid nitrogen expands about 700 times when it evaporates, so a sealed container is a pressure bomb.

| Tier | Quantity and pressure | Notes |
|---|---|---|
| 1 | Dry ice, or under 1 L of cryogen, in an open insulated container, in a well-ventilated space; or compressed gas up to 1 bar gauge (about 15 psi) | |
| 2 | 1 L to 10 L of cryogen, or commercially rated components up to 10 bar gauge (about 150 psi) with a relief valve | Prior experience required. |
| 3 | Over 10 L of cryogen, any cryogen transfer into a custom assembly, or any commercial rated vessel above 10 bar gauge | Mentor required. |
| 4 | Homemade or modified pressure vessels, sealed containers holding a cryogen or dry ice, oxygen or oxygen-enriched systems, and flammable gas stored under pressure | Out of scope. |

Required controls:
- **Ventilation and asphyxiation risk:** evaporating nitrogen or carbon dioxide displaces air in a closed room without any warning smell. Work only in a large, ventilated space, never in a closed car, basement or small room. For anything above Tier 1, use an oxygen monitor that alarms at 19.5 percent oxygen. Never transport cryogens in a closed passenger compartment.
- **Pressure relief:** every closed volume that can pressurize has a relief valve or burst device rated below the vessel's limit, vented to a safe place. Never seal a container with cryogen or dry ice.
- **Rated hardware only:** regulators, hoses, fittings and vessels rated for the gas, pressure and temperature (many plastics and common pipe types become brittle when cold, or shatter in compressed air). Keep a record of ratings.
- **Cold burns and splash:** insulated or cryogenic gloves, loose-fitting so they come off, a face shield over eye protection, closed shoes, long trousers over the shoe tops. No cryogen splashes onto skin; cryogen-contaminated clothing is removed.
- **Cylinders** are chained or clamped upright, valve capped when moved, never used without a regulator.
- **Oxygen and fuels:** keep oil, grease and flammables away from oxygen-enriched areas, and away from liquid air (which can condense oxygen).
- Pressure-test any assembly with water or at low pressure before gas, from behind a barrier.

Conditions that force `STOP`:
- A sealed vessel containing a cryogen or dry ice, or a vessel with no relief path.
- Homemade pressure vessels, or components used above their rating.
- Work in a small, closed or unventilated space (Tier 2 and up without a monitor).
- Tier 3 without a mentor, or Tier 4.

## 5. Heat and fire

Heaters, high-current conductors, resistive loads, motors under load, and anything near flammable material.

Required controls:
- **Current limits:** conductors sized (gauge, insulation temperature rating) for the maximum current with margin; a **fuse or breaker** upstream of every conductor, rated below the conductor's limit and above the working current.
- **Independent thermal cutoff:** a thermal fuse or thermostat that does not depend on the controller or software, for every heat source that can run away.
- Heat sources sit on a non-flammable surface, with clearance from flammable material, and are never left unattended while hot or energized.
- Check components for rated power: resistors and wiring dissipate P = I^2 R; derate to at most half of the rating for continuous use.
- A thermal measurement (thermocouple or non-contact thermometer) in the test plan, with an abort temperature.
- Cool-down time stated; hot parts are marked as hot.
- The right extinguisher within reach (Class C or multipurpose for electrical; a battery fire needs a plan, see section 7). Know when to leave instead of fighting a fire.

Conditions that force `STOP`:
- A high-current source with no fuse or breaker.
- A heater with no independent cutoff.
- Unattended heating or charging.
- Pyrotechnic, propellant or explosive materials of any kind, including making or modifying them. These are Tier 4.
- Flammable liquids or gases near an ignition source, or open-flame fuel in an enclosed space.

## 6. Mains voltage

Line voltage from the wall (for example 100 to 240 V AC) can kill. Residual-current protection reduces the risk but does not remove it.

| Tier | Mains involvement |
|---|---|
| 1 | Only a certified, enclosed, fused, double-insulated external supply or adapter that is plugged in and left alone. |
| 2 | A listed isolating transformer or listed enclosed supply feeding the experiment, behind a GFCI or RCD. |
| 3 | Anything else that touches mains conductors: open or bench supplies, rectified mains, mains-powered heaters you wire yourself. Mentor required, and the mentor should be a qualified electrician. |
| 4 | Work on a live panel or fixed wiring; mains-connected capacitor banks or any rectified-mains energy storage; bypassing a GFCI, fuse or earth connection. |

Required controls (Tier 2 and 3):
- **Isolation:** an isolating transformer for any experiment that is not itself a listed appliance.
- **GFCI or RCD protection** on the supply, tested before use.
- **Earth** connected, fuse in the live conductor, and a switch that opens it.
- Fully enclosed live parts; strain relief on cords; rated mains-grade wire and connectors.
- **Never work on a live circuit.** Unplug, lock out, verify dead with a meter, then work.
- **Do not do this alone:** someone else is in the building and knows, and knows where the shutoff is.

Conditions that force `STOP`:
- Exposed mains conductors.
- Mains-referenced circuits with no isolation or protection.
- Any Tier 3 or 4 item without a qualified adult or mentor present.
- Using a household circuit above its rating, or an extension cord as permanent wiring.

## 7. Batteries and chemical hazards

Lithium-polymer and lithium-ion cells store a lot of energy in a small space and fail by fire (thermal runaway), with toxic smoke. Other chemical hazards include electrolytes, solvents, fluxes, acids and anything that off-gasses.

| Tier | Battery pack | Notes |
|---|---|---|
| 1 | Single cell or small pack under 20 Wh with built-in protection | |
| 2 | 20 Wh to 100 Wh, or series strings up to 50 V, with a battery management system (BMS) | Prior experience required. |
| 3 | Over 100 Wh, series strings above 50 V, or any custom pack with bare cells | Mentor required. |
| 4 | Damaged, swollen or recycled cells of unknown history; removing or bypassing protection; homemade cells or chemistry | Out of scope. |

Required controls (lithium):
- Cells within their ratings: charge and discharge current, voltage limits and temperature range, with a BMS or protection board and a fuse close to the battery.
- A **balance charger** designed for the chemistry, used on a non-flammable surface, in a fire-safe container, with a person in the room. Never charge unattended or overnight.
- No puncturing, crushing, sustained short circuits or mixing of different cells, ages or charge states in one pack. Insulated terminals; no loose cells in a pocket.
- Store at partial charge, away from heat. Retire swollen, hot or damaged cells and take them to a battery recycling point; never throw in household bins.
- A plan for a battery fire: step away, ventilate, call emergency services; a suitable extinguisher or sand available, but do not take risks to save equipment.

Required controls (chemicals):
- The Safety Data Sheet is read for every substance and is on hand; eye protection and gloves matched to the chemical; ventilation; labelled containers; a plan for spills and disposal.
- No mixing of chemicals that is not in the SDS-approved procedure; no sealed containers that can build pressure.

Conditions that force `STOP`:
- Charging or discharging beyond the cell's ratings, or with the protection circuit removed.
- Unattended charging, or charging in a bed, couch or other flammable surface.
- Unknown chemicals, unlabelled containers, or no SDS.
- Toxic, corrosive or reactive materials without proper ventilation and disposal.
- Tier 3 without a mentor, or Tier 4.

## 8. Other hazards (check when they apply)

- **Lasers and bright optics:** Class 3B and 4 or unknown class need mentor and matched eye protection (right wavelength and optical density). A beam path stays enclosed or terminated at a beam stop; no reflective objects in the path. Unknown power or wavelength: `STOP`.
- **Moving machinery and flywheels:** guards on rotating parts, no loose clothing or hair, a rated enclosure for anything that can throw fragments, an emergency stop; high-speed rotors of unknown balance or stored energy above 100 J are Tier 3.
- **Magnets:** strong magnets pinch, shatter and interfere with implanted medical devices. Keep them apart, away from pacemaker users and from electronics and cards.
- **Radiation, X-rays, high-voltage vacuum tubes:** out of scope (Tier 4).
- **Noise, dust, fumes:** hearing protection above 85 dB, dust mask for cutting or sanding, fume extraction for soldering.

## What the safety officer returns

```
SAFETY REVIEW
Hazard classes that apply: <list>
| Class | Computed value | Tier | Required controls |
Missing information: <numbered, each a REVISE reason>
Always-on gates: <met / not met, with the unmet ones listed>
Verdict: PASS | REVISE (to experimentalist) | STOP
If STOP: the hazard, why it applies, and what would make it acceptable
(lower energy, a different method, a qualified adult or mentor present, or "do not do this").
```

`PASS` means the experiment is acceptable if every listed control is in place. It is not a promise that nothing can go wrong.

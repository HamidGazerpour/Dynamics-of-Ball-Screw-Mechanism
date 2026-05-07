# Dynamics of Ball Screw Mechanism

This repository contains MATLAB scripts for simulating the motion profile and torque demand of a ball screw mechanism driven by a cam-like motion program. The model computes the linear position, velocity, and acceleration of the screw, converts them into equivalent screw angular kinematics, and estimates the required motor torque over one full 360-degree cycle.

## Repository contents

| File | Purpose |
| --- | --- |
| `main_dynamics.m` | Main simulation script. Defines screw, load, inertia, and speed parameters; evaluates the motion over one cycle; computes screw kinematics and required torque; and plots the results. |
| `MC_03.m` | Motion-cycle function. Defines the dwell, rise, top-dwell, return, and final-dwell segments over a 360-degree input cycle. |
| `MCMtraposoidal.m` | Trapezoidal-style normalized motion-law function used by `MC_03.m` to generate smooth position, velocity, and acceleration values. |

## Model overview

The simulation follows these steps:

1. Define the actuator angular speed, screw geometry, screw lead, friction coefficient, cutting/load force, and total rotational inertia.
2. Sweep the input cam angle from `0` to `360` degrees.
3. Use `MC_03` to obtain linear screw displacement, velocity, and acceleration for each input angle.
4. Convert linear screw motion into angular screw position, angular velocity, and angular acceleration using the screw lead.
5. Add the cutting/load torque during the active cutting interval and combine it with the inertial torque.
6. Plot:
   - linear position, velocity, acceleration, and required torque versus time;
   - angular position, velocity, and acceleration versus time;
   - motor torque versus screw rotational speed.

## Requirements

- MATLAB, or a compatible GNU Octave installation for basic script execution.
- No third-party MATLAB toolboxes are required by the current scripts.

## Usage

1. Open MATLAB or Octave.
2. Change the working directory to this repository.
3. Run the main script:

```matlab
main_dynamics
```

The script generates three figures showing linear screw dynamics, angular screw dynamics, and the torque-speed relationship.

## Key parameters

Most configurable parameters are defined near the top of `main_dynamics.m`:

| Parameter | Description |
| --- | --- |
| `omega` | Input angular speed in radians per second. |
| `r_wire`, `sigma_wire` | Wire radius and stress used to calculate the cutting/load force. |
| `d0`, `d1`, `d_ave` | Screw diameter values. |
| `L` | Screw lead. |
| `mu` | Static friction coefficient. |
| `Jtot` | Total equivalent rotational inertia. |

The motion-cycle segment angles and stroke height are defined in `MC_03.m`.

## Notes

- Comments in `main_dynamics.m` label `d0` and `d1` as millimeter values, but the numeric values are used directly in SI-style equations. Verify units before using the results for design decisions.
- The plotted torque is based on the current load model and active-force interval in `main_dynamics.m`; update those assumptions to match a specific mechanism or duty cycle.
- The repository is intended for simulation and educational analysis. Validate the model before applying it to hardware selection or safety-critical design.

## Suggested workflow for changes

1. Adjust physical parameters in `main_dynamics.m`.
2. Adjust the motion schedule in `MC_03.m` if the rise, dwell, or return timing changes.
3. Adjust the normalized motion law in `MCMtraposoidal.m` if a different acceleration profile is required.
4. Re-run `main_dynamics` and compare the generated plots.

# Final Results Tables

## Problem 1 — Nodal Displacement Comparison

All values in mm. "Reference" is the MATLAB solution to 4 decimal places, used as the baseline both FEA models are checked against.

| DOF | MATLAB (mm) | FEA Truss (mm) | Error vs MATLAB | FEA Beam (mm) | Error vs MATLAB |
|---|---|---|---|---|---|
| x1 | −9.1617 | −9.1622 | 0.005% | −9.1585 | 0.035% |
| x2 | 1.5719 | 1.5720 | 0.006% | 1.5737 | 0.114% |
| x3 | −7.5898 | −7.5902 | 0.005% | −7.5876 | 0.029% |
| x4 | −3.1438 | −3.1440 | 0.006% | −3.1445 | 0.022% |
| x5 | −19.8953 | −19.8960 | 0.004% | −19.8970 | 0.009% |
| x6 | −4.7157 | −4.7159 | 0.004% | −4.7170 | 0.027% |
| x7 | −21.4672 | −21.4680 | 0.004% | −21.4700 | 0.013% |
| x8 | −17.0212 | −17.0220 | 0.005% | −17.0270 | 0.034% |

**Max deflection:** ≈21.47 mm vertically at the loaded node (Node 4), consistent across all three methods.

**Member stress (FEA beam tool, combined stress):**

| Quantity | Value |
|---|---|
| Peak compressive stress | −661.95 MPa (member 2/7 region) |
| Peak tensile stress | 457.31 MPa (member 5) |
| Structural steel yield stress | 250 MPa |

Both peaks exceed yield by a wide margin — see the [README](../README.md) for what that means for the design.

**Reaction force check (FEA truss model):**

| Support | Fx (N) | Fy (N) |
|---|---|---|
| Fixed Support 1 | −40,000 | 20,000 |
| Fixed Support 2 | 40,000 | 0 |
| **Sum** | **0** | **20,000** (= applied load `P`, as required for equilibrium) |

## Problem 2 — Belleville Spring, δ = 3.72 mm

| Analysis | Force (N) | Spring Constant, *k* (N/mm) | Peak Von Mises Stress (MPa) |
|---|---|---|---|
| Manufacturer data | 68,204 | — | 1000 |
| Analytical (Norton + FD) | 68,791 | 12,956 | — (not predicted) |
| FEA 2D (axisymmetric) | 66,533 | 11,828 | 2631.3 |
| FEA 3D | 78,522 | 20,559 | 2419.7 |

**Deviation from manufacturer data (force):**

| Analysis | Deviation |
|---|---|
| Analytical | 0.86% |
| FEA 2D | 2.45% |
| FEA 3D | 15.13% |

**Deviation from analytical:**

| Analysis | Force deviation | Spring constant (*k*) deviation |
|---|---|---|
| FEA 2D | 3.28% | 8.71% |
| FEA 3D | 14.15% | 58.68% |

> **Note:** the original report's discussion text and Table 2 quote "2.4%" as the 2D model's *deviation from analytical*, but 2.4% is actually the 2D-vs-*manufacturer* figure (2.45%, above). The true 2D-vs-analytical force deviation is 3.28%. Both are small enough that the report's overall conclusion is unaffected, but see [`belleville-spring-method.md`](belleville-spring-method.md#a-note-on-a-reporting-inconsistency-in-the-original-report) for the full breakdown rather than just picking a side silently.

**Mesh sizes used (post grid-convergence):**

| Model | Elements | Convergence criterion |
|---|---|---|
| 2D axisymmetric | 472 | <0.003% change in avg. directional deformation between finer meshes |
| 3D | 50,292 (quadratic) | <0.034% change in avg. directional deformation between finer meshes |

**On the Von Mises stress numbers:** both FEA peak stresses (2631.3 MPa 2D, 2419.7 MPa 3D) are well above the 1000 MPa manufacturer limit, but they occur at the sharp inner-bore corner and keep climbing with mesh refinement rather than settling on a value — the textbook signature of a stress singularity, not a real material response. The bulk/average stresses away from that corner (481.82 MPa 2D, 535.19 MPa 3D) stay comfortably under the limit. Treat the peak numbers as a meshing artifact, not a finding.

# Project Brief

**Module:** Numerical Modelling and Engineering Simulations (University of Sussex)
**Assignment:** Coursework Two — Solid Mechanics Simulation
**Weighting:** 20% of module mark
**Tools required:** MATLAB, ANSYS Workbench Mechanical

This was a two-part coursework brief: solve a structural problem analytically in MATLAB, then verify it with FEA in ANSYS, then explain where the two agree or disagree.

## Problem 1 — Equilibrium Truss

An 8-member planar truss (circular tube cross-section, two fixed supports, a 20 kN point load at the free node) had to be solved three ways:

1. **MATLAB** — derive the nodal equilibrium equations by hand, assemble them into a linear system `Ax = b`, and solve for the 8 nodal displacements. The brief specifically asked for a matrix built from area *coefficients* (not hard-coded numbers), so the same code could be re-run for a different cross-section without rewriting the matrix.
2. **2D truss FEA** (link/axial elements only) in ANSYS, verified with reaction force probes at the supports.
3. **2D beam FEA** (elements that also carry bending/shear) using the same geometry, to see what changes when joints aren't treated as ideal pins.

All three then had to be compared and the truss member stresses checked against the beam tool in ANSYS.

## Problem 2 — Belleville Spring Washer

A Belleville spring is a conical disc spring with strongly non-linear force-deflection behaviour. The task was to find the spring constant `k` at a given deflection (3.72 mm) four different ways and compare them against the manufacturer's quoted figure:

1. **Analytical** — Norton's closed-form force-deflection equation for conical disc springs, differentiated numerically (second-order central finite difference) to get `k = dF/dδ`.
2. **2D axisymmetric FEA** — model just the cross-section and let ANSYS handle the rotational symmetry. Required a grid convergence study and large-deflection (geometric non-linearity) enabled.
3. **3D FEA** — the full revolved solid, again with grid convergence and large deflection, plus a third boundary condition to stop the model from spinning freely about its own axis (something the 2D model doesn't need).
4. Tabulate all four results (manufacturer, analytical, 2D, 3D) for force, spring constant, and peak stress, and judge which model is actually trustworthy.

## Deliverables

- A single PDF technical report, 1000–2000 words, max 20 pages, with a defined structure (abstract, nomenclature, intro, setup, analysis/discussion, conclusions, references, and a MATLAB code appendix).
- The ANSYS Workbench project files and any MATLAB/Excel files used, submitted separately for originality verification.

## Marking Split

| Section | Weight |
|---|---|
| Problem 1: MATLAB `Ax=b` solution | 20% |
| Problem 1: 2D truss FEA | 5% |
| Problem 1: 2D beam FEA | 5% |
| Problem 1: comparison & discussion | 10% |
| Problem 2: analytical spring constant | 5% |
| Problem 2: 2D axisymmetric FEA | 10% |
| Problem 2: 3D FEA | 10% |
| Problem 2: comparison & discussion | 15% |
| Report structure | 10% |
| Report clarity / technical writing | 10% |

This summary is based on the original coursework brief and the two problem sheets issued for the assignment. The submitted report itself is included in full at [`report/full-report.pdf`](../report/full-report.pdf).

# Concept & Method Design

This page covers the modelling decisions made for each problem, what alternatives were considered, and why they were rejected.

## Problem 1 — Equilibrium Truss

### Solving the linear system

**Options considered:** Gaussian elimination written from scratch, matrix inversion (`inv(A)*b`), or MATLAB's built-in backslash operator (`A\b`).

**Rejected:** Explicit matrix inversion. It's numerically less stable than decomposition methods for anything beyond toy problems, and squares the condition number of the system unnecessarily — there's no upside for an 8×8 system.

**Chosen:** `A\b`, which MATLAB resolves internally via LU decomposition for a square, dense, well-conditioned system like this one. It's the standard, numerically stable choice and needs no extra code.

### Matrix construction

**Options considered:** Hard-code the 8×8 matrix with numeric values once the area and angle were known, or build it parametrically from area/angle coefficients.

**Rejected:** Hard-coding. It technically gives the same answer for this specific truss, but the brief explicitly rewarded a matrix that updates if the cross-section or member layout changes, and a hard-coded matrix would need to be rederived by hand for every design iteration.

**Chosen:** Coefficients (`A`, `γA`, etc.) are defined symbolically from area and angle, then substituted in. The MATLAB script also exposes a menu so the same code runs for a custom tube/cylindrical profile, angle, length, or load without touching the matrix structure.

### Truss FEA vs Beam FEA element choice

**Options considered:** Model the truss with link (axial-only) elements, beam elements, or both.

**Chosen:** Both, deliberately, because the brief asked for a comparison and the difference between them is the more interesting result. Link elements give the theoretically "correct" answer for an idealised pin-jointed truss (matching the MATLAB assumption exactly); beam elements are more representative of how a real welded or bolted joint behaves, since they transmit moment. Running both let the report quantify how much that assumption actually costs in displacement and stress (turned out to be small for displacement, ~0.11% max, but meaningfully larger for member stress).

## Problem 2 — Belleville Spring

### 2D axisymmetric vs full 3D

**Options considered:** Skip straight to a 3D model, since that's the "real" geometry, or start with a 2D axisymmetric idealisation.

**Rejected:** 3D-only. The brief specifically asked for both, but more importantly the 2D model is cheaper to mesh-converge and validate first, and it preserves the spring's true axisymmetry exactly — there is no circumferential variation in load or geometry, so reducing to 2D loses no physics. Going to 3D first would have made it harder to isolate whether any error came from the geometry, the mesh, or the boundary conditions.

**Chosen:** Build and converge the 2D model first, then revolve it into 3D and converge that separately. This made it possible to trace the eventual 3D over-prediction back to a boundary condition rather than a meshing issue, since the 2D model (sharing the same cross-section and loading) was already known to behave correctly.

### 3D anti-rotation boundary condition

**Problem:** A 3D model with only an axial displacement and an axial fixed support is free to spin about its own axis — a rigid-body rotation that gives ANSYS no unique solution.

**Options considered:** Constrain rotation using a Cartesian fixed edge (X = 0, Z = 0 on the outer top edge), or constrain only the tangential degree of freedom in a cylindrical coordinate system.

**Chosen (with hindsight, the wrong one):** The Cartesian constraint, because it's the simpler boundary condition to set up and is common practice for preventing rigid-body modes. It does stop the spring spinning, but it does so by also resisting the *radial* expansion of the outer rim as the cone flattens under load — physically, the 2D axisymmetric model lets that rim expand freely, but the Cartesian BC in 3D doesn't. That mismatch is the dominant reason the 3D force and spring constant came out high (discussed in detail in the [report's discussion section](../report/full-report.pdf) and in [`calculations/belleville-spring-method.md`](../calculations/belleville-spring-method.md)).

**What should have been used instead:** A cylindrical coordinate system constraining only the tangential displacement component, leaving the radial direction free. This is flagged explicitly in the report as the fix for a repeat of this analysis, rather than glossed over.

### Mesh type for the 3D model

**Options considered:** Linear (first-order) elements or quadratic (second-order, mid-side node) elements.

**Rejected:** Linear elements at the same element count, since they approximate the curved conical cross-section as a series of straight facets and need a much finer mesh to capture the same accuracy.

**Chosen:** Quadratic elements. They resolve the curved cross-section properly for a given mesh density and were used consistently with the sizing strategy from the 2D study, so the only real difference between the 2D and 3D convergence studies is dimensionality, not element order.

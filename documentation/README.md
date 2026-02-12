# Multi-Dimensional Bisection Method (MDBM) - Matlab Documentation

**MDBM** is an efficient and robust root-finding algorithm for determining high-dimensional submanifolds of the roots of implicit non-linear equation systems.

[![CC BY-NC-ND 2.0](https://img.shields.io/badge/License-CC%20BY--NC--ND%202.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/2.0/)

---

## 1. Introduction & Quick Start

The Multi-Dimensional Bisection Method extends the classic 1D bisection (interval halving) method to higher dimensions. It is designed to find all solutions to:
$$f_i(x_j) = 0, \quad i=1 \dots k, \quad j=1 \dots l, \quad k \leq l$$

### Quick How-to-Use
1.  **Define Parameter Space (`ax`)**: Define range and initial grid.
    ```matlab
    ax(1).val = linspace(-2, 2, 5);
    ax(2).val = linspace(-2, 2, 5);
    ```
2.  **Define the Function**:
    ```matlab
    fun = @(x) x(1,:).^2 + x(2,:).^2 - 1; 
    ```
3.  **Run MDBM**:
    ```matlab
    sol = mdbm(ax, fun, 4);
    ```
4.  **Visualize**: `plot_mdbm(sol);`

---

## 2. Detailed Options (`mdbmset`)

The `mdbmset` function creates the options structure. Each field is critical for fine-tuning the solver's performance and robustness.

| Field | Description | Related Demonstration |
| :--- | :--- | :--- |
| `fvectorized` | (Always true) Assumes the function accepts and returns matrices of points for speed. | - |
| `isconstrained` | If true, the last equation in the output is treated as a domain boundary. Solutions are only kept where this value is positive. | `features/constrained_problems_simple.m` |
| `interporder` | Order of root interpolation: `0` (raw grid points), `1` (linear), `2` (quadratic). Higher orders provide smoother results but require more neighbors. | `features/interpolation_order.m` |
| `bracketingdistance` | Distance (in grid units) to look for sign changes. Increasing this can help recover branches in very dense solution regions. | `features/bracketing_ncube_detection.m` |
| `bracketingnorm` | The norm used to calculate distance for bracketing. | `features/bracketing_ncube_detection.m` |
| `checkneighbourinallsteps` | If true, neighbor checking is performed at every iteration. Highly robust but slower. | `features/neighbor_check_demo.m` |
| `checkneighbour` | Maximum number of consecutive neighbor check steps. Set to `Inf` for maximum robustness or `0` to disable. | `features/neighbor_check_demo.m` |
| `directionalneighbouronly` | Optimization: if true, only neighbors in directions where a root is expected are checked. | - |
| `connections` | If true, calculates the Delaunay connectivity needed for plotting surfaces and curves. | `features/connection_of_points_to_simplex.m` |
| `zerotreshold` | Numerical value below which a function evaluation is considered exactly zero. Essential for degenerate or non-smooth functions. | `features/degenerate_function_1.m` |
| `cornerneighbours` | If true, includes diagonal (corner) neighbors in the search, not just face neighbors. Required for `interporder > 1`. | `features/interpolation_order.m` |
| `refinetype` | Refinement strategy: `'all'` (standard bisection), `'pos'` (refine specific coordinate range), `'object'` (refine near detected roots), `'curvature'`. | `features/local_refinement_nonsmooth_mandelbrot.m` |
| `Ncodim` | Manually specify the number of equations if it cannot be determined automatically. | - |
| `timelimit` | Maximum allowed time (seconds) for a single refinement step. Prevents excessive computation in complex regions. | `case_studies/Delay_Mathieu...` |
| `funcallimit` | Maximum number of function evaluations allowed to prevent memory overflow. | - |

---

## 3. Core Engine Files (`src`)

A detailed breakdown of the files in the `src` directory:

| File | Description |
| :--- | :--- |
| `mdbm.p` | **Main Entry Point**. Orchestrates the iterative bisection, calling refinement and interpolation logic. |
| `mdbmset.m` | **Configuration**. Utility to create the options structure with sensible defaults. |
| `plot_mdbm.m` | **Primary Visualization**. Intelligent plotting for 1D, 2D, and 3D submanifolds. Handles scaling and color-mapping. |
| `extend_axis.m` | **Domain Extension**. Adds new parameter ranges to an existing solution, allowing for "continuation" into unknown territory. |
| `refine.p` | **Grid Management**. Implements the various refinement strategies (splitting cells into sub-cells). |
| `checkneighbour.p` | **Robustness Engine**. Scans adjacent grid cells to find missing solution branches that the standard bisection might have missed. |
| `interpolating_cubes.p` | **Root Finder**. Performs the actual interpolation (0th, 1st, or 2nd order) to locate the root inside a grid cell. |
| `DTconnect.p` | **Meshing (Standard)**. Generates the Delaunay triangulation/connection logic for visualizing submanifolds. |
| `DTconnect_delunay_high_order.p` | **Meshing (Advanced)**. More robust connection logic for complex or higher-dimensional manifolds. |
| `interpplot.p` | **Visual Smoothing**. Generates high-quality smooth interpolation specifically for the plotting engine. |
| `plotthecomputedpoints.m` | **Debug Visualization**. Useful for seeing exactly which grid points were evaluated by the solver. |
| `mdbm_variax_wrapper.m` | **Parameter Sweep Wrapper**. Helper for running MDBM over variations of parameters (used in envelope sweeping). |
| `axdoubling.p` | **Internal**. Logic for doubling axis resolution during refinement. |
| `axialpos.p` | **Internal**. Converts grid indices to physical coordinates in the parameter space. |
| `db_combnk.p` | **Internal**. Combinatorial utility for high-dimensional grid indexing. |
| `evalmissingnodes.p` | **Internal**. Identifies and evaluates grid nodes that were skipped in previous iterations. |
| `getncubeval.p` | **Internal**. Retrieves the function values at the vertices of an n-dimensional hypercube. |
| `getneithbours.p` | **Internal**. Identifies neighboring cells in the n-dimensional grid. |
| `ind2sub_mdbm.p` | **Internal**. Optimized index-to-subscript conversion for MDBM structures. |
| `sub2ind_mdbm.p` | **Internal**. Optimized subscript-to-index conversion for MDBM structures. |
| `timelength_check.p` | **Internal**. Performance monitoring used to enforce `timelimit`. |

---

## 4. Folder Descriptions & Gallery

### `templates/`
Boilerplate scripts for various parameter/equation combinations. Use these to jump-start your project.
*   *Example:* `template_pardim2_codim1.m` for finding a curve in a 2D plane.

### `features/`
Demonstrations of specific solver capabilities and options.

#### Simplex Connections
`connection_of_points_to_simplex.m` shows how points are joined into a mesh.
![Simplex Connections](figures/feature_connection.png)

#### Constrained Problems
`constrained_problems_simple.m` (and `complex.m`) show how to limit the solution domain using a constraint function (positive values are kept).
![Constraints Simple](figures/feature_constraints_simple.png)
![Constraints Complex](figures/feature_constraints_complex.png)

#### Interpolation Order
`interpolation_order.m` demonstrates the convergence and accuracy of 0th, 1st, and 2nd order interpolation.
![Interpolation Order](figures/feature_interpolation_order.png)

#### Local Refinement
`local_refinement_nonsmooth_mandelbrot.m` shows how to increase resolution in a specific area.
![Local Refinement](figures/feature_local_refinement.png)

#### Neighbor Check
`neighbor_check_demo.m` illustrates how MDBM recovers missing solution branches by checking adjacent cells.
![Neighbor Check](figures/feature_neighbor_check.png)

#### Bracketing n-cubes
`bracketing_ncube_detection.m` demonstrates how the solver identifies cells that contain a root based on the distance to the manifold. It performs a sweep of the `bracketingdistance` parameter to show the trade-off between robustness (finding all branches) and efficiency (minimizing evaluated points).
![Bracketing n-cubes](figures/feature_bracketing.png)

#### Singularity Handling
`singularty_handling.m` demonstrates how to handle cases where sign changes are caused by singularities (where the function tends to infinity) rather than actual roots. It shows post-filtering techniques and using constraints to bound the function value.
![Singularity Handling](figures/feature_singularity.png)

### `examples/`
Practical and visual applications.

#### Unit Circles
`unit_circles.m`: Visualization of $L^p$ norms in 3D.
![Unit Circles](figures/example_unit_circles.png)

#### Julia Set 3D
`julia_set_3d.m`: Fractal boundaries in 3D space.
![Julia Set 3D](figures/example_julia_3d.png)

#### Catastrophe Surface
`catastrophe_surface_visualization_gradient.m`: Visualization of critical points.
![Catastrophe Surface](figures/example_catastrophe.png)

#### Stability Analysis
`delayed_pd_controler_stability.m`: Stability regions for a delayed PD controller.
![PD Stability](figures/example_pd_stability.png)

#### Noise Handling
`noise_handeling.m`: Robustness against noisy function evaluations.
![Noise Handling](figures/example_noise.png)

### `case_studies/`
Replication of scientific problems.

#### Shimmy Problem
`shimmy_stability_surface.m`: Lateral vibration stability of wheels.
![Shimmy Case](figures/case_shimmy.png)

#### Turning Stability
`turning_stability_instabilitygradient.m`: Stability charts for machining processes.
![Turning Case](figures/case_turning.png)

---

## 5. History & Background

The core idea of MDBM occurred during my MSc thesis (written during an Erasmus stay at the **University of Bristol** - thank you for that!) in **2006**. It has been updated in larger and smaller bursts throughout the last 20 years, leading to my most cited paper.

The primary motivation was the solution of the characteristic equations of **Delay Differential Equations (DDEs)**, which typically involve $2+1$ parameters and 2 equations (real and imaginary parts of the characteristic equation). At that time, no direct method existed to solve these automatically in a robust way, especially for detecting closed manifolds of non-differentiable functions. As far as I know, there is still no other method that handles this as effectively.

---

## 6. Known Alternatives

*   **Mathematica (ContourPlot/Isosurface)**: Mathematica performs contour plots by iteratively refining the grid (triangle-based), which is similar to my method. As far as I know, it does this in 3D as well. However, it can generally handle only one equation (which is the "easy" problem).
*   **Sequential Projection / Triangulation**: There are versions where you solve the first equation in higher dimensions, then triangulate the result, and solve the second equation on that mesh, and so on. While this creates a robust solution, the complexity is very, very high—almost the same as a brute-force search.
*   **Interval Arithmetic (Guaranteed Solutions)**: Some methods provide guaranteed solutions (whereas in MDBM, it is inevitable that a small piece of the solution might be lost in higher dimensions—in contrast to the traditional 1D bisection problem). See the great works of **David P. Sanders** on Interval Arithmetic (e.g., `IntervalRootFinding.jl`).
*   **Newton-Raphson & Continuation Methods**: Standard local solvers are faster if a good initial guess is available but cannot easily find all branches or handle non-smooth manifolds as robustly as MDBM.

---

## 7. Disclaimer & Versions

**Note on Protected Files**: I would like to protect my work, thus I use `*.p` files for the core engine (some of you may dislike it, sorry). In my opinion, the code is far too long and complex to understand; I spent more than 10 years on it, and sometimes it is hard even for me to understand the logic! (I am a mechanical engineer, not a professional programmer). However, all files that might need modification for special needs are provided as `*.m` files.

**Julia Version**: A newer version is available in Julia. Although not all features from the Matlab version have been migrated yet (as some are not critical), they have similar capabilities. Currently, only the Julia version is being actively maintained and updated, so great new features will come there first. For instance, sub-cube interpolation is already available, and the error-based non-uniform refinement (**"best and most needed feature ever"**) is already in a usable beta version.

---

## 9. Appendix: Detailed File List

### `features/` (Detailed)
*   `bracketing_ncube_detection.m`: Effect of `bracketingdistance` on manifold discovery.
*   `connection_of_points_to_simplex.m`: Visualization of the mesh generation.
*   `constrained_problems_simple.m`: Basic usage of the `isconstrained` option.
*   `constrained_problems_complex.m`: Composition of multiple constraints and objective functions.
*   `continuation_and_extension_1.m`: Extending the domain of a known solution.
*   `continuation_and_extension_2.m`: Advanced domain extension for disconnected branches.
*   `degenerate_function_1.m`: Handling functions with zero-gradients at roots.
*   `degenerate_function_2_detecting_different_dimensions.m`: Detecting manifolds of mixed dimensions.
*   `interpolation_of_the_results.m`: Showcase of different interpolation techniques.
*   `interpolation_order.m`: Convergence analysis for 0th, 1st, and 2nd order interpolation.
*   `local_refinement_nonsmooth_mandelbrot.m`: Targeted resolution increase in complex regions.
*   `neighbor_check_demo.m`: Robustness via adjacent cell scanning.
*   `plotting_exampels.m`: Comprehensive guide to the `plot_mdbm` function options.
*   `singularty_handling.m`: Filtering false sign changes caused by poles.

### `examples/` (Detailed)
*   `unit_circles.m`: Visualization of $L^p$ norms in 3D.
*   `catastrophe_surface_visualization_gradient.m`: Surface sections and fold lines.
*   `convergence_transcendent.m`: Error analysis against iterative refinement.
*   `delayed_pd_controler_stability.m`: Stability of systems with time-delay.
*   `fun_with_floor.m`: Handling non-smooth (staircase) functions.
*   `julia_set_3d.m`: Fractals in 3D.
*   `noise_handeling.m`: Robustness against stochastic function values.

### `case_studies/` (Detailed)
*   `catastrophe_surface/catastrophe_demo.m`: Pendulum catastrophe surface.
*   `Claster_Treatment_of_Characteristic_Roots/main_CTCR.m`: Delay-dependent stability analysis.
*   `Delay_Mathieu_simulation_based_stability_chart/DelayedMathieuStability_MDBM.m`: Stability of time-periodic delayed systems.
*   `shimmy_problem/shimmy_stability_surface.m`: Wheel vibration stability.
*   `Sweeping_envelope/sweeping_enveloper_only.m`: Efficient envelope detection in parameter sweeps.
*   `turning_stability/turning_stability_instabilitygradient.m`: Tool stability in machining.

### `templates/` (Detailed)
*   `template_pardim[N]_codim[M].m`: Standard starting scripts for $N$ parameters and $M$ equations ($N=1..4, M=1..3$).
*   `superminimal_template_pardim3_codim1.m`: The most concise template for high-dimensional problems.

---

## 10. Citing

If you use this software in your research, please cite:
> **Bachrathy, Daniel, and Gabor Stepan.** "Bisection Method in Higher Dimensions and the Efficiency Number." *Periodica Polytechnica Mechanical Engineering*, vol. 56, no. 2, 2012, p. 81. [doi:10.3311/pp.me.2012-2.01](https://doi.org/10.3311/pp.me.2012-2.01)

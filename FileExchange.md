# Multi-Dimensional Bisection Method (MDBM)

Multi-Dimensional Bisection Method (MDBM) finds all the solutions/roots of a system of implicit equations efficiently, where the number of unknowns is larger than the number of equations.

This function is an alternative to the `contourplot` or the `isosurface` in higher dimensions (higher number of parameters). The main advantage: it can handle multiple functions (contour plot or the isosurface can handle scalar values only).
In addition, MDBM uses much less function evaluation than the brute-force method, so for complex tasks, it is much faster and uses far less memory.

## Getting Started
Extensive examples can be found in the `examples` folder.
1. Run the `runme_run_all_the_exmaples.m` file.
2. The `run_test_....` files should be tested. Don't forget to add the `src` folder (formerly `code_folder`) to the path.
3. Check the possible options defined by `mdbmoptions = mdbmset()`. (Note: if an option is not commented in the code, it is likely an internal variable.)

## Compatibility and Versions
* **Matlab:** As a consequence of the change in the "vectorized +" function, MDBM is compatible with the newer Matlab versions only.
* **Julia:** A newer version is available in Julia. Although not all features available in the Matlab version are migrated to Julia yet (as they are not crucial), they have similar capabilities. Currently, the Julia version is the one actively maintained and developed. Great features are coming: sub-cube interpolation is already available, and error-based non-uniform refinement (one of the best and most needed features) is in a usable beta version.

## Note on Protected Files
I would protect my work, thus I use `*.p` files for the core engine. In my opinion, the code is far too long and far too complex to understand. I spent more than 10 years on it, and sometimes it is hard even for me to understand (I am a mechanical engineer and not a professional programmer). However, those files which might need modification for special needs are provided as `*.m` files. If you have any questions or problems, you can easily find me!

## Cite As
Bachrathy, Daniel, and Gabor Stepan. “Bisection Method in Higher Dimensions and the Efficiency Number.” *Periodica Polytechnica Mechanical Engineering*, vol. 56, no. 2, Periodica Polytechnica Budapest University of Technology and Economics, 2012, p. 81, [doi:10.3311/pp.me.2012-2.01](https://doi.org/10.3311/pp.me.2012-2.01).

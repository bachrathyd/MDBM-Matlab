# MDBM-Matlab
Multi-Dimensional Bisection Method (MDBM) to efficiently find the all the solutions of a system of implicit equation, where the number of unknown are larger than the number of equations

# Multi-Dimensional Bisection Method for finding the roots of non-linear implicit equation systems

In the proposed project an efficient root finding algorithm will be implemented in Julia language, which can determine whole high-dimensional submanifolds (points, curves, surfaces…) of the roots of implicit non-linear equation systems, even in cases, where the number of unknowns surpasses the number of equations.

$$ f_i(x_j)=0 \quad i=1...k \quad j=1...l, \quad k \leq l,$$

This type of problems can be found in many different field of science 
- differential geometry (isolines, isosurfaces in higher dimensions)
- linkage (mechanical: workspace of robots)
- stability computation, stabilyzability diagrams

## Introduction

The bisection method - or the so-called interval halving method - is one of the simplest root-finding algorithms which is used to find zeros of continuous non-linear functions.
This method is very robust and it always tends to the solution if the signs of the function values are different at the borders of the chosen initial interval.

In many application, this 1-dimensional intersection problem must be extended to higher dimensions, e.g.: intersections of surfaces in a 3D space (volume), which can be described as a system on non-linear implicit equations.
In higher dimensions, the existence of multiple solutions becomes very important, since the intersections of two surfaces can create multiple intersection lines.

The proposed algorithm canhandle automatically:
- multiple solutions 
- arbitrary number of parameter (typically: 3-6)
- arbitrary number implicit equations
- constraints in the parameter space
- handle degenerated functions
- first order interpolation in higher dimensions
- provides the gradients of the equations for the roots

# History

I am an assistant professor at the Budapest University of Technology and Economics, at the Faculty of Mechanical Engineering, the Department of Applied Mechanics.
During my studies and research, I have to determine stability charts of models described by delayed differential equations, which are typically formed as a "3 parameter / 2 implicit equation" problem. I have faced the difficulty that there is no applicable solution in any available software (e.g.: Mathematica, Matlab,...) which could easily be used in engineering problems. 
Due to this reason, I have started to develop the Multi-Dimensional Bisection Method ~10 years ago in Matlab. It has been slowly improved by adding new features.

Best regards,
Dr. Daniel Bachrathy


<img src="by-nc-nd.png"
     alt="CC BY-NC-ND"
     style="float: right; margin-right: 10px; width: 200px;" />


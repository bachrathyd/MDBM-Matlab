# MDBM-Matlab
Multi-Dimensional Bisection Method (MDBM) to efficiently find the all the solutions of a system of implicit equation, where the number of unknown are larger than the number of equations.

This function is an alternative of the contour plot or the isosurface in higher dimension, however, as a main advantage: it can handle multiple functions. <br>
In additional uses much less function evaluation than the brute-force method, so for complex task it is much faster and use fare less memory.

## Citation:
If you use the MDBM as part of your research, teaching, or other work, I would be grateful if you could cite my corresponding publication: <https://pp.bme.hu/me/article/view/1236/640>

## Web:
<https://www.mm.bme.hu/~bachrathy/research_EN.html>

# Multi-Dimensional Bisection Method for finding the roots of non-linear implicit equation systems

In the proposed project an efficient root finding algorithm will be implemented in Julia language, which can determine whole high-dimensional submanifolds (points, curves, surfaces…) of the roots of implicit non-linear equation systems, even in cases, where the number of unknowns surpasses the number of equations.

<a href="https://www.codecogs.com/eqnedit.php?latex=f_i(x_j)=0&space;\quad&space;i=1...k&space;\quad&space;j=1...l,&space;\quad&space;k&space;\leq&space;l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?f_i(x_j)=0&space;\quad&space;i=1...k&space;\quad&space;j=1...l,&space;\quad&space;k&space;\leq&space;l" title="f_i(x_j)=0 \quad i=1...k \quad j=1...l, \quad k \leq l" /></a>

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

# Usage

The provided user's guide belongs to an old version, but it provide some good description of the idea.
New version: "comming soon " <br>

## Basics:
 * Create the parameter space with the corresponding initial mesh <br>
    ```matlab
    ax=[];
    ax(1).val=linspace(-3,3,8);
    ax(2).val=linspace(-3,3,8);
    ax(3).val=linspace(-3,3,8);

    ```
 * Create a _vectorized_ function which will provide the implicit function values for the paremetrs parameter space with the corresponding initial mesh <br>
    ```matlab
    fun=@(ax)[ax(1,:).^2+ax(2,:).^2+ax(3,:).^2-2^2.5   ;...
    sin(ax(1,:))-ax(2,:)];
    ```

   first row is the implicit equation of a sphere  <br>
    second row is the implicit form of "y=sin(x)

* Define the number of iteration<br>
    ```matlab
    Niteration=5; 
    ```
    The initial grid will be devided _Niteration_ times. So the number of points in the final grid it _~2<sup>Niteration</sup>_ times more than in the initial grid. Take care, the large values can easily lead to memory problem. Start around 3.

* Run the Multi-Dimensional Bisection Method <br>
    ```matlab
    mdbm_sol=mdbm(ax,fun,Niteration);
    ```

* The solution can be plotted direcly <br>
    ```matlab
    plot_mdbm(mdbm_sol);
    ```


For advanced options go thorugh the examples!
/More description in the way./


# History

I am an assistant professor at the Budapest University of Technology and Economics, at the Faculty of Mechanical Engineering, the Department of Applied Mechanics.
During my studies and research, I have to determine stability charts of models described by delayed differential equations, which are typically formed as a "3 parameter / 2 implicit equation" problem. I have faced the difficulty that there is no applicable solution in any available software (e.g.: Mathematica, Matlab,...) which could easily be used in engineering problems. 
Due to this reason, I have started to develop the Multi-Dimensional Bisection Method ~10 years ago in Matlab. It has been slowly improved by adding new features.

Best regards,
Dr. Daniel Bachrathy


# Licence: CC BY-NC-ND Licence 
I would like to keep the developement in my hand, but I wellcome all the comments. <br>
<https://creativecommons.org/licenses/by-nc-nd/2.0/>

<img src="by-nc-nd.png"
     alt="CC BY-NC-ND"
     style="float: right; margin-right: 10px; width: 200px;" />


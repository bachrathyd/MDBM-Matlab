# MDBM-Matlab

Multi-Dimensional Bisection Method (MDBM) is an efficient and robust root-finding algorithm, which can be used to determine whole high-dimensional submanifolds (points, curves, surfaces…) of the roots of implicit non-linear equation systems, even in cases, where the number of unknowns surpasses the number of equations.

<a href="https://www.codecogs.com/eqnedit.php?latex=f_i(x_j)=0&space;\quad&space;i=1...k&space;\quad&space;j=1...l,&space;\quad&space;k&space;\leq&space;l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?f_i(x_j)=0&space;\quad&space;i=1...k&space;\quad&space;j=1...l,&space;\quad&space;k&space;\leq&space;l" title="f_i(x_j)=0 \quad i=1...k \quad j=1...l, \quad k \leq l" /></a>

This type of problems can be found in many different field of science, just to mention a few:
- differential geometry (isolines, isosurfaces in higher dimensions)
- analysis of linkages (mechanical: workspace of robots)
- stability computation, stabilyzability diagrams


This method is an alternative to the contour plot or to isosurfaces in higher dimension, however, it has as the advantage of being able to handle multiple functions at once. <br>
In addition, it uses far less function evaluation than the brute-force approach, making it much faster and more memory efficient, especially for complex tasks.


## Introduction

The bisection method - or the so-called interval halving method - is one of the simplest root-finding algorithms which is used to find zeros of continuous non-linear functions.
This method is very robust and it always tends to the solution if the signs of the function values are different at the borders of the chosen initial interval.

Geometrically, root-finding algorithms of __f__(__x__)=0 find one intersection point of the graph of the function with the axis of the independent variable.
In many applications, this 1-dimensional intersection problem must be extended to higher dimensions, e.g.: intersections of surfaces in a 3D space (volume), which can be described as a system on non-linear implicit equations. In higher dimensions, the existence of multiple solutions becomes very important, since the intersection of two surfaces can create multiple intersection curves.

MDBM algorithm canhandle automatically:
- multiple solutions 
- arbitrary number of parameter (typically: 3-6)
- arbitrary number implicit equations
- multiple constraints in the parameter space
- handle degenerated functions
- first order interpolation (and convergence rate)
- provides the gradients of the equations for the roots


## Citing
The software was developed as part of academic research. If you use the MDBM Matlab package as part of your research, teaching, or other work, I would be grateful if you could cite my corresponding publication: <https://pp.bme.hu/me/article/view/1236/640>


## Web:
<https://www.mm.bme.hu/~bachrathy/research_EN.html>
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
Due to this reason, I have started to develop the Multi-Dimensional Bisection Method  sice 2006 in Matlab. It has been slowly improved by adding new features.

Best regards,
Dr. Daniel Bachrathy


# Licence: CC BY-NC-ND Licence 
I would like to keep the developement in my hand, but I wellcome all the comments. <br>
<https://creativecommons.org/licenses/by-nc-nd/2.0/>

<img src="by-nc-nd.png"
     alt="CC BY-NC-ND"
     style="float: right; margin-right: 10px; width: 200px;" />


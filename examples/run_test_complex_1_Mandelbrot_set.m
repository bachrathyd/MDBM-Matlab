
%% Multi-Dimensional Bisection Method
% -1 complex example -
% parameter dimension : 2
%co-dimension (number of equations): 1
%
% Computation based on a iterative function
% of the Mandelbrot-set
% it show how to perform the computation of the function itself is
% complicated


ax=[];
ax(1).val=linspace(-3,1,4);%real axis
ax(2).val=linspace(-1.5,1.5,4);%imag axis

%% extra constant parameters
par=[];
par.iter=500;

mdbm_options=mdbmset('connections',false,'interporder',0);
% interporder is set to zero to use the 'safe selection method', which
% could be important if the solution is not smooth

% number of iteration
Niteration=7;%take care of the exponentially increasing memory consumption


%% function for which the roots are detected
bound_fuction_name='fval_complex_1_Mandelbrot_set';
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_options,par);%zero


figure(101)
plot_mdbm(mdbm_sol);
title('Press a button to create a first order interpolation')
pause
%% set the interporder to 1, to create a first order 'final' interpolation
mdbm_sol.opt.interporder=1;
mdbm_sol=interpolating_cubes(mdbm_sol);
figure(101)
plot_mdbm(mdbm_sol);



title('Press a button to visualize, the axes. Major tick: initial meshsize, Minor tick: refined meshsize')
pause

plot_mdbm(mdbm_sol,[],[],[],[],ax);


%% try this segment multiple times... and have fun!
title('Press a button, then select an area (by two mouse click) to refine that range only (3 times).')
pause
[xy]=ginput(2);
xy=sort(xy,1);
mdbm_sol.opt.refinetype='pos';
for k=1:5
mdbm_sol=refine(mdbm_sol,[[1;2],xy']); %refinement
mdbm_sol=interpolating_cubes(mdbm_sol); %interpolation of the new points
end
figure(101)
plot_mdbm(mdbm_sol,[],[],[],[],ax);


title('Press a button to check the neighbours.')
pause
mdbm_sol.opt.interporder=0;
mdbm_sol=checkneighbour(mdbm_sol); %neighbour check
mdbm_sol.opt.interporder=1;
mdbm_sol=interpolating_cubes(mdbm_sol); %interpolation of the new points
plot_mdbm(mdbm_sol,[],[],[],[],ax);
title('Done.')
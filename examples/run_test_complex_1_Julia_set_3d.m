
%% Multi-Dimensional Bisection Method
% -1 complex example -
% parameter dimension : 2
% co-dimension (number of equations): 1
%
% Computation based on a iterative function
% of the Julia-set
% it show how to perform the computation of the function itself is complicated


% Julia set with 
% abs(c)=1 (unitariy disc)

ax=[];
ax(1).val=linspace(-2,2,14);%z0 real axis
ax(2).val=linspace(-1.5,1.5,14);%z0 imag axis
ax(3).val=linspace(2,4,14);%angle of c 

%% extra constant parameters
par=[];
par.iter=500;%number of iteration during the mapping of Julia set
mdbm_options=mdbmset('connections',false,'interporder',0,'timelimit',Inf);
mdbm_sol=mdbm(ax,'fval_complex_1_Julia_set_3d',4,mdbm_options,par);%zero

%% The next part to perform the connenction for surface plotting
% Note, It might take a long time.
mdbm_sol.opt.interporder=1;
mdbm_sol=interpolating_cubes(mdbm_sol);
mdbm_sol=DTconnect(mdbm_sol);
%%

figure(101),clf
Numerofinterpolation=0;%presenting the numerical results without interpolation, (see the help of plot_mdbm
plot_mdbm(mdbm_sol,[],[],[],[],[],0);
shading interp
lighting flat
view([-60,37])
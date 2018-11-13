
%% Multi-Dimensional Bisection Method
% -6 basic example -
% parameter dimension : 3
%co-dimension (number of equations): 3

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,4,7);
ax(2).val=linspace(-3,4,7);
ax(3).val=linspace(-3,4,7);

% number of iteration
Niteration=5;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
bound_fuction_name='fval_basic_6_pardim3_codim3';

mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);

figure(6)
plot_mdbm(mdbm_sol);
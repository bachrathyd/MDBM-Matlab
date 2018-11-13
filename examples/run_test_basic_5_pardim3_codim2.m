
%% Multi-Dimensional Bisection Method
% -5 basic example -
% parameter dimension : 3
%co-dimension (number of equations): 2

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,3);
ax(2).val=linspace(-3,3,3);
ax(3).val=linspace(-3,3,3);

% number of iteration
Niteration=5;%take care, the large values can easily lead to memory problem
par.k=3;

%% function for which the roots are detected
bound_fuction_name='fval_basic_5_pardim3_codim2';

mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,[],par);

figure(5)
plot_mdbm(mdbm_sol,'k');


%% Multi-Dimensional Bisection Method
% -8 basic example -
% parameter dimension : 4
%co-dimension (number of equations): 2

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,3);%x
ax(2).val=linspace(-3,3,3);%y
ax(3).val=linspace(-3,3,3);%z
ax(4).val=linspace(1,2,2);%r


% number of iteration
Niteration=4;%take care, the large values can easily lead to memory problem
%% function for which the roots are detected
bound_fuction_name='fval_basic_8_pardim4_codim2';

mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);%zero

figure(8)
ghendle=plot_mdbm(mdbm_sol);
set(ghendle,'LineStyle','none')

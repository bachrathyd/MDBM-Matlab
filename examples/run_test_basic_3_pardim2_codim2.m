
%% Multi-Dimensional Bisection Method
% -3 basic example -
% parameter dimension : 2
%co-dimension (number of equations): 2

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,8);
ax(2).val=linspace(-3,3,8);

% number of iteration
Niteration=7;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
% bound_fuction_name='fval_basic_3_pardim2_codim2';
fun=@(ax)[ax(1,:).^2+ax(2,:).^2-2^2   ;...
    ax(1,:)-ax(2,:)];

mdbm_sol=mdbm(ax,fun,Niteration);

figure(3)
plot_mdbm(mdbm_sol);
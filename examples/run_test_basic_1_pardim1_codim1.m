
%% Multi-Dimensional Bisection Method
% -1 basic example -
% parameter dimension : 1
%co-dimension (number of equations): 1

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-4,5,11);

% number of iteration aw
Niteration=7;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
bound_fuction_name='fval_basic_1_pardim1_codim1';

mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);
figure(1)
solgraphand=plot_mdbm(mdbm_sol,'b');
%--------------------------
%the sin(x) function, too
hold on
x=linspace(-4,5,1000);
plot(x,sin(x),'r-')

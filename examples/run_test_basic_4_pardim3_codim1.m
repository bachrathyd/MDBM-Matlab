
%% Multi-Dimensional Bisection Method
% -4 basic example -
% parameter dimension : 3
%co-dimension (number of equations): 1

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,3);
ax(2).val=linspace(-3,3,3);
ax(3).val=linspace(-3,3,3);

% number of iteration
Niteration=2;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
bound_fuction_name='fval_basic_4_pardim3_codim1';
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);

ghendle=plot_mdbm(mdbm_sol,[],[],1);
set(ghendle,'Marker','*')
set(ghendle,'LineWidth',3)
figure(4)
hold on
plot_mdbm(mdbm_sol);
shading interp
lighting flat
light('Position',[1 -1 -15],'Style','infinite');
light('Position',[1 -1 25],'Style','infinite');
light('Position',[10 10 10],'Style','infinite');
light('Position',[-10 -10 -10],'Style','infinite');
view(3)
%% simples example
%% Multi-Dimensional Bisection Method
% github example
% parameter dimension : 3
%co-dimension (number of equations): 2
%Eq.(1) x^2+y^2+z^2=r^2
%Eq.(2) : y=sin(x)

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,8); %x
ax(2).val=linspace(-3,3,8); %y
ax(3).val=linspace(-3,3,8); %z

% number of iteration
Niteration=5;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
r=2.5;
fun=@(ax)[ax(1,:).^2+ax(2,:).^2+ax(3,:).^2-r^2   ;...Eq.(1) :x^2+y^2+z^2-2^2=0
    sin(ax(1,:))-ax(2,:)];%Eq.(2) :sin(x)-y=0
figure
mdbm_sol=mdbm(ax,fun,Niteration);
plot_mdbm(mdbm_sol);
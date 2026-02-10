
%% Multi-Dimensional Bisection Method
% -2 complex example -
% parameter dimension : 3
%co-dimension (number of equations): 1-2
%
% computation of the catastrophe surface
% (see: nonlinear equation of an inverted pendulum)
% This example show, how to plot special sections of a surface
% as co-dimension 2 problem, and how to present them, togethet with the
% gradient of the functions


%% definition of the parameter space
%the limits and the initial mesh

%firt axis
aN=5;%25;%[db]
amin=-3.5;
amax=2.5;
aaxis=linspace(amin,amax,aN);

%second axis
bN=5;%25;%[db]
bmin=-2.51;%Note, that perfectly symmetrix axis, usually leads to hitting degenerated poitns
bmax=2.5;
baxis=linspace(bmin,bmax,bN);

%third axis
xN=5;%25;%[db]
xmin=-2.01;
xmax=2.0;
xaxis=linspace(xmin,xmax,xN);

ax=[];
ax(1).val=aaxis;
ax(2).val=baxis;
ax(3).val=xaxis;


%% number of iteration
Niteration=4;

%% function for which the roots are detected

%empty parameter set
par=[];
mdbm_sol=mdbm(ax,@catastrophe_surface,Niteration,[],par);%zero

figure(102),clf
plot_mdbm(mdbm_sol,[],[],[],1);
colormap gray
shading interp
view([-210,20])
grid on

%% 
par=[];
par.direc=1;%along a axis

for ka=(-3:0.5:2)
par.val=ka;
mdbm_sol=mdbm(ax,@catastrophe_surface,Niteration,[],par);%zero

plot_mdbm(mdbm_sol,'b');
drawnow
end


%% 
par=[];
par.direc=2;%along a axis

for kb=(-1.5:0.5:1.5)
par.val=kb;
mdbm_sol=mdbm(ax,@catastrophe_surface,Niteration,[],par);%zero

plot_mdbm(mdbm_sol,'g');
drawnow
end


%%
par=[];
par.direc=3;

mdbm_sol=mdbm(ax,@catastrophe_surface,Niteration,[],par);%zero

graph=plot_mdbm(mdbm_sol,'r',[],[],1);
set(graph(1),'LineWidth',5)
set(graph(2),'Color',[1,1,0])
set(graph(3),'Color',[0,1,1])
drawnow

xlabel('a')
ylabel('b')
zlabel('x')

alpha 0.5


function [fun_val]=catastrophe_surface(ax,par)
%initialization
if isempty(par)
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(1,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
elseif par.direc==1  %section along a - axis
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=a-par.val;
elseif par.direc==2 %section along b - axis
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=b-par.val;  
elseif par.direc==3%critical values
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=a.*cos(x)+1;%df1/dx=0
end
end
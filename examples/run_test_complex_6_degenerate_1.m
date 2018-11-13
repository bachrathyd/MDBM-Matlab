%Representation of the function

[x,y]=ndgrid(linspace(-4,4,50),linspace(-4,4,50));
z= y.*sin((abs(x+1)-abs(x-1)-2*x))+...
    atan(abs(y+1)-abs(y-1)-2*y);
% z= ((abs(x+1)-abs(x-1)-2*x))+...
%     (abs(y+1)-abs(y-1)-2*y);
figure(1)
clf
hold on

resultsurf=surface(x,y,z);
shading interp
alpha 0.4
view(73,36)
set(resultsurf,'EdgeColor',[0.75,0.75,0.75]);
%---------------MDBM solution in case of degenare function
ax=[];
%tolerance problem
ax(1).val=linspace(-4,4.00245335,3);
ax(2).val=linspace(-4,4.0015245,3);
% ax(1).val=linspace(-4,4,3);
% ax(2).val=linspace(-4,4,3);

bound_fuction_name='fval_complex_6_degenerate_1';
mdbm_opts=mdbmset('zerotreshold',1e-10);
Niteration=5;% number of iteration
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_opts);

hold on
plotobject=plot_mdbm(mdbm_sol,'k',[],[],1);

set(plotobject(1),'LineWidth',3)

% Triangulated degenerate surface sements

%plotting all the point where the function is evaluated
evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
X=evalpos(1,:);
Y=evalpos(2,:);
Z=mdbm_sol.HC;

epsilon=mdbm_sol.opt.zerotreshold;
hold on
plot3(X(Z>epsilon),Y(Z>epsilon),Z(Z>epsilon),'r.')
plot3(X(Z<-epsilon),Y(Z<-epsilon),Z(Z<-epsilon),'g.')
plot3(X(abs(Z)<epsilon),Y(abs(Z)<epsilon),Z(abs(Z)<epsilon),'m.')
view(73,36)
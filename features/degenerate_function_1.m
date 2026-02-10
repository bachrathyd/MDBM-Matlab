%Representation of the function (explicit in this casae)

[x,y]=ndgrid(linspace(-4,4,50),linspace(-4,4,50));
z= y.*sin((abs(x+1)-abs(x-1)-2*x))+...
    atan(abs(y+1)-abs(y-1)-2*y);
% z= ((abs(x+1)-abs(x-1)-2*x))+...
%     (abs(y+1)-abs(y-1)-2*y);
figure(1)
clf
subplot(1,2,1)
hold on

resultsurf=surface(x,y,z);
shading interp
alpha 0.4
view(73,36)
set(resultsurf,'EdgeColor',[0.75,0.75,0.75]);

hold on
espi=1e-12 %treating the numerical errors
contour(x,y,z,[-espi,0,epsi],'k','LineWidth',3)
title('Explicit degenerate function, BruteForce and counture plot')
%% ---------------MDBM solution in case of degenare function
ax=[];
%tolerance problem
ax(1).val=linspace(-4,4.00245335,3);
ax(2).val=linspace(-4,4.0015245,3);
% ax(1).val=linspace(-4,4,3);
% ax(2).val=linspace(-4,4,3);

bound_fuction_name=@foo_degenerate_1;
mdbm_opts=mdbmset('zerotreshold',1e-10);
Niteration=5;% number of iteration
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_opts);
subplot(1,2,2)
plotobject=plot_mdbm(mdbm_sol,[],[],2,[],[],0);% 2 is for surface elemnts, the last zero for "no interpolation of the solution"
shading interp
hold on
plotobject=plot_mdbm(mdbm_sol,'k',[],1,[],[],0);% 1 is for line elemnts, the last zero for "no interpolation of the solution"
set(plotobject(1),'LineWidth',2)

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
title('MDBM soltuion')
legend({'sol','gradient', 'evaluated +', 'evaluated -', 'evaluated ~zero' },'Location','northoutside','NumColumns',2)

function Z=foo_degenerate_1(ax)
%% version 1: simple calculate the function value(s) for each parameter points
Z=zeros(1,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    
    x1=abs(x+1)-abs(x-1)-2*x;
    y1=abs(y+1)-abs(y-1)-2*y;

    Z(k)=y*sin(x1)+atan(y1);

end

end
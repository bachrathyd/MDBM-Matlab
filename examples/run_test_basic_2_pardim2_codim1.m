%% Multi-Dimensional Bisection Method
% -2 basic example -
% parameter dimension : 2
%co-dimension (number of equations): 1

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,3);
ax(2).val=linspace(-3,3,3);

% number of iteration
Niteration=9;%take care, the large values can easily lead to memory problem

%% function for which the roots are detected
bound_fuction_name='fval_basic_2_pardim2_codim1';

mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);
figure(2)
plotobject=plot_mdbm(mdbm_sol,'k');
set(plotobject,'LineWidth',2)


%plotting all the point where the function is evaluated
evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
X=evalpos(1,:);
Y=evalpos(2,:);
Z=mdbm_sol.HC;
hold on
plot3(X(Z>0),Y(Z>0),Z(Z>0),'r.')
plot3(X(Z<0),Y(Z<0),Z(Z<0),'g.')
plot3(X(Z==0),Y(Z==0),Z(Z==0),'m+')
view(2)
%%----- Check the radius error for different final interpolation order ----
disp('The lagrest deviance from the object')
colorslegened='rgb';
for InterpolationOrder=0:2
    
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbmset('interporder',InterpolationOrder,'cornerneighbours',1));
radiuserror(InterpolationOrder+1)=max(abs((mdbm_sol.posinterp(1,:).^2+mdbm_sol.posinterp(2,:).^2).^0.5-2));
figure(2222)
hold on
plot_mdbm(mdbm_sol,colorslegened(InterpolationOrder+1));
end
legend(...
{['final interpolation order: 0 , maximal radius error: ',num2str(radiuserror(1))],...
['final interpolation order: 1 , maximal radius error: ',num2str(radiuserror(2))],...
['final interpolation order: 2 , maximal radius error: ',num2str(radiuserror(3))]})
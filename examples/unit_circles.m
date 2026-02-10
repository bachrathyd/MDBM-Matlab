
%% Multi-Dimensional Bisection Method
% -4 complex example -
% parameter dimension : 3
%co-dimension (number of equations): 1
%
% plotting the unit "circles" for different norms (metrics)


%% definition of the parameter space
%the limits and the initial mesh



ax=[];
ax(1).val=linspace(-1.5,1.5,5);%x
ax(2).val=linspace(-1.5,1.5,5);%y
ax(3).val=linspace(0.4,4,4);% norm

unit_circle=@(x,y,p) abs(x).^p+ abs(y).^p - 1.0.^p

foo_3d=@(ax) unit_circle(ax(1,:),ax(2,:),ax(3,:))

mdbm_sol=mdbm(ax,foo_3d,4);


%%

figure(104)
clf
plot_mdbm(mdbm_sol,[],[3,1,2],2);%plot the surface, 
shading interp
alpha 0.6
colormap spring
hold on
%graphhandel=plot_mdbm(mdbm_sol,'k');%plot the computed points
%set(graphhandel,'Marker','.')
%set(graphhandel,'LineWidth',1)
xlabel('value of the norm')
ylabel('x')
zlabel('y')
view(3)
drawnow


%% draw only sections
ax=[]
ax(1).val=linspace(-1.5,1.5,5);%x
ax(2).val=linspace(-1.5,1.5,5);%y

for p_loc=0.2505:0.25:3.5
foo_2d_fix_p = @(ax) unit_circle(ax(1,:),ax(2,:),p_loc);
mdbm_sol_section=mdbm(ax,foo_2d_fix_p,6);
x=mdbm_sol_section.posinterp(1,:);
y=mdbm_sol_section.posinterp(2,:);
plot3(p_loc*ones(1,length(x)),x,y,'k.')
drawnow
end
legend('surfaces','computed pont','secions at p=0.5:0.5:3.5','Location','northoutside')


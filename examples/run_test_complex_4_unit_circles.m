
%% Multi-Dimensional Bisection Method
% -4 complex example -
% parameter dimension : 3
%co-dimension (number of equations): 1
%
% plotting the unit "circles" for different norms (metrics)


%% definition of the parameter space
%the limits and the initial mesh


ax=[];
ax(1).val=linspace(-1.5,1.5,4);%x
ax(2).val=linspace(-1.5,1.5,4);%y
ax(3).val=linspace(0.4,4,4);% norm

par=[];
mdbm_sol=mdbm(ax,'fval_complex_4_unit_circles',4,[],par);


%%

figure(104)
clf
plot_mdbm(mdbm_sol,[],[3,1,2],2);%plot the surface
shading interp
alpha 0.6
colormap spring
hold on
graphhandel=plot_mdbm(mdbm_sol,'k',[3,1,2],0);%plot the computed points
set(graphhandel,'Marker','.')
set(graphhandel,'LineWidth',1)
xlabel('value of the norm')
ylabel('x')
ylabel('y')
view(3)
drawnow

for par=0.5:0.5:3.5
mdbm_sol_section=mdbm(ax,'fval_complex_4_unit_circles',6,[],par);
graphhandel=plot_mdbm(mdbm_sol_section,'b',[3,1,2]);%plot the computed points
set(graphhandel,'LineWidth',3)
drawnow
end
legend('surfaces','computed pont','secions at p=0.5:0.5:3.5','Location','northeast')
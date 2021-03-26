%% Multi-Dimensional Bisection Method
% -example to a pure continuation
% this is not the good way to use the MDBM, for this there are good 
% alternatives. However, this example shows well, how efficinetly can it
%follow the submanifold of the solution.



%% PART 1 the method as it should be presented in the MDBM
% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,5);
ax(2).val=linspace(-3,3,5);
ax(3).val=linspace(-3,3,5);
% function for which the roots are detected
f1=@(xyz) sum(abs(xyz).^3,1)-1.5^3;
f2=@(xyz) xyz(3,:)-sin(-xyz(1,:)*8);
bound_fuction=@(xyz) [f1(xyz);f2(xyz)];

mdbm_sol=mdbm(ax,bound_fuction,6);
figure(31415),clf
subplot(1,2,1)
plot_mdbm(mdbm_sol);
title(['Number of evaluated points: ',num2str(length(mdbm_sol.linindex))])
%%

%% PART 2: findin a single solution, and make a continuation from there
% Note: in this case the closed solution can not be detected!!!

%first, find a signle solution point with any method
xyz0=fminsearch(@(xyz) norm(bound_fuction(xyz)),[1;1;1]);
figure(31415),subplot(1,2,1), hold on
plot3(xyz0(1),xyz0(2),xyz0(3),'ro','LineWidth',4)

%second, make a very small volume around it, and start the MDBM
epsi=0.05;
ax=[];
for k=1:3
ax(k).val=linspace(xyz0(k)-epsi,xyz0(k)+epsi,2);
end

mdbm_sol_contin=mdbm(ax,bound_fuction,1);

% third, extend the grid with high resolution
for k=1:3
    mdbm_sol_contin=extend_axis(mdbm_sol_contin,k,-3:epsi:(xyz0(k)-2*epsi),(xyz0(k)-2*epsi):epsi:3);
end
mdbm_sol_contin=interpolating_cubes(mdbm_sol_contin); %interpolation of the new points
mdbm_sol_contin=checkneighbour(mdbm_sol_contin);%interpolation of the new points
mdbm_sol_contin=DTconnect(mdbm_sol_contin);
figure(31415),subplot(1,2,2)
plot_mdbm(mdbm_sol_contin);
title(['Number of evaluated points: ',num2str(length(mdbm_sol_contin.linindex))])

msgbox('Note, that much less point is needed, but in this case you cannot find, multiple closed curves automatically!','Warning')
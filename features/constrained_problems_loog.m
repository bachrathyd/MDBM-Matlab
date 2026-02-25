%% MDBM Feature: Constrained Problems (Anonymous Function Approach)
% This version demonstrates how to use constraints
% mdbm_options.isconstrained = true, then the last element of the output is
% treated as a constraint (solution is calculated only at the positive side

% --- Definition of Individual Components ---
% Objective functions (sphere)
foo_1 = @(ax) ax(1,:).^4+ax(2,:).^4+ax(3,:).^4 - 1.0;
foo_2 = @(ax) sin(ax(1,:).^2+ax(2,:)/2)+ax(2,:)+4*ax(3,:)- 0.5;

% Constraint: a shifted cylinder (note, outside is positive)
coo_cylinder = @(ax) (ax(1,:)+0.5).^2+(ax(2,:)-1).^2 - 1.0^2;
% --- Setup Parameter Space ---
ax=[];
ax(1).val = linspace(-2,2,10);
ax(2).val = linspace(-2,2,10);
ax(3).val = linspace(-1,1.5,10);

% setting the options fields
mdbm_options = mdbmset( );

figure(107); clf; hold on;
subplot(1,2,1)
%% 1. Plotting the sphere only
mdbm_options.isconstrained = true;
mdbm_sol_f1c = mdbm(ax, @(x) [foo_1(x);coo_cylinder(x)], 3, mdbm_options);
gh = plot_mdbm(mdbm_sol_f1c, 'g');
set(gh, 'LineStyle', 'none'); alpha 0.1;
hold on
mdbm_sol_f2c = mdbm(ax, @(x) [foo_2(x);coo_cylinder(x)], 3, mdbm_options);
gh = plot_mdbm(mdbm_sol_f2c, 'b');
set(gh, 'LineStyle', 'none'); alpha 0.1;
view(3)
drawnow


%% 2. Plotting the constraints only
mdbm_options.isconstrained = false;
mdbm_sol_c = mdbm(ax,coo_cylinder, 4, mdbm_options);
hold on
gh = plot_mdbm(mdbm_sol_c, 'r');
set(gh, 'LineStyle', 'none'); alpha 0.2;
drawnow
%% 3. Plotting Function with Constraints
mdbm_options.isconstrained = true;
mdbm_options.connections=0;
foo_f1f2c=@(x) [foo_1(x);foo_2(x);coo_cylinder(x)]
tic
mdbm_sol_f1f2c = mdbm(ax, foo_f1f2c, 8, mdbm_options);
tCPU=toc;
gh = plot_mdbm(mdbm_sol_f1, 'k');
set(gh, 'LineWidth', 4);
title({"Multiple Implicit Equations","with constraint"})
legend('f1 - c', 'f2 - c','f1&f2 - c','c', 'Location', 'northeast');
drawnow
view([-85,45])
xlabel("x")
ylabel("y")
zlabel("z")

subplot(1,2,2)
gh = plot_mdbm(mdbm_sol_f1, 'k');
set(gh, 'LineWidth', 4);
hold on
title({"CPU time: "+tCPU+"s","Grid resolution:","["+NaxN(1)+"x"+NaxN(2)+"x"+NaxN(3)+"]"})
legend('c', 'Location', 'northeast');

grid on; 

xlabel("x")
ylabel("y")
zlabel("z")

functino_call_rate_to_BF=prod(mdbm_sol_f1f2c.opt.NaxN)/length(mdbm_sol_f1f2c.linindex)
view([-85,45])
text(-1,1.75,-1,{functino_call_rate_to_BF+"x less"})
text(-1,1.75,-1.5,{"function call than"})
text(-1,1.75,-2,{" Brute Force"})


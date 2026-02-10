%% MDBM Feature: Constrained Problems (Anonymous Function Approach)
% This version demonstrates how to use constraints
% mdbm_options.isconstrained = ture, than the lase element of the output is
% treated as a constarint (solution is calculated only at the positive side

% --- Definition of Individual Components ---
% Objective functions (sphere)
foo_sphere = @(ax) ax(1,:).^2+ax(2,:).^2+ax(3,:).^2 - 1.0;

% Constraint: a shifted cylinder (note, outside is positive)
coo_cylinder = @(ax) (ax(1,:)+0.5).^2+ax(2,:).^2 - 0.5^2;



% --- Setup Parameter Space ---
ax=[];
ax(1).val = linspace(-2,2,7);
ax(2).val = linspace(-2,2,7);
ax(3).val = linspace(-2,2,7);

% setting the options fies
mdbm_options = mdbmset( );

figure(107); clf; hold on;
subplot(1,2,1)
%% 1. Plotting the shpere olny Only
mdbm_options.isconstrained = false;
mdbm_sol_c = mdbm(ax, foo_sphere, 3, mdbm_options);
gh = plot_mdbm(mdbm_sol_c, 'r');
set(gh, 'LineStyle', 'none'); alpha 0.1;
view(3)
drawnow


%% 2. Plotting the constraints only
mdbm_options.isconstrained = false;
mdbm_sol_f1 = mdbm(ax,coo_cylinder, 3, mdbm_options);
hold on
gh = plot_mdbm(mdbm_sol_f1, 'b');
set(gh, 'LineStyle', 'none'); alpha 0.2;
drawnow

legend('function', 'Constrain');

subplot(1,2,2)
%% 3. Plotting Function with Constraints
mdbm_options.isconstrained = true;
mdbm_sol_f1 = mdbm(ax, @(x) [foo_sphere(x); coo_cylinder(x)], 4, mdbm_options);
gh = plot_mdbm(mdbm_sol_f1, 'g');
set(gh, 'LineStyle', 'none'); alpha 0.2;
drawnow

legend('Constrained function');

grid on; 


%% MDBM Feature: Constrained Problems (Anonymous Function Approach)
% This version demonstrates how to define individual functions separately
% and combine them on-the-fly for different MDBM runs. 
% This is very flexible for testing various combinations of constraints 
% and objective functions.

% --- Definition of Individual Components ---
% Objective functions (surfaces)
fun1 = @(ax) sin(ax(1,:)*2 + ax(2,:) + ax(3,:)) - 0.1*ax(2,:).^2 - 0.5*ax(3,:) - 0.5;
fun2 = @(ax) ax(2,:) - ax(3,:) - 0.2;

% Individual constraints (feasible where > 0)
sphere1 = @(ax) (ax(1,:)+1).^2 + ax(2,:).^2 + (ax(3,:)+0.5).^2 - 1.5^2;
sphere2 = @(ax) (ax(1,:)-0.5).^2 + (ax(2,:)-1).^2 + ax(3,:).^2 - 1.5^2;

% Combined constraint (intersection of feasible regions)
all_const = @(ax) min([sphere1(ax); sphere2(ax)], [], 1);


% --- Setup Parameter Space ---
ax=[];
ax(1).val = linspace(-3,3,7);
ax(2).val = linspace(-3,3,7);
ax(3).val = linspace(-3,3,7);

figure(107); clf; hold on;
% setting the options fies
mdbm_options = mdbmset( );


%% 1. Plotting the Constraint Boundary Only
% We combine the constraint function itself as the objective.
% Note: We set isconstrained to false to see the whole boundary.
fprintf('Computing constraint boundary...');
mdbm_options.isconstrained = false;
mdbm_sol_c = mdbm(ax, @(x) all_const(x), 3, mdbm_options);
gh = plot_mdbm(mdbm_sol_c, 'r');
set(gh, 'LineStyle', 'none'); alpha 0.1;
view(3)
drawnow


%% 2. Plotting Function 1 with Constraints
% We combine [fun1; all_const] and set isconstrained to true.
% MDBM will treat the last row (all_const) as the constraint.
fprintf('Computing Fun 1 with constraints...');
mdbm_options.isconstrained = true;
mdbm_sol_f1 = mdbm(ax, @(x) [fun1(x); all_const(x)], 4, mdbm_options);
gh = plot_mdbm(mdbm_sol_f1, 'b');
set(gh, 'LineStyle', 'none'); alpha 0.2;
drawnow
%% 2. Plotting Function 2 with Constraints
% We combine [fun2; all_const] and set isconstrained to true.
% MDBM will treat the last row (all_const) as the constraint.
fprintf('Computing Fun 2 with constraints...');
mdbm_options.isconstrained = true;
mdbm_sol_f1 = mdbm(ax, @(x) [fun2(x); all_const(x)], 4, mdbm_options);
gh = plot_mdbm(mdbm_sol_f1, 'g');
set(gh, 'LineStyle', 'none'); alpha 0.2;
drawnow


%% 3. Plotting the Intersection (Fun 1 & Fun 2) with Constraints
% We combine [fun1; fun2; all_const]. The last row is always the constraint.
fprintf('Computing intersection with constraints...');
mdbm_options.isconstrained = true;
mdbm_sol_f12 = mdbm(ax, @(x) [fun1(x); fun2(x); all_const(x)], 6, mdbm_options);
gh = plot_mdbm(mdbm_sol_f12, 'k');

set(gh, 'LineWidth', 3)
drawnow


% Final styling
legend('Constraint Boundary', 'Surface 1 (Constrained)', 'Intersection (Constrained)', 'Location', 'northoutside');
title('MDBM: Flexible Anonymous Function Composition');
grid on; 


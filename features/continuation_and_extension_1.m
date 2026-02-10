
%% MDBM Feature: Axis Extension and Submanifold Continuation
% This example demonstrates how to dynamically extend the parameter space
% and how to perform continuation of a solution submanifold.
% This is useful when the initial range is too small or when following a
% specific branch of a solution.

%% Example 1: Extending a too small initial range
fprintf('--- Example 1: Range Extension ---');

% Initial parameter space (too small to contain the full solution)
ax=[];
ax(1).val=linspace(-3,1,5);
ax(2).val=linspace(-3,1,7);

% Function: a non-smooth boundary
f_range = @(xy) abs(xy(1,:)-0.271).^0.2 + abs(xy(2,:)-0.314).^0.2 - 5^0.3;

fprintf('Performing initial MDBM iterations...');
mdbm_sol = mdbm(ax, f_range, 3);

figure(1); clf;
subplot(1,2,1);
plot_mdbm(mdbm_sol, 'k', [], [], [], mdbm_sol.ax);
title('Initial small range');
view(2); grid on;

%% Extension of the first axis
fprintf('Extending axis 1...');
mdbm_sol = extend_axis(mdbm_sol, 1, [], 1.1:0.1:6);
subplot(1,2,2); cla;
plot_mdbm(mdbm_sol, 'k', [], [], [], mdbm_sol.ax);
title('Range Extension (Axis 1)'); view(2); grid on; drawnow;

%% Extension of the second axis by adding just one point (to be refined later)
fprintf('Extending axis 2 and refining...');
mdbm_sol = extend_axis(mdbm_sol, 2, [], 5);
subplot(1,2,2); cla;
plot_mdbm(mdbm_sol, 'k', [], [], [], mdbm_sol.ax);
title('Range Extension (Axis 1 & 2)'); view(2); grid on; drawnow; pause(0.5);

%% Repeated refinement of the newly added area
for k=1:5
    fprintf('Refinement step %d...', k);
   % refinet based on coodinate value ('pos')
   % [2,1.0,4.0] hase the meaining
   % 2-> second axis, refinement only between 1.0 and 4.0
    mdbm_sol = refine(mdbm_sol, [2, 1.0, 4.0], 'pos'); 
    mdbm_sol = interpolating_cubes(mdbm_sol);
    mdbm_sol = checkneighbour(mdbm_sol);
    mdbm_sol = DTconnect(mdbm_sol);
    
    subplot(1,2,2); cla;
    plot_mdbm(mdbm_sol, 'k', [], [], [], mdbm_sol.ax);
    title(['Extended and refined range (step ', num2str(k), ')']);
    view(2); grid on; drawnow; pause(0.5);
end

plotthecomputedpoints(mdbm_sol)

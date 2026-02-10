%% MDBM Feature: Neighbor Check
% This example demonstrates the importance of the 'checkneighbour' option.
% The neighbor check ensures that all connected components of the solution 
% are found, even if they are not intersected by the initial coarse mesh.
% It also helps in following the solution branch into neighboring cells.

% Parameter space and objective function
ax=[];
ax(1).val = linspace(-7, 7, 5); % x
ax(2).val = linspace(-7, 7, 5); % y

% A complex function with multiple branches
func = @(ax) sum([abs(sin(ax(1,:))+ax(1,:)+ax(2,:)).^0.5; abs(ax(2:end,:)-0.5).^0.5], 1).^2 - 5;

figure(201); clf;

% --- Part 1: No Neighbor Check ---
% Without neighbor check, some parts of the solution might be missed if they
% don't cross the grid lines of the current refinement level.
fprintf('Running MDBM without neighbor check...\n');
subplot(2,2,1);
mdbm_sol_no = mdbm(ax, func, 6, mdbmset('checkneighbour', 0));
plot_mdbm(mdbm_sol_no); view(2); grid on;
title({'No neighbor check', ['Function evaluations: ', num2str(length(mdbm_sol_no.linindex))]});
drawnow; pause(1);

% --- Part 2: Automatic Neighbor Check at each step ---
% This is the most robust way. At each iteration, MDBM checks if the solution
% continues into any neighbor cells that were not yet identified.
fprintf('Running MDBM with automatic neighbor check at every step (step-by-step)...\n');
subplot(2,2,2);
mdbm_sol_auto = mdbm(ax, func, 0, mdbmset('checkneighbour', Inf)); % initialization
for kiter = 1:6
    mdbm_sol_auto = mdbm(mdbm_sol_auto, 1); % one step refinement
    subplot(2,2,2); cla;
    plot_mdbm(mdbm_sol_auto, [], [], [], [], ax); view(2); grid on;
    title({['Automatic neighbor check at every step (Step ', num2str(kiter), ')'], ...
           ['Function evaluations: ', num2str(length(mdbm_sol_auto.linindex))]});
    drawnow; pause(1);
end

% --- Part 3: Procedure of neighbor check only at the end ---
% You can also perform the neighbor check manually after the iterations.
fprintf('Running manual neighbor check at the end...\n');
subplot(2,2,3);
mdbm_sol_manual = mdbm(ax, func, 6, mdbmset('checkneighbour', 0));
plot_mdbm(mdbm_sol_manual); view(2); title('Before manual check');
drawnow; pause(0.01);

% Perform manual neighbor check until no new cells are found
kstep = 0;
while true
    kstep = kstep + 1;
    n_before = length(mdbm_sol_manual.linindex);
    mdbm_sol_manual.opt.checkneighbour = 1; % allow 1 step of check
    mdbm_sol_manual = checkneighbour(mdbm_sol_manual);
    mdbm_sol_manual = interpolating_cubes(mdbm_sol_manual);
    mdbm_sol_manual = DTconnect(mdbm_sol_manual);
    
    n_after = length(mdbm_sol_manual.linindex);
    if n_after == n_before, break; end
    
    subplot(2,2,3); cla;
    plot_mdbm(mdbm_sol_manual, [], [], [], [], ax); view(2); grid on;
    title({['Neighbor check at the end: step ', num2str(kstep)], ...
           ['Function evaluations: ', num2str(n_after)]});
    drawnow; pause(0.001);
end

subplot(2,2,4);
plot_mdbm(mdbm_sol_auto, 'k', [], [], [], ax); view(2); grid on;
title('Final robust solution');
drawnow;



%% MDBM Feature: Axis Extension and Submanifold Continuation
% This example demonstrates how to dynamically extend the parameter space
% and how to perform continuation of a solution submanifold.
% This is useful when the initial range is too small or when following a
% specific branch of a solution.



%% Example 2: Pure Continuation from a single point
fprintf('--- Example 2: Pure Continuation ---');
% This shows how to start from a single solution point and follow the submanifold.

% 3D parameter space
ax_c=[];
ax_c(1).val=linspace(-3,3,3);
ax_c(2).val=linspace(-3,3,3);
ax_c(3).val=linspace(-3,3,3);

% Two functions defining a 1D submanifold (curve) in 3D
f1 = @(xyz) sum(abs(xyz).^3,1) - 1.5^3;
f2 = @(xyz) xyz(3,:) - sin(-xyz(1,:)*8);
bound_fuction = @(xyz) [f1(xyz); f2(xyz)];

% 1. Find a single solution point (e.g., using fminsearch)
xyz0 = fminsearch(@(xyz) norm(bound_fuction(xyz)), [1;1;1]);

%% 2. Create a very small initial volume around this point
epsi = 0.05;
ax_start = [];
for k=1:3
    ax_start(k).val = linspace(xyz0(k)-epsi, xyz0(k)+epsi, 2);
end

fprintf('Starting continuation from point: [%.2f, %.2f, %.2f]', xyz0(1), xyz0(2), xyz0(3));
% creating the correspoing mdbm object
mdbm_sol_contin = mdbm(ax_start, bound_fuction, 1);

% 3. Extend the grid in all directions to follow the curve
for k=1:3
    mdbm_sol_contin = extend_axis(mdbm_sol_contin, k, -3:epsi:(xyz0(k)-2*epsi), (xyz0(k)+2*epsi):epsi:3);
end

% Update the solution for the new extended axes
mdbm_sol_contin = interpolating_cubes(mdbm_sol_contin);%initialization
mdbm_sol_contin = checkneighbour(mdbm_sol_contin);% this will create the magic : pure continuation
mdbm_sol_contin = DTconnect(mdbm_sol_contin);%connection of the poitns

figure(2); clf;
% --- Continuation Method Plots ---
% Solution
ax2loc(1) = subplot(2,2,1);
gh=plot_mdbm(mdbm_sol_contin);
set(gh, 'LineWidth',3);
title(['Continuation: Solution']);
grid on; view(3);
hold on
plot3(xyz0(1),xyz0(2),xyz0(3),'r','Marker','o','MarkerSize',8,'LineWidth',4)
legend({'full solution','initali starting point'},'Location','northeast','NumColumns',2)
% Evaluated Points
ax2loc(2) = subplot(2,2,2);
plotthecomputedpoints(mdbm_sol_contin)
title(['Continuation: function evaluation', num2str(size(evalpos,2)), ' points']);
grid on; view(3);

%% Part 3: Traditional MDBM Approach (for comparison)
fprintf('\n--- Example 2 / Part 3: Traditional MDBM ---');
% Initial global coarse grid
ax_trad = [];
for k=1:3
    ax_trad(k).val = linspace(-3, 3, 9); % Start with 8 intervals
end

% 4 iterations results in 8 * 2^4 = 128 intervals (mesh size ~0.047)
% This is comparable to the continuation mesh size (0.05)
fprintf('Starting traditional MDBM with 4 iterations...');
mdbm_sol_trad = mdbm(ax_trad, bound_fuction, 4);

% --- Traditional Method Plots ---
% Solution
ax2loc(3) = subplot(2,2,3);
gh_t = plot_mdbm(mdbm_sol_trad);
set(gh_t, 'LineWidth', 3);
title(['Traditional: Solution']);
grid on; view(3);

% Evaluated Points
ax2loc(4) = subplot(2,2,4);
plotthecomputedpoints(mdbm_sol_trad)
title(['Traditional: function evaluation', num2str(size(mdbm_sol_trad.linindex,2)), ' points']);
grid on; view(3);

% Link view for better comparison
linkprop(ax2loc, 'CameraPosition');
linkaxes(ax2loc, 'xyz');


msgbox('Note, that much less point is needed, but in this case you cannot find, multiple closed curves automatically!','Warning')



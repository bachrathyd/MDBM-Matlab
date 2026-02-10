% DelayedMathieuStability.m
%
% Stability Chart Construction for the Delayed Mathieu Equation
% using MDBM + DMD (Dynamic Mode Decomposition) Spectral Estimation.
%
% Reference: Insperger & Stepan (2002)[cite: 37, 447].
%
% Features:
%   - Uses robust snapshot-based spectral radius calculation.
%   - Includes damping parameter 'kappa'.
%   - Generates ALL charts: Fig 3 ((delta,b)), Fig 1 ((delta,epsilon)), and Fig 4 (3D).

%clear; close all; clc;

disp('--------------------------------------------------------------');
disp('Delayed Mathieu Stability Analysis (MDBM + DMD Method)');
disp('--------------------------------------------------------------');

%% ========================================================================
%  GLOBAL PARAMETERS
% ========================================================================
kappa_global = 0.01;  % Fixed damping parameter (Set to 0.0 for exact article reproduction)
N_iter = 4;           % MDBM refinement depth

% Set MDBM options to allow longer computation times for the DDE solver
mdbm_options = mdbmset('timelimit', 300);

disp(['Using Kappa (damping) = ' num2str(kappa_global)]);


%% ========================================================================
%  SECTION 1: 2D Stability in (delta, b) Plane [Fig 3 equivalent]
%  Fixed epsilon, varying delta and b
% ========================================================================
disp('--> Starting Fig 3: (delta, b) plane...');
epsilon_fixed = 1.0;

% 1. Define Search Space
ax1 = [];
ax1(1).val = linspace(-1, 5, 5);    % delta
ax1(2).val = linspace(-1.5, 1.5, 5); % b

% 2. Wrapper Function
% Passes the fixed epsilon and kappa to the calculator
% Maps: p(1)->delta, p(2)->b
func_fig3 = @(p) wrapper_2d(p, @(d, b) calc_stability_robust(d, epsilon_fixed, b, kappa_global));

% 3. Run MDBM
tic;
sol1 = mdbm(ax1, func_fig3, N_iter, mdbm_options);
t1 = toc;
disp(['    Fig 3 calculation done in ' num2str(t1) 's']);

% 4. Plot
figure(1);% clf;
subplot(2,2,1),
plot_mdbm(sol1);hold on

%plotting the evaluated points
evalpos=axialpos(sol1.ax,sol1.vectindex);
Fval=sol1.HC;
X=evalpos(1,:);
Y=evalpos(2,:);
scatter3(X,Y,Fval,10,sign([Fval(1,:)',-Fval(1,:)',0*Fval(1,:)']),'filled')




title(['Fig 3: Stability Boundaries (\epsilon=' num2str(epsilon_fixed) ', \kappa=' num2str(kappa_global) ')']);
xlabel('\delta');
ylabel('b');
grid on; axis tight;
view(2)
drawnow; % Force update


%% ========================================================================
%  SECTION 2: 2D Stability in (delta, epsilon) Plane [Fig 1 equivalent]
%  Fixed b = 0 (Strutt-Ince Chart), varying delta and epsilon
% ========================================================================

disp('--> Starting Fig 1: (delta, epsilon) plane (Strutt-Ince)...');
b_fixed = 0.0;

% 1. Define Search Space
ax2 = [];
ax2(1).val = linspace(-1, 5, 5);   % delta
ax2(2).val = linspace(0, 5, 5);    % epsilon

% 2. Wrapper Function
% Passes fixed b=0 and kappa
% Maps: p(1)->delta, p(2)->epsilon
func_fig1 = @(p) wrapper_2d(p, @(d, e) calc_stability_robust(d, e, b_fixed, kappa_global));

% 3. Run MDBM
tic;
sol2 = mdbm(ax2, func_fig1, N_iter, mdbm_options);
t2 = toc;
disp(['    Fig 1 calculation done in ' num2str(t2) 's']);

% 4. Plot
subplot(2,2,3)
plot_mdbm(sol2);hold on
title(['Fig 1: Strutt-Ince Chart (b=' num2str(b_fixed) ', \kappa=' num2str(kappa_global) ')']);
xlabel('\delta');
ylabel('\epsilon');
grid on; axis tight;
view(2)
drawnow; % Force update


%% ========================================================================
%  SECTION 3: 3D Stability Surface in (delta, b, epsilon) [Fig 4 equivalent]
% ========================================================================

disp('--> Starting Fig 4: 3D (delta, b, epsilon) space...');

% 1. Define Search Space
ax3 = [];
ax3(1).val = linspace(-1, 5, 5);      % delta
ax3(2).val = linspace(-1.5, 1.5, 5);  % b
ax3(3).val = linspace(0, 4, 5);       % epsilon

% 2. Wrapper Function
% Maps p(1)->d, p(2)->b, p(3)->eps
func_fig4 = @(p) wrapper_3d(p, @(d, b, e) calc_stability_robust(d, e, b, kappa_global));

% 3. Run MDBM
% We can use fewer iterations for 3D to save time, or keep N_iter
N_iter_3d = 3;
tic;
sol3 = mdbm(ax3, func_fig4, N_iter_3d, mdbm_options);
t3 = toc;
disp(['    Fig 4 calculation done in ' num2str(t3) 's']);

% 4. Plot

subplot(2,2,[2,4])
plot_mdbm(sol3);hold on
title(['Fig 4: 3D Stability Surface (\kappa=' num2str(kappa_global) ')']);
xlabel('\delta');
ylabel('b');
zlabel('\epsilon');
view(3); grid on;
drawnow; % Force update
shading interp
disp('Done.');

%% ========================================================================
%  WRAPPER HELPERS
% ========================================================================

function H = wrapper_2d(p, eval_handle)
% p is [2 x N_points]. Row 1 = x, Row 2 = y
n = size(p, 2);
H = zeros(1, n);
for k = 1:n
    % Call the stability calculator for each point
    H(k) = eval_handle(p(1,k), p(2,k));
end
end

function H = wrapper_3d(p, eval_handle)
% p is [3 x N_points]. Row 1 = x, Row 2 = y, Row 3 = z
n = size(p, 2);
H = zeros(1, n);
for k = 1:n
    % Map MDBM axes to (delta, b, epsilon)
    % Note: user logic defines ax(1)=d, ax(2)=b, ax(3)=e
    H(k) = eval_handle(p(1,k), p(2,k), p(3,k));
end
end
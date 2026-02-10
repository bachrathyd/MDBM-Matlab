% SHIMMYSTABILITY
% Compute and plot the (Hopf) bifurcation curves/surfaces of the
% Takács–Stépán stretched-string tyre-delay model (Takács et al., EJMS 2009).
%
% This MATLAB script replicates the logic of 'ShimmyStability_4par_2eq.jl'.
%
% 1. First: codimension-2 curves in (V,L,omega) for fixed Sigma=1.8, zeta=0
% 2. Then: codimension-2 surface in (V,L,omega,zeta) (lifting by zeta)
%
% Requirements:
%   - mdbm.m (Multi-Dimensional Bisection Method class/function)
%   - plot_mdbm.m

clc; clear; close all;

disp('Delay effects in shimmy dynamics of wheels with stretched string-like tyres');
disp('D Takács, G Orosz, G Stépán');
disp('=============================================================================');

%% =============================================================================
% 1. Load DIMENSIONAL PARAMETERS (Table 1 of Takács et al. 2009)
% =============================================================================
% Tyre contact half-length
a_dim = 0.04;    % [m]
% Tyre relaxation length
sigma_dim = 0.072;   % [m]
% Lateral tyre stiffness per unit length
k_dim = 53506;   % [N/m^2]
% Lateral tyre damping per unit length
b_dim = 140;     % [Ns/m^2]
% Undamped natural angular frequency (measured)
omega_n_dim = 15.29;   % [rad/s]
% Corresponding natural frequency f_n (Hz)
f_n = 2.43;    % [Hz] (not used directly below)

%% =============================================================================
% 2. Compute DIMENSIONLESS PARAMETERS from Eq. (21) & (26):
%
%   Sigma = sigma / a ,     zeta = (omega_n * b)/(2 * k) ,
%   V = (v/(2a))/omega_n ,    L = l/a .
%
%  We will fix Sigma = 1.8 and later vary zeta as needed.
% =============================================================================
Sigma_target = sigma_dim / a_dim;                % = 1.8  (dimensionless relaxation length)
zeta_target = (omega_n_dim * b_dim) / (2 * k_dim);  % approx 0.02 (dimensionless damping ratio)

fprintf('\nDimensional -> Dimensionless:\n');
fprintf('  a = %.4f m  =>   Sigma = sigma/a = %.3f\n', a_dim, Sigma_target);
fprintf('  b = %.1f Ns/m^2,  k = %.1f N/m^2,  omega_n = %.2f rad/s\n', b_dim, k_dim, omega_n_dim);
fprintf('  => zeta = omega_n*b/(2k) = %.4f\n\n', zeta_target);


%% =============================================================================
% 4. CODIMENSION-2 ROOT-FINDING in (V,L,omega) with Sigma=1.8, zeta=0.0
%
%    Re D(i*omega; V,L,Sigma=1.8, zeta=0) = 0
%    Im D(i*omega; V,L,Sigma=1.8, zeta=0) = 0
%
%  -> This yields a 1-dimensional manifold of solutions in 3D.
% =============================================================================

% Fix Sigma and zeta for Figure 4(a):
Sigma_fixed = 1.8;
zeta_fixed = 0.0;     % zeta = 0 for the undamped case (Fig 4(a))

% Choose parameter ranges (matching Julia file)
V_min = 0.02; V_max = 0.6;
L_min = -0.2 + pi/1000; L_max = 7.0;
omega_min = 0.1; omega_max = 30.0;

% Build coarse MDBM axes in (V, L, omega):
ax3 = [];
ax3(1).val = linspace(V_min, V_max, 15);    % V
ax3(2).val = linspace(L_min, L_max, 15);    % L
ax3(3).val = linspace(omega_min, omega_max, 15); % omega

% Number of iterations
Niteration = 4;

fprintf('-> Setting up MDBM for codim-2 curve in (V,L,omega) with Sigma=1.8, zeta=0 ...\n');

% Define the wrapper function for 3D case
% Note: We pass the FIXED zeta and Sigma here.
func3d = @(ax) char_fun3d_wrapper(ax, Sigma_fixed, zeta_fixed);

% Solve
mdbm_sol3 = mdbm(ax3, func3d, Niteration);

fprintf('-> Finished MDBM solve for Fig 4(a).\n');

%% =============================================================================
% 5. PLOTTING
% =============================================================================
figure('Name', 'Takacs Shimmy Stability', 'Color', 'w', 'Position', [100 100 1200 500]);

% Subplot 1: 3D Case
subplot(1, 2, 1);
plot_mdbm(mdbm_sol3);
title({'3D Solution: (V, L, \omega)'; ['\Sigma=' num2str(Sigma_fixed) ', \zeta=' num2str(zeta_fixed)]});
xlabel('V'); ylabel('L'); zlabel('\omega');
grid on; axis square;
view(3);

drawnow
%% =============================================================================
% 6. LIFTING THE PROBLEM ONE DIMENSION HIGHER: ADD zeta AS A PARAMETER
%
%   Now treat mu = (V, L, omega, zeta) with Sigma fixed at 1.8.
%   Solve:
%     Re D(i*omega; V,L,Sigma=1.8, zeta) = 0,
%     Im D(i*omega; V,L,Sigma=1.8, zeta) = 0
%   -> codim-2 in 4D => 2-dimensional surface in (V,L,zeta,omega).
% =============================================================================

% Choose zeta range: from 0.0 up to 0.05
zeta_min = 0.00; zeta_max = 0.05;

% Define coarse axes in (V, L, omega, zeta):
ax4 = [];
ax4(1).val = linspace(V_min, V_max, 8);      % V
ax4(2).val = linspace(L_min, L_max, 8);      % L
ax4(3).val = linspace(omega_min, omega_max, 8); % omega
ax4(4).val = linspace(zeta_min, zeta_max, 5);  % zeta

fprintf('-> Setting up MDBM for codim-2 SURFACE in (V,L,omega,zeta) ...\n');

% Define the wrapper function for 4D case
% Note: zeta is now a VARIABLE (4th axis), Sigma is still fixed.
func4d = @(ax) char_fun4d_wrapper(ax, Sigma_target);

% Solve (fewer iterations usually needed for higher dim to save time/memory)
Niteration=3
mdbm_sol4 = mdbm(ax4, func4d, Niteration,mdbmset('connections',false));

%mdbm_sol4=DTconnect(mdbm_sol4);% this version crashes due to the high memory demand
mdbm_sol4=DTconnect_delunay_high_order(mdbm_sol4);
fprintf('-> Finished MDBM solve for 4D (V,L,omega,zeta) hopf surface.\n');

% Subplot 2: 4D Case
subplot(1, 2, 2);
plot_mdbm(mdbm_sol4,[],[1,2,4,3]);
title({'4D Solution: (V, L, \omega, \zeta)'; ['\Sigma=' num2str(Sigma_target)]});
xlabel('V'); ylabel('L'); zlabel('\omega');
% Note: plot_mdbm typically plots the first 3 dims.
% You can rotate the plot to see the relationships.
grid on; axis square;
view(3);
shading interp

fprintf('\n**Done**.\n');



%% =============================================================================
% AUXILIARY FUNCTIONS
% =============================================================================

function H = char_fun3d_wrapper(ax, Sigma, zeta)
% Wrapper for the 3D case where zeta is fixed
% ax dimensions: 1=V, 2=L, 3=omega

% We process points in a loop or vectorized. MDBM passes a grid or list.
% To be safe and clear, we loop over the columns (points).
n_points = size(ax, 2);
H = zeros(2, n_points);

for k = 1:n_points
    V = ax(1, k);
    L = ax(2, k);
    omega = ax(3, k);

    [Re, Im] = char_fun_dimless(V, L, omega, Sigma, zeta);
    H(1, k) = Re;
    H(2, k) = Im;
end
end

function H = char_fun4d_wrapper(ax, Sigma)
% Wrapper for the 4D case where zeta is a variable
% ax dimensions: 1=V, 2=L, 3=omega, 4=zeta

n_points = size(ax, 2);
H = zeros(2, n_points);

for k = 1:n_points
    V = ax(1, k);
    L = ax(2, k);
    omega = ax(3, k);
    zeta = ax(4, k);

    [Re, Im] = char_fun_dimless(V, L, omega, Sigma, zeta);
    H(1, k) = Re;
    H(2, k) = Im;
end
end

%% =============================================================================
% 3. Define the DIMENSIONLESS characteristic function D(lambda; mu) (Eq. 31)
%
%   mu = (V, L, Sigma, zeta)
%   lambda = i*omega   (purely imaginary for hopf)
%
%   D(lambda; mu) logic follows the Julia implementation exactly.
% =============================================================================
function [ReD, ImD] = char_fun_dimless(V, L, omega, Sigma, zeta)

lambda = 1i * omega;

% Denominator: L^2 + 1/3 + Sigma * (L^2 + 1 + Sigma)
denom = L^2 + 1/3 + Sigma * (L^2 + 1 + Sigma);

% Numerator factor outside the curly braces: (L - 1 - Sigma)
num_fac = L - 1 - Sigma;

% --- Terms inside the { ... } from the provided formula ---

% Term A: 2/lambda^2 * [ (L-1)lambda + 2 - ((L+1)lambda + 2) e^{-lambda} ]
termA = (2.0 / lambda^2) * ((L - 1) * lambda + 2 - ((L + 1) * lambda + 2) * exp(-lambda));

% Term B: 4 zeta V L (1 + Sigma) (2 + Sigma lambda) / (L - 1 - Sigma)
% Note: Julia divides by num_fac here, which is (L - 1 - Sigma)
termB = 4.0 * zeta * V * L * (1 + Sigma) * (2 + Sigma * lambda) / num_fac;

% Term C: (L - 1 - Sigma)( 2 Sigma zeta V lambda + Sigma + 4 zeta V )
% Note: Julia multiplies by num_fac here
termC = num_fac * (2 * Sigma * zeta * V * lambda + Sigma + 4 * zeta * V);

% Term D: (L + 1 + Sigma)( 2 Sigma zeta V lambda + Sigma - 4 zeta V ) e^{-lambda}
termD = (L + 1 + Sigma) * (2 * Sigma * zeta * V * lambda + Sigma - 4 * zeta * V) * exp(-lambda);

% Combine the curly-brace terms:
curly = (termA + termB + termC + termD);

% --- Polynomial part: Sigma V^2 lambda^3 + 2 V (V + Sigma zeta) lambda^2 + (Sigma + 4 zeta V) lambda + 2 ---
poly = Sigma * V^2 * lambda^3;
poly = poly + 2.0 * V * (V + Sigma * zeta) * lambda^2;
poly = poly + (Sigma + 4.0 * zeta * V) * lambda;
poly = poly + 2.0;

% Final D(lambda; mu)
% D = poly - num_fac / denom * curly
D_val = poly - (num_fac / denom) * curly;

ReD = real(D_val);
ImD = imag(D_val);
end
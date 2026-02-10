% DelayedMathieuBruteForce.m
% 
% Stability Chart Construction using Robust Hybrid Method.
% Handles the "Noise Floor" to ensure stable regions show negative exponents.

% clear; close all; clc;

disp('--------------------------------------------------------------');
disp('Delayed Mathieu Stability: Robust Grid Search');
disp('--------------------------------------------------------------');

%% PARAMETERS
kappa_global = 0.01;   
epsilon_fixed = 1.0;  
T = 2*pi;             

% Grid Resolution
% 40x40 is a good balance for testing. Increase to 80x80 for publication quality.
delta_vals = linspace(5, -1, 30);    
b_vals = linspace(-1.5, 1.5, 30);    

[D, B] = meshgrid(delta_vals, b_vals);
Stab_Map = zeros(size(D));

total_points = numel(D);

disp(['Grid Size: ' num2str(size(D,1)) 'x' num2str(size(D,2))]);
disp('Starting simulation...');

%% SIMULATION LOOP
figure(11)
tic;
for i = 1:total_points
    d = D(i);
    b = B(i);
    
    % Call the ROBUST calculator
    Stab_Map(i) = calc_stability_robust(d, epsilon_fixed, b, kappa_global);
    
    if mod(i, 50) == 0
        progress = (i / total_points) * 100;
        fprintf('Progress: %.1f%%\n', progress);

        % Contourf with explicit levels to visualize the negative "valleys"
% Levels from -1.0 to +0.5
levels = linspace(-1.5, 0.5, 30);
contourf(D, B, Stab_Map, levels, 'LineStyle', 'none'); 
hold on;

% Thick Black Line for Stability Boundary (0)
[C, h] = contour(D, B, Stab_Map, [0 0], 'k-', 'LineWidth', 2);
clabel(C, h);

% Color Map: Custom map where 0 is clearly defined
colormap(jet); 
c = colorbar;
c.Label.String = 'Real Characteristic Exponent (\sigma)';

% Clamp the color axis so deep stable regions don't wash out the boundary
caxis([-1.0 0.5]); 

title({['Stability Chart (\epsilon=' num2str(epsilon_fixed) ', \kappa=' num2str(kappa_global) ')']; ...
       'Robust Noise Handling'});
xlabel('\delta');
ylabel('b');
grid on; axis tight;
drawnow;
    end
end
runtime = toc;
disp(['Done in ' num2str(runtime) ' seconds.']);



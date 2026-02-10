%% MDBM Template: Non-smooth problem with local refinement (Mandelbrot set)
% This example demonstrates how to handle non-smooth boundaries (fractals)
% and how to perform localized resolution increase in a selected range.

% Definition of the parameter space (initial coarse mesh)
ax=[];
ax(1).val=linspace(-2.1, 0.6, 5); % real axis
ax(2).val=linspace(-1.2, 1.2, 5); % imag axis

% Extra parameters for the Mandelbrot iteration
par=[];
par.iter=200;

% MDBM options
% interporder is set to 0 initially for the 'safe selection method'
% which is crucial for non-smooth or fractal-like boundaries.
mdbm_options = mdbmset('connections', false, 'interporder', 0);

% Initial iterations
Niteration = 6;
fprintf('Performing initial MDBM iterations (%d steps)...', Niteration);
mdbm_sol = mdbm(ax, @fval_mandelbrot, Niteration, mdbm_options, par);

% Visualization
figure(1)
clf
plot_mdbm(mdbm_sol);
title('Initial MDBM result. Zoom in or press a button to select a region for refinement.');
axis equal

%% Local Refinement / Zooming
% The power of MDBM is that we can refine only a specific sub-domain.
disp('Select a rectangular area for local refinement by clicking two points (top-left and bottom-right).');
try
    [xy] = ginput(2);
    if size(xy,1) == 2
        xy = sort(xy, 1); % Ensure correct min/max order
        
        fprintf('Refining selected range: Re:[%.2f, %.2f], Im:[%.2f, %.2f]', xy(1,1), xy(2,1), xy(1,2), xy(2,2));
        
        % Set refinement type to 'pos' (position-based range)
        mdbm_sol.opt.refinetype = 'pos';
        
        % Perform 5 steps of local refinement in the selected range
        for k = 1:5
            fprintf('Refinement step %d...', k);
            % refine(sol, [axes_indices; min_values; max_values])
            mdbm_sol = refine(mdbm_sol, [[1;2], xy']); 
            
            % Re-interpolate to update the solution structure
            mdbm_sol.opt.interporder = 1; % Use 1st order for final visualization
            mdbm_sol = interpolating_cubes(mdbm_sol);
            
            % Update plot
            clf
            plot_mdbm(mdbm_sol, 'b', [], [], [], ax);
            axis equal
            title(sprintf('Local refinement step %d/5', k));
            drawnow
        end
        
        % Optional: Final neighbor check to ensure connectivity in the refined area
        fprintf('Performing final neighbor check...');
        mdbm_sol.opt.interporder = 0;
        mdbm_sol = checkneighbour(mdbm_sol);
        mdbm_sol.opt.interporder = 1;
        mdbm_sol = interpolating_cubes(mdbm_sol);
        
        clf
        plot_mdbm(mdbm_sol, 'k', [], [], [], ax);
        axis equal
        title('Final result with local refinement');
    end
catch
    disp('Selection cancelled or failed.');
end


%% --- Local Function: Mandelbrot Value Calculation ---
function [fun_val] = fval_mandelbrot(ax, par)
    % ax: coordinates (2 x N matrix)
    % par: structure with 'iter'
    
    fun_val = zeros(1, size(ax, 2));
    
    for kax = 1:size(ax, 2)
        c = ax(1, kax) + 1i * ax(2, kax);
        z = 0;
        k = 0;
        % Standard Mandelbrot iteration: z_{n+1} = z_n^2 + c
        while (k < par.iter) && (abs(z) < 2)
            z = z^2 + c;
            k = k + 1;
        end
        % The boundary is at abs(z) == 2. 
        % Returning abs(z)-2 gives a distance-like metric for the solver.
        fun_val(1, kax) = abs(z) - 2;
    end
end

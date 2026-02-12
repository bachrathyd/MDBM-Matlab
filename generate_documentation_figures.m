%% Script to generate ALL figures for MDBM Documentation
% This script runs all relevant examples and saves the results as images.

% Add src to path
addpath('src');

% Ensure figures directory exists
if ~exist('documentation/figures', 'dir')
    mkdir('documentation/figures');
end


%% --- FEATURES ---

% 1. Connection of points to simplex
try
    fprintf('Running: connection_of_points_to_simplex.m\n');
    run('features/connection_of_points_to_simplex.m');
    save_and_close('feature_connection.png');
catch ME
    fprintf('Failed: connection_of_points_to_simplex.m - %s\n', ME.message);
end

% 2. Constrained Problems (Simple & Complex)
try
    fprintf('Running: constrained_problems_simple.m\n');
    run('features/constrained_problems_simple.m');
    save_and_close('feature_constraints_simple.png');
    
    fprintf('Running: constrained_problems_complex.m\n');
    run('features/constrained_problems_complex.m');
    save_and_close('feature_constraints_complex.png');
catch ME
    fprintf('Failed: constrained_problems - %s\n', ME.message);
end

% 3. Continuation and Extension
try
    fprintf('Running: continuation_and_extension_1.m\n');
    run('features/continuation_and_extension_1.m');
    save_and_close('feature_extension.png');
catch ME
    fprintf('Failed: continuation_and_extension_1.m - %s\n', ME.message);
end

% 4. Interpolation Order
try
    fprintf('Running: interpolation_order.m\n');
    run('features/interpolation_order.m');
    save_and_close('feature_interpolation_order.png');
catch ME
    fprintf('Failed: interpolation_order.m - %s\n', ME.message);
end

% 5. Neighbor Check Demo
try
    fprintf('Running: neighbor_check_demo.m\n');
    run('features/neighbor_check_demo.m');
    save_and_close('feature_neighbor_check.png');
catch ME
    fprintf('Failed: neighbor_check_demo.m - %s\n', ME.message);
end

% 6. Bracketing n-cube detection
try
    fprintf('Running: bracketing_ncube_detection.m\n');
    run('features/bracketing_ncube_detection.m');
    save_and_close('feature_bracketing.png');
catch ME
    fprintf('Failed: bracketing_ncube_detection.m - %s\n', ME.message);
end

% 7. Local Refinement (Mandelbrot) - Modified for non-interactive
try
    fprintf('Running: local_refinement_nonsmooth_mandelbrot.m (Automated)\n');
    % We use the logic but skip ginput
    ax=[]; ax(1).val=linspace(-2.1, 0.6, 5); ax(2).val=linspace(-1.2, 1.2, 5);
    par.iter=200; mdbm_options = mdbmset('connections', false, 'interporder', 0);
    mdbm_sol = mdbm(ax, @(ax,par) fval_mandelbrot_local(ax,par), 6, mdbm_options, par);
    % Hardcoded refinement range for the "Seahorse valley"
    xy = [-0.8, -0.75; 0.0, 0.2]; % [xmin, xmax; ymin, ymax]
    mdbm_sol.opt.refinetype = 'pos';
    for k = 1:3
        mdbm_sol = refine(mdbm_sol, [[1;2], xy]); 
    end
    mdbm_sol.opt.interporder = 1; mdbm_sol = interpolating_cubes(mdbm_sol);
    figure(1); clf; plot_mdbm(mdbm_sol, 'k', [], [], [], ax); axis equal;
    save_and_close('feature_local_refinement.png');
catch ME
    fprintf('Failed: local_refinement - %s\n', ME.message);
end

% 8. Singularity Handling
try
    fprintf('Running: singularty_handling.m\n');
    run('features/singularty_handling.m');
    save_and_close('feature_singularity.png');
catch ME
    fprintf('Failed: singularty_handling.m - %s\n', ME.message);
end

% 10. Continuation and Extension 2
try
    fprintf('Running: continuation_and_extension_2.m\n');
    run('features/continuation_and_extension_2.m');
    save_and_close('feature_extension_2.png');
catch ME
    fprintf('Failed: continuation_and_extension_2.m - %s\n', ME.message);
end

% 11. Degenerate Functions
try
    fprintf('Running: degenerate_function_1.m\n');
    run('features/degenerate_function_1.m');
    save_and_close('feature_degenerate_1.png');
    
    fprintf('Running: degenerate_function_2_detecting_different_dimensions.m\n');
    run('features/degenerate_function_2_detecting_different_dimensions.m');
    save_and_close('feature_degenerate_2.png');
catch ME
    fprintf('Failed: degenerate_functions - %s\n', ME.message);
end

% 12. Plotting Examples
try
    fprintf('Running: plotting_exampels.m\n');
    run('features/plotting_exampels.m');
    % This script creates multiple figures, let's save the last one (210)
    figure(210);
    save_and_close('feature_plotting.png');
catch ME
    fprintf('Failed: plotting_exampels.m - %s\n', ME.message);
end

%% --- EXAMPLES ---

% 1. Unit Circles
try
    fprintf('Running: unit_circles.m\n');
    run('examples/unit_circles.m');
    save_and_close('example_unit_circles.png');
catch ME
    fprintf('Failed: unit_circles.m - %s\n', ME.message);
end

% 2. Julia Set 3D
try
    fprintf('Running: julia_set_3d.m\n');
    run('examples/julia_set_3d.m');
    save_and_close('example_julia_3d.png');
catch ME
    fprintf('Failed: julia_set_3d.m - %s\n', ME.message);
end

% 3. Noise Handling
try
    fprintf('Running: noise_handeling.m\n');
    run('examples/noise_handeling.m');
    save_and_close('example_noise.png');
catch ME
    fprintf('Failed: noise_handeling.m - %s\n', ME.message);
end

% 4. Catastrophe Surface
try
    fprintf('Running: catastrophe_surface_visualization_gradient.m\n');
    run('examples/catastrophe_surface_visualization_gradient.m');
    save_and_close('example_catastrophe.png');
catch ME
    fprintf('Failed: catastrophe_surface - %s\n', ME.message);
end

% 5. Delayed PD Controller
try
    fprintf('Running: delayed_pd_controler_stability.m\n');
    run('examples/delayed_pd_controler_stability.m');
    save_and_close('example_pd_stability.png');
catch ME
    fprintf('Failed: delayed_pd_controler_stability.m - %s\n', ME.message);
end

% 6. Convergence Transcendent
try
    fprintf('Running: convergence_transcendent.m\n');
    run('examples/convergence_transcendent.m');
    save_and_close('example_convergence.png');
catch ME
    fprintf('Failed: convergence_transcendent.m - %s\n', ME.message);
end

% 7. Fun with Floor
try
    fprintf('Running: fun_with_floor.m\n');
    run('examples/fun_with_floor.m');
    save_and_close('example_floor.png');
catch ME
    fprintf('Failed: fun_with_floor.m - %s\n', ME.message);
end

%% --- CASE STUDIES ---

% 1. Shimmy Problem
try
    fprintf('Running: shimmy_stability_surface.m\n');
    run('case_studies/shimmy_problem/shimmy_stability_surface.m');
    save_and_close('case_shimmy.png');
catch ME
    fprintf('Failed: shimmy_problem - %s\n', ME.message);
end

% 2. Turning Stability
try
    fprintf('Running: turning_stability_instabilitygradient.m\n');
    run('case_studies/turning_stability/turning_stability_instabilitygradient.m');
    save_and_close('case_turning.png');
catch ME
    fprintf('Failed: turning_stability - %s\n', ME.message);
end

% 3. CTCR
try
    fprintf('Running: main_CTCR.m\n');
    run('case_studies/Claster_Treatment_of_Characteristic_Roots/main_CTCR.m');
    save_and_close('case_ctcr.png');
catch ME
    fprintf('Failed: main_CTCR.m - %s\n', ME.message);
end

% 4. Mathieu Stability
try
    fprintf('Running: DelayedMathieuStability_MDBM.m\n');
    run('case_studies/Delay_Mathieu_simulation_based_stability_chart/DelayedMathieuStability_MDBM.m');
    save_and_close('case_mathieu.png');
catch ME
    fprintf('Failed: Mathieu - %s\n', ME.message);
end

% 5. Catastrophe Demo
try
    fprintf('Running: catastrophe_demo.m\n');
    run('case_studies/catastrophe_surface/catastrophe_demo.m');
    catastrophe_demo();
    save_and_close('case_catastrophe.png');
catch ME
    fprintf('Failed: catastrophe_demo.m - %s\n', ME.message);
end

% 6. Sweeping Envelope
try
    fprintf('Running: sweeping_enveloper_only.m\n');
    run('case_studies/Sweeping_envelope/sweeping_enveloper_only.m');
    save_and_close('case_sweeping.png');
catch ME
    fprintf('Failed: Sweeping_envelope - %s\n', ME.message);
end

fprintf('Figure generation completed.\n');

% Local function helper for Mandelbrot (copied from the original file)
function [fun_val] = fval_mandelbrot_local(ax, par)
    fun_val = zeros(1, size(ax, 2));
    for kax = 1:size(ax, 2)
        c = ax(1, kax) + 1i * ax(2, kax);
        z = 0; k = 0;
        while (k < par.iter) && (abs(z) < 2)
            z = z^2 + c;
            k = k + 1;
        end
        fun_val(1, kax) = abs(z) - 2;
    end
end

% Function to save figure with consistent settings
function save_and_close(filename)
    fprintf('Saving: %s\n', filename);
    % Set figure background to white for documentation
    set(gcf, 'Color', 'w');
    % Save as PNG
    exportgraphics(gcf, ['documentation/figures/', filename], 'Resolution', 150);
    close(gcf);
end
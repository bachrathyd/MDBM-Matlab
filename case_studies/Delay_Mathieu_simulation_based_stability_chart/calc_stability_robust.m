function exponent = calc_stability_robust(delta, epsilon, b, kappa)
% CALC_STABILITY_ROBUST
% Calculates stability exponent, handling the "Noise Floor" issue.
%
% Algorithm:
% 1. Simulate system.
% 2. Check signal magnitude.
% 3. IF signal < NoiseFloor:
%       Calculate decay rate based on time to reach floor (Simple Log Decay).
%    ELSE:
%       Use DMD (Arnoldi) to find dominant eigenvalues of the active signal.

    %% 1. Parameters
    T = 2*pi;
    tau = T;
    
    % Simulation settings
    n_transient = 2;
    n_snapshots = 10;
    total_periods = n_transient + n_snapshots + 1;
    t_span = [0, total_periods*T];
    
    % Solver thresholds
    NoiseFloor = 1e-2; % Below this, we assume it's just numerical noise
    
    % DDE System: x'' + kappa*x' + (delta + eps*cos(t))x = b*x(t-tau)
    ddefun = @(t, y, Z) [y(2); ...
                         -kappa*y(2)-(delta + epsilon*cos(t))*y(1)+b*Z(1,1)];

    history = [100; 100]; % Start with large enough amplitude
    
    % Tighten tolerances slightly to lower the actual noise floor
    opts = ddeset('RelTol', 1e-3, 'AbsTol', 1e-3);
    
    try
        sol = dde23(ddefun, tau, history, t_span, opts);
    catch
        exponent = 5; return; % Solver fail = unstable
    end
    
    %% 2. Extract Snapshots
    M_resolution = 10; 
    Snapshots = zeros(2*M_resolution, n_snapshots + 1);
    
    % We also track the norms to check for decay
    snapshot_norms = zeros(1, n_snapshots + 1);
    
    for k = 1:(n_snapshots + 1)
        period_idx = n_transient + k;
        t_segment = linspace((period_idx-1)*T, period_idx*T, M_resolution);
        y_segment = deval(sol, t_segment); 
        
        vec = y_segment(:);
        Snapshots(:, k) = vec;
        snapshot_norms(k) = norm(vec);
    end
    
    %% 3. Hybrid Decision Logic
    
    % Check the final amplitude
    final_amp = snapshot_norms(end);
    initial_amp = snapshot_norms(1);
    
    if final_amp < NoiseFloor
        % CASE A: System is Stable (Decayed to Noise)
        % We cannot use DMD on the tail because it's just noise.
        % We calculate the exponent based on the overall drop.
        
        % Avoid log(0)
        if final_amp < 1e-12, final_amp = 1e-12; end
        if initial_amp < 1e-12, initial_amp = 1e-12; end
        
        % Rate = ln(Final / Initial) / Time_Elapsed
        time_elapsed = n_snapshots * T;
        exponent = log(final_amp / initial_amp) / time_elapsed;
        
        % Safety: Ensure it doesn't return positive by mistake due to noise variance
        if exponent > 0, exponent = -1e-3; end
        
    else
        % CASE B: Active Signal (Unstable, Limit Cycle, or Slow Decay)
        % The signal is above the noise floor, so DMD will work well.
        
        X = Snapshots(:, 1:end-1);
        Y = Snapshots(:, 2:end);
        
        [U, S, V] = svd(X, 'econ');
        
        % RELATIVE Truncation (Key for robustness)
        % Keep modes that are at least 0.1% strength of the dominant mode
        sigmas = diag(S);
        max_sig = max(sigmas);
        r = sum(sigmas > max_sig * 1e-3); 
        if r < 1, r = 1; end
        
        U_r = U(:, 1:r);
        S_r = S(1:r, 1:r);
        V_r = V(:, 1:r);
        
        Atilde = U_r' * Y * V_r / S_r;
        mu_vals = eig(Atilde);
        
        rho = max(abs(mu_vals));
        
        if rho < 1e-12, rho = 1e-12; end
        exponent = log(rho) / T;
    end
end
%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 3
% co-dimension (number of equations): 2

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-3, 3, 3);
ax(2).val = linspace(-3, 3, 3);
ax(3).val = linspace(-3, 3, 3);

% number of iterations
Niteration = 5; % take care, large values can lead to memory problems
par.k = 3;

%% function for which the roots are detected
bound_fuction_name = @fval;

mdbm_sol = mdbm(ax, bound_fuction_name, Niteration, [], par);

figure(5)
plot_mdbm(mdbm_sol, 'k');

%plotthecomputedpoints(mdbm_sol)
function H = fval(ax, par, val)
    %% version 1: simple calculate the function value(s) for each parameter points
    H = zeros(2, size(ax, 2));
    for k = 1:size(ax, 2)
        x = ax(1, k);
        y = ax(2, k);
        z = ax(3, k);
        H(1, k) = x^2 + y^2 + z^2 - 2^2;
        H(2, k) = x - y * par.k;
    end

    %% version 2: vectorized
    % x = ax(1,:);
    % y = ax(2,:);
    % z = ax(3,:);
    % H = [x.^2 + y.^2 + z.^2 - 2^2; ...
    %      x - y * par.k];

    %% version 3: vectorized, without new variables (fastest)
    % H = [ax(1,:).^2 + ax(2,:).^2 + ax(3,:).^2 - 2^2; ...
    %      ax(1,:) - ax(2,:) * par.k];
end

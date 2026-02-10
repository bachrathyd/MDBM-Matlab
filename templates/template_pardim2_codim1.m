%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 2
% co-dimension (number of equations): 1

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-3, 3, 3);
ax(2).val = linspace(-3, 3, 3);

% number of iterations
Niteration = 3; % take care, large values can lead to memory problems

%% function for which the roots are detected
bound_fuction_name = @fval;

mdbm_options = mdbmset('connections', 1, 'checkneighbour', Inf, 'checkneighbourinallsteps', 1, 'directionalneighbouronly', 0, 'cornerneighbours', 1);
mdbm_sol = mdbm(ax, bound_fuction_name, Niteration, mdbm_options);

figure(2), clf
plotobject = plot_mdbm(mdbm_sol, 'k');
set(plotobject, 'LineWidth', 2)
view(2)

function H = fval(ax)
    %% version 1: simple calculate the function value(s) for each parameter points
    H = zeros(1, size(ax, 2));
    for k = 1:size(ax, 2)
        x = ax(1, k);
        y = ax(2, k);
        H(k) = x^2 + y^2 - 2^2;
    end

    %% version 2: vectorized
    % x = ax(1,:);
    % y = ax(2,:);
    % H = x.^2 + y.^2 - 2^2;

    %% version 3: vectorized, without new variables (fastest)
    % H = ax(1,:).^2 + ax(2,:).^2 - 2^2;
end

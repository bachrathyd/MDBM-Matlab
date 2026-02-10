%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 4
% co-dimension (number of equations): 1

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(0, 4, 3); % x
ax(2).val = linspace(0, 4, 3); % y
ax(3).val = linspace(0, 4, 3); % z
ax(4).val = linspace(2, 3, 2); % r

% number of iterations
Niteration = 3; % take care, large values can lead to memory problems

%% function for which the roots are detected
bound_fuction_name = @fval;
mdbm_sol = mdbm(ax, bound_fuction_name, Niteration); % zero
mdbm_sol = DTconnect_delunay_high_order(mdbm_sol); % forced 'triangulation' in higher dimension

figure(7)
% presenting the numerical results without interpolation
plot_mdbm(mdbm_sol, [], [], [], [], [], 0);
alpha 0.3
title(['DTconncetion time: ', num2str(mdbm_sol.opt.times.DTconnect), ' [s]'])

function H = fval(ax)
    %% version 1: simple calculate the function value(s) for each parameter points
    H = zeros(1, size(ax, 2));
    for k = 1:size(ax, 2)
        x = ax(1, k);
        y = ax(2, k);
        z = ax(3, k);
        r = ax(4, k);
        H(1, k) = x^2 + y^2 + z^2 - r^2;
    end

    %% version 2: vectorized
    % x = ax(1,:);
    % y = ax(2,:);
    % z = ax(3,:);
    % r = ax(4,:);
    % H = x.^2 + y.^2 + z.^2 - r.^2;

    %% version 3: vectorized, without new variables (fastest)
    % H = ax(1,:).^2 + ax(2,:).^2 + ax(3,:).^2 - ax(4,:).^2;
end

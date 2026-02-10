%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 4
% co-dimension (number of equations): 3

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-3, 3, 3); % x
ax(2).val = linspace(-3, 3, 3); % y
ax(3).val = linspace(-3, 3, 3); % z
ax(4).val = linspace(1, 2, 2); % r

% number of iterations
Niteration = 5; % take care, large values can lead to memory problems

%% function for which the roots are detected
bound_fuction_name = @fval;

mdbm_sol = mdbm(ax, bound_fuction_name, Niteration); % zero

figure(9)
ghendle = plot_mdbm(mdbm_sol);
set(ghendle, 'LineWidth', 3)

function H = fval(ax)
    %% version 1: simple calculate the function value(s) for each parameter points
    H = zeros(3, size(ax, 2));
    for k = 1:size(ax, 2)
        x = ax(1, k);
        y = ax(2, k);
        z = ax(3, k);
        r = ax(4, k);
        H(1, k) = x^2 + y^2 + z^2 - r^2;
        H(2, k) = sin(x * 3) + 2 * y;
        H(3, k) = x - y + 2 * z;
    end

    %% version 2: vectorized
    % x = ax(1,:);
    % y = ax(2,:);
    % z = ax(3,:);
    % r = ax(4,:);
    % H = [x.^2 + y.^2 + z.^2 - r.^2; ...
    %      x - y; ...
    %      x + y + z];

    %% version 3: vectorized, without new variables (fastest)
    % H = [ax(1,:).^2 + ax(2,:).^2 + ax(3,:).^2 - ax(4,:).^2; ...
    %      ax(1,:) - ax(2,:); ...
    %      ax(1,:) + ax(2,:) + ax(3,:)];
end

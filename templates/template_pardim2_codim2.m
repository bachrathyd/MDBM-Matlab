%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 2
% co-dimension (number of equations): 2
%Note that MDBM not good if the above dimensions are the same!

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-3, 3, 8);
ax(2).val = linspace(-3, 3, 8);
% ax(2).val = rand(16, 1) * 6 - 3;

% number of iterations
Niteration = 7; % take care, large values can lead to memory problems

%% function for which the roots are detected
bound_fuction_name = @fval;

mdbm_sol = mdbm(ax, bound_fuction_name, Niteration);

figure(3)
plot_mdbm(mdbm_sol);

function H = fval(ax)
    H = [ax(1,:).^2 + ax(2,:).^2 - 2^2; ...
         ax(1,:) - ax(2,:)];
end

%% Multi-Dimensional Bisection Method
% basic example
% parameter dimension: 1
% co-dimension (number of equations): 1
% Note that MDBM not good if the above dimensions are the same!

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-4, 5, 11);

% number of iterations
Niteration = 7; % take care, large values can lead to memory problems

%% function for which the roots are detected
bound_fuction_name = @fval;
tic
mdbm_sol = mdbm(ax, bound_fuction_name, Niteration);
toc

figure(1)
solgraphand = plot_mdbm(mdbm_sol, 'b');
set(solgraphand,'Marker','x','MarkerSize',10)
% Comparison with sin(x)
hold on
x = linspace(-4, 5, 1000);
plot(x, sin(x), 'r-')
legend( 'sin(x)=0','sin(x)', 'Location', 'northeast')
function H = fval(ax)
    H = sin(ax);
end

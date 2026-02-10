function catastrophe_demo()
%% MDBM Demonstration: Catastrophe Surface
% This example computes the catastrophe surface of a non-linear equation:
% f(x, a, b) = a*sin(x) + x + b = 0
% It demonstrates how to plot sections of a surface (co-dimension 2) 
% and find critical values (e.g., where df/dx = 0).

% Definition of the parameter space (a, b, x)
ax=[];
ax(1).val = linspace(-3.51, 2.5, 5); % a
ax(2).val = linspace(-2.51, 2.5, 5); % b
ax(3).val = linspace(-2.01, 2.0, 5); % x

Niteration = 4;
figure(102); clf;

% --- Part 1: Full Catastrophe Surface ---
fprintf('Computing full catastrophe surface...');
par=[];
mdbm_sol = mdbm(ax, @fval_catastrophe, Niteration, [], par);
plot_mdbm(mdbm_sol, [], [], [], 1);
colormap gray; shading interp; grid on; view([-210, 20]);
hold on; alpha 0.5;
xlabel('a'); ylabel('b'); zlabel('x');
title('Catastrophe Surface and Sections');

% --- Part 2: Sections along a-axis ---
fprintf('Computing sections along a-axis...');
par.direc = 1;
for ka = (-3:1.0:2)
    par.val = ka;
    sol_sec = mdbm(ax, @fval_catastrophe, Niteration, [], par);
    plot_mdbm(sol_sec, 'b');
    drawnow;
end

% --- Part 3: Sections along b-axis ---
fprintf('Computing sections along b-axis...');
par.direc = 2;
for kb = (-1.5:1.0:1.5)
    par.val = kb;
    sol_sec = mdbm(ax, @fval_catastrophe, Niteration, [], par);
    plot_mdbm(sol_sec, 'g');
    drawnow;
end

% --- Part 4: Critical Values (Fold lines) ---
% Intersection of f=0 and df/dx=0
fprintf('Computing critical values (fold lines)...');
par.direc = 3;
sol_crit = mdbm(ax, @fval_catastrophe, Niteration, [], par);
gh = plot_mdbm(sol_crit, 'r', [], [], 1);
if ~isempty(gh)
    set(gh(1), 'LineWidth', 5);
end
title('Catastrophe Surface with Sections and Fold Lines (Red)');

end

%% --- Local Function: Catastrophe Surface and Sections ---
function fun_val = fval_catastrophe(ax, par)
    a = ax(1,:);
    b = ax(2,:);
    x = ax(3,:);
    
    f = a.*sin(x) + x + b;
    
    if isempty(par)
        fun_val = f;
    elseif par.direc == 1  % Section a = const
        fun_val = [f; a - par.val];
    elseif par.direc == 2  % Section b = const
        fun_val = [f; b - par.val];
    elseif par.direc == 3  % Critical values (df/dx = 0)
        dfdx = a.*cos(x) + 1;
        fun_val = [f; dfdx];
    end
end

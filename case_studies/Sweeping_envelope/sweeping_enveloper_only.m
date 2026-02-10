%% Multi-Dimensional Bisection Method
% example of sweepiing an object
% computing only the envelope efficiently

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-4, 8, 7);
ax(2).val = linspace(-4, 4, 7);

%% ------ 2 axis parameter - the basic shape
% calculation the sweeping with the brute force mtehod
mdbm_sol = mdbm(ax, @fval, 4);

figure(2), clf
subplot(1,3,1)
plotobject = plot_mdbm(mdbm_sol,'k');
set(plotobject,'LineWidth',3)
view(2)
drawnow
%% ------ 2 axis parameter - 1 sweeping parameter

ax(3).val = linspace(-1.5,1,5);
% calculation the sweeping with the brute force mtehod
mdbm_sol = mdbm(ax, @fval, 3);

subplot(1,3,2)
plotobject = plot_mdbm(mdbm_sol);
shading interp
alpha 0.3
view(3)
drawnow
% Finding the sweept volume with varaible axis (variax) definition
ax_fix=ax(1:2);
variax=ax(3);
mdbm_sols=mdbm_variax_wrapper(ax_fix,variax,@fval,5);
for k = 1:length(mdbm_sols)
    x=mdbm_sols{k}.posinterp(1,:);
    y=mdbm_sols{k}.posinterp(2,:);
    z=mdbm_sols{k}.posinterp(3,:);
    hold on
    plot3(x,y,z,'k.','MarkerSize',15)
    drawnow
end

%% ------ 2 axis parameter - 2 sweeping parameter
ax(4).val = linspace(-0,2,5);
tic
mdbm_sol = mdbm(ax, @fval, 2,mdbmset('connections',false));%no connection, that would be a volume
toc

subplot(1,3,3)
plotobject = plot_mdbm(mdbm_sol, 'r');
set(plotobject, 'LineWidth', 2)
view(3)
drawnow
% Finding the sweept boundary with varaible axis (variax) definition
ax_fix=ax(1:2);
variax=ax(3:4);
tic
mdbm_sols=mdbm_variax_wrapper(ax_fix,variax,@fval,5);
toc
for k = 1:length(mdbm_sols)
    x=mdbm_sols{k}.posinterp(1,:);
    y=mdbm_sols{k}.posinterp(2,:);
    z=mdbm_sols{k}.posinterp(3,:);
    hold on
    plot3(x,y,z,'k.','MarkerSize',16)
    drawnow
end

%% --------------------------------------
function H = fval(ax)
H = zeros(1, size(ax, 2));
for k = 1:size(ax, 2)
    if size(ax,1)<3 %preparation for one sweeping parameter
        r1=0;
    else
        r1=ax(3,k);
    end
    if size(ax,1)<4 %preparation for doulbe sweeping parameter
        r2=0;
    else
        r2=ax(4,k);
    end
    x = ax(1, k)+r1-r2^2;
    y = ax(2, k)+r1^2-r2;
    H(k) = x^4 + y^4 - 1.3^4;
end

end

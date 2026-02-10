%% Multi-Dimensional Bisection Method
% if you would like to carry out more iteration in a high 'parameter dimension' problem
%, then it would be very hard (& time-memory consuming) to connect the points for plotting.
% If you compute and plot the points only, than you can save a lot of time.
% Usually to plot the points only is enought for iteration.

% definition of the parameter space
% the limits and the initial mesh
ax = [];
ax(1).val = linspace(-3, 0, 3);
ax(2).val = linspace(-3, 0, 3);
ax(3).val = linspace(0, 3, 3);

%% function for which the roots are detected
%the calculatino of the connectivity is swithed off
% (you can save a lot of time in some situation)
mdbm_options=mdbmset('connections',false,'interporder',0); %test it with interporder =0,1,2 too!
mdbm_sol = mdbm(ax, @(ax) sum(ax.^2,1)-5, 3, mdbm_options);
%note, mdbm_sol.DT is empty

figure(4), clf
subplot(2,3,1)
hold on
plot_mdbm(mdbm_sol);
shading interp

% you can do the connection later
% There is two different mtehod

%% 1. face neighbour based connection ---------------------------
% leading to less overlapping elements, but memory intensive for large problems

mdbm_sol=DTconnect(mdbm_sol);

% Note, the first elelment of DT (mdbm_sol.DT{1}) refers to edge connections
% if higher order connection is availblae (e.g.: surface like manifold)
% then mdbm_sol.DT{2} show the simplex connections
%  mdbm_sol.DT{3} volume connection

N_soluttion_inteprolation=0; %test it with 2,5,10 too!

subplot(2,3,2)
%lines only
plot_mdbm(mdbm_sol,[],[],1,[],[],N_soluttion_inteprolation) % the last
subplot(2,3,3)
% surface only
plot_mdbm(mdbm_sol,[],[],2,[],[],N_soluttion_inteprolation)
%shading interp

%% 2.corner neighbours connection -----------------
%  faster, less gaps, less memeory
% needed, but leads to man overlapping elemens
mdbm_sol=DTconnect_delunay_high_order(mdbm_sol);


subplot(2,3,5)
%lines only
plot_mdbm(mdbm_sol,[],[],1,[],[],N_soluttion_inteprolation)
subplot(2,3,6)
% surface only
plot_mdbm(mdbm_sol,[],[],2,[],[],N_soluttion_inteprolation)
%shading interp

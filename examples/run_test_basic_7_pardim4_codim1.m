
%% Multi-Dimensional Bisection Method
% -7 basic example -
% parameter dimension : 4
%co-dimension (number of equations): 1

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(0,4,3);%x
ax(2).val=linspace(0,4,3);%y
ax(3).val=linspace(0,4,3);%z
ax(4).val=linspace(2,3,2);%r

% number of iteration
Niteration=3;%take care, the large values can easily lead to memory problem
%% function for which the roots are detected
bound_fuction_name='fval_basic_7_pardim4_codim1';
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration);%zero

figure(7)
subplot(1,2,1)
plot_mdbm(mdbm_sol);
alpha 0.3
title(['DTconncetion time: ', num2str(mdbm_sol.opt.times.DTconnect),' [s]'])
drawnow
% if you would like to carry out more iteration in a high 'parameter dimension' problem
%, then it would be very hard (& time consuming) to connect the points for plotting.
% If you compute and plot the points only, than you can save a lot of time
% The last parameter defines, that no connection is needed:
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbmset('connections',false));
figure(7)
subplot(1,2,2)
plot_mdbm(mdbm_sol);
title(['DTconncetion time: ', num2str(mdbm_sol.opt.times.DTconnect),' [s]'])
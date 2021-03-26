
%% Multi-Dimensional Bisection Method - with constraints
% test example

% clear all
% close all
% clc


% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,7);
ax(2).val=linspace(-3,3,7);
ax(3).val=linspace(-3,3,7);


% function for which the roots are detected
bound_fuction_name='fval_complex_8_constrained';
par=[];


mdbm_options=mdbmset('isconstrained',false,'interporder',1);
%% -----------
par.type='constrain';
mdbm_options.isconstrained=0;% set the mdbm method, to consider the last value of the 'fval_complex_constrained' output as a constrain
par.constrained=0;% set the 'fval_complex_constrained' method, to compute the constrain
mdbm_sol_CONST=mdbm(ax,bound_fuction_name,3,mdbm_options,par);
figure(106),clf
shading interp
ghandle=plot_mdbm(mdbm_sol_CONST,'r');
set(ghandle,'LineStyle','none')
hold on
alpha 0.2
drawnow
%% -----------
par.type='fun1';
mdbm_options.isconstrained=1;% set the mdbm method, to consider the last value of the 'fval_complex_constrained' output as a constrain
par.constrained=1;% set the 'fval_complex_constrained' method, to compute the constrain
mdbm_sol_fun1=mdbm(ax,bound_fuction_name,4,mdbm_options,par);
ghandle=plot_mdbm(mdbm_sol_fun1,'b');
set(ghandle,'LineStyle','none')
alpha 0.2
drawnow
%% -----------
par.type='fun2';
mdbm_options.isconstrained=1;% set the mdbm method, to consider the last value of the 'fval_complex_constrained' output as a constrain
par.constrained=1;% set the 'fval_complex_constrained' method, to compute the constrain
mdbm_sol_fun2=mdbm(ax,bound_fuction_name,4,mdbm_options,par);
ghandle=plot_mdbm(mdbm_sol_fun2,'g');
set(ghandle,'LineStyle','none')
alpha 0.2
drawnow
%% -----------
par.type='fun12';
mdbm_options.isconstrained=0;% set the mdbm method, to consider the last value of the 'fval_complex_constrained' output as a constrain
par.constrained=0;% set the 'fval_complex_constrained' method, to compute the constrain
mdbm_sol_fun12=mdbm(ax,bound_fuction_name,7,mdbm_options,par);
plotsolall=plot_mdbm(mdbm_sol_fun12,'k');
set(plotsolall,'LineWidth',1)
drawnow

% % post process filtering--- ("no-comment" (yet))----
% par.type='constrain';
% par.constrained=0;
% mdbm_sol_filter=mdbm_sol_fun12;
% H=fval_test_constrained(mdbm_sol_fun12.posinterp,par);
% 
% plot3(mdbm_sol_filter.posinterp(1,H>=0),...
%     mdbm_sol_filter.posinterp(2,H>=0),...
%     mdbm_sol_filter.posinterp(3,H>=0),'go')
% 
% mdbm_sol_filter.posinterp(:,H<0)=NaN;
% plotsolfilter_mdbm=plot_mdbm(mdbm_sol_filter,'b',[],[],0);
% set(plotsolfilter_mdbm,'LineWidth',2,'Marker','o')
%% -----------
par.type='fun12';
mdbm_options.isconstrained=1;% set the mdbm method, to consider the last value of the 'fval_complex_constrained' output as a constrain
par.constrained=1;% set the 'fval_complex_constrained' method, to compute the constrain
mdbm_sol_fun12_C=mdbm(ax,bound_fuction_name,7,mdbm_options,par);
plotsolall_C=plot_mdbm(mdbm_sol_fun12_C,'k');
set(plotsolall_C,'LineWidth',3)
drawnow

legend('boundary of the constraint',...
    'fun_1=0 with constraint',...
    'fun_2 = 0 with constraint',...
    'fun_1 = 0 & fun_2 = 0',...
    'fun_1 = 0 & fun_2 = 0 with constraint','Location','northeast')
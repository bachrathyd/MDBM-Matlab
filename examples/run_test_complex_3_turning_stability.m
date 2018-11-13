
%% Multi-Dimensional Bisection Method
% -3 complex example -
% parameter dimension : 3
% co-dimension (number of equations): 2
%
% computation of the bifurcation curves (stability boundaries)
% of the turning process with the traditional proecss damping effect



%% definition of the parameter space
%the limits and the initial mesh

%first axis - OM spindle speed [rad/s]
OMN=20;%25;%[db]
OMmin=0.05;
OMmax=0.6;
OMaxis=1./linspace(1/OMmin,1/OMmax,OMN);%inversly linear initial mesh

%second axis - w axial depth of cut
wN=6;%25;%[db]
wmin=0;
wmax=1;
waxis=linspace(wmin,wmax,wN);


%third axis - om chatter frequency
omcN=10;%25;%[db]
omcmin=0.6;
omcmax=1.8;
omcaxis=linspace(omcmin,omcmax,omcN);


ax=[];
ax(1).val=OMaxis;%OM
ax(2).val=waxis;%w
ax(3).val=omcaxis;%omc

%% extra constant parameters

par.zeta=0.05;
par.procdamp=0.005;
par.contraintonly=false;

%% number of iteration
Niteration=4;
%% function for which the roots are detected
bound_fuction_name='fval_complex_3_turning_stability';
mdbm_options=mdbmset('interporder',0,'isconstrained',true);%due to the very dens structure at low spindle speeds, fist order interpolation can lead to wrong results (which cannot be 'continued') and segments would be lost
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_options,par);
mdbm_sol.opt.interporder=1;% for the final first order interpolation
mdbm_sol.opt.bracketingdistance=5;%due to the very dens at low spindle speeds
mdbm_sol=interpolating_cubes(mdbm_sol);
mdbm_sol=DTconnect(mdbm_sol);
%%

figure(103),clf
subplot(2,1,1)
title('Turning stability with traditional process damping effect')
ghandle=plot_mdbm(mdbm_sol,[],[1,3,2],[],[],ax);
set(ghandle, 'LineWidth',2)
view(2)
xlabel('Dimensionless spindle speed')
ylabel('chatter frequency')

subplot(2,1,2)
ghandle=plot_mdbm(mdbm_sol,[],[],[],[],ax);
set(ghandle, 'LineWidth',2)
view(2)
xlabel('Dimensionless spindle speed')
ylabel('axial depth of cut')

drawnow

%% refine the lower speed range along the spindle speed only

mdbm_sol.opt.refinetype='all';% refine all the axis along the specified dimensions
mdbm_sol=refine(mdbm_sol,[3,3]); % refinement along the spindle speed axis only (however, it is refined twice!!!)

mdbm_sol.opt.refinetype='pos';% refine a selected range alon the specified dimensions
mdbm_sol=refine(mdbm_sol,[1,0,0.3]); % refinement along the spindle speed axis (first parameter) only in the ragne [0,0.3]
mdbm_sol=interpolating_cubes(mdbm_sol); %interpolation of the new points
mdbm_sol=refine(mdbm_sol,[1,0,0.1]);  % refinement along the spindle speed axis (first parameter) only in the ragne [0,0.1]

mdbm_sol.opt.refinetype='all';% refine all the axis along the specified dimensions
mdbm_sol=refine(mdbm_sol,3); % refinement along the spindle speed axis only

mdbm_sol.opt.interporder=2;% for the final second order interpolation
mdbm_sol.opt.bracketingdistance=4;%due to the very dens at low spindle speeds
mdbm_sol=checkneighbour(mdbm_sol);%interpolation of the new points
mdbm_sol=interpolating_cubes(mdbm_sol);%interpolation of the new points
mdbm_sol=DTconnect(mdbm_sol);%connection of the final results

figure(103),clf
subplot(2,1,1)
title('Turning stability with traditional process damping effect')
ghandle=plot_mdbm(mdbm_sol,[],[1,3,2],[],[],ax);
set(ghandle, 'LineWidth',2)
view(2)
xlabel('Dimensionless spindle speed')
ylabel('chatter frequency')

subplot(2,1,2)
ghandle=plot_mdbm(mdbm_sol,[],[],[],[],ax);
set(ghandle, 'LineWidth',2)
view(2)
xlabel('Dimensionless spindle speed')
ylabel('axial depth of cut')

drawnow

%% plot the constraints only
par.contraintonly=true; %not the constrain is independent from the omc parameter, thus, only a two parameter computation should be evaluated to have a faster solution
mdbm_solConst=mdbm(ax,bound_fuction_name,3,[],par);
subplot(2,1,2),hold on
plot_mdbm(mdbm_solConst,'r',[],1);

%% determine the instablility gradient (the direction where the system has more unstable rooths
instabgrad=mdbm_sol.gradient(:,1,:)+1i*mdbm_sol.gradient(:,2,:);
instabgrad=imag(bsxfun(@times,instabgrad,conj(instabgrad(end,:,:))));
%unifying the gradients
for kpos=1:size(instabgrad,2)
    instabgrad(:,kpos)=instabgrad(:,kpos)/norm(instabgrad(:,kpos));
end
posvect=mdbm_sol.posinterp;
%plot
hold on
% plot3(posvect(1,:),posvect(2,:),posvect(3,:),'r.')

quiver3(posvect(1,:),posvect(2,:),posvect(3,:),...
    instabgrad(1,:),instabgrad(2,:),instabgrad(3,:),5);

legend({'Stability limits (bifurcation curves)','applied constraints','instability gradient'})

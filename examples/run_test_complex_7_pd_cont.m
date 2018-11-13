%% Multi-Dimensional Bisection Method
% -5 complex example -
% parameter dimension : 3
% co-dimension (number of equations): 2
%
% computation of the bifurcation curves (stability boundaries)
% of the delayed PD contorl


%% definition of the parameter space
ax=[];
ax(1).val=linspace(-25,20,11);%p
ax(2).val=linspace(-10,6,11);%d
ax(3).val=linspace(-30,30,21);%omc

%% extra constant parameters
par.a=6;
par.D=0.2;

par.interpolationorder=2;
mdbm_sol=mdbm(ax,'fval_complex_7_pd_cont',5,[],par);

figure(103),clf
ghandle=plot_mdbm(mdbm_sol);
set(ghandle, 'LineWidth',2)
view(2)
xlabel('p')
ylabel('d')

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




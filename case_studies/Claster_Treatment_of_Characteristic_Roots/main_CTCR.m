
%% Multi-Dimensional Bisection Method
% CTCR example - nautral DDE with two delays
% Claster Treatment of Characteristic Roots
% (the original CTCR is slightly diffenet but the concept is the same)

%%- traditional mapp in tau1,tau2 and omega space based on the
%%characteristic equation:
% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(0,3*2*pi,28);%tau1
ax(2).val=linspace(0,3*2*pi,28);%tau11
ax(3).val=linspace(0.01,2,16);%\omega

par.a=1;
par.zeta=0.2;
par.b=0.4;%0.7;
par.c=0.3;
% function for which the roots are detected
bound_fuction_name=@fval_CTCR_comp_tau_Base;
% number of iteration
Niteration=3;%take care, the large values can easily lead to memory problem
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,[],par);

figure(1)
clf
subplot(1,2,2)
%plot_mdbm(mdbm_sol,'k');

graphandle0=plot_mdbm(mdbm_sol);% you can set the edge color separately
set(graphandle0,'LineWidth',3)
xlabel("tau1")
ylabel("tau2")
zlabel("omega")
grid on
view(2)

% projection into phase coordinates
xyz=mdbm_sol.posinterp;
tau1=xyz(1,:);
tau2=xyz(2,:);
om=xyz(3,:);
fi1=mod(tau1.*om,2*pi);
fi2=mod(tau2.*om,2*pi);

figure(1)
%clf
subplot(1,2,1)
plot3(fi1,fi2,om,'o',MarkerSize=10)%,om
hold on
grid on
%% Multi-Dimensional Bisection Method
% CTCR example - nautral double delay

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(0,2*pi,8);%Phi1
ax(2).val=linspace(0,2*pi,8);%Phi1
ax(3).val=linspace(0.01,2,16);%\omega


par.a=1;
par.zeta=0.2;
par.b=0.4;%0.7;
par.c=0.3;
% function for which the roots are detected
bound_fuction_name=@fval_CTCR;
% number of iteration
Niteration=4;%take care, the large values can easily lead to memory problem
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,[],par);



xyz=mdbm_sol.posinterp;
fi1=xyz(1,:);
fi2=xyz(2,:);
om=xyz(3,:);
figure(1)
%clf
subplot(1,2,1)

plot3(fi1,fi2,om,'.',MarkerSize=15)%,om
xlabel("Phi1")
ylabel("Phi2")
zlabel("omega")
set(gca, 'ZScale', 'log');
grid on


%% determine the instablility gradient (the direction where the system has more unstable rooths
instabgrad_phi12=mdbm_sol.gradient(:,1,:)+1i*mdbm_sol.gradient(:,2,:);
instabgrad=-imag(bsxfun(@times,instabgrad_phi12,conj(instabgrad_phi12(end,:,:))));
%unifying the gradients
for kpos=1:size(instabgrad,3)
    instabgrad(:,kpos)=instabgrad(:,kpos)/norm(instabgrad(:,kpos));
end
posvect=mdbm_sol.posinterp;
%plot
hold on
% plot3(posvect(1,:),posvect(2,:),posvect(3,:),'r.')

quiver3(posvect(1,:),posvect(2,:),posvect(3,:),...
    instabgrad(1,:),instabgrad(2,:),instabgrad(3,:),2);

view(2)
legend({'Stability limits (bifurcation curves)','applied constraints','instability gradient'},'Location','northeast')

instabgrad_tau12=mdbm_sol.gradient(:,1,:)+1i*mdbm_sol.gradient(:,2,:);
instabgrad_tau12(1,:,:)=instabgrad_tau12(1,:,:) .* instabgrad_tau12(3,:,:);
instabgrad_tau12(2,:,:)=instabgrad_tau12(2,:,:) .* instabgrad_tau12(3,:,:);
instabgrad_tau12=-imag(bsxfun(@times,instabgrad_tau12,conj(instabgrad_tau12(end,:,:))));
%unifying the gradients
for kpos=1:size(instabgrad,2)
    instabgrad_tau12(:,kpos)=instabgrad_tau12(:,kpos)/norm(instabgrad_tau12(:,kpos));
end

figure(1)
subplot(1,2,2)
for k1=-2:2
    tau1=(fi1+k1*2*pi)./om;
    %igrad1=(instabgrad(1,:))./om;
    for k2=-5:5
        tau2=(fi2+k2*2*pi)./om;
        hold on
        plot(tau1,tau2,'o',MarkerSize=5)%,om

axis tight

        quiver(tau1,tau2,...
            instabgrad_tau12(1,:),instabgrad_tau12(2,:),3);
        %  quiver(tau1,tau2,  igrad1,igrad2);
        hold on
    end
end
xlim([0,15])
xlabel("tau1")
ylim([0,15])
ylabel("tau2")

title({"c=",par.c})


drawnow;



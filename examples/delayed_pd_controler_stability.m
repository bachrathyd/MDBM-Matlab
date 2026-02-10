%% Multi-Dimensional Bisection Method
% -5 complex example -
% parameter dimension : 3
% co-dimension (number of equations): 2
%
% computation of the bifurcation curves (stability boundaries)
% of the delayed PD contorl


%% definition of the parameter space
ax=[];
ax(1).val=linspace(-5,20,11);%p
ax(2).val=linspace(-2,12,11);%d
ax(3).val=linspace(-0.1,10,21);%omc

%% extra constant parameters

par.wn=1;%natural frequency
par.zeta=0.01;%damping
par.tau=0.2;

mdbm_sol=mdbm(ax,@pd_delay_contoller,3,[],par);

figure(103),clf
subplot(1,2,1)
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


%dermineing for different characteristic damping

%% definition of the parameter space

ax=[];
ax(1).val=linspace(-5,20,11);%p
ax(2).val=linspace(-2,12,11);%d
ax(3).val=linspace(-0.1,10,21);%omc
ax(4).val=linspace(3,-4,11);%sigma

mdbm_options=mdbmset('connections',false);
mdbm_sol_sigma=mdbm(ax,@pd_delay_contoller,2,mdbm_options,par);

mdbm_sol_sigma=DTconnect_delunay_high_order(mdbm_sol_sigma);


figure(103)
subplot(1,2,2)
ghandle_sigma=plot_mdbm(mdbm_sol_sigma,[],[1,2,4,4]);%forcige the colorscale same as the z axis    colormap turbo
shading interp
view(2)
xlabel('p')
ylabel('d')
zlabel('sigma')



%% fancy coloring, stable range is different form the unstable one
% 1. Define the number of levels for smoothness
n = 256*4*6; 

% 2. Calculate the split point
% Total range is 6 units (-4 to 2). 
% The portion from -4 to 0 is 4/6 (or 2/3) of the total scale.
split_idx = round(n * (4/6));

% 3. Create the Gradient (Blue to Red)
% Interpolate R from 0 to 1, G is 0, B from 1 to 0
red_part =zeros(split_idx, 1); 
blue_part = linspace(1, 0, split_idx)';
green_part = linspace(0, 1, split_idx)';
gradient_section = [red_part, green_part, blue_part];

% 4. Create the Solid Section (Pure Red)
red_part =ones(n - split_idx, 1); 
blue_part = linspace(1, 0, n - split_idx)';
green_part = zeros(n - split_idx, 1);

solid_section = [red_part, green_part, blue_part];
% 5. Combine and apply
custom_map = [gradient_section; solid_section];

% Apply to your figure
colormap(custom_map);
c = colorbar;
caxis([-4 2]); % Ensure the axis matches your data range



c.Label.String = 'sigma - Real( \lamda )';
view(3)
pause(2)
view(2)
%% ------------------------------------------------------------------------
function CharEQ_Re_Im=pd_delay_contoller(ax,par)

CharEQ_Re_Im=zeros(2,size(ax,2));

for kax=1:size(ax,2)

    p=ax(1,kax);%proportional gain
    d=ax(2,kax);%derivatie gain
    om=ax(3,kax);%chatter frequency


    if size(ax,1)>3
        sigma=ax(4,kax);
    else
        sigma=0;
    end
    lamda=sigma + 1i*om;% critial frequency
    tau=par.tau;%delay

    D=lamda^2+(2*par.zeta*par.wn)*lamda+par.wn^2+p*(exp(-lamda*tau))+d*lamda*(exp(-lamda*tau));

    CharEQ_Re_Im(1,kax)=real(D);
    CharEQ_Re_Im(2,kax)=imag(D);
end

end

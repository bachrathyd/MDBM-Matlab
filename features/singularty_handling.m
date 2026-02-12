%% Multi-Dimensional Bisection Method
% singularity problem
ax = [];
ax(1).val = linspace(-2,8, 10);
ax(2).val = linspace(0, 5, 10);

foo=@(x) (sin(x(1,:)).^2+cos(x(2,:)).^2-0.5)./cos(x(2,:)/2+x(1,:)/1.5);
toc
mdbm_sol_sign_change = mdbm(ax, foo, 5);%initial solution
toc
figure(2), clf
subplot(3,2,1)
plot_mdbm(mdbm_sol_sign_change, 'k');
title("simple mdbm solution for sign changes")
view(2)
hold on
subplot(3,2,3)
plot_mdbm(mdbm_sol_sign_change, 'k',[],0);hold on
plotthecomputedpoints(mdbm_sol_sign_change)
title("the function values tends to inf at the singular values")
zlim([-10,10])
view(3),shading interp, alpha 0.3

%% Post filtering the singular point by reevaluating the function in the
% interpolated points.
% Note, it can be expensive if foo is complicated!!!

function_val_at_signchange=foo(mdbm_sol_sign_change.posinterp);

% Plot the function value distribution
% plot(log(sort(abs(function_val_at_signchange))),'.')
limit_val=1e-1; %finding the proper limit value is hard, and it also can depend on the final resolution,

% % TODO: you can play with this parameret to see the effect
% limit_val=1e-3; %too small
% limit_val=1e2; %too large
is_close_to_zeros=abs(function_val_at_signchange)<limit_val;

subplot(3,2,5)
plot(mdbm_sol_sign_change.posinterp(1,is_close_to_zeros),...
    mdbm_sol_sign_change.posinterp(2,is_close_to_zeros),'g.')
hold on
plot(mdbm_sol_sign_change.posinterp(1,~is_close_to_zeros),...
    mdbm_sol_sign_change.posinterp(2,~is_close_to_zeros),'r.')
legend({"sign change","singularity"},'Location','northeast')
title('post filtered points')

% you might try to eliminate the n-cubes directly by modify the mdbm_sol
% structure (not advised)
mdbm_sol_sign_change_modif=mdbm_sol_sign_change;
mdbm_sol_sign_change_modif.ncubevect=mdbm_sol_sign_change_modif.ncubevect(:,is_close_to_zeros);
mdbm_sol_sign_change_modif.ncubelin=mdbm_sol_sign_change_modif.ncubelin(:,is_close_to_zeros);
mdbm_sol_sign_change_modif.posinterp = mdbm_sol_sign_change_modif.posinterp(:,is_close_to_zeros);
mdbm_sol_sign_change_modif.gradient=mdbm_sol_sign_change_modif.gradient(:,:,is_close_to_zeros);
mdbm_sol_sign_change_modif.curvnorm=mdbm_sol_sign_change_modif.curvnorm(:,is_close_to_zeros);

%you can recover the structure by run 0 more iteration:
mdbm_sol_sign_change_modif=mdbm(mdbm_sol_sign_change_modif,0);
plot_mdbm(mdbm_sol_sign_change_modif,'k')
%you can increase further the resolution, but note if you do not switch off
%the neighbour checking it might recover the lost segments of the "singular-curves"
% (if it connected to the "zero-curve"
mdbm_sol_sign_change_modif=mdbm(mdbm_sol_sign_change_modif,1);
plot_mdbm(mdbm_sol_sign_change_modif,'b')
%% False solution appears, at x= k*pi, and y=k*pi, where the sign change is caused by the singularity (the function tends to inf / -inf)


%Trying to eliminate the false points via constraint
%limiting the maximum value, by theory at the constraint will hide the singularity

%setting the limit too low, will remove many solutions if the zero-curve
%crosses the singularity-curve
limit_small=0.15;
%with a good choice 'only' some part might missing (but still can lead to
%discontinuity in crossing appears)
limit_acceptable=1.5;
%Too large value might be ineffective
limit_large=15;
%Note. These values also depend on the final resolution

limis=[limit_small,limit_acceptable,limit_large];
for k =1:length( limis)
    limit=limis(k);
    foo_const=@(x) limit-abs(foo(x));
    subplot(3,2,2*k)
    plot_mdbm(mdbm_sol_sign_change, 'k');
    mdbm_sol_constraint_boundary_only = mdbm(ax, foo_const, 3);%initial solution
    hold on
    plot_mdbm(mdbm_sol_constraint_boundary_only, 'r');

    title("limit: "+num2str(limit))
    mdbm_sol_zeros_by_const = mdbm(ax, @(x) [foo(x);foo_const(x)], 3,mdbmset('isconstrained',true));%initial solution
    gh=plot_mdbm(mdbm_sol_zeros_by_const, 'g');
    set(gh,'Marker','o'),view(2)
    legend({'sign changing', 'constraint boundary','sign change by constraint'},'Location','northeast')
    view(2)
end
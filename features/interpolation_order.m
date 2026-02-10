%demonstration of the interpolation order (0,1,2) and the convergence rate

%% Multi-Dimensional Bisection Method
% -2 basic example -
% parameter dimension : 2
%co-dimension (number of equations): 1

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,3,4);
ax(2).val=linspace(-3,3,4);

%% function for which the roots are detected
bound_fuction_name=@(ax) ax(1,:).^2+ax(2,:).^2-2^2;
Niteration=3
mdbm_options=mdbmset('connections',1,'checkneighbour',Inf,'checkneighbourinallsteps',1,'directionalneighbouronly',0,'cornerneighbours',1);
mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_options);


figure(2),clf
subplot(1,3,1)
plotobject=plot_mdbm(mdbm_sol,'k');
set(plotobject,'LineWidth',2)
view(3)


%plotting all the point where the function is evaluated
evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
X=evalpos(1,:);
Y=evalpos(2,:);
Z=mdbm_sol.HC;
hold on
plot3(X(Z>0),Y(Z>0),Z(Z>0),'r.')
plot3(X(Z<0),Y(Z<0),Z(Z<0),'g.')
plot3(X(Z==0),Y(Z==0),Z(Z==0),'m+')
view(2)
%% ----- Check the radius error for different final interpolation order ----
disp('The lagrest deviance from the object')
colorslegened='rgb';
for InterpolationOrder=0:2
    mdbm_options=mdbmset('interporder',InterpolationOrder);
    mdbm_sol=mdbm(ax,bound_fuction_name,Niteration,mdbm_options);
    radiuserror(InterpolationOrder+1)=max(abs((mdbm_sol.posinterp(1,:).^2+mdbm_sol.posinterp(2,:).^2).^0.5-2));
    figure(2),subplot(1,3,2)
    hold on
    plot_mdbm(mdbm_sol,colorslegened(InterpolationOrder+1));
end
legend(...
    {['final interpolation order: 0 , maximal radius error: ',num2str(radiuserror(1))],...
    ['final interpolation order: 1 , maximal radius error: ',num2str(radiuserror(2))],...
    ['final interpolation order: 2 , maximal radius error: ',num2str(radiuserror(3))]}, 'Location', 'northoutside')

%check the convergence rate as the number of interation
figure(2)
subplot(1,3,3)
hold on
grid on
xlabel('Iteration number')
ylabel('Radius error (Mean + Std and Max)')
set(gca,'YScale','log')
colorslegened='rgb';
for Ninter= 1:10
    for InterpolationOrder=0:2
        mdbm_options=mdbmset('interporder',InterpolationOrder);
        mdbm_sol=mdbm(ax,bound_fuction_name,Ninter,mdbm_options);
        
        errors = abs((mdbm_sol.posinterp(1,:).^2+mdbm_sol.posinterp(2,:).^2).^0.5-2);
        radiuserror_max(InterpolationOrder+1,Ninter) = max(errors);
        radiuserror_mean(InterpolationOrder+1,Ninter) = mean(errors);
        radiuserror_std(InterpolationOrder+1,Ninter) = std(errors);
    end
    subplot(1,3,3)
    cla
    hold on
    for InterpolationOrder=0:2
        errorbar(1:Ninter, radiuserror_mean(InterpolationOrder+1,1:Ninter), radiuserror_std(InterpolationOrder+1,1:Ninter), [colorslegened(InterpolationOrder+1),'-o'],'DisplayName',['Mean Order ',num2str(InterpolationOrder)])
        plot(1:Ninter, radiuserror_max(InterpolationOrder+1,1:Ninter), [colorslegened(InterpolationOrder+1),':x'],'DisplayName',['Max Order ',num2str(InterpolationOrder)])
    end
    legend('Location','northoutside')
    drawnow
end

% Approximation of convergence rate for the last 5 steps
disp('Estimated convergence rates (last 5 steps):')

for InterpolationOrder=0:2
    % Convergence rate based on the slope of log2(error) vs iteration
    % Error approx C * (1/2)^(rate * Ninter)
    % log2(Error) approx log2(C) - rate * Ninter
    p = polyfit(6:10, log2(radiuserror_max(InterpolationOrder+1,6:10)), 1);
    rate = -p(1);
    fprintf('Interpolation Order %d: %.2f\n', InterpolationOrder, rate);
    
end

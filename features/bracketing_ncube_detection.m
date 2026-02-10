%% Multi-Dimensional Bisection Method
%This version breaks the trade-offs into bullet points, making it much easier to read.
%To determine whether an n-cube is bracketing, we calculate the distance from the center of the n-cube to the closest point on the fitted hyperplane (using the Euclidean norm).
%
%The norm type is defined by mdbm_set.bracketingnorm (default is 2).
%The acceptable distance threshold is defined by mdbm_set.bracketingdistance.
%
%Note: For a normalized n-cube of size 2 (range [-1, 1]), the distance from the center to the closest face is 1, and the distance to the farthest corner is sqrt(length(ax)).
%
%If the function changes in a non-smooth way, a larger mdbm_set.bracketingdistance should be used. However, there is a trade-off:
%
%Too large: Leads to a very wide band around the solution (n-cubes further away are kept and used via extrapolation). This increases CPU time and causes plotting artifacts.
%
%Too small: May cause real bracketing n-cubes to be falsely marked as non-bracketing. Consequently, the continuation algorithm cannot "jump" through them, leading to uncharted components of the manifold.
%

ax = [];
ax(1).val = linspace(-3, 3, 5);
ax(2).val = linspace(-3, 3, 5);

bracketing_distance_v=[0.6:0.2:1.4,2,4,8,20];
figure(2), clf
for k=1:length(bracketing_distance_v)
    subplot(3,3,k)
    mdbm_set= mdbmset('bracketingdistance',bracketing_distance_v(k));
    foo=@(x) ((x(1,:).^2.0 + x(2,:)) - 1.0^2.0).*x(1,:);
    mdbm_sol = mdbm(ax, foo, 4,mdbm_set);

    plotobject = plot_mdbm(mdbm_sol, 'k');
    set(plotobject, 'LineWidth', 2)
    view(2)
    evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
    N_eval=size(evalpos,2)
    Fval=mdbm_sol.HC;
    X=evalpos(1,:);
    Y=evalpos(2,:);
    hold on
    scatter3(X,Y,Fval,10,sign([Fval(1,:)',-Fval(1,:)',0*Fval(1,:)']),'filled')
    val = bracketing_distance_v(k); % Assume this is your value
    title(["bracketing\_distance = " + val; "N eval = " + N_eval]);
    view(2)
end

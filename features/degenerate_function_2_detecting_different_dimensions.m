% Presentation of the multiple-degenerate type example

foo=@(ax) [sin((abs(ax+1)-abs(ax-1)-2*ax)*pi);-sum(ax,1)+0.2;];

ax=linspace(-1.8,1.81,1000);
figure(1),clf,
subplot(1,3,1)
plot(ax,foo(ax))
legend({'function', 'constraint'}, 'Location', 'northoutside')

ylabel('Function value - applied to each parameter (H_i=f(x_i)')
hold on

mdbmoptions=mdbmset();
mdbmoptions.zerotreshold=1e-10;
mdbmoptions.refinetype='object';
mdbmoptions.isconstrained=1;
mdbmoptions.interporder=1;


ax=[];
for k=1:3 %increaseing the parameter dimension
    ax(k).val=linspace(-1.8,1.81,5);
    
    subplot(1,3,k)
    hold on
    mdbm_sol=mdbm(ax,foo,5-k,mdbmoptions);
    
    plotobject=plot_mdbm(mdbm_sol,[],[],0:2);
    set(plotobject,'LineWidth',0.5)
    if k==3
        view(110,27)
%         shading interp
    end
end

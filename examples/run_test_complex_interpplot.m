%% Multi-Dimensional Bisection Method

ax=[];
ax(1).val=linspace(-3,3.1,5);
ax(2).val=linspace(-3,3.1,5);
ax(3).val=linspace(0.3,3.1,5);

mdbmoptions=mdbmset();
mdbmoptions.isconstrained=1;
mdbmoptions.refinetype='all';

mdbmoptions.interporder=2;
mdbmoptions.cornerneighbours=mdbmoptions.interporder>1;
%% function for which the roots are detected
bound_fuction_name='fval_complex_9_interpplot';

mdbm_sol=mdbm(ax,bound_fuction_name,0,mdbmoptions);% no refinement, only initialization!!!

mdbm_sol=interpolating_cubes(mdbm_sol);
axtoloc=[];
for k=1:3 % determine and plot the results in each steps
    disp(k)
    mdbm_sol=refine(mdbm_sol);
    mdbm_sol=interpolating_cubes(mdbm_sol);
    
    mdbm_sol=DTconnect(mdbm_sol);
    figure(8)
    axtoloc(k)=subplot(2,2,k);
    plot_mdbm(mdbm_sol,[],[],2,[],ax);
    view(212,77)
    title(['After ', num2str(k),' iteration'])
    shading interp
    drawnow
end
mdbm_sol=interpolating_cubes(mdbm_sol);
mdbm_sol=checkneighbour(mdbm_sol);
mdbm_sol=DTconnect(mdbm_sol);
figure(8)
axtoloc(4)=subplot(2,2,4);
plot_mdbm(mdbm_sol,[],[],2,[],ax);
title('After the checkneighbour')
set(gcf,'Position', [100,100,900,600])
view(212,77)
shading interp
drawnow

linkaxes(axtoloc,'xy')
linkprop(axtoloc, 'CameraPosition');


%% Check differnet interpolation order
axcucc=[];
figure(1234),clf
set(gcf,'Position', [100,100,900,600])
mdbm_sol=mdbm(ax,bound_fuction_name,2,mdbmoptions);% no refinement, only initialization!!!
for iorder=0:2
    axcucc(end+1)=subplot(2,3,iorder+1);
    mdbm_sol.opt.interporder=iorder;
    mdbm_sol=interpolating_cubes(mdbm_sol);
    mdbm_sol=DTconnect(mdbm_sol);
    Numerofinterpolation=0;%presenting the numerical results without interpolation, (see the help of plot_mdbm
    plot_mdbm(mdbm_sol,[],[],[],[],[],Numerofinterpolation)
    view(2)
    title({['Order of interpolation: ',num2str(iorder)],[ ' , with original mesh']})
    drawnow
    
    axcucc(end+1)=subplot(2,3,iorder+1+3);
    mdbm_sol_interp=interpplot(mdbm_sol,6);
    plot_mdbm(mdbm_sol_interp)
    title({['Order of interpolation: ',num2str(iorder)],[ ' , with interpolated mesh']})
    shading interp
    lighting flat
    light('Position',[1 -1 -15],'Style','infinite');
    light('Position',[1 -1 25],'Style','infinite');
    light('Position',[10 10 10],'Style','infinite');
    light('Position',[-10 -10 -10],'Style','infinite');
    drawnow
end
linkaxes(axcucc,'xy')
linkprop(axcucc, 'CameraPosition');


%%
mdbm_sol=mdbm(ax,bound_fuction_name,2,mdbmoptions);% no refinement, only initialization!!!
for SN=[3,6,9,12]%10%3:25
    
    figure(8),clf
    set(gcf,'Position', [100,100,900,600])
    mdbm_sol_interp2=interpplot(mdbm_sol,SN);
    
    ax2loc2(1)=subplot(1,2,1);
    plot_mdbm(mdbm_sol);
    % view(2),axis([-0.6215   -0.2586   -1.3978   -0.8532])
    shading interp
    lighting flat
    light('Position',[1 -1 25],'Style','infinite');
    light('Position',[10 10 10],'Style','infinite');
    view(-210,77)
    title('Uninterpolated results')
    
    
    ax2loc2(2)=subplot(1,2,2);
    plot_mdbm(mdbm_sol_interp2);
    % view(2),axis([-0.6215   -0.2586   -1.3978   -0.8532])
    shading interp
    lighting flat
    light('Position',[1 -1 25],'Style','infinite');
    light('Position',[10 10 10],'Style','infinite');
    view(-210,77)
    title(['Number of interpolation segments: ',num2str(SN)])
    
    
    linkaxes(ax2loc2,'xy')
    linkprop(ax2loc2, 'CameraPosition');
    drawnow
    
end
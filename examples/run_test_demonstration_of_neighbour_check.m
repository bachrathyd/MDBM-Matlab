
ax=[];
ax(1).val=linspace(-7,7,5);%x
ax(2).val=linspace(-7,7,5);%y

func=@(ax) sum([abs(sin(ax(1,:))+ax(1,:)+ax(2,:)).^0.5;abs(ax(2:end,:)-0.5).^0.5],1).^2-5;


%%
figure(201),clf,subplot(2,2,1)
mdbm_sol=mdbm(ax,func,6,mdbmset('checkneighbour',0));%six step of iteration, no neighbour check
plot_mdbm(mdbm_sol);
title({'no-neighbour check at all',['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))]})
drawnow

figure(201),subplot(2,2,2)
mdbm_sol=mdbm(ax,func,6,mdbmset('checkneighbour',inf)); %six step of iteration, at each step neighbour check
plot_mdbm(mdbm_sol,[],[],[],[],ax);
title({'automatic neighbour check in each steps',['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))]})
drawnow


figure(201),subplot(2,2,3)
mdbm_sol=mdbm(ax,func,0,mdbmset('checkneighbour',0));%no iteration only initialization
for kiter=1:6
    mdbm_sol=mdbm(mdbm_sol,1);%one refinement
    plot_mdbm(mdbm_sol,[],[],[],[],ax);
    title({['Iteration step without neighbour check ',num2str(kiter)],['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],'press a button for the next step'})
    pause
end
kneigh=0;
kstep=0;
while kneigh~=length(mdbm_sol.ncubelin)
    kstep=kstep+1;
    kneigh=length(mdbm_sol.ncubelin);
    mdbm_sol.opt.checkneighbour=1; % only 1 step of neighbour check is allowd
    mdbm_sol=checkneighbour(mdbm_sol);
    mdbm_sol=interpolating_cubes(mdbm_sol);
    mdbm_sol=DTconnect(mdbm_sol);
    plot_mdbm(mdbm_sol,[],[],[],[],ax);
    title({'procedure of neighbour check only at the end',...
        ['number of neighbour checks: ',num2str(kstep)],...
        ['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],...
        '''continuation-like-method''; no-benefit of parallel exectuion (+ timeconsuming neighbour checking)'})
    drawnow
    
end
%%
figure(201),subplot(2,2,4)
mdbm_sol=mdbm(ax,func,0,mdbmset('checkneighbour',0));%no iteration only initialization
plot_mdbm(mdbm_sol,[],[],[],[],ax);
title({['Iteration step ',num2str(0),' with neighbour check '],...
    ['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],...
    '',...
    'press a button for the next step'})
pause
for kiter=1:6
    mdbm_sol=mdbm(mdbm_sol,1);%one refinement
    kneighprew=0;
    kstep=0;
    while kneigh~=length(mdbm_sol.ncubelin)
        kstep=kstep+1;
        kneigh=length(mdbm_sol.ncubelin);
        mdbm_sol.opt.checkneighbour=1;% only 1 step of neighbour check is allowd
        mdbm_sol=checkneighbour(mdbm_sol);
        mdbm_sol=interpolating_cubes(mdbm_sol);
        mdbm_sol=DTconnect(mdbm_sol);
        plot_mdbm(mdbm_sol,[],[],[],[],ax);
        title({['Iteration step ',num2str(kiter),' with neighbour check '],...
            ['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],...
            ['number of neighbour checks: ',num2str(kstep)],''})
        drawnow
    end
    title({['Iteration step ',num2str(kiter),'with neighbour check '],...
        ['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],...
        ['number of neighbour checks: ',num2str(kstep)],...
        'press a button for the next step'})
    pause
end

    title({['Iteration step ',num2str(kiter),'with neighbour check '],...
        ['number of function evaluation: ',num2str(length(mdbm_sol.ncubelin))],...
        ['number of neighbour checks: ',num2str(kstep)],...
        'Done'})

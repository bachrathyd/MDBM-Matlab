%% Multi-Dimensional Bisection Method
% -5 complex example -
% parameter dimension : 2
%co-dimension (number of equations): 1 and 2
%0
% Finding the roots of two transcendent equations,
% and then refine the solutions.
%
% This example shows also check the computational error
% of the Multi-Dimensional Bisection Method.


%% definition of the parameter space
%the limits and the initial mesh


ax=[];
ax(1).val=linspace(-5,5,45);%x
ax(2).val=linspace(-8,8,45);%y

bound_fuction_name='fval_complex_5_transcendent';
% bound_fuction_name=@fval_complex_5_transcendent;

%----------------------------------------------------------

%plot the surface of function 1 for a fines mesh

[X,Y]=ndgrid(linspace(-5,5,50),linspace(-8,8,50));

par=[];
par.funtype=1;
[Z1]=feval(bound_fuction_name,[X(:),Y(:)]',par);
Z1=reshape(Z1,size(X));

figure(105)
subplot(2,2,1)
surf(X,Y,Z1)
shading interp

%plot the roots of function 1
tic
mdbm_sol1=mdbm(ax,bound_fuction_name,4,[],par);
toc
hold on
graphobj=plot_mdbm(mdbm_sol1,'k');
set(graphobj,'LineWidth',5)

title('function 1')
drawnow
%----------------------------------

%plot the surface of function 2 for a fines mesh
par.funtype=2;
[Z2]=feval(bound_fuction_name,[X(:),Y(:)]',par);
Z2=reshape(Z2,size(X));

figure(105)
subplot(2,2,2)
surf(X,Y,Z2)
shading interp


%plot the roots of function 2

mdbm_sol2=mdbm(ax,bound_fuction_name,4,[],par);
hold on
graphobj2=plot_mdbm(mdbm_sol2,'m');
set(graphobj2,'LineWidth',5)


title('function 2')
drawnow
%======================================
%plot the roots of function 1 and 2 together
figure(105)
subplot(2,2,3)
graphobj3=plot_mdbm(mdbm_sol1,'k');
set(graphobj3,'LineWidth',2)
hold on
graphobj4=plot_mdbm(mdbm_sol2,'m');
set(graphobj4,'LineWidth',2)

%compute the roots of function 1 and function 2 togeher
par.funtype=[];

mdbm_sol12=mdbm(ax,bound_fuction_name,7,[],par);
hold on
graphobj=plot_mdbm(mdbm_sol12,'b');
set(graphobj,'LineWidth',2)
set(graphobj,'MarkerSize',8)
set(graphobj,'Marker','o')


title('roots of function 1 and 2')
drawnow
%%

%note, that the error of the Multi-Dimensional Bisection method can be
%decreased by increasing the iteration number
%
%Note, high vale of the iteration can easily lead to Memory problems
%Increase it step-by-step!!!

%~~~~~~~~~~~~ error analysis ~~~~~~~~~~~~~~~
par.funtype=[];
erroriter=[];
for kinterpolationorder=0:2
    
    mdbm_sol12=mdbm(ax,bound_fuction_name,0,mdbmset('interporder',kinterpolationorder,'cornerneighbours',true,'refinetype','all'),par);
    for kiter=1:15
        %disp([kinterpolationorder,kiter])
        mdbm_sol12=refine(mdbm_sol12);
        mdbm_sol12=checkneighbour(mdbm_sol12);%in case of second order interpolation is is important to check the neighbours first, to have enough data for the sceond orded interpolation
        mdbm_sol12=interpolating_cubes(mdbm_sol12);
        erroriter(kiter)=max(max(abs(fval_complex_5_transcendent(mdbm_sol12.posinterp,par))));
    end
    figure(105)
    subplot(2,2,4)
    semilogy(1:kiter,erroriter)
    hold on
    xlabel('number of iteration')
    set(gca,'XTick',1:kiter)
    ylabel('maximal funtion error')
    %     grid on
    legendstring{kinterpolationorder+1}=['Iterp.order = ',num2str(kinterpolationorder)];
    grid on
    drawnow
end
legend(legendstring)


%% If much higher precision is required than the output of the MDBM should be
%used as an input of an another type of root finging algoritm
% e.g.: see the method below, where an fminsearch function is used to each point:

x=zeros(size(mdbm_sol12.posinterp));%initialization of the refined values
for k=1:size(mdbm_sol12.posinterp,2)%refineing the results one-by-one
    x(:,k)= fminsearch( @(xval) norm(fval_complex_5_transcendent(xval,par)),mdbm_sol12.posinterp(:,k),...
        optimset('TolFun',1e-14));
end
figure(105)
subplot(2,2,3)
refinedvalerror=max(max(abs(fval_complex_5_transcendent(x,par))))
plot(x(1,:),x(2,:),'g*','MarkerSize',8)
legend({'sol. of fun. 1 by mdbm','sol. of fun. 2 by mdbm','sol. of fun. 1 & 2 by mdbm','sol. of fun. 1 & 2 by fminsearch'})

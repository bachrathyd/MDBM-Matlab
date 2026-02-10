
%% Multi-Dimensional Bisection Method
% -plotting examples -

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,4,3);%x
ax(2).val=linspace(-3,4,3);%y
ax(3).val=linspace(-3,4,3);%z

% number of iteration
Niteration=2;%take care, the large values can easily lead to memory problem
%% function for which the roots are detected
foo= @(ax) ax(1,:).^2 + ax(2,:).^2 + ax(3,:).^2 - 2.0.^2;
mdbm_sol1=mdbm(ax,foo,Niteration);%zero

%%

%plot in different colorus
figure(201)
subplot(2,2,1)
plot_mdbm(mdbm_sol1);
subplot(2,2,2)
graphandle2=plot_mdbm(mdbm_sol1,'r');
subplot(2,2,3)
graphandle3=plot_mdbm(mdbm_sol1,'g');
subplot(2,2,4)
graphandle4=plot_mdbm(mdbm_sol1,[0.234,0.42,0.4321]);%valid only for surface and line type object
% you can set the edge color separately
set(graphandle4,'EdgeColor','m')
set(graphandle3,'EdgeColor',[0.4,0.05,0.1])%RGB colors
%you can add some light to see the surface structure
subplot(2,2,2)
light('Position',[-1 -1 0],'Style','infinite');


%set the marker type
set(graphandle4,'Marker','o')
set(graphandle4,'MarkerFaceColor','k')
set(graphandle4,'MarkerEdgeColor','g')

%%
% hold on

% represent the solution by different oject types (points, lines, surfaces)
% the dimension of the oject must be defined as the fourth parameter
figure(202)
subplot(1,3,1)
plot_mdbm(mdbm_sol1,[],[],0);
subplot(1,3,2)
plot_mdbm(mdbm_sol1,[],[],1);
subplot(1,3,3)
plot_mdbm(mdbm_sol1,[],[],2);


%% ----------------------

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-0,4,3);%x
ax(2).val=linspace(-3,4,7);%y
ax(3).val=linspace(-3,4,7);%z

% number of iteration
Niteration=3;%take care, the large values can easily lead to memory problem
% function for which the roots are detected
par.k=10;
foo2=@(ax,par) [ax(1,:).^2 + ax(2,:).^2 + ax(3,:).^2 - 2^2; ax(1,:) - ax(2,:) * par.k];

mdbm_sol3=mdbm(ax,foo2,Niteration,[],par);

figure(203)
% define the order of axis in plotting
subplot(2,2,1)
plot_mdbm(mdbm_sol3);
subplot(2,2,2)
plot_mdbm(mdbm_sol3,'r',[2,1,3]);
subplot(2,2,3)
plot_mdbm(mdbm_sol3,[],[3,2,1]);
subplot(2,2,4)
plot_mdbm(mdbm_sol3,'g',[3,1,2],0);


%% the gradinet of the functions can be also plotted
figure(204)
subplot(1,3,1)
plot_mdbm(mdbm_sol1,[],[],[],1);
subplot(1,3,2)
plot_mdbm(mdbm_sol3,[],[3,1,2],[],1);

%the objecthandels is given separately for the "normals"
subplot(1,3,3)
graphandlesSET=plot_mdbm(mdbm_sol3,[],[3,1,2],[],1);


set(graphandlesSET(1),'LineWidth',4)
set(graphandlesSET(2),'LineWidth',2)
set(graphandlesSET(3),'LineWidth',3)
set(graphandlesSET(2),'Color',[1,0.4,0])
set(graphandlesSET(3),'Color','b')
drawnow

shading interp

%% demonstratin the initial (Major Ticks) and the refined axes (Minor Ticks).
figure(210)
ax=[];
ax(1).val=linspace(-2,2,5);%x
ax(2).val=linspace(-2,2,5);%y
mdbm_sol_ax=mdbm(ax,@(ax) sum(abs([0.8,0.1;-0.3,1]*ax).^(1/3),1).^3-2,8);

subplot(1,2,1)
plot_mdbm(mdbm_sol_ax);
view(2)
subplot(1,2,2)
plot_mdbm(mdbm_sol_ax,[],[],[],[],ax);
view(2)

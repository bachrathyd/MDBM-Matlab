%% Multi-Dimensional Bisection Method
% -Exapmle : how to extend a too small inital range -

% definition of the parameter space
%the limits and the initial mesh
ax=[];
ax(1).val=linspace(-3,1,5);
ax(2).val=linspace(-3,1,7);

%% function for which the roots are detected
bound_fuction_name=@(xy) abs(xy(1,:)-0.271).^0.2+abs(xy(2,:)-0.314).^0.2-5^0.3;

mdbm_sol=mdbm(ax,bound_fuction_name,3);
figure(2),clf
plot_mdbm(mdbm_sol,'k',[],[],[],mdbm_sol.ax);
view(2)


waitfor(msgbox({'Now, we can see that the initlai limits of the axis was not large enough!',...
    'Lest, extend them. '}))

%extension
mdbm_sol=extend_axis(mdbm_sol,1,[],1.1:0.1:6);%The first axis is exteded by a grid with the desired resolution 
plot_mdbm(mdbm_sol,'k',[],[],[],mdbm_sol.ax);view(2)
waitfor(msgbox({'The first axis is exteded by a grid with the desired resolution.'}))
mdbm_sol=extend_axis(mdbm_sol,2,[], 5);%along the second axis we add just one ponit, an later it will be refined meny times
plot_mdbm(mdbm_sol,'k',[],[],[],mdbm_sol.ax);view(2)
waitfor(msgbox({'Along the second axis we add just one ponit. Later it will be refined many times'}))

for k=1:6 %refine the second direction repeatedly
mdbm_sol=refine(mdbm_sol,[2,1,8],'pos'); %refinement
mdbm_sol=interpolating_cubes(mdbm_sol); %interpolation of the new points
mdbm_sol=checkneighbour(mdbm_sol);
mdbm_sol=DTconnect(mdbm_sol);
plot_mdbm(mdbm_sol,'k',[],[],[],mdbm_sol.ax);view(2);
view(2)
drawnow
pause(1)
end



evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
X=evalpos(1,:);
Y=evalpos(2,:);
Z=mdbm_sol.HC;
hold on
plot3(X(Z>0),Y(Z>0),Z(Z>0),'r.')
plot3(X(Z<0),Y(Z<0),Z(Z<0),'g.')
plot3(X(Z==0),Y(Z==0),Z(Z==0),'m+')
view(2)
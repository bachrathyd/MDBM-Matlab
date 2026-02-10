function plotthecomputedpoints(mdbm_sol)
%plotting all the point where the function is evaluated
evalpos=axialpos(mdbm_sol.ax,mdbm_sol.vectindex);
Fval=mdbm_sol.HC;
if mdbm_sol.opt.Ndim==1
    X=evalpos(1,:);
    plot(X(Fval>0),Fval(Fval>0),'r.')
    plot(X(Fval<0),Fval(Fval<0),'g.')
    plot(X(Fval==0),Fval(Fval==0),'m+')
    
elseif mdbm_sol.opt.Ndim==2
    X=evalpos(1,:);
    Y=evalpos(2,:);
    
    if mdbm_sol.opt.Ncodim==1
        tri = delaunay(X,Y);
        hold on
        trisurf(tri,X,Y,Fval)
        hold on
        %shading interp
        alpha 0.5
        
        
        scatter3(X,Y,Fval,10,sign([Fval(1,:)',-Fval(1,:)',0*Fval(1,:)']),'filled')
        
        %         plot3(X(Fval>0),Y(Fval>0),Fval(Fval>0),'r.','MarkerSize',8)
        %         plot3(X(Fval<0),Y(Fval<0),Fval(Fval<0),'g.','MarkerSize',8)
        %         plot3(X(Fval==0),Y(Fval==0),Fval(Fval==0),'m+','MarkerSize',8)
        %
        %         plot3(X(Fval>0),Y(Fval>0),Fval(Fval>0),'r.','MarkerSize',8)
        %         plot3(X(Fval<0),Y(Fval<0),Fval(Fval<0),'g.','MarkerSize',8)
        
    elseif mdbm_sol.opt.Ncodim==2
        scatter(X,Y,8,sign([Fval(1,:)',-Fval(2,:)',0*Fval(1,:)']),'filled')
        view(2)
    end
else
    X=evalpos(1,:);
    Y=evalpos(2,:);
    Z=evalpos(3,:);
    if mdbm_sol.opt.Ncodim==1
        scatter3(X,Y,Z,8,sign([Fval(1,:)',-Fval(1,:)',-Fval(1,:)'*0]),'filled')
    elseif mdbm_sol.opt.Ncodim==2
        scatter3(X,Y,Z,8,sign([Fval(1,:)',-Fval(2,:)',-Fval(1,:)'*0]),'filled')
    else
        scatter3(X,Y,Z,8,sign([Fval(1,:)',-Fval(2,:)',Fval(3,:)']),'filled')
    end
    view(3)
end
grid on
end
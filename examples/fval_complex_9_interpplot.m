function H=fval_complex_9_interpplot(ax)
%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(2,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    z=ax(3,k);
     H(1,k)=norm(abs([x,y+sin(x*3)/2,z]),2.58)-2.2;
     H(2,k)=sum(ax(:,k));
end
end
function fval_unitnorm=fval_complex_4_unit_circles(ax,par)
if isempty(par)
    fval_unitnorm=zeros(1,size(ax,2));
    for k=1:size(ax,2)
        fval_unitnorm(k)=norm(ax(1:2,k),ax(3,k))-1;
    end
    
else %only a section    
    fval_unitnorm=zeros(2,size(ax,2));
    for k=1:size(ax,2)
        fval_unitnorm(1,k)=norm(ax(1:2,k),ax(3,k))-1;
        fval_unitnorm(2,k)=ax(3,k)-par;
    end
end
end
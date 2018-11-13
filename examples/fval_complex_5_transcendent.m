function H=fval_complex_5_transcendent(ax,par)

if par.funtype==1 %equation 1 only
    H=sin(ax(2,:)*2+0.5*ax(1,:).^2)+0.2*ax(1,:).^2+0.1*ax(2,:).^2-1;
elseif par.funtype==2 %equation 2 only
    H=cos(ax(1,:)*3)+sin(ax(2,:)*2)-0.5;
else %equation 1 and 2 togheter
    H=[sin(ax(2,:)*2+0.5*ax(1,:).^2)+0.2*ax(1,:).^2+0.1*ax(2,:).^2-1;...
        cos(ax(1,:)*3)+sin(ax(2,:)*2)-0.5];
end
end
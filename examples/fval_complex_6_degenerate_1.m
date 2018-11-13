function H=fval_complex_6_degenerate_1(ax)
%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(1,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    
    x1=abs(x+1)-abs(x-1)-2*x;
    y1=abs(y+1)-abs(y-1)-2*y;

    H(k)=y*sin(x1)+atan(y1);

end

end
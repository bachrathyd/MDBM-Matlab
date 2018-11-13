function H=fval_complex_7_degenerate_2(ax)

 H=[sin((abs(ax+1)-abs(ax-1)-2*ax)*pi);-sum(ax,1)+0.2;];
%  H=[sin((abs(ax+1)-abs(ax-1)-2*ax)*pi)]; 
%  H=[-sum(ax,1)+0.2];

end
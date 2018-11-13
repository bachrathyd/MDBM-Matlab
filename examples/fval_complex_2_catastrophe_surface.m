function [fun_val]=fval_complex_2_catastrophe_surface(ax,par)

%initialization
if isempty(par)
    
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(1,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
elseif par.direc==1  %section along a - axis
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=a-par.val;
elseif par.direc==2 %section along b - axis
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=b-par.val;
    
    
elseif par.direc==3%critical values
    a=ax(1,:);
    b=ax(2,:);
    x=ax(3,:);
    fun_val=ones(2,length(ax(1,:)));
    fun_val(1,:)=a.*sin(x)+x+b;
    fun_val(2,:)=a.*cos(x)+1;%df1/dx=0
end
end
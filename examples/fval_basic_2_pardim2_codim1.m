function H=fval_basic_2_pardim2_codim1(ax)
%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(1,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    H(k)=x^2+y^2-2^2;
end

%% version 2: vectorized
% x=ax(1,:);
% y=ax(2,:);
% H=x.^2+y.^2-2^2;

%% version 3: vectorized, without new variables (fastest)
% H=ax(1,:).^2+ax(2,:).^2-2^2;

end
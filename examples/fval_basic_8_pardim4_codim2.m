function H=fval_basic_8_pardim4_codim2(ax)

%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(2,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    z=ax(3,k);
    r=ax(4,k);
    H(1,k)=x^2+y^2+z^2-r^2;
    H(2,k)=x+2*y;
end


%% version 2: vectorized
% x=ax(1,:);
% y=ax(2,:);
% z=ax(3,:);
% r=ax(4,:);
% H=[x.^2+y.^2+z.^2-r.^2   ;...
%     x-y;];

%% version 3: vectorized, without new variables (fastest)
% H=[ax(1,:).^2+ax(2,:).^2+ax(3,:).^2-ax(4,:).^2   ;...
%     ax(1,:)-ax(2,:);];


end
function H=fval_basic_5_pardim3_codim2(ax,par,val)

%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(2,size(ax,2));
for k=1:size(ax,2)
    x=ax(1,k);
    y=ax(2,k);
    z=ax(3,k);
    H(1,k)=x^2+y^2+z^2-2^2;
    H(2,k)=x-y*par.k;
end

%% version 2: vectorized
% x=ax(1,:);
% y=ax(2,:);
% z=ax(3,:);
% H=[x.^2+y.^2+z.^2-2^2   ;...
%     x-y*par.k];


%% version 3: vectorized, without new variables (fastest)
% H=[ax(1,:).^2+ax(2,:).^2+ax(3,:).^2-2^2   ;...
%     ax(1,:)-ax(2,:)*par.k];



end
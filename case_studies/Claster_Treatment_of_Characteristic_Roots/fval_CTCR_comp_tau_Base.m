function H=fval_CRCT_comp_tau_Base(ax,par)
%% version 1: simple calculate the function value(s) for each parameter points
H=zeros(2,size(ax,2));

for k=1:size(ax,2)
    tau1=ax(1,k);
    tau2=ax(2,k);
    omega=ax(3,k);
    lamda=1i*omega;
    %xpp+zeta*xp+a*x=b*xp(t-tau1)+c*xpp(t-tau2)
    %0=-xpp+a*x+b*xpp(t-tau1)+c*xpp(t-tau2)

    D=lamda^2+par.zeta*lamda+par.a+par.b*lamda*exp(-lamda*tau1)+par.c*lamda^2*exp(-lamda*tau2);
    H(1,k)=real(D);
    H(2,k)=imag(D);
end

end
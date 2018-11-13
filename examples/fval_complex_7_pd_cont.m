function CharEQ_Re_Im=fval_complex_7_pd_cont(ax,par)

CharEQ_Re_Im=zeros(2,size(ax,2));

for kax=1:size(ax,2)
    
    p=ax(1,kax);%spindle speed
    d=ax(2,kax);%axial depth of cut
    om=ax(3,kax);%chatter frequency
    
    
    lamda=1i*om;
    tau=1;
    

    par.a=6;
    par.D=0.2;
    D=lamda^2+(2*par.D*par.a)*lamda+par.a*par.a-p*(exp(-lamda*tau))-d*lamda*(exp(-lamda*tau));
    
    CharEQ_Re_Im(1,kax)=real(D);
    CharEQ_Re_Im(2,kax)=imag(D);
end

end
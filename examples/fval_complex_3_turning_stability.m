function CharEQ_Re_Im_Limit=fval_complex_3_turning_stability(ax,par)

CharEQ_Re_Im_Limit=zeros(3,size(ax,2));


for kax=1:size(ax,2)
    
    Om=ax(1,kax);%spindle speed
    w=ax(2,kax);%axial depth of cut
    om=ax(3,kax);%chatter frequency
    
    zeta=par.zeta;%damping
    procdamp=par.procdamp;%process damping coefficient
    
    lamda=1i*om;
    tau=2*pi/Om;
    
    D=lamda^2+(2*zeta+procdamp*tau)*lamda+1+w*(1-exp(-lamda*tau));
    
    CharEQ_Re_Im_Limit(1,kax)=real(D);
    CharEQ_Re_Im_Limit(2,kax)=imag(D);
    
    constraints(1)=0.5-Om;%Om<0.5 -  max limit: spinle speed (cutting speed)
    constraints(2)=Om-0.07;%Om>0.07 -  min limit: spinle speed (cutting speed)
    constraints(3)=0.15-Om*w;%Om>0.07 -  max limit: Power limit
    constraints(4)=0.9-w;%Om>0.07 -  max limit: deph of cut limit
    
    CharEQ_Re_Im_Limit(3,kax)=min(constraints);
    
end
if par.contraintonly
    CharEQ_Re_Im_Limit=CharEQ_Re_Im_Limit(end,:);
end
end
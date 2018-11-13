function [fun_val]=fval_complex_1_Julia_set_3d(ax,par)
    %initialization
    fun_val=ones(1,length(ax(1,:)));
    for kax=1:size(ax,2)
        z=(ax(1,kax)+1i*ax(2,kax));% Julia set
        c=exp(1i*ax(3,kax));
        k=0;
        while and(k<par.iter,abs(z)<2e5)
            z=z^2+0.7*c;%Julia set for a given paramter c=1
            k=k+1;
        end
         fun_val(1,kax)=abs(z)-2; %unstable if abs(z)>2 %this leads to a bit better interpolation
    end

end
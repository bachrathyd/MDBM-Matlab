function HC=fval_complex_8_constrained(ax,par)

const1=@(ax) (ax(1,:)+1).^2+ax(2,:).^2+(ax(3,:)+0.5).^2-1.5^2; %constrain 1st sphere
const2=@(ax) (ax(1,:)-0.5).^2+(ax(2,:)-1).^2+ax(3,:).^2-1.5^2; %constrain 2 shpere
const12=@(ax) min([const1(ax);const2(ax)],[],1); %combination of the two constrain

fun1=@(ax) sin(ax(1,:)*2+ax(2,:)+ax(3,:))-0.1*ax(2,:).^2-0.5*ax(3,:)-0.5; %wavy surface
fun2=@(ax)  ax(2,:)-ax(3,:)-0.2; % plane

if par.constrained
    C=const12(ax).*min(3-abs(ax),[],1); %constraints for the wall at +-3 in any direction (it will create a nice and smooth results along the boundary of the parameter space)
else
    C=ones(0,size(ax,2)); %no-constraint (It is a bad solution, to suppress the constraints!)
    %it would be better to use [H,par] as varargout
end

if strcmp(par.type,'constrain')%plot the boudary of the constraint
    H=const12(ax);
elseif strcmp(par.type,'fun1') %function 1 only
    H= fun1(ax);
elseif strcmp(par.type,'fun2') %function 1 only
    H=  fun2(ax);
elseif strcmp(par.type,'fun12') %function 1 and 2 together
    H=[fun1(ax);fun2(ax)];
end
HC=[H;C];
end
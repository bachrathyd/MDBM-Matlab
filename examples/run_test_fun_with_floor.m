%How to use mdbm with anonymous function functions

% crating a stair function with smaller and small steps
x=linspace(-2,15,10001);
Nr=1.9;
fround=@(x)round(abs(x.^Nr)).^(1/Nr).*sign(x);
y=fround(x);
figure(1),clf
subplot(2,2,1)
plot(x,y)
axis tight

subplot(2,2,4)
plot(y,x)
axis tight

%% apply it to a circle (circle if Npow is set to 2)

ax=[];
ax(1).val=linspace(0,5,15);
ax(2).val=linspace(0,5,15);
Npow=1.5; %now it is a norm with power 1.5
f=@(ax) sum((abs(((ax))-2.5)).^Npow,1)-2^Npow;
mdbm_sol=mdbm(ax,f,7);


figure(1)
subplot(2,2,2)
plotobject=plot_mdbm(mdbm_sol,'k');
set(plotobject,'LineWidth',2)
hold on
f=@(ax) sum((abs((fround(ax))-2.5)).^Npow,1)-2^Npow;
mdbm_sol=mdbm(ax,f,7);
plotobject=plot_mdbm(mdbm_sol,'r');
set(plotobject,'LineWidth',2)
legend('without fround', 'with fround')
%%

ax(1).val=linspace(-2,15,15);
ax(2).val=linspace(-2,15,15);
f=@(ax) sum((abs(sin((ax)))).^Npow,1)-0.8^Npow;
mdbm_sol=mdbm(ax,f,6);

figure(1)
subplot(2,2,3)
plotobject=plot_mdbm(mdbm_sol,'k');
set(plotobject,'LineWidth',2)


f=@(ax) sum((abs(sin(fround(ax)))).^Npow,1)-0.8^Npow;
mdbm_sol=mdbm(ax,f,6);

figure(1)
subplot(2,2,3),hold on
plotobject=plot_mdbm(mdbm_sol,'r');
set(plotobject,'LineWidth',2)
legend('without fround', 'with fround')

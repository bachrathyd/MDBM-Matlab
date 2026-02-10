ax(1).val = linspace(0, 2, 4);
ax(2).val = -2:0.5:2;
ax(3).val = 0:2:7;
mdbm_sol = mdbm(ax, @(x) x(1,:).^2 + x(2,:).^2-2-sin(x(3,:)), 3);
plot_mdbm(mdbm_sol);shading interp
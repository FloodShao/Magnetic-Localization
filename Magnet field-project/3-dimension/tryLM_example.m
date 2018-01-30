rng default;
d = linspace(0,3);
y = exp(-1.3*d) + 0.05*randn(size(d));

fun = @(r)exp(-d*r) - y;
x0 = 4;

options = optimoptions(@lsqnonlin, 'Algorithm', 'levenberg-marquardt');
options = optimoptions(@lsqnonlin, 'Display', 'iter');

x = lsqnonlin(fun,x0, [], [], options);

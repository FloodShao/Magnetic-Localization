rng default;

x0 = [10; 10; 10];
options = optimoptions(@lsqnonlin);
options.Display = 'iter';
options.Algorithm = 'levenberg-marquardt';
options.StepTolerance = 1e-6;
options.MaxFunctionEvaluations = 1000;
x = lsqnonlin(@myfun, x0, [],[], options);

P_magnet = [0.4;0.5;0.6];
H0 = [0;0;1];
Bt = 10;
P_s = [
    0,0,0;
    0,1,0;
    0,2,0;
    1,0,0;
    1,1,0;
    1,2,0;
    2,0,0;
    2,1,0;
    2,2,0];
P_s = P_s';
B_measured = Bt*MagneticSensorValue(P_magnet, H0, P_s);

function F = myfun(x)
Bt = 10;
P_magnet = [0.4;0.5;0.6];
P_s = [
    0,0,0;
    0,1,0;
    0,2,0;
    1,0,0;
    1,1,0;
    1,2,0;
    2,0,0;
    2,1,0;
    2,2,0];
P_s = P_s';
H0 = [0;0;1];
B_estimate = Bt*MagneticSensorValue(x, H0, P_s);
B_measured = Bt*MagneticSensorNoise(P_magnet, H0, P_s);
Error = B_estimate - B_measured;
F = norm(Error);
end


%with constraints
function Pose_retrieval = PoseRetrievalConstraints(init_pose, Bt, sensor_position, sensor_data)
%init_pose is the initial guess of the pose of the magnet 6*1 vector,
%   orientation vector is normalized
%Bt is the magnetic field intensity, constant
%sensor_position is the 3*n matrix related to the position
%sensor_data is the 3*n matrix coresponding to the sensor_position

%Algorithm attemptance
%'trust-region-reflective' cannot solve the constraints problem
%'interior-point' default algorithm has problem when the path changes a lot
%'sqp-legacy' has the poorest performance both on speed and accuracy 
%'active-set' so far has the best performance, mind that this algorithm
%   only performs on small scale

options = optimoptions(@fmincon);
options.Algorithm = 'active-set'; 
options.ConstraintTolerance = 1e-4;
options.Display = 'iter';
options.MaxIterations = 300;
options.MaxFunctionEvaluations = 1000;
options.StepTolerance = 1e-6;
options.OptimalityTolerance = 1e-6;

x0 = init_pose;
x0(4:6) = x0(4:6) / norm(x0(4:6));
lb = [];
ub = [];
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = @(x) spericalcon(x, x0); %provide c(x)<=0 constraints and ceq(x) = 0 constraints
Pose_retrieval = fmincon(@(x) myfun(x, Bt, sensor_position, sensor_data), x0, A, b, Aeq, beq, lb, ub, nonlcon, options);

    function Error = myfun(x, Bt, sensor_position, sensor_data)
        Pose_m = x;
%         B_measured = sensor_data;
%         B_estimated = Bt * MagneticSensorValue(Pose_m, sensor_position);
        B_measured = sensor_data / Bt;
        B_estimated = MagneticSensorValue(Pose_m, sensor_position);
        Error = norm((B_estimated - B_measured));
    end

    function [c, ceq] = spericalcon(x, x0)
        c = norm(x(1:3) - x0(1:3)) -50e-3;
%         c = [];
        ceq = norm(x(4:6)) -1;
    end

end
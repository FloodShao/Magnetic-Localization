%LM retrieval
function Pose_retrieval = PoseRetrieval(init_pose, Bt, sensor_position, sensor_data)
%init_pose is the initial guess of the pose of the magnet 6*1 vector
%Bt is the magnetic field intensity, constant
%sensor_position is the 3*n matrix related to the position
%sensor_data is the 3*n matrix coresponding to the sensor_position
x0 = init_pose;

options = optimoptions(@lsqnonlin);
options.Display = 'iter';
options.Algorithm = 'levenberg-marquardt';
options.StepTolerance = 1e-20;
options.MaxFunctionEvaluations = 1000;
Pose_retrieval = lsqnonlin(@(x) myfun(x, Bt, sensor_position, sensor_data), x0, [], [], options);

    function Error = myfun(x, Bt, sensor_position, sensor_data)
    %x(1:6) is the pose of the magnet, x(7) is the BT of the magnet
    %sensor_position is 3*n matrix
    %sensor_data is also 3*n matrix coresponding to the sensor_position
    Pose_m = x;

    B_measured = sensor_data;
    B_estimated = Bt * MagneticSensorValue(Pose_m, sensor_position);

    Error = B_estimated - B_measured;
    Error = norm(Error);

    end


end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

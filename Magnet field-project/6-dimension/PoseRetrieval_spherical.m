%LM retrieval
function Pose_retrieval = PoseRetrieval_spherical(init_pose, Bt, sensor_position, sensor_data)
%init_pose is the initial guess of the pose of the magnet 6*1 vector,
%(x,y,z,m,n,p) where m,n,p is on the unit sphere
%Bt is the magnetic field intensity, constant
%sensor_position is the 3*n matrix related to the position
%sensor_data is the 3*n matrix coresponding to the sensor_position

%use spherical coordinates should convert the orientation vector to
%spherical coordinates as theta and phi.
%x0 is a 5d vector (x,y,z, theta, phi)

% [theta, phi] = Rec2Sphere(init_pose(4:6));
% x0 = [init_pose(1:3); theta; phi];

x0 = init_pose;

options = optimoptions(@lsqnonlin);
options.Display = 'iter';
options.Algorithm = 'levenberg-marquardt';
options.StepTolerance = 1e-20;
options.MaxFunctionEvaluations = 1000;
Pose_retrieval = lsqnonlin(@(x) myfun(x, Bt, sensor_position, sensor_data), x0, [], [], options); %in 5-d (x,y,z,theta, phi)
%convert to original rectangle coordinates
% Pose_retrieval = [Pose_retrieval(1:3); sin(Pose_retrieval(5))*cos(Pose_retrieval(4)); sin(Pose_retrieval(5))*sin(Pose_retrieval(4)); cos(Pose_retrieval(5))];

    function Error = myfun(x, Bt, sensor_position, sensor_data)
    %x(1:5) is the pose of the magnet in spherical coordinates
    %sensor_position is 3*n matrix
    %sensor_data is also 3*n matrix coresponding to the sensor_position
    Pose_m = [x(1:3); sin(x(5))*cos(x(4)); sin(x(5))*sin(x(4)); cos(x(5))];

    B_measured = sensor_data / Bt;
    B_estimated = MagneticSensorValue(Pose_m, sensor_position);

    Error = B_estimated - B_measured;
    Error = norm(Error);

    end


end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

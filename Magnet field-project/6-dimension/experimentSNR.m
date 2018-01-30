function [E_matrix, E_position, E_orientation, E_angle, Pose_retrieval] = experimentSNR(Path, sensor_position, Bt, noise_level)
   %%
    %generate sensor data
    num_points = size(Path,2);
    Pose_retrieval = zeros(size(Path));
    Pose_retrieval(:,1) = Path(:,1);
    
    %5D LM optimization
%     path = anglePath2vectorPath(Path);
    
    init_pose = Pose_retrieval(:, 1);
    for i = 2:num_points
       sensor_data = GenerateSensorData(sensor_position, Path(:,i), Bt, noise_level);

       %use (x,y,z,m,n,p) constraints optimization
       Pose_retrieval(:,i) = PoseRetrievalConstraints(init_pose, Bt, sensor_position, sensor_data);
        
       %use (x,y,z,theta,phi) LM optimization --turns out this method is
       %not good
%         Pose_retrieval(:,i) = PoseRetrieval_spherical(init_pose, Bt, sensor_position, sensor_data);

       %use (x,y,z,m,n,p) LM optimization
%         Pose_retrieval(:,i) = PoseRetrieval(init_pose, Bt, sensor_position, sensor_data);
        
        if norm(Pose_retrieval(1:3,i) - Pose_retrieval(1:3, i-1)) < 50e-3
            init_pose = Pose_retrieval(:, i);
        else
            init_pose = Pose_retrieval(:, i-1);
        end


    end
    
    %%
    %calculate the estimation error
    E_matrix = Path( :, 2:end) - Pose_retrieval( :, 2:end);
    E_position = sqrt( (norm(E_matrix(1:3, 2:end)))^2 / (size(Path, 2) ) );
    E_orientation = sqrt( (norm(E_matrix(4:6, 2:end)))^2 / (size(Path, 2)));
    E_angle = 2 * asin(E_orientation /2);
    
end
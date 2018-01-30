function sensor_position = GenerateSensorPosition_OnePlane(n_h, n_w, axis_distance, axis_matrix)
%n_h and n_w must be even number
%axis_matrix like this
%xy plane [1,0,0;0,1,0;0,0,1]; x axis as the n_w, y axis as the n_h
%yz plane [0,0,1;1,0,0;0,1,0]; y axis as the n_w, z axis as the n_h
%xz plane [1,0,0;0,0,1;0,1,0]; x axis as the n_w, z axis as the n_h


d = 100e-3 / 2;%the 1/2distance between sensors
sensor_position = zeros(n_h*n_w, 3); %for convenience, use raw vector

for i = 1:n_h/2  %n_h must be even_number
    for j = 1:n_w/2
        sensor_position( (i-1)*n_w*2 + (j-1)*4+1:(i-1)*n_w*2 + j*4, :)= [
            (2*j-1)*d, (2*i-1)*d, axis_distance;
            -(2*j-1)*d, (2*i-1)*d, axis_distance;
            (2*j-1)*d, -(2*i-1)*d, axis_distance;
            -(2*j-1)*d, -(2*i-1)*d, axis_distance;
            ];
    end
end

sensor_position = axis_matrix * sensor_position';

end
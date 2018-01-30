%Proceed version after  MATLAB 2016B
%output the calculated 

function B_3n = MagneticSensorValue(Pose_m, Position_s)
%Pose_m: is the position and orientation of the magnet, 1:3 is the position
%coordinates, 4:6 is the orientation vector
%Position_s: is the 3*n matrix where n is the number of sensors

Position_m = Pose_m(1:3);
Orientation_m = Pose_m(4:6);

B_3n = zeros(3, size(Position_s, 2)); %initiate B_3n  output 3*n

if(norm(Orientation_m) ~= 1) %normalize the Orientation
    Orientation_m = Orientation_m / norm(Orientation_m);
end

P_distance = Position_m - Position_s;
for i = 1:size(Position_s, 2)
    R = norm(P_distance(:,i));
    H0_Fl = dot(Orientation_m, P_distance(:,i));
    B_3n(:,i) = 1/R^5 * (3 * H0_Fl * P_distance(:,i) - R^2 * Orientation_m);
end

end
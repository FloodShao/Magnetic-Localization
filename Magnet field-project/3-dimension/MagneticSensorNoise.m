%Proceed after MATLAB 2016B
%output the sensor reading including the noise
function B_3n = MagneticSensorNoise( Position_m, Orientation_m, Position_s)
%Position_m & Orientation_m are 3*1 vector
%Position_s is a 3*n matrix where n is the number of sensors

B_3n = zeros(3, size(Position_s,2)); %initialize B_3n

if(norm(Orientation_m) ~= 1) %normalize the Orientation
    Orientation_m = Orientation_m / norm(Orientation_m);
end

P_distance = Position_m - Position_s;
for i = 1:size(Position_s,2)
    R = norm(P_distance(:,i));
    H0_Pl = dot(Orientation_m, P_distance(:,i));
    B_3n(:,i) = 1/R^5 * (3 * H0_Pl * P_distance(:,i) - R^2*Orientation_m);
end

% add noise, in the first place we add random guassian noise for simulate
% the sensor noise

%Guassian noise
sigma = 1e-14; %only when the noise level is less than 1e-14, the position retrieval can work
mu = 0;
noise = sigma * randn(size(B_3n));
B_3n = B_3n + noise;



%to be completed, add the noise effect from the earth

end
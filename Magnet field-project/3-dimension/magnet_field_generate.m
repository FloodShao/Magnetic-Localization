clear; clc;
rng default; %use the random seed to make sure every time the generated number is the same

%this program is to generate a magnetic field under a static magnet
%the intrinsic parameter of magnet
Bt = 1;
%three directional vector
vx = [1;0;0];
vy = [0;1;0];
vz = [0;0;1];

%the position of magnet and pose vector of magnet
P_magnet = [1;1;1];
H0 = [0;0;1];
H0 = H0/norm(H0); %the orientation of the magnet is normalized

%the position of the magnetic sensors, as a matrix, on the xy plane
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

%calculate the magnetic field
P_l = P_s - P_magnet;
Bl = [];
for i=1:size(P_l,2)
    R = norm(P_l(:,i));
    H0_Pl = dot(H0, P_l(:,i));
    Bli = Bt/R^5 * (3*H0_Pl*P_l(:,i) - R^2*H0);
    Bl = [Bl , Bli];
end

B_3n = MagneticSensorValue(P_magnet, [0; 0; 2], P_s);



    





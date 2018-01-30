function Path = GeneratePathFixed_CircleOnly(pose_0, num_points)
%this function generate a fixed path with straight line, spiral line, and
%circle line

%generate 100 points of the path
%desired pose_0 is (1;1;4;0;0;1)
Path = zeros(6, num_points);
sigma = 0;
Path(:,1) = pose_0;
%100 points spiral down, 2*pi
N_spiral = 100; %need to convert to cylindrical coordinates
O = [0;0]; %central point
R = 80e-3; 
d_theta = -4*pi/N_spiral; %clockwise movement
d_down = -160e-3 / N_spiral;
theta0 = atan( (Path(2,1)-O(2)) / (Path(1,1)-O(1)) );
for i = 2 : N_spiral
   Path(1:2, i) = [R * cos(theta0 + i*d_theta); R * sin(theta0 + i*d_theta)] + O;
   Path(3, i) = Path(3,i-1) + d_down;
%    Path(4:6, i ) = Path(4:6, N) + 2 * rand(3,1) - 1;
   Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
   Path(4:6, i) = Path(4:6, i) / norm(Path(4:6, i));
   R = R - 5e-4;
end

end
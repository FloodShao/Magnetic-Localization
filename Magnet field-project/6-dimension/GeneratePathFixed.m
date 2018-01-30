function Path = GeneratePathFixed(pose_0, num_points)
%this function generate a fixed path with straight line, spiral line, and
%circle line
N = 0;
%generate 100 points of the path
%desired pose_0 is (1;1;4;0;0;1)
Path = zeros(6, num_points);
sigma = 0;
%(1)10 points down
N_down1 = 10;
down1_d= 50e-3;
for i = 1:N_down1
    unit_vector = [0;0;-1];
    Path(1:3,i) = pose_0(1:3) + i * (down1_d / N_down1) * unit_vector;
%     Path(4:6,i) = pose_0(4:6) + 2 * rand(3,1) - 1;
    if(i == 1) 
        Path(4:6, i) = Path(1:3, i) - pose_0(1:3) + sigma*randn(3,1);
    else
        Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
    end
    Path(4:6,i) = Path(4:6, i) / norm(Path(4:6, i));
end
N = N + N_down1;

%(2)10 points turn left
N_left = 10;
left_d = 60e-3;
for i = N+1 : N+N_left
   unit_vector = [-1;0;0];
   Path(1:3,i) = Path(1:3, N) + (i-N) * (left_d / N_left) * unit_vector;
%    Path(4:6,i) = Path(4:6, N) + 2 * rand(3,1) - 1;
   
   Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);

   Path(4:6,i) = Path(4:6, i) / norm(Path(4:6, i));
end
N = N + N_left;

%(3) 5 points down
N_down2 = 5;
down2_d = 40e-3;
for i = N+1 : N+N_down2
    unit_vector = [0;0;-1];
    Path(1:3, i) = Path(1:3, N) + (i-N) * (down2_d / N_down2) * unit_vector;
%     Path(4:6, i) = Path(4:6, N) + 2 * rand(3,1) - 1;
    Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
    Path(4:6, i) = Path(4:6, i) / norm(Path(4:6, i));
end
N = N + N_down2;

%(4) 5 points back
N_back = 5;
back_d = 30e-3;
for i = N+1 : N+N_back
    unit_vector = [0;1;0];
    Path(1:3, i) = Path(1:3, N) + (i-N) * (back_d / N_back) * unit_vector;
%     Path(4:6, i) = Path(4:6, N) + 2 * rand(3,1) - 1;
    Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
    Path(4:6, i) = Path(4:6, i) / norm(Path(4:6, i));
end
N = N + N_back;

%(5)20 points turn right
N_right = 20;
right_d = 120e-3;
for i = N+1 : N+N_right
    unit_vector = [1;0;0];
    Path(1:3, i) = Path(1:3, N) + (i-N) * (right_d / N_right) * unit_vector;
%     Path(4:6, i) = Path(4:6, N) + 2 * rand(3,1) - 1;
    Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
    Path(4:6, i) = Path(4:6, i) / norm(Path(4:6, i));
end
N = N + N_right;

%(6)50 points spiral down, 2*pi
N_spiral = 50; %need to convert to cylindrical coordinates
O = [0;0]; %central point
R = norm(Path(1:2,N) - O); 
d_theta = -2*pi/N_spiral; %clockwise movement
d_down = -100e-3 / N_spiral;
theta0 = atan( (Path(2,N)-O(2)) / (Path(1,N)-O(1)) );
for i = N+1 : N+N_spiral
   Path(1:2, i) = [R * cos(theta0 + (i-N)*d_theta); R * sin(theta0 + (i-N)*d_theta)] + O;
   Path(3, i) = Path(3, N) + (i-N)*d_down;
%    Path(4:6, i ) = Path(4:6, N) + 2 * rand(3,1) - 1;
   Path(4:6, i) = Path(1:3, i) - Path(1:3, i-1) + sigma*randn(3,1);
   Path(4:6, i) = Path(4:6, i) / norm(Path(4:6, i));
end

end
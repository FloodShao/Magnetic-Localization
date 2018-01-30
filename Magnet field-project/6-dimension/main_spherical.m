clear; clc;
% rng(1);

num_points = 100;

% % remove comment when use combination path
% pose_0 = [0; 0; 80e-3; 0; 0; 1];
% path = GeneratePathFixed( pose_0, num_points);
% Path = vectorPath2anglePath(path);
% save('Path.mat', 'Path');

% remove comment when use circle path
pose_0 = [80e-3; 0; 80e-3; 0; -1; 0];
path = GeneratePathFixed_CircleOnly( pose_0, num_points);
Path = vectorPath2anglePath(path);
save('Path_CircleOnly.mat', 'Path');


% sensor_position = [
%     0,0,0;
%     0,1,0;
%     0,2,0;
%     1,0,0;
%     1,1,0;
%     1,2,0;
%     2,0,0;
%     2,1,0;
%     2,2,0];

d = 80e-3;
sensor_position = [
    %xy plane, z = 0
    0,0,0;
    d,0,0;
    -d,0,0;
    
    0,-d,0;
    d,-d,0;
    -d,-d,0;
    
    0,d,0;
    d,d,0;
    -d,d,0;
    
% %     xz plane, y = d
%     0,d,d;
%     d,d,d;
%     -d,d,d;
%     
% %     yz plane, x = d
%     d,0,d;
%     d,-d,d;
    ];

% sensor_position = [
%     0,0,0;
%     0,1,0;
%     0,2,0;
%     1,0,0;
%     1,1,0;
%     1,2,0;
%     2,0,0;
%     2,1,0;
%     2,2,0;
%     0,0,1;
%     0,1,1;
%     0,2,1;
%     0,1,2;
%     0,2,2;
%     0.5,0.5,0;
%     0.5,1.5,0;
%     1.5,0.5,0;
%     1.5,1.5,0;
%     0,0.5,0.5;
%     0,0.5,1.5;
%     0,1.5,0.5;
%     0,1.5,1.5
%     ];


sensor_position = (sensor_position )';

ur = 1;
u0 = 4*pi*1e-7;
r = 0.005; %radius is 5mm
L = 0.02;
M0 = 1.032*1e6;
Bt = ur*u0*pi*r^2*L*M0/(4*pi);

% Bt = 100;

% N = 10;
% E_log = zeros(4,N);
% for i = 1:N
%     noise_level = 1e-10 * 10^(i-1);
%     [E_matrix, E_position, E_orientation, E_angle, Pose_retrieval] = experimentSNR(Path, sensor_position, Bt, noise_level, d);
%     save(['Pose_retrieval' num2str(i) '.mat'], 'Pose_retrieval');
%     E_log(:,i) = [E_position; E_orientation; E_angle; noise_level];
% end

noise_level = 2e-7;
[E_matrix, E_position, E_orientation, E_angle, Pose_retrieval] = experimentSNR(Path, sensor_position, Bt, noise_level);
E_log = [E_position; E_orientation; E_angle; noise_level];
figure;
plot3(Path(1,:), Path(2,:), Path(3,:), 'r-x', 'LineWidth',2);
hold on;
scatter3(Pose_retrieval(1,:), Pose_retrieval(2,:), Pose_retrieval(3,:));
grid on;

save('E_log.mat', 'E_log');
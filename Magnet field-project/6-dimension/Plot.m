%Plot all the data
close all;
for i = 1:N
    figure;
    load('Path_CircleOnly.mat');
    plot3(Path(1,:), Path(2,:), Path(3,:), 'r-x', 'LineWidth', 2);
    hold on;
    load(['Pose_retrieval' num2str(i) '.mat']);
    scatter3(Pose_retrieval(1,:), Pose_retrieval(2,:), Pose_retrieval(3,:), [], 'b');
    grid on;
end

figure;
load('E_log.mat');
plot(1:10, E_log(1,:));
hold on;
plot(1:10, E_log(2,:));

function Path = GeneratePath( init_point, num_points)
%init_point is a 6*1 pose
%num_points is the number of points needed to generate

Path = zeros(6, num_points);
Path(:,1) = init_point;

for i=2:num_points
    pose_change = 2*rand(6,1)-1; %random position translation -1~1
    Path(:,i) = Path(:,i-1) + pose_change;
    Path(4:6,i) =  Path(4:6,i)/norm( Path(4:6,i) );
end

end
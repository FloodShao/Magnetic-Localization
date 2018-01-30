function Path = vectorPath2anglePath(path)
%path is the 6*n matrix with each pose (x,y,z,m,n,p)
%output Path is the 5*n matrix with each pose (x,y,z,theta,phi)
    Path = zeros(5, size(path,2));
    Path(1:3,:) = path(1:3,:);
    [theta, phi] = Rec2Sphere(path(4:6,:));
    Path(4:5,:) = [theta; phi];
end
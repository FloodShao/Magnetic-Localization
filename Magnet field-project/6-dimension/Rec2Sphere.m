function [theta, phi] = Rec2Sphere( orientation )
%This function converts the orientation_vector (3*n dimension) to 2 angles
%theta and phi in spherical coordinates

phi = acos(orientation(3,:));
theta = zeros(1, size(phi,2));

for i = 1:size(phi,2)
    if(orientation(2,i) >= 0)
        theta(i) = acos(orientation(1,i)/sin(phi(i)));
    else
        theta(i) = 2*pi - acos(orientation(1,i)/sin(phi(i)));
    end
    
    if(isnan(theta(i))) 
        theta(i) = 0;
    end
end

end
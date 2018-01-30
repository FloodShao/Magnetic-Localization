function magnet_position_Cal = Generate_Magnet_Position(num_quarter, z)
%generate a series magnet position on a xy plane with z as the height

d = 10e-3;
magnet_position_Cal = zeros(6, 2*num_quarter+1);
for i = -num_quarter : num_quarter
    for j = -num_quarter : num_quarter
        magnet_position_Cal(:, (i + num_quarter) * (2*num_quarter+1) + (j + num_quarter +1)) = [i * d; j * d; z; 0; 0; 1];
    end
end

end
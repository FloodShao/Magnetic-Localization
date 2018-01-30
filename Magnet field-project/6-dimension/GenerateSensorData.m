function sensor_data = GenerateSensorData(sensor_position, Pose_m, Bt, noise_level)

sensor_data_ideal = Bt * MagneticSensorValue(Pose_m, sensor_position);

min = norm(sensor_data_ideal);

for i = 1:size(sensor_data_ideal,2)
    if(norm(sensor_data_ideal(:,i)) < min)
        min = norm(sensor_data_ideal(:,i));
    end
end

sensor_data = sensor_data_ideal + Noise(noise_level, size(sensor_data_ideal));

end
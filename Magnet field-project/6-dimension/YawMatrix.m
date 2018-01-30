function yaw_matrix = YawMatrix(angle)
    
    yaw_matrix = [
        cos(angle), -sin(angle), 0;
        sin(angle), cos(angle), 0;
        0, 0, 1;
    ];

end
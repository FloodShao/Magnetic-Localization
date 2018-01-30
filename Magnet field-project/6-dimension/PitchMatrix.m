function pitch_matrix = PitchMatrix(angle)
    
    pitch_matrix = [
        cos(angle), 0, sin(angle);
        0, 1, 0;
        -sin(angle), 0, cos(angle);
    ];

end
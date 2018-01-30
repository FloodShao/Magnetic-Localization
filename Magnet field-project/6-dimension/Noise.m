function noise = Noise(noise_e, size)

noise = noise_e * randn(size);

Earth_field = zeros(size); %3*n matrix
Earth_field(1:2,:) = ones(2, size(2)) / sqrt(2);

noise = noise + Earth_field * 56.6e-6;
% noise = noise + Earth_field * 566e-6;

end
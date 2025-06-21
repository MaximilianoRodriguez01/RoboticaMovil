% Make librobotics available
addpath('practica_2_modelos_filtro_discreto_pf_2025a/pf_framework_matlab/librobotics');

% Read world data, i.e. landmarks
fprintf('Reading world data ...');
landmarks = read_world('practica_2_modelos_filtro_discreto_pf_2025a/pf_framework_matlab/data/world.dat');

fprintf(' done\n');
% Read sensor readings, i.e. odometry and range-bearing sensor
fprintf('Reading sensor data ...');
data = read_data('practica_2_modelos_filtro_discreto_pf_2025a/pf_framework_matlab/data/sensor_data.dat');
fprintf(' done\n');

% Initialize particles
particles = initialize_particles(500);

for t = 1:size(data.timestep, 2)
    fprintf('.');

    new_particles = sample_motion_model(data.timestep(t).odometry, particles);

    weights = measurement_model(data.timestep(t).sensor, new_particles, landmarks);
    normalizer = sum(weights);
    weights = weights ./ normalizer;

    plot_state(new_particles, weights, landmarks, t);

    particles = resample(new_particles, weights);
end

fprintf('Final pose: ')
disp(mean_position(particles, weights))

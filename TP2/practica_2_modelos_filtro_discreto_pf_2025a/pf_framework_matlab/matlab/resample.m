function new_particles = resample(particles, weights)
    % Performs stochastic universal sampling from a weighted particle set.
    %
    % particles: M x D matrix where each row is a particle
    % weights: M x 1 vector of normalized weights
    
    M = size(particles, 1);
    new_particles = zeros(size(particles));
    
    % Asegurarse de que los pesos estén normalizados
    weights = weights / sum(weights);
    
    % Inicialización
    r = rand() / M; % primer índice aleatorio
    c = weights(1);
    i = 1;
    
    % Remuestreo
    for m = 1:M
        U = r + (m - 1) / M;
        while U > c
            i = i + 1;
            c = c + weights(i);
        end
        new_particles(m, :) = particles(i, :);
    end
end

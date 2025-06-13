function mean_pos = mean_position(particles, weights)
    % Returns a single estimate of filter state based on the particle cloud.
    %
    % particles (M x 3): set of M particles to sample from. Each row contains a state hypothesis of dimension 3 (x, y, theta).
    % weights (M x 1): weights of the particles. Each row contains a weight.

    weights = weights / sum(weights);

    mean_pos = sum(particles .* weights, 1);
end
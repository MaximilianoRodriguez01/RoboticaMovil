
function weight = measurement_model(z, x, l)
    % Computes the observation likelihood of all particles using range-only sensor model.
    %
    % z: array of landmark observations with fields .id and .range
    % x: Nx3 matrix of particles (x, y, theta)
    % l: array of landmarks with fields .id, .x, .y
    
    sigma = 0.2;
    N = size(x, 1); % cantidad de partículas
    weight = ones(N, 1); % inicializar pesos

    if isempty(z)
        return;
    end
    
    for i = 1:length(z)
        % Obtener posición del landmark observado
        landmark_position = [l(z(i).id).x, l(z(i).id).y];
        measurement_range = z(i).range;
        
        % Calcular la distancia esperada desde cada partícula al landmark
        dx = x(:,1) - landmark_position(1);
        dy = x(:,2) - landmark_position(2);
        expected_range = sqrt(dx.^2 + dy.^2);
        
        % Likelihood gaussiana
        likelihood = exp(-0.5 * ((expected_range - measurement_range) / sigma).^2);
        
        % Acumular peso
        weight = weight .* likelihood;
    end

    % Normalizar (opcional, pero común)
    weight = weight / sum(weight);
end

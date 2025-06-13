% Crear GIF animado desde las imágenes guardadas
folder = 'practica_2_modelos_filtro_discreto_pf_2025a/pf_framework_matlab/plots';
output_file = fullfile(folder, 'filtro_particulas.gif');
num_frames = size(data.timestep, 2); % cantidad de frames

for t = 1:num_frames
    filename = sprintf('%s/pf_%03d.png', folder, t);
    A = imread(filename);

    % Convertir imagen RGB a formato indexado
    [A_ind, map] = rgb2ind(A, 256);

    if t == 1
        imwrite(A_ind, map, output_file, 'gif', 'LoopCount', Inf, 'DelayTime', 0.2);
    else
        imwrite(A_ind, map, output_file, 'gif', 'WriteMode', 'append', 'DelayTime', 0.2);
    end
end

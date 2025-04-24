clear all
close all

n = 100000;

bines = ceil(sqrt(n));

Z1 = normal(1, n);
figure;
histogram(Z1, bines, 'Normalization', 'pdf', 'FaceColor', '#c0688d');
hold on
title('Histograma de Z_1');


function z = normal(sigma, n)
    % genero 12 uniformes entre -sigma y sigma
    r = -sigma + (2*sigma).*rand(12, n);
    % sumo los 12 uniformes
    z = mean(r);
end

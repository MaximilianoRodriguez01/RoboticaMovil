clear all
close all

n = 100000;

bines = ceil(sqrt(n));

mu = 2;
sigma = 1;


Z1 = normal_con_uniformes(mu, sigma, n);
figure;
histogram(Z1, bines, 'Normalization', 'pdf', 'FaceColor', '#c0688d');
hold on
title('Histograma de Z_1 generado con la suma de 12 uniformes')
xlabel('Z_1');
ylabel('Densidad de probabilidad')
grid on

Z2 = normal_muestra_con_rechazo(mu, sigma, n);
figure;
histogram(Z2, bines, 'Normalization', 'pdf', 'FaceColor', '#c0688d');
hold on
title('Histograma de Z_2 generado con el método de rechazo')
xlabel('Z_2');
ylabel('Densidad de probabilidad')
grid on


Z3 = normal_box_muller(mu, sigma, n);
figure;
histogram(Z3, bines, 'Normalization', 'pdf', 'FaceColor', '#c0688d');
hold on
title('Histograma de Z_3 generado con el método de Box-Muller');
xlabel('Z_3');
ylabel('Densidad de probabilidad');
grid on


function z = normal_box_muller(mu, sigma, n)
    z = zeros(1, n);
    for i = 1:n
        u1 = rand(1, 1);
        u2 = rand(1, 1);
        z(i) = mu + sigma * sqrt(-2*log(u1)) * cos(2*pi*u2);
    end
end


function z = normal_muestra_con_rechazo(mu, sigma, n)
    z = zeros(1, n);
    for i = 1:n
        aprobado = 0;
        while aprobado == 0
            x = mu - 5*sigma + (10*sigma) * rand();
            f_x = normpdf(x, mu, sigma);
            c = 1/(sqrt(2*pi)*sigma) * rand(1, 1);
            if c <= f_x
                z(i) = x;
                aprobado = 1;
            end
        end
    end
end

function z = normal_con_uniformes(mu, sigma, n)
    r = -sigma + (2*sigma) .* rand(12, n);
    z = (1/2)* sum(r);
    z =  z + mu;
end
